# Citext 
- - -

This package provides:

* Bilingual bibliography hack before official Typst support for CSL-M (https://github.com/typst/citationberg/issues/5)
* `parencite` `citep` like support

It calls `citation.js` from QuickJS and WebAssembly using https://github.com/Enter-tainer/jogs.

It is designed for `gb-t-7714-2015-numeric-bilingual.csl` but may work for other CSL styles with `numeric` category.

```typst
#import "package/lib.typ": *
#let bib = init_citation(read("test.bib"))
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
