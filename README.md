# karissawhiting.github.io

## Updating the publications listing

`research/publications.yaml` is the canonical source for the [Research](research.qmd) page: a hand-maintained list of entries, each with a single `citation` field holding the full, pre-formatted citation text. `research.qmd` renders it as a Quarto listing via `research/publications-template.ejs.md`.

To add or edit a publication, just add/edit a `citation:` entry in the yaml. Entries render in the order they appear in the file (`sort: false`) — reorder entries there to change the display order.

The previous CSV/CSL-JSON/citeproc pipeline (pull-from-Scholar script, `publications.csv`, `apa.csl`) has been archived under `archive/research-legacy/` for reference; it's no longer wired into the site build.

## Updating the software listing

`software/software.csv` is the canonical source for R packages on the [Software](software.qmd) page (columns: `repo, title, html_url, github_url, paper_url, description, category, role, reviewed, display`), following the same pull → review → publish pattern:

1. `Rscript scripts/pull_software.R` — pulls repos from the accounts/orgs in `GH_SOURCES` (currently `karissawhiting` + `MSKCC-Epi-Bio`), appending new ones with `category = ""`, `role = ""`, `reviewed = No`, `display = No`. Existing rows are never touched.
2. Review new rows: set `role` (e.g. `Creator & Maintainer`, `Maintainer`, `Author`), `github_url`/`paper_url` if applicable, `reviewed = Yes`, `display`. Edit `title` for a nicer display name if needed.
3. `scripts/generate_software.R` runs automatically on render, filtering to `display = Yes` and building `software/packages.yaml`, sorted by the role order in `ROLE_ORDER`. It doesn't contact GitHub.

`software.qmd` renders `packages.yaml` as a Quarto listing via `software/software-template.ejs.md` — the same custom-listing mechanism used for [Presentations](presentations.qmd), and both templates use the same `.software-*` CSS classes for a consistent look.

Courses and workshops (formerly a second section on this page) now live on the [Presentations](presentations.qmd) page instead, alongside talks.

Notes:
- Only `display = Yes` rows publish; `reviewed` is just tracking.
- Don't hand-edit `packages.yaml` — it's regenerated on every render.
