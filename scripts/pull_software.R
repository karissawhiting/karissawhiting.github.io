# Manual step: pull the latest repos from GitHub.
#
# Run this by hand occasionally (not on every render):
#   Rscript scripts/pull_software.R
#
# It fetches repos from the GitHub accounts/orgs listed in GH_SOURCES below
# and appends any not already in software/software.csv (matched by repo
# name), setting category = "", role = "", reviewed = "No", display = "No"
# on the new rows. Existing rows (including any you've hand-edited) are left
# completely untouched. If software/software.csv doesn't exist yet, this
# creates it fresh from everything found.
#
# scripts/generate_software.R then builds the site listing data straight
# from software.csv without hitting GitHub again.

library(tidyverse)

# Personal account plus any orgs to pull repos from.
GH_SOURCES <- list(
  list(type = "user", login = "karissawhiting"),
  list(type = "orgs", login = "MSKCC-Epi-Bio")
)

fetch_repos <- function(source) {
  gh::gh(
    "/{type}/{login}/repos",
    type = source$type,
    login = source$login,
    per_page = 100,
    .limit = Inf
  )
}

repos <- map(GH_SOURCES, fetch_repos) %>% flatten()

df_repos <- map_df(repos, ~ .x[c("name", "description", "html_url", "homepage")]) %>%
  mutate(
    html_url = case_when(
      (homepage == "" | is.na(homepage)) ~ html_url,
      TRUE ~ homepage
    )
  ) %>%
  transmute(
    repo = name,
    title = name,
    html_url,
    description = replace_na(description, "")
  ) %>%
  distinct(repo, .keep_all = TRUE)

software <- if (file.exists("software/software.csv")) {
  readr::read_csv(
    "software/software.csv",
    col_types = readr::cols(.default = "c"),
    na = character()
  )
} else {
  tibble(
    repo = character(), title = character(), html_url = character(),
    description = character(), category = character(), role = character(),
    reviewed = character(), display = character()
  )
}

new_rows <- df_repos %>%
  filter(!repo %in% software$repo) %>%
  mutate(category = "", role = "", reviewed = "No", display = "No")

if (nrow(new_rows) > 0) {
  software <- bind_rows(software, new_rows)
  readr::write_csv(software, "software/software.csv")
  message(
    nrow(new_rows),
    " new repo(s) added to software.csv with reviewed = No. Set category ",
    "(package/course), role, and reviewed/display, then render the site ",
    "to publish."
  )
  print(new_rows$repo)
} else {
  message("No new repos found.")
}
