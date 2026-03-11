#' Match mammal names against an MDD table
#'
#' @param names Character vector of names to resolve.
#' @param data A data frame or tibble containing an MDD name column.
#' @param name_col Column in `data` containing candidate names.
#' @param max_distance Maximum normalized distance accepted for approximate
#'   matches. Ignored for exact matching.
#' @param method Matching method. One of `"exact"` or `"agrep"`.
#'
#' @return A tibble with submitted names, matched names, match status, and
#'   distance.
#' @export
mdd_match_names <- function(names,
                            data,
                            name_col = "scientificName",
                            max_distance = 0.1,
                            method = c("exact", "agrep")) {
  method <- rlang::arg_match(method)

  if (!is.character(names)) {
    rlang::abort("`names` must be a character vector.")
  }

  if (!name_col %in% names(data)) {
    rlang::abort(paste0("Column not found in `data`: ", name_col))
  }

  candidates <- data[[name_col]]
  candidates <- stringr::str_squish(stringr::str_to_lower(as.character(candidates)))
  submitted <- stringr::str_squish(stringr::str_to_lower(names))

  matches <- lapply(submitted, function(x) {
    if (is.na(x) || x == "") {
      return(list(match = NA_character_, status = "empty", distance = NA_real_))
    }

    exact_idx <- which(candidates == x)[1]
    if (!is.na(exact_idx)) {
      return(list(
        match = data[[name_col]][exact_idx],
        status = "exact",
        distance = 0
      ))
    }

    if (identical(method, "exact")) {
      return(list(match = NA_character_, status = "unmatched", distance = NA_real_))
    }

    distances <- utils::adist(x, candidates, partial = FALSE, ignore.case = TRUE)
    scaled <- as.numeric(distances) / pmax(nchar(x), nchar(candidates), 1)
    best_idx <- which.min(scaled)
    best_distance <- scaled[[best_idx]]

    if (is.finite(best_distance) && best_distance <= max_distance) {
      return(list(
        match = data[[name_col]][best_idx],
        status = "approximate",
        distance = best_distance
      ))
    }

    list(match = NA_character_, status = "unmatched", distance = NA_real_)
  })

  tibble::tibble(
    submitted_name = names,
    matched_name = vapply(matches, `[[`, character(1), "match"),
    match_status = vapply(matches, `[[`, character(1), "status"),
    match_distance = vapply(matches, `[[`, numeric(1), "distance")
  )
}
