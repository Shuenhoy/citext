import { Cite, plugins } from "@citation-js/core";
import "@citation-js/plugin-csl";
import "@citation-js/plugin-bibtex";

export function initConfig(template, locales) {
    const templateName = "custom1";

    let config = plugins.config.get("@csl");
    config.templates.add(templateName, template);
    config.locales.add("zh-CN", locales);

}

export function citeone(bib) {
    const templateName = "custom1";

    let cite = new Cite(bib);
    let data = cite.format('data', {
        format: "object",
        template: templateName,
    })


    for (let value of data) {
        return [value.id, {
            bibliography: cite.format('bibliography', {
                template: templateName,
                entry: value.id,
            }).trim(),
            author: value.author,
            language: value.language || "en-US",
        }]
    }
}

export function citex(bib) {
    const templateName = "custom1";

    let cite = new Cite(bib);
    let data = cite.format('data', {
        format: "object",
        template: templateName,
    })

    let citations = {}

    for (let value of data) {
        citations[value.id] = {
            bibliography: cite.format('bibliography', {
                template: templateName,
                entry: value.id,
            }).trim(),
            author: value.author,
            language: value.language || "en-US",
        }
    }
    return citations
}
