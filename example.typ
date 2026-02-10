#import "./package/lib.typ": *

#let bib = init-citation(read("test.bib"))
#show: show-extcite.with(bib: bib, gen-id: true)


@texbook
@zjugradthesisrules
@latex2e

@zjugradthesisrules<citea>

@zjugradthesisrules<citep>

@lesk:1977<citet>

@latex:companion<citep>

// remove duplicate citations
#mulcite[@texbook @zjugradthesisrules @latex2e @zjugradthesisrules]

// legacy `mulcite` interface, for compatibility only.
#mulcite(<texbook>, <zjugradthesisrules>, <latex2e>, <zjugradthesisrules>)

// sorted citations, grouped contiguously citations
#mulcite[@latex:companion @texbook @zjugradthesisrules @latex2e]

#show bibliography: none

#bibliography("test.bib", style: "gb-7714-2015-numeric")

= 参考文献

#extbib(bib)

#new-citext-session()


@zjugradthesisrules

@lesk:1977<citet>

#cite(<latex:companion>, form: "prose")

#cite(<zjugradthesisrules>, form: "full")

`<citey>` 与 `<citea>` 不会在后面的参考文献列表中添加条目：

@texbook<citey>
@latex2e<citea>


= 参考文献
#extbib(bib)
