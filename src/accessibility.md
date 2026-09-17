---
title: Accessibility
description: "How accessible satyrn.ai is, how we test it, what we know is missing, and how to tell us when something doesn't work for you."
---

# Accessibility

We want everyone who could use Satyrn to be able to read about it,
contribute to it, and find their way around this site.

## Our target

This site aims to meet the
[Web Content Accessibility Guidelines (WCAG) 2.2](https://www.w3.org/TR/WCAG22/)
at level AA.
We haven't had it independently audited,
so we don't claim full conformance.
This page says what we've checked and what we haven't.

## What we've tested

Last reviewed on 16 September 2026.

- Text and background colours were measured against WCAG AA on every page type:
  the home page, content pages, the blog, a post, and tag and author archives.
  That covered six screen widths from 320px to 1440px, in both light and dark mode.
  Normal-size text is at 5:1 or better.
- The same pages were checked for sideways scrolling at each of those widths.
- Every page sets its language, has a single main heading,
  and starts with a link that skips straight to the content.
- Buttons and links are large enough to tap,
  and buttons have a visible edge and a visible focus outline.
- Nothing on the site flashes, and nothing moves on its own for more than a few seconds without a way to stop it.
  At the top of the home page, the moons and stars in the space illustration
  move only as you scroll or move your pointer over the top of the page,
  or make one short sweep in browsers that can't link them to scrolling.
  A shooting star crosses once when the page loads and each time your pointer moves onto it,
  and a few stars twinkle twice.
  If your system is set to reduce motion, all of that is switched off.
  A row of contributor avatars on the home page scrolls slowly on its own.
  It has a Pause button, stops while you hover over it or tab into it,
  and doesn't move at all if your system is set to reduce motion.
  Otherwise the only motion is short interface transitions, like the menu sliding open.
- Light and dark mode follow your system setting,
  and you can switch between them from the header.

## What we know isn't done yet

- We haven't tested the site with a screen reader from start to finish,
  or with keyboard-only navigation on every page.
- The search dialog and other parts of the site theme we build on
  haven't been checked beyond colour contrast.
- Checks run by hand today, not automatically on every change.
- Blog post titles have a decorative outline layer behind them.
  It's marked as decorative so screen readers should skip it,
  but we haven't confirmed that in every screen reader,
  or that it reads well at high zoom.

## Tell us what doesn't work

If something on this site is hard or impossible for you to use,
please [open an accessibility issue on GitHub](https://github.com/satyrn-ai/satyrn-evals-collector/issues/new?labels=accessibility).
Tell us the page, what you were trying to do,
and the browser or assistive technology you use, if you're comfortable sharing.

You don't need to know which guideline it breaks.
"I couldn't do this" is enough for us to start.
