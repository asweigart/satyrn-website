# Satyrn AI website task runner.
#
# Everything here runs through `uv`, so `just` and `uv` are the only two things
# you need installed. Run `just` on its own to see what is available.

# Show available commands. Hidden so it does not list itself.
[private]
default:
    @just --list --unsorted

# Serve the site locally with live reload at http://localhost:8000
serve:
    uv run zensical serve

# Serve on a specific address, e.g. `just serve-at 0.0.0.0:9000`
serve-at addr:
    uv run zensical serve -a {{ addr }}

# Build the production site into ./site
build:
    uv run zensical build --strict

# Delete build output and caches
clean:
    rm -rf site .cache

# Build from scratch, exactly as CI would
rebuild: clean build

# Check every internal asset reference in the built site resolves
check-assets: build
    #!/usr/bin/env -S uv run python
    import pathlib, re, sys
    root = pathlib.Path("site")
    pattern = re.compile(r'(?:src|srcset|href)="([^"]*assets/[^"]+\.(?:webp|avif|png|svg|ico))"')
    missing = []
    for page in root.rglob("*.html"):
        for ref in set(pattern.findall(page.read_text())):
            if ref.startswith(("http://", "https://", "//")):
                continue
            target = root / ref.lstrip("/") if ref.startswith("/") else page.parent / ref
            if not target.exists():
                missing.append(f"{page.relative_to(root)} -> {ref}")
    for m in missing:
        print(f"missing: {m}")
    print(f"{len(missing)} broken asset reference(s)")
    sys.exit(1 if missing else 0)

# Check every page's front matter parses as YAML
check-frontmatter:
    #!/usr/bin/env -S uv run --with pyyaml python
    import pathlib, sys, yaml
    # Zensical parses front matter inside `except Exception: pass`, so a stray
    # colon silently discards the whole block -- taking `template:` with it --
    # and the build still reports success. --strict cannot see this because
    # nothing is ever emitted. Hence checking it here.
    bad = []
    for page in sorted(pathlib.Path("src").rglob("*.md")):
        text = page.read_text()
        if not text.startswith("---"):
            continue
        _, _, rest = text.partition("---")
        block, sep, _ = rest.partition("\n---")
        if not sep:
            bad.append((page, "front matter is never closed"))
            continue
        try:
            meta = yaml.safe_load(block)
        except yaml.YAMLError as e:
            bad.append((page, str(e).split("\n")[0]))
            continue
        if not isinstance(meta, dict):
            bad.append((page, f"parsed as {type(meta).__name__}, not a mapping"))
    for page, why in bad:
        print(f"{page}: {why}")
    print(f"{len(bad)} page(s) with unparseable front matter")
    sys.exit(1 if bad else 0)

# Lint markdown and spelling. The only recipe that needs node; GitHub runners
# ship it preinstalled, so this costs a package download and no setup step.
#
# Versions are pinned. Unpinned, `npx -y` resolves latest on every run, so a new
# major could add a rule and fail CI with nothing in the repo having changed.
lint:
    #!/usr/bin/env bash
    set -euo pipefail
    command -v npx >/dev/null || {
      echo "lint needs npx (ships with node). GitHub runners have it preinstalled;"
      echo "locally, install node or skip this recipe."; exit 1; }
    npx -y markdownlint-cli2@0.23.2 "src/**/*.md" "*.md"
    npx -y cspell@10.0.1 --no-progress --no-summary "src/**/*.md" "*.md"

# Report what one visit to the landing page actually downloads
weigh: build
    #!/usr/bin/env -S uv run python
    import gzip, pathlib, re
    from collections import defaultdict
    # Walk what the page REFERENCES, not every file under site/. Counting the
    # directory sums stylesheets the theme ships but never links, both formats
    # of a <picture>, and every other page's HTML -- roughly 60% overstatement,
    # enough to hide a real regression inside the noise.
    root = pathlib.Path("site")
    page = root / "index.html"
    html = page.read_text()

    def resolve(ref):
        if ref.startswith(("http://", "https://", "//")):
            return None
        target = root / ref.lstrip("/") if ref.startswith("/") else page.parent / ref
        return target.resolve() if target.exists() else None

    refs = {page.resolve()}
    for ref in re.findall(r'(?:src|srcset|href)="([^"]+\.(?:css|js|webp|avif|png|svg|ico))"', html):
        if (target := resolve(ref)):
            refs.add(target)
    # Inside a <picture> the browser takes the first source it supports and never
    # requests the <img> fallback, so count the source and drop the fallback.
    for block in re.findall(r"<picture[^>]*>.*?</picture>", html, re.S):
        chosen = re.search(r'<source[^>]+srcset="([^"]+)"', block)
        fallback = re.search(r'<img[^>]+src="([^"]+)"', block)
        if chosen and fallback and (drop := resolve(fallback.group(1))):
            refs.discard(drop)
    label_of = {".html": "markup", ".css": "styles", ".js": "scripts"}
    compressible = {".html", ".css", ".js", ".svg"}
    groups, total = defaultdict(lambda: [0, 0]), 0
    for f in sorted(refs):
        # Report what crosses the wire. Images are already compressed.
        size = (len(gzip.compress(f.read_bytes(), 9))
                if f.suffix in compressible else f.stat().st_size)
        label = label_of.get(f.suffix, "images")
        groups[label][0] += size
        groups[label][1] += 1
        total += size
    for label, (size, n) in sorted(groups.items()):
        print(f"  {label:<8} {size / 1024:8.1f} KiB  ({n} files)")
    print(f"  {'total':<8} {total / 1024:8.1f} KiB  gzipped (one visit to /)")

# Needs imagemagick, cwebp and avifenc; only run this when the artwork changes.
# Re-encode source artwork into the sizes and formats the site ships
[confirm("Overwrite src/assets from the originals in the given directory?")]
encode-assets src_dir:
    #!/usr/bin/env bash
    set -euo pipefail
    command -v magick >/dev/null || { echo "needs imagemagick"; exit 1; }
    command -v cwebp  >/dev/null || { echo "needs cwebp (brew install webp)"; exit 1; }
    command -v avifenc >/dev/null || { echo "needs avifenc (brew install libavif)"; exit 1; }
    # Hero mascot: one AVIF, with a WebP fallback for pre-2024 browsers.
    # 600px is 2.5x the 240px the mascot renders at; more is wasted bytes.
    magick "{{ src_dir }}/avatar.png" -resize 600x600 /tmp/satyrn-avatar.png
    cwebp -q 80 -alpha_q 90 /tmp/satyrn-avatar.png -o src/assets/avatar.webp
    avifenc -q 62 --speed 4 /tmp/satyrn-avatar.png src/assets/avatar.avif
    # Logo: WebP only. The header logo is a bare <img> from the theme, so a
    # second format would mean shipping the same artwork twice.
    magick -background none "{{ src_dir }}/satyrn-logo-light.svg" -resize 480x /tmp/satyrn-logo.png
    cwebp -q 85 -alpha_q 95 /tmp/satyrn-logo.png -o src/assets/satyrn-logo-light.webp
    # Favicon: 96px wide is ~3x the largest size a browser actually renders it at.
    magick "{{ src_dir }}/favicon.png" -resize 96x -strip -colors 128 \
      -define png:compression-level=9 src/assets/favicon.png
    just weigh

# Everything CI should run before a merge
ci: rebuild check-frontmatter check-assets lint weigh
