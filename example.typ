#import "@local/citext:0.2.0": *

#let bib = init-citation(read("test.bib"))
#show: show-extcite.with(bib: bib, gen-id: true)


@texbook
@zjugradthesisrules
@latex2e

@zjugradthesisrules<citeauthor>

@zjugradthesisrules<citep>

@lesk:1977<citet>

@latex:companion<citep>

#show bibliography: none

#bibliography("test.bib", style: "gb-7714-2015-numeric")

= 参考文献

#extbib(bib)

#new-citext-session()

@zjugradthesisrules<citeauthor>

@zjugradthesisrules

@lesk:1977<citet>

= 参考文献
#extbib(bib)
