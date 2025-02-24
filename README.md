# Citext 
- - -

This package provides:

* Bilingual bibliography hack before official Typst support for CSL-M (https://github.com/typst/citationberg/issues/5)
* `parencite` `citep` like support

It calls `citation.js` from QuickJS and WebAssembly using https://github.com/lublak/typst-ctxjs-package.

It is designed for `gb-t-7714-2015-numeric-bilingual.csl` but may work for other CSL styles with `numeric` category.

```typst
#import "package/lib.typ": *
#let bib = init-citation(read("test.bib"))
#show: show-extcite.with(bib: bib)



@texbook
@zjugradthesisrules
@latex2e

@zjugradthesisrules<citeauthor>

@zjugradthesisrules<citep>

@lesk:1977<citet>

@latex:companion<citef>

// #show bibliography: none

#bibliography("test.bib", style: "gb-7714-2015-numeric")

= 参考文献

#extbib(bib)
```

## Mode
`init-citation` supports 3 modes: `"lazy"` (default), `"eager"` and `"stable"`, you can change the mode with `mode:`
e.g. `init-citation(read("test.bib"), mode: "eager")`.

* `"lazy"`: a citation will be processed when it is used.  It depends on the Typst caching mechanism to avoid duplicated computation.
* `"eager"`: all citations in your BibTeX will be processed at once in individual. 
* `"stable"`: all citations in your BibTeX will be processed at once as a whole. 

Both `"lazy"` and `"eager"` will benefit from the incremental compilation capability of Typst, and run in multi thread. You may need to try out which is faster for your document. To use `"lazy"` or `"eager"` mode, your BibTeX must be formatted such that there must be no space before the `@` of each item `@article{`, so that the items can be split.

If you still meet any issue, you could try the `"stable"` mode, which does not depend on the heuristic splitting. However, it cannot perform incremental compilation, and can be very slow.