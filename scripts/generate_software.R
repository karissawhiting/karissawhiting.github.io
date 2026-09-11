# Automatic step: build software/packages.yaml from software/software.csv,
# the single canonical, hand-editable source of truth. Runs on every render
# as a Quarto pre-render step (see _quarto.yaml) and does NOT contact
# GitHub — run scripts/pull_software.R by hand to pull in new repos.
#
# software.qmd renders this file as a Quarto listing (see
# software/software-template.ejs.md).

library(tidyverse)

if (!file.exists("software/software.csv")) {
  stop("software/software.csv not found. Run scripts/pull_software.R first.")
}

# Preferred display order for role labels; anything not listed sorts after
# these, alphabetically.
ROLE_ORDER <- c("Creator & Maintainer", "Maintainer", "Author")

readr::read_csv(
  "software/software.csv",
  col_types = readr::cols(.default = "c"),
  na = character()
) %>%
  filter(display == "Yes") %>%
  mutate(
    role_rank = match(role, ROLE_ORDER),
    role_rank = if_else(is.na(role_rank), length(ROLE_ORDER) + 1L, role_rank)
  ) %>%
  arrange(role_rank, title) %>%
  transmute(title, html_url, github_url, paper_url, description, role) %>%
  purrr::transpose() %>%
  yaml::write_yaml("software/packages.yaml")
