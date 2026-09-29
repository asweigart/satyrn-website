// GitHub links open in a new tab, severed from this page: `noopener` denies the
// new tab a `window.opener` handle back, `noreferrer` also drops the referrer.
// `document$` rather than DOMContentLoaded, because navigation.instant swaps
// pages without a reload.
document$.subscribe(function () {
  document.querySelectorAll('a[href^="https://github.com"]').forEach(function (a) {
    a.target = "_blank"
    a.rel = "noopener noreferrer"
  })
})
