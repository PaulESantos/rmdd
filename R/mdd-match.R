#' Match names against a reference table
#'
#' Compatibility wrapper for the original `rmdd` matching interface used by the
#' package tests. It performs exact matching first and, when requested, a
#' simple approximate lookup against a column of candidate scientific names.
#'
#' @param names Character vector of names to match.
#' @param data Data frame containing a column of candidate names.
#' @param column Name of the candidate-name column in `data`.
#' @param method Matching method. Supported values are `"exact"` and `"agrep"`.
#' @param max_distance Maximum distance passed to [agrep()] when
#'   `method = "agrep"`.
#'
#' @return A tibble with `input_name`, `matched_name`, and `match_status`.
#' @examples
#' sample_path <- system.file("extdata", "mdd_sample.csv", package = "rmdd")
#' mdd_tbl <- mdd_load(sample_path)
#' mdd_match_names(
#'   names = c("Puma concolor", "Puma concolr"),
#'   data = mdd_tbl,
#'   method = "agrep"
#' )
#' @export
mdd_match_names <- function(
  names,
  data,
  column = "scientificName",
  method = c("exact", "agrep"),
  max_distance = 0.1
) {
  method <- match.arg(method)

  if (!is.character(names)) {
    rlang::abort("`names` must be a character vector.")
  }

  if (!inherits(data, "data.frame")) {
    rlang::abort("`data` must be a data frame.")
  }

  if (!column %in% names(data)) {
    rlang::abort(paste0("Column `", column, "` was not found in `data`."))
  }

  candidates <- unique(stats::na.omit(as.character(data[[column]])))
  candidate_key <- .clean_name_for_match(candidates)

  match_one <- function(x) {
    key <- .clean_name_for_match(x)
    exact_idx <- which(candidate_key == key)

    if (length(exact_idx) >= 1) {
      return(tibble::tibble(
        input_name = x,
        matched_name = candidates[[exact_idx[[1]]]],
        match_status = "exact"
      ))
    }

    if (identical(method, "agrep")) {
      approx_idx <- agrep(
        pattern = key,
        x = candidate_key,
        max.distance = max_distance,
        ignore.case = TRUE
      )

      if (length(approx_idx) >= 1) {
        return(tibble::tibble(
          input_name = x,
          matched_name = candidates[[approx_idx[[1]]]],
          match_status = "approximate"
        ))
      }
    }

    tibble::tibble(
      input_name = x,
      matched_name = NA_character_,
      match_status = "none"
    )
  }

  dplyr::bind_rows(lapply(names, match_one))
}
