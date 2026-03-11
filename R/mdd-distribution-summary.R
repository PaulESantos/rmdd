#' Summarize mammal diversity by country, continent, or subregion
#'
#' Expand MDD distribution fields and compute diversity summaries by
#' geographic unit. The summary reports counts of distinct orders, families,
#' genera, living species, and extinct species for each unit listed in the
#' selected MDD distribution column.
#'
#' @param level Geographic level to summarize. Use `"country"`,
#'   `"continent"`, or `"subregion"`.
#' @param checklist Optional checklist data frame. Defaults to
#'   `mdd_checklist`.
#' @param exclude_domesticated Logical. If `TRUE`, drop rows where
#'   `domestic == 1`.
#' @param exclude_widespread Logical. If `TRUE`, drop species whose
#'   distribution spans more than `widespread_threshold` units at the chosen
#'   level.
#' @param widespread_threshold Optional threshold used to define widespread
#'   species. If `NULL`, a level-specific default is used.
#'
#' @return A tibble with one row per geographic unit and the columns `region`,
#'   `orders`, `families`, `genera`, `living_species`, `extinct_species`, and
#'   `total_species`.
#' @export
mdd_distribution_summary <- function(level = c("country", "continent", "subregion"),
                                     checklist = NULL,
                                     exclude_domesticated = TRUE,
                                     exclude_widespread = TRUE,
                                     widespread_threshold = NULL) {
  level <- match.arg(level)
  checklist <- checklist %||% .mdd_default_dataset("mdd_checklist")

  if (is.null(checklist)) {
    cli::cli_abort(c(
      "{.arg checklist} is required when {.data mdd_checklist} is not available.",
      "i" = "Load the packaged data or supply a compatible checklist tibble."
    ))
  }

  area_col <- switch(
    level,
    country = "country_distribution",
    continent = "continent_distribution",
    subregion = "subregion_distribution"
  )

  checklist <- tibble::as_tibble(checklist)
  required_cols <- c(area_col, "order", "family", "genus", "sci_name")
  .assert_has_columns(checklist, required_cols, "checklist")

  if (!"extinct" %in% names(checklist)) {
    checklist$extinct <- NA_real_
  }

  if (!"domestic" %in% names(checklist)) {
    checklist$domestic <- NA_real_
  }

  if (is.null(widespread_threshold)) {
    widespread_threshold <- .mdd_default_widespread_threshold(level)
  }

  if (!is.numeric(widespread_threshold) || length(widespread_threshold) != 1L ||
      is.na(widespread_threshold) || widespread_threshold < 1) {
    cli::cli_abort(c(
      "{.arg widespread_threshold} must be a single positive number.",
      "x" = "You supplied {.val {widespread_threshold}}."
    ))
  }

  checklist <- checklist |>
    dplyr::mutate(.distribution_count = .mdd_distribution_count(.data[[area_col]]))

  if (isTRUE(exclude_domesticated)) {
    checklist <- checklist |>
      dplyr::filter(is.na(domestic) | domestic == 0)
  }

  if (isTRUE(exclude_widespread)) {
    checklist <- checklist |>
      dplyr::filter(is.na(.distribution_count) | .distribution_count <= widespread_threshold)
  }

  expanded <- .mdd_expand_distribution_units(checklist, area_col)

  if (nrow(expanded) == 0) {
    return(tibble::tibble(
      region = character(),
      orders = integer(),
      families = integer(),
      genera = integer(),
      living_species = integer(),
      extinct_species = integer(),
      total_species = integer()
    ))
  }

  expanded |>
    dplyr::group_by(region) |>
    dplyr::summarise(
      orders = dplyr::n_distinct(order),
      families = dplyr::n_distinct(family),
      genera = dplyr::n_distinct(genus),
      living_species = dplyr::n_distinct(sci_name[is.na(extinct) | extinct == 0]),
      extinct_species = dplyr::n_distinct(sci_name[!is.na(extinct) & extinct == 1]),
      total_species = dplyr::n_distinct(sci_name),
      .groups = "drop"
    ) |>
    dplyr::arrange(dplyr::desc(living_species), region)
}

.mdd_expand_distribution_units <- function(checklist, area_col) {
  out <- lapply(seq_len(nrow(checklist)), function(i) {
    value <- checklist[[area_col]][[i]]
    units <- .mdd_parse_distribution_units(value)
    if (length(units) == 0) {
      return(NULL)
    }

    row <- checklist[rep(i, length(units)), , drop = FALSE]
    row$region <- units
    row
  })

  out <- out[!vapply(out, is.null, logical(1))]
  if (length(out) == 0) {
    return(tibble::as_tibble(checklist[0, , drop = FALSE]) |>
      dplyr::mutate(region = character()))
  }

  dplyr::bind_rows(out) |>
    dplyr::distinct(region, sci_name, .keep_all = TRUE)
}

.mdd_parse_distribution_units <- function(x) {
  if (length(x) == 0 || is.null(x) || all(is.na(x))) {
    return(character())
  }

  units <- unlist(strsplit(as.character(x[[1]]), "\\|"), use.names = FALSE)
  units <- trimws(gsub("[?]+$", "", units))
  units <- units[nzchar(units)]
  unique(units)
}

.mdd_distribution_count <- function(x) {
  vapply(x, function(value) length(.mdd_parse_distribution_units(value)), integer(1))
}

.mdd_default_widespread_threshold <- function(level) {
  switch(
    level,
    country = 25L,
    continent = 3L,
    subregion = 40L
  )
}
