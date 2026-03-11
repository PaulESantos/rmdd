#' Return the default rmdd cache directory
#'
#' @param path Optional path. If `NULL`, a user cache directory is constructed.
#'
#' @return A scalar character path.
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
#' @param url URL to the source file.
#' @param dest_dir Destination directory for the downloaded file.
#' @param dest_file Optional output filename.
#' @param mode Transfer mode passed to [utils::download.file()].
#'
#' @return The downloaded file path, invisibly.
#' @export
mdd_download <- function(url,
                         dest_dir = mdd_cache_dir(),
                         dest_file = NULL,
                         mode = "wb") {
  fs::dir_create(dest_dir)

  if (is.null(dest_file)) {
    dest_file <- basename(url)
  }

  out_file <- fs::path(dest_dir, dest_file)
  cli::cli_alert_info("Downloading MDD source file to {.file {out_file}}")
  utils::download.file(url = url, destfile = out_file, mode = mode, quiet = TRUE)
  cli::cli_alert_success("Download complete")

  invisible(out_file)
}

#' Load an MDD comma-separated export
#'
#' @param path Path to a local CSV export from MDD.
#'
#' @return A tibble.
#' @export
mdd_load <- function(path) {
  if (!fs::file_exists(path)) {
    rlang::abort(paste0("File does not exist: ", path))
  }

  ext <- fs::path_ext(path)
  if (!identical(tolower(ext), "csv")) {
    rlang::abort("`mdd_load()` currently supports CSV files only.")
  }

  readr::read_csv(path, col_types = readr::cols(), show_col_types = FALSE)
}

#' Reference metadata for the Mammal Diversity Database
#'
#' @return A tibble with package-relevant reference metadata.
#' @export
mdd_reference <- function() {
  tibble::tibble(
    source = "Mammal Diversity Database",
    url = "https://www.mammaldiversity.org/",
    notes = "Replace with a stable file endpoint once the preferred MDD export is selected."
  )
}
