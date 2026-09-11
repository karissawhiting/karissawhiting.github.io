# Project notes

## Conventions

- Use the `.yaml` extension (not `.yml`) for new YAML files in this repo.

## File layout

Page source (`.qmd`) and rendered output (`.html`) stay at the repo root so site URLs don't change. Each page's supporting data/template files live in a same-named subfolder:

- `research/` — supports `research.qmd`: `publications.yaml` (hand-maintained, each entry a pre-formatted `citation` string), `publications-template.ejs.md` (listing template)
- `presentations/` — supports `presentations.qmd`: `presentations.yaml` (hand-maintained), `presentations-template.ejs.md` (listing template)

`archive/research-legacy/` holds the retired CSV → CSL-JSON → citeproc pipeline (`publications.csv`, `apa.csl`, `pull_publications.R`, `generate_publications.R`) for reference only — it is not wired into the site build. Don't resurrect it without being asked.

## Research and Presentations pages: Quarto listings

Both `research.qmd` and `presentations.qmd` use Quarto's custom listing feature — a hand-maintained YAML file rendered via an `.ejs` template — see `research/publications.yaml`/`research/publications-template.ejs.md` and `presentations/presentations.yaml`/`presentations/presentations-template.ejs.md`.

**Template gotcha (learned the hard way):** in this listing engine, only markup written *literally* in the `.ejs.md` file is treated as raw HTML. Building a whole HTML fragment in JS (e.g. a helper function that returns a string via template literals) and emitting it with `<%- %>` gets HTML-escaped instead of rendered. Stick to literal `<li>`/`<div>` tags in the template with `<%= item.field %>` for individual field substitutions (and `<% if/for %>` for control flow) — the pattern both existing templates use.

Relevant docs when modifying a listing or template:

- https://quarto.org/docs/websites/website-listings.html — listing options (contents, sort, fields, filtering, pagination)

- https://quarto.org/docs/websites/website-listings-custom.html — custom listing templates (`template:` + `.ejs` files), the mechanism used above

# Rules

- check for quarto native (or related tool native) solutions https://quarto.org/docs before custom coding up new ones