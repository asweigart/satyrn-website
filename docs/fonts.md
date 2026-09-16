# Fonts

## Triple Charm Font Trio

- **Designer:** BilberryCreates
- **Source:** Creative Market (purchased 2026-08-29)
- **Files:** vendor-supplied webfont build (`.woff2` + `.woff`), served as-is.
  Do **not** re-convert or subset these — the licence covers embedding the
  provided webfont files, and modifying them is a separate grey area.

### Faces

| File | `@font-face` family | Used for |
| --- | --- | --- |
| `triplecharm-sans-*` | `Triple Charm Sans` | Headings (the display face) |
| `triplecharm-sansoutline-*` | `Triple Charm Outline` | Special display text (not yet in use) |
| `triplecharm-script-*` | `Triple Charm Script` | Human names / flourishes (not yet in use) |

All three are declared in `src/stylesheets/satyrn.css` and exposed as the
`--satyrn-font-*` tokens there.

### ⚠️ Licence limit

Two licences were purchased:

- **Desktop** — for producing artwork (logo, graphics) in design tools.
- **Webfont** — for `@font-face` embedding on the site. **Capped at 10,000
  page views per month.**

If satyrn.ai traffic exceeds ~10K page views/month, the Webfont licence must be
upgraded to a higher tier on Creative Market. Keep an eye on this as the site
grows.
