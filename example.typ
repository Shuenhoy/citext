#import "package/lib.typ": *
#let bib = init_citation(read("test.bib"))
#show: show-extcite.with(bib: bib)



@texbook
@zjugradthesisrules
@latex2e

@zjugradthesisrules<citeauthor>

@zjugradthesisrules<citep>

@lesk:1977<citet>

@latex:companion<citep>

// #show bibliography: none

#bibliography("test.bib", style: "gb-7714-2015-numeric")

= 参考文献

#extbib(bib)