## code to download the latest Mammal Diversity Database release and record metadata
## re-run this to update the MDD data when there is a new release
## REMEMBER TO UPDATE THE DOCS IF THE DATA STRUCTURE HAS CHANGED

library(cli)
library(fs)
library(readr)
library(stringr)
library(usethis)

source_url <- "https://github.com/mammaldiversity/mammaldiversity.github.io/raw/refs/heads/master/assets/data/MDD.zip"

temp_zip <- tempfile(fileext = ".zip")
extract_dir <- tempfile(pattern = "mdd-files-")
dir_create(extract_dir)

cli_alert_info("Downloading latest MDD data from {source_url}...")

old_timeout <- getOption("timeout")
on.exit(options(timeout = old_timeout), add = TRUE)
options(timeout = max(600, old_timeout))

method <- if (.Platform$OS.type == "windows") "wininet" else "libcurl"

download.file(
  url = source_url,
  destfile = temp_zip,
  method = method,
  mode = "wb",
  quiet = TRUE
)

zip_listing <- tryCatch(
  utils::unzip(temp_zip, list = TRUE),
  error = function(e) NULL
)

if (is.null(zip_listing)) {
  stop(
    "The ZIP download appears incomplete or corrupted. Re-run the download or try a different network.",
    call. = FALSE
  )
}

cli_alert_success("ZIP file downloaded and verified.")
utils::unzip(temp_zip, exdir = extract_dir)

# ---------------------------------------------------------------
release_root <- path("data-raw")

extract_path <- function(rel_path) {
  path(release_root, rel_path)
}

find_member <- function(pattern, required = TRUE, prefix = release_root) {
  hits <- zip_listing$Name[str_detect(
    zip_listing$Name,
    regex(pattern, ignore_case = TRUE)
  )]

  if (length(hits) == 0) {
    if (required) {
      stop(
        paste0("Required file not found in MDD archive: ", pattern),
        call. = FALSE
      )
    }
    return(NA_character_)
  }

  path(prefix, hits[[1]])
}

read_csv_release <- function(rel_path) {
  read_csv(rel_path, show_col_types = FALSE)
}

parse_release_toml <- function(path) {
  if (is.na(path) || !file_exists(path)) {
    return(list())
  }

  lines <- readLines(path, warn = FALSE)
  lines <- str_trim(lines)
  lines <- lines[lines != ""]
  lines <- lines[!str_starts(lines, "#")]
  lines <- lines[!str_detect(lines, "^\\[")]

  keys <- str_match(lines, "^([A-Za-z0-9_]+)\\s*=\\s*\"?(.*?)\"?$")
  keys <- keys[!is.na(keys[, 2]), , drop = FALSE]

  stats::setNames(as.list(keys[, 3]), keys[, 2])
}

checklist_file <- find_member("(^|/)MDD_.*species\\.csv$")
synonym_file <- find_member("(^|/)Species_Syn_.*\\.csv$")
type_file <- find_member(
  "(^|/)TypeSpecimenMetadata_.*\\.csv$",
  required = FALSE
)
diff_file <- find_member("(^|/)Diff_v.*\\.csv$", required = FALSE)
diff_all_file <- find_member(
  "(^|/)Diff-AllChanges_v.*\\.csv$",
  required = FALSE
)
meta_file <- find_member("(^|/)META_v.*\\.csv$", required = FALSE)
release_file <- find_member("(^|/)release\\.toml$", required = FALSE)

cli_alert_info("Processing current checklist from {.file {checklist_file}}...")
checklist_file
mdd_checklist <- read_csv_release(checklist_file) |>
  janitor::clean_names()
mdd_checklist

cli_alert_info("Processing synonym table from {.file {synonym_file}}...")
mdd_synonyms <- read_csv_release(synonym_file) |>
  janitor::clean_names()
mdd_synonyms

if (!is.na(type_file)) {
  cli_alert_info(
    "Processing type specimen metadata from {.file {type_file}}..."
  )
  mdd_type_specimen_metadata <- read_csv_release(type_file) |>
    janitor::clean_names()
}
mdd_type_specimen_metadata

if (!"sci_name" %in% names(mdd_checklist)) {
  cli_alert_warning(
    "The current checklist does not contain a {.field sci_name} column. Review the upstream structure before updating matching helpers."
  )
}

if (!"mdd_species" %in% names(mdd_synonyms)) {
  cli_alert_warning(
    "The synonym table does not contain a {.field MDD_species} column. Review the upstream structure before updating synonym helpers."
  )
}

cli_alert_info("Saving package datasets...")

usethis::use_data(mdd_checklist, compress = "xz", overwrite = TRUE)
usethis::use_data(mdd_synonyms, compress = "xz", overwrite = TRUE)

if (exists("mdd_type_specimen_metadata")) {
  usethis::use_data(
    mdd_type_specimen_metadata,
    compress = "xz",
    overwrite = TRUE
  )
}

release_metadata <- parse_release_toml(release_file)
release_metadata

metadata <- list(
  source = "Mammal Diversity Database",
  source_url = source_url,
  downloaded_at = as.character(Sys.Date()),
  archive_file = basename(source_url),
  archive_members = zip_listing$Name[
    str_detect(zip_listing$Name, "^MDD/") & # solo carpeta MDD/
      !str_detect(zip_listing$Name, "^__MACOSX") & # excluir metadata macOS
      !str_ends(zip_listing$Name, "/") # excluir directorios
  ],
  checklist_file = checklist_file,
  checklist_rows = nrow(mdd_checklist),
  checklist_cols = ncol(mdd_checklist),
  synonym_file = synonym_file,
  synonym_rows = nrow(mdd_synonyms),
  synonym_cols = ncol(mdd_synonyms),
  type_specimen_file = type_file,
  release_file = release_file,
  release = release_metadata
)

metadata

usethis::use_data(
  metadata,
  internal = TRUE,
  overwrite = TRUE
)

cli_alert_success(
  "Datasets updated: checklist ({nrow(mdd_checklist)} rows), synonyms ({nrow(mdd_synonyms)} rows)."
)

cli_alert_info("Cleaning up temporary files...")
unlink(extract_dir, recursive = TRUE)

cli_alert_success("MDD data update process completed successfully.")
