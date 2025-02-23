#import "@preview/ctxjs:0.3.1"
#import "@preview/mitex:0.2.4": mi


#let cite-src = read("./dist/index.min.js")


#let gb-t-7714-2015-numeric-bilingual = read("gb-t-7714-2015-numeric-bilingual.csl")
#let locales-zh-CN = read("locales-zh-CN.xml")

#let simpleparse(bs) = {
  let ls = str.split(bs, "@").map(str.trim).filter(it => it != "").map(it => "@" + it)
  // for each element x, first line must be @<type>{<key>,
  // make a dict with key as key and value as x

  ls.map(x => {
    let key = str.split(x, "{").at(1).split(",").at(0)
    (key.trim(), x)
  })
}

#let init_citation(bib, csl: gb-t-7714-2015-numeric-bilingual, locales: locales-zh-CN) = {
  let ctx = ctxjs.new-context(
    load: (
      ctxjs.load.load-module-js("citext", cite-src),
      ctxjs.load.call-module-function("citext", "initConfig", (gb-t-7714-2015-numeric-bilingual, locales-zh-CN)),
    ),
  )
  return ctxjs.ctx.call-module-function(ctx, "citext", "citex", (bib.replace("$", "\\$"),))
}

#let init_citation_sep(bib, csl: gb-t-7714-2015-numeric-bilingual, locales: locales-zh-CN) = {
  let ctx = ctxjs.new-context(
    load: (
      ctxjs.load.load-module-js("citext", cite-src),
      ctxjs.load.call-module-function("citext", "initConfig", (gb-t-7714-2015-numeric-bilingual, locales-zh-CN)),
    ),
  )
  let bibs = simpleparse(bib.replace("$", "\\$"))
  bibs
    .map(kv => {
      let k = kv.at(0)
      let v = kv.at(1)
      (k, ctxjs.ctx.call-module-function(ctx, "citext", "citeone", (v,)))
    })
    .to-dict()
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
