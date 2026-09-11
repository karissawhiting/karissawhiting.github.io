# Automatic step: build research/publications.json (a CSL-JSON bibliography)
# from research/publications.csv, the single canonical, hand-editable source
# of truth. Runs on every render as a Quarto pre-render step (see
# _quarto.yaml) and does NOT contact Google Scholar — run
# scripts/pull_publications.R by hand to pull in new publications.
#
# research.qmd renders this bibliography directly via Quarto/Pandoc's
# citeproc (bibliography: + csl: + nocite: "@*"), so formatting (APA style)
# is handled by standard citation tooling rather than a custom template.

library(tidyverse)

if (!file.exists("research/publications.csv")) {
  stop("research/publications.csv not found. Run scripts/pull_publications.R first.")
}

# "DD Sjoberg" -> list(family = "Sjoberg", given = "DD"); a trailing
# "and others" becomes an author with only a family name ("others"), so APA
# renders it as "..., & others" in place of the truncated remainder of the
# author list Scholar didn't give us.
parse_authors <- function(author_string) {
  if (length(author_string) == 0) {
    return(list())
  }
  names <- str_split(author_string, ", ")[[1]]
  map(names, function(name) {
    if (name == "and others") {
      list(family = "others")
    } else {
      parts <- str_match(name, "^(.*) (\\S+)$")
      list(given = parts[, 2], family = parts[, 3])
    }
  })
}

df_articles <- readr::read_csv(
  "research/publications.csv",
  col_types = readr::cols(.default = "c"),
  na = character()
) %>%
  # only publish rows explicitly marked display = Yes
  filter(display == "Yes") %>%
  mutate(id = str_glue("pub{row_number()}"))

listing_items <- df_articles %>%
  rowwise() %>%
  mutate(
    type = "article-journal",
    issued = list(list(`date-parts` = list(list(as.numeric(year))))),
    author = list(parse_authors(author))
  ) %>%
  ungroup() %>%
  transmute(
    id,
    type,
    title,
    author,
    `container-title` = journal,
    volume = number,
    issued
  ) %>%
  purrr::transpose()

jsonlite::write_json(
  listing_items,
  "research/publications.json",
  auto_unbox = TRUE,
  null = "null"
)
