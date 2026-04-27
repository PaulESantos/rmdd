#' Return the default rmdd cache directory
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' This function is stable and its interface is expected to remain compatible.
#'
#' @param path Optional path. If `NULL`, a user cache directory is constructed.
#'
#' @return A scalar character path.
#' @examples
#' mdd_cache_dir(tempdir())
#' @export
mdd_cache_dir <- function(path = NULL) {
  if (!is.null(path)) {
    fs::dir_create(path)
    return(path)
  }

  cache_path <- fs::path(
    tools::R_user_dir("rmdd", which = "cache"),
    "mdd"
  )

  fs::dir_create(cache_path)
  cache_path
}

#' Download a Mammal Diversity Database file
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' This function is stable and its interface is expected to remain compatible.
#'
#' @param url URL to the source file.
#' @param dest_dir Destination directory for the downloaded file.
#' @param dest_file Optional output filename.
#' @param mode Transfer mode passed to [utils::download.file()].
#'
#' @return The downloaded file path, invisibly.
#' @examples
#' if (interactive()) {
#'   mdd_download(
#'     url = "https://www.mammaldiversity.org/robots.txt",
#'     dest_dir = tempdir()
#'   )
#' }
#' @export
mdd_download <- function(
  url,
  dest_dir = mdd_cache_dir(),
  dest_file = NULL,
  mode = "wb"
) {
  fs::dir_create(dest_dir)

  if (is.null(dest_file)) {
    dest_file <- basename(url)
  }

  out_file <- fs::path(dest_dir, dest_file)
  cli::cli_alert_info("Downloading MDD source file to {.file {out_file}}")
  utils::download.file(
    url = url,
    destfile = out_file,
    mode = mode,
    quiet = TRUE
  )
  cli::cli_alert_success("Download complete")

  invisible(out_file)
}

#' Load an MDD comma-separated export
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' This function is stable and its interface is expected to remain compatible.
#'
#' @param path Path to a local CSV export from MDD.
#'
#' @return A tibble.
#' @examples
#' sample_path <- system.file("extdata", "mdd_sample.csv", package = "rmdd")
#' mdd_load(sample_path)
#' @export
mdd_load <- function(path) {
  if (!fs::file_exists(path)) {
    cli::cli_abort("File does not exist: {.file {path}}")
  }

  ext <- fs::path_ext(path)
  if (!identical(tolower(ext), "csv")) {
    cli::cli_abort("{.fn mdd_load} currently supports CSV files only.")
  }

  readr::read_csv(path, col_types = readr::cols(), show_col_types = FALSE)
}

