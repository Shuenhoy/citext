#import "@preview/jogs:0.2.3": compile-js, call-js-function, list-global-property
#import "@preview/mitex:0.2.4": mi


#let cite-src = read("./dist/index.iife.js")
#let cite-bytecode = compile-js(cite-src)

#let gb-t-7714-2015-numeric-bilingual = read("gb-t-7714-2015-numeric-bilingual.csl")

#let locales-zh-CN = read("locales-zh-CN.xml")

#let init_citation(bib, csl: gb-t-7714-2015-numeric-bilingual, locales: locales-zh-CN) = {
  return call-js-function(cite-bytecode, "citext", bib.replace("$", "\\$"), csl, locales)
}


#let extcitefull(bib, id) = {
  show regex("\$.+?\$"): it => mi(it)
  bib.at(id).at("bibliography")
}
#let citeauthor-one-two-more(authors, ETAL: none, AND: none) = {
  let len = authors.len()
  if len > 2 {
    return authors.at(0).family + ETAL
  } else if len == 2 {
    return authors.at(0).family + AND + authors.at(1).family
  } else {
    return authors.at(0).family
  }
}
#let en-US-citeauthor = citeauthor-one-two-more.with(AND: " and ", ETAL: " et al.")
#let zh-CN-citeauthor = citeauthor-one-two-more.with(AND: "和", ETAL: "等")

#let extciteauthor(
  bib,
  id,
  mapping: (
    en-US: zh-CN-citeauthor,
    zh-CN: zh-CN-citeauthor,
  ),
) = {
  let entry = bib.at(id)
  mapping.at(entry.at("language"), default: mapping.en-US)(entry.at("author"))
}

#let cite-targets = state("cite-targets", ())
#let show-extcite(s, bib: (:)) = {
  show ref: it => {
    if it.element != none {
      // Citing a document element like a figure, not a bib key
      // So don't update refs
      it
      return
    }
    cite-targets.update(old => {
      if it.target not in old {
        old.push(it.target)
      }
      old
    })

    it
  }

  show cite: it => {
    cite-targets.update(old => {
      if it.key not in old {
        old.push(it.key)
      }
      old
    })

    it
  }

  show ref.where(label: <citeauthor>): it => {
    extciteauthor(bib, str(it.target))
  }

  show ref.where(label: <citep>): it => {
    [#extciteauthor(bib, str(it.target)) #cite(it.target)]
  }

  show ref.where(label: <citet>): it => {
    show super: it => it.body
    [#extciteauthor(bib, str(it.target)) #cite(it.target)]
  }

  show ref.where(label: <citef>): it => {
    [#footnote[#extcitefull(bib, str(it.target))]]
  }
  s
}



#let extbib(bib) = {
  context {
    grid(
      columns: 2,
      column-gutter: 0.65em,
      row-gutter: 1.2em,
      ..cite-targets
        .at(here())
        .enumerate()
        .map(x => {
          let i = x.at(0) + 1
          let target = x.at(1)
          ([\[#i\]], extcitefull(bib, str(target)))
        })
        .flatten()
    )
  }
}
