# Manual step: pull the latest publications from Google Scholar.
#
# Run this by hand occasionally (not on every render):
#   Rscript scripts/pull_publications.R
#
# It fetches from Scholar and appends any titles not already in
# research/publications.csv, marking them reviewed = No, display = No.
# Existing rows (including any you've hand-edited) are left completely
# untouched — matching is by exact title, so a pull never overwrites manual
# edits. If research/publications.csv doesn't exist yet, this creates it
# fresh from everything Scholar returns (all rows start reviewed = No,
# display = No).
# scripts/generate_publications.R then builds the site bibliography straight
# from publications.csv without hitting Scholar again.

library(tidyverse)

df_articles <-
  scholar::get_publications('00zHKW8AAAAJ') %>%
  as_tibble() %>%
  # delete abstracts
  filter(
    !is.na(year), # missing publication year
    title != str_to_upper(title), # title is all upper case
    !str_detect(number, fixed("Supplement")), # number contains 'Supplement'
    !str_detect(number, fixed("_suppl")), # number contains '_suppl'
    # journal is EU Supplements
    journal != "European Urology Supplements"
  )

df_articles <- df_articles %>%
  # clean up authors
  mutate(
    author = case_when(
      str_detect(author, "EV Robilotti") ~ str_replace(
        author,
        fixed("EV Robilotti, K Whiting"),
        fixed("K Whiting, EV Robilotti")
      ),
      str_detect(author, "N Almassi, K Whiting") ~ str_replace(
        author,
        fixed("N Almassi, K Whiting"),
        fixed("K Whiting, N Almassi")
      ),
      str_detect(author, "KA Whiting") ~ str_replace(
        author,
        "KA Whiting",
        "K Whiting"
      ),
      TRUE ~ author
    )
  ) %>%

  mutate(
    # replacing ... with 'and others'
    author = str_replace(author, fixed("..."), fixed("and others")),
    author = case_when(
      !str_detect(author, fixed("Whiting")) ~
        str_replace(
          author,
          fixed("and others"),
          fixed("K Whiting, and others")
        ),
      TRUE ~ author
    )
  ) %>%
  select(title, author, journal, number, year) %>%
  distinct(title, .keep_all = TRUE)

publications <- if (file.exists("research/publications.csv")) {
  readr::read_csv(
    "research/publications.csv",
    col_types = readr::cols(.default = "c"),
    na = character()
  )
} else {
  tibble(
    title = character(), author = character(), journal = character(),
    number = character(), year = character(), reviewed = character(),
    display = character()
  )
}

new_rows <- df_articles %>%
  filter(!title %in% publications$title) %>%
  mutate(reviewed = "No", display = "No") %>%
  mutate(year = as.character(year))

if (nrow(new_rows) > 0) {
  publications <- bind_rows(publications, new_rows)
  readr::write_csv(publications, "research/publications.csv")
  message(
    nrow(new_rows),
    " new publication(s) added to publications.csv with ",
    "reviewed = No. Review them and set reviewed/display, then render ",
    "the site to publish."
  )
  print(new_rows$title)
} else {
  message("No new publications found.")
}