#' Reference citations for the Mammal Diversity Database
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' This function is stable and its interface is expected to remain compatible.
#'
#' Return the recommended citation for the current MDD Zenodo release and,
#' optionally, format a citation for a specific MDD taxon entry.
#'
#' @param taxon_id Optional MDD taxon identifier for a specific entry.
#' @param taxon_name Optional scientific name to use in the entry citation.
#'   If `NULL` and `taxon_id` is provided, the function tries to recover the
#'   accepted name from `mdd_checklist`.
#' @return An object of class `mdd_reference` containing dataset-level and,
#'   when requested, entry-level citation strings.
#' @examples
#' mdd_reference()
#' mdd_reference(taxon_id = "1001892", taxon_name = "Dipodomys deserti")
#' @export
mdd_reference <- function(taxon_id = NULL, taxon_name = NULL) {
  has_taxon <- !is.null(taxon_id)

  if (has_taxon) {
    taxon_id <- as.character(taxon_id)
    if (length(taxon_id) != 1L || is.na(taxon_id) || !nzchar(taxon_id)) {
      cli::cli_abort(c(
        "{.arg taxon_id} must be a single non-empty value.",
        "x" = "You supplied {.val {taxon_id}}."
      ))
    }
  }

  fetched_on <- Sys.Date()

  dataset_citation <- paste(
    "Mammal Diversity Database. (2026). Mammal Diversity Database",
    "(Version 2.4) [Data set]. Zenodo. https://doi.org/10.5281/zenodo.17033774"
  )

  resolved_taxon_name <- taxon_name
  if (has_taxon && is.null(resolved_taxon_name)) {
    checklist <- .mdd_default_dataset("mdd_checklist")
    if (!is.null(checklist)) {
      match_row <- tibble::as_tibble(checklist) |>
        dplyr::filter(as.character(id) == taxon_id) |>
        dplyr::slice_head(n = 1)
      if (nrow(match_row) == 1) {
        resolved_taxon_name <- .canonical_binomial(
          match_row$genus,
          match_row$specific_epithet
        )
      }
    }
  }

  entry_citation <- NULL
  if (has_taxon) {
    if (
      is.null(resolved_taxon_name) || !nzchar(as.character(resolved_taxon_name))
    ) {
      cli::cli_abort(c(
        "A specific entry citation requires a taxon name.",
        "i" = "Supply {.arg taxon_name} or provide a {.arg taxon_id} present in {.data mdd_checklist}."
      ))
    }

    fetched_label <- .mdd_format_citation_date(fetched_on)

    entry_citation <- paste0(
      resolved_taxon_name,
      " (ASM Mammal Diversity Database #",
      taxon_id,
      ") fetched ",
#' optionally, format a citation for a specific MDD taxon entry.
#'
#' @param taxon_id Optional MDD taxon identifier for a specific entry.
#' @param taxon_name Optional scientific name to use in the entry citation.
#'   If `NULL` and `taxon_id` is provided, the function tries to recover the
#'   accepted name from `mdd_checklist`.
#' @return An object of class `mdd_reference` containing dataset-level and,
#'   when requested, entry-level citation strings.
#' @examples
#' mdd_reference()
#' mdd_reference(taxon_id = "1001892", taxon_name = "Dipodomys deserti")
#' @export
mdd_reference <- function(taxon_id = NULL, taxon_name = NULL) {
  has_taxon <- !is.null(taxon_id)

  if (has_taxon) {
    taxon_id <- as.character(taxon_id)
    if (length(taxon_id) != 1L || is.na(taxon_id) || !nzchar(taxon_id)) {
      cli::cli_abort(c(
        "{.arg taxon_id} must be a single non-empty value.",
        "x" = "You supplied {.val {taxon_id}}."
      ))
    }
  }

  fetched_on <- Sys.Date()

  dataset_citation <- paste(
    "Mammal Diversity Database. (2026). Mammal Diversity Database",
    "(Version 2.4) [Data set]. Zenodo. https://doi.org/10.5281/zenodo.17033774"
  )

  resolved_taxon_name <- taxon_name
  if (has_taxon && is.null(resolved_taxon_name)) {
    checklist <- .mdd_default_dataset("mdd_checklist")
    if (!is.null(checklist)) {
      match_row <- tibble::as_tibble(checklist) |>
        dplyr::filter(as.character(id) == taxon_id) |>
        dplyr::slice_head(n = 1)
      if (nrow(match_row) == 1) {
        resolved_taxon_name <- .canonical_binomial(
          match_row$genus,
          match_row$specific_epithet
        )
      }
    }
  }

  entry_citation <- NULL
  if (has_taxon) {
    if (
      is.null(resolved_taxon_name) || !nzchar(as.character(resolved_taxon_name))
    ) {
      cli::cli_abort(c(
        "A specific entry citation requires a taxon name.",
        "i" = "Supply {.arg taxon_name} or provide a {.arg taxon_id} present in {.data mdd_checklist}."
      ))
    }

    fetched_label <- .mdd_format_citation_date(fetched_on)

    entry_citation <- paste0(
      resolved_taxon_name,
      " (ASM Mammal Diversity Database #",
      taxon_id,
      ") fetched ",
      fetched_label,
      ". Mammal Diversity Database. 2026. https://www.mammaldiversity.org/taxon/",
      taxon_id
    )
  }

  out <- list(
    dataset_citation = dataset_citation,
    dataset_doi = "https://doi.org/10.5281/zenodo.17033774",
    dataset_url = "https://www.mammaldiversity.org/",
    entry_citation = entry_citation,
    taxon_id = if (has_taxon) taxon_id else NULL,
    taxon_name = if (has_taxon) as.character(resolved_taxon_name) else NULL,
    fetched_on = fetched_on
  )

  class(out) <- "mdd_reference"
  out
}

#' @return The \code{mdd_reference} object, invisibly.
#' @export
print.mdd_reference <- function(x, ...) {
  cli::cli_h2("MDD Citation")
  cli::cli_text(x$dataset_citation)
  cli::cli_text("DOI: {.url {x$dataset_doi}}")

  if (!is.null(x$entry_citation)) {
    cli::cli_h3("Specific Entry")
    cli::cli_text(x$entry_citation)
  }

  invisible(x)
}

.mdd_format_citation_date <- function(x) {
  x <- as.Date(x)
  parts <- as.POSIXlt(x)
  paste0(month.name[[parts$mon + 1]], " ", parts$mday, ", ", parts$year + 1900)
}
