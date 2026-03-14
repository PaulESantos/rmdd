#' Return checklist records in a normalized tibble
#'
#' @param checklist Optional checklist data frame. Defaults to `mdd_checklist`.
#'
#' @return A tibble.
#' @examples
#' mdd_checklist_records()
#' @export
mdd_checklist_records <- function(checklist = NULL) {
  checklist <- checklist %||% .mdd_default_dataset("mdd_checklist")

  if (is.null(checklist)) {
    cli::cli_abort(c(
      "{.arg checklist} is required when {.data mdd_checklist} is not available.",
      "i" = "Load the packaged data or supply a compatible checklist tibble."
    ))
  }

  tibble::as_tibble(checklist)
}

#' Return synonym records in a normalized tibble
#'
#' @param synonyms Optional synonym data frame. Defaults to `mdd_synonyms`.
#'
#' @return A tibble.
#' @examples
#' mdd_synonym_records()
#' @export
mdd_synonym_records <- function(synonyms = NULL) {
  synonyms <- synonyms %||% .mdd_default_dataset("mdd_synonyms")

  if (is.null(synonyms)) {
    cli::cli_abort(c(
      "{.arg synonyms} is required when {.data mdd_synonyms} is not available.",
      "i" = "Load the packaged data or supply a compatible synonym tibble."
    ))
  }

  tibble::as_tibble(synonyms)
}

#' Return release records used by rmdd
#'
#' @param checklist Optional checklist data frame.
#' @param synonyms Optional synonym data frame.
#' @param type_specimen_metadata Optional type specimen metadata table.
#'
#' @return A named list of tibbles.
#' @examples
#' x <- mdd_release_records()
#' names(x)
#' @export
mdd_release_records <- function(
  checklist = NULL,
  synonyms = NULL,
  type_specimen_metadata = NULL
) {
  list(
    checklist = mdd_checklist_records(checklist),
    synonyms = mdd_synonym_records(synonyms),
    type_specimen_metadata = tibble::as_tibble(
      type_specimen_metadata %||%
        .mdd_default_dataset("mdd_type_specimen_metadata")
    )
  )
}

.mdd_match_records_cache <- new.env(parent = emptyenv())

.has_prepared_checklist_match_cols <- function(x) {
  all(c(
    ".match_genus", ".original_leading_genus", ".original_query_name",
    ".original_query_name_clean", ".original_query_genus",
    ".original_query_species", ".original_stripped_query_name",
    ".original_stripped_query_name_clean", ".original_stripped_query_genus",
    ".original_stripped_query_species"
  ) %in% names(x))
}

.has_prepared_synonym_match_cols <- function(x) {
  all(c(
    ".original_leading_genus", ".synonym_query_name",
    ".synonym_query_name_clean", ".synonym_query_genus",
    ".synonym_query_species", ".synonym_stripped_query_name",
    ".synonym_stripped_query_name_clean", ".synonym_stripped_query_genus",
    ".synonym_stripped_query_species"
  ) %in% names(x))
}

.mdd_prepare_checklist_genus_index <- function(checklist) {
  checklist <- mdd_checklist_records(checklist)
  .assert_has_columns(checklist, c("id", "genus", "specific_epithet"), "checklist")

  if (!"original_name_combination" %in% names(checklist)) {
    checklist$original_name_combination <- NA_character_
  }

  checklist |>
    dplyr::mutate(
      .match_genus = .title_case(genus),
      .original_leading_genus = .leading_genus(original_name_combination)
    )
}

.mdd_prepare_synonym_genus_index <- function(synonyms) {
  synonyms <- mdd_synonym_records(synonyms)
  .assert_has_columns(
    synonyms,
    c("mdd_syn_id", "mdd_species_id", "mdd_original_combination"),
    "synonyms"
  )

  synonyms |>
    dplyr::mutate(
      .original_leading_genus = .leading_genus(mdd_original_combination)
    )
}

.prepare_checklist_genus_index <- function(checklist = NULL) {
  if (!is.null(checklist) && all(c(".match_genus", ".original_leading_genus") %in% names(checklist))) {
    return(tibble::as_tibble(checklist))
  }

  if (is.null(checklist)) {
    if (!exists("checklist_genus_index", envir = .mdd_match_records_cache, inherits = FALSE)) {
      assign(
        "checklist_genus_index",
        .mdd_prepare_checklist_genus_index(NULL),
        envir = .mdd_match_records_cache
      )
    }

    return(get("checklist_genus_index", envir = .mdd_match_records_cache, inherits = FALSE))
  }

  .mdd_prepare_checklist_genus_index(checklist)
}

.prepare_synonym_genus_index <- function(synonyms = NULL) {
  if (!is.null(synonyms) && ".original_leading_genus" %in% names(synonyms)) {
    return(tibble::as_tibble(synonyms))
  }

  if (is.null(synonyms)) {
    if (!exists("synonym_genus_index", envir = .mdd_match_records_cache, inherits = FALSE)) {
      assign(
        "synonym_genus_index",
        .mdd_prepare_synonym_genus_index(NULL),
        envir = .mdd_match_records_cache
      )
    }

    return(get("synonym_genus_index", envir = .mdd_match_records_cache, inherits = FALSE))
  }

  .mdd_prepare_synonym_genus_index(synonyms)
}

.mdd_prepare_checklist_match_records <- function(checklist) {
  checklist <- mdd_checklist_records(checklist)
  .assert_has_columns(
    checklist,
    c("id", "genus", "specific_epithet"),
    "checklist"
  )

  if (!"sci_name" %in% names(checklist)) {
    checklist$sci_name <- paste(
      checklist$genus,
      checklist$specific_epithet,
      sep = "_"
    )
  }

  if (!"authority_species_author" %in% names(checklist)) {
    checklist$authority_species_author <- NA_character_
  }

  if (!"original_name_combination" %in% names(checklist)) {
    checklist$original_name_combination <- NA_character_
  }

  parsed_original <- .parse_backbone_name(checklist$original_name_combination)
  parsed_original_stripped <- .parse_backbone_name(
    .strip_subgenus(checklist$original_name_combination)
  )

  checklist |>
    dplyr::mutate(
      .match_genus = .title_case(genus),
      .original_leading_genus = .leading_genus(original_name_combination),
      .original_query_name = parsed_original$query_name,
      .original_query_name_clean = parsed_original$query_name_clean,
      .original_query_genus = parsed_original$query_genus,
      .original_query_species = parsed_original$query_species,
      .original_stripped_query_name = parsed_original_stripped$query_name,
      .original_stripped_query_name_clean = parsed_original_stripped$query_name_clean,
      .original_stripped_query_genus = parsed_original_stripped$query_genus,
      .original_stripped_query_species = parsed_original_stripped$query_species
    )
}

.mdd_prepare_synonym_match_records <- function(synonyms) {
  synonyms <- mdd_synonym_records(synonyms)
  .assert_has_columns(
    synonyms,
    c("mdd_syn_id", "mdd_species_id", "mdd_original_combination"),
    "synonyms"
  )

  if (!"mdd_author" %in% names(synonyms)) {
    synonyms$mdd_author <- NA_character_
  }

  normalized_combination <- if (
    "mdd_normalized_original_combination" %in% names(synonyms)
  ) {
    dplyr::coalesce(
      synonyms$mdd_normalized_original_combination,
      synonyms$mdd_original_combination
    )
  } else {
    synonyms$mdd_original_combination
  }

  parsed_original <- .parse_backbone_name(normalized_combination)
  parsed_original_stripped <- .parse_backbone_name(.strip_subgenus(
    normalized_combination
  ))

  synonyms |>
    dplyr::mutate(
      .original_leading_genus = .leading_genus(mdd_original_combination),
      .synonym_query_name = parsed_original$query_name,
      .synonym_query_name_clean = parsed_original$query_name_clean,
      .synonym_query_genus = parsed_original$query_genus,
      .synonym_query_species = parsed_original$query_species,
      .synonym_stripped_query_name = parsed_original_stripped$query_name,
      .synonym_stripped_query_name_clean = parsed_original_stripped$query_name_clean,
      .synonym_stripped_query_genus = parsed_original_stripped$query_genus,
      .synonym_stripped_query_species = parsed_original_stripped$query_species
    )
}

.prepare_checklist_match_records <- function(checklist = NULL) {
  if (!is.null(checklist) && .has_prepared_checklist_match_cols(checklist)) {
    return(tibble::as_tibble(checklist))
  }

  if (is.null(checklist)) {
    if (
      !exists(
        "prepared_checklist",
        envir = .mdd_match_records_cache,
        inherits = FALSE
      )
    ) {
      assign(
        "prepared_checklist",
        .mdd_prepare_checklist_match_records(NULL),
        envir = .mdd_match_records_cache
      )
    }

    return(get(
      "prepared_checklist",
      envir = .mdd_match_records_cache,
      inherits = FALSE
    ))
  }

  .mdd_prepare_checklist_match_records(checklist)
}

.prepare_synonym_match_records <- function(synonyms = NULL) {
  if (!is.null(synonyms) && .has_prepared_synonym_match_cols(synonyms)) {
    return(tibble::as_tibble(synonyms))
  }

  if (is.null(synonyms)) {
    if (
      !exists(
        "prepared_synonyms",
        envir = .mdd_match_records_cache,
        inherits = FALSE
      )
    ) {
      assign(
        "prepared_synonyms",
        .mdd_prepare_synonym_match_records(NULL),
        envir = .mdd_match_records_cache
      )
    }

    return(get(
      "prepared_synonyms",
      envir = .mdd_match_records_cache,
      inherits = FALSE
    ))
  }

  .mdd_prepare_synonym_match_records(synonyms)
}

.mdd_source_genera <- function(checklist = NULL, synonyms = NULL) {
  if (is.null(checklist) && is.null(synonyms)) {
    if (
      !exists(
        "source_genera",
        envir = .mdd_match_records_cache,
        inherits = FALSE
      )
    ) {
      prepared_checklist <- .prepare_checklist_genus_index()
      prepared_synonyms <- .prepare_synonym_genus_index()
      genera <- unique(c(
        prepared_checklist$.match_genus,
        prepared_checklist$.original_leading_genus,
        prepared_synonyms$.original_leading_genus
      ))
      genera <- unique(stats::na.omit(genera[nzchar(genera)]))
      assign("source_genera", genera, envir = .mdd_match_records_cache)
    }

    return(get(
      "source_genera",
      envir = .mdd_match_records_cache,
      inherits = FALSE
    ))
  }

  prepared_checklist <- .prepare_checklist_genus_index(checklist)
  prepared_synonyms <- .prepare_synonym_genus_index(synonyms)
  genera <- unique(c(
    prepared_checklist$.match_genus,
    prepared_checklist$.original_leading_genus,
    prepared_synonyms$.original_leading_genus
  ))
  unique(stats::na.omit(genera[nzchar(genera)]))
}

#' Build a normalized MDD name index
#'
#' Create a reusable name index that combines accepted checklist names,
#' checklist original combinations, and synonym names while preserving the
#' accepted-species linkage for each row.
#'
#' @param checklist Optional checklist data frame. Defaults to `mdd_checklist`.
#' @param synonyms Optional synonym data frame. Defaults to `mdd_synonyms`.
#'
#' @return A tibble with one row per queryable accepted name or synonym.
#' @examples
#' idx <- mdd_name_index(
#'   checklist = dplyr::slice(mdd_checklist, 1:10),
#'   synonyms = dplyr::slice(mdd_synonyms, 1:20)
#' )
#' idx
#' @export
mdd_name_index <- function(checklist = NULL, synonyms = NULL) {
  checklist <- .prepare_checklist_match_records(checklist)
  synonyms <- .prepare_synonym_match_records(synonyms)

  accepted <- checklist |>
    dplyr::transmute(
      query_name = .canonical_binomial(genus, specific_epithet),
      query_name_clean = .clean_name_for_match(query_name),
      query_genus = as.character(genus),
      query_species = as.character(specific_epithet),
      matched_name_id = as.character(id),
      matched_name = query_name,
      matched_author = as.character(authority_species_author),
      taxon_status = "accepted",
      match_source = "checklist",
      original_name_raw = as.character(sci_name),
      accepted_id = as.character(id),
      accepted_name = query_name,
      accepted_author = as.character(authority_species_author),
      accepted_genus = as.character(genus),
      accepted_species = as.character(specific_epithet),
      is_accepted_name = TRUE,
      status_rank = 2L
    )

  original_rows <- checklist |>
    dplyr::transmute(
      query_name = .original_query_name,
      query_name_clean = .original_query_name_clean,
      query_genus = .original_query_genus,
      query_species = .original_query_species,
      matched_name_id = as.character(id),
      matched_name = query_name,
      matched_author = as.character(authority_species_author),
      taxon_status = "original_combination",
      match_source = "checklist_original_combination",
      original_name_raw = as.character(original_name_combination),
      accepted_id = as.character(id),
      accepted_name = .canonical_binomial(genus, specific_epithet),
      accepted_author = as.character(authority_species_author),
      accepted_genus = as.character(genus),
      accepted_species = as.character(specific_epithet),
      is_accepted_name = FALSE,
      status_rank = 1L
    ) |>
    dplyr::filter(!is.na(query_name), nzchar(query_name))

  original_stripped_rows <- checklist |>
    dplyr::transmute(
      query_name = .original_stripped_query_name,
      query_name_clean = .original_stripped_query_name_clean,
      query_genus = .original_stripped_query_genus,
      query_species = .original_stripped_query_species,
      matched_name_id = as.character(id),
      matched_name = query_name,
      matched_author = as.character(authority_species_author),
      taxon_status = "original_combination",
      match_source = "checklist_original_combination_stripped",
      original_name_raw = as.character(original_name_combination),
      accepted_id = as.character(id),
      accepted_name = .canonical_binomial(genus, specific_epithet),
      accepted_author = as.character(authority_species_author),
      accepted_genus = as.character(genus),
      accepted_species = as.character(specific_epithet),
      is_accepted_name = FALSE,
      status_rank = 1L
    ) |>
    dplyr::filter(!is.na(query_name), nzchar(query_name))

  if (nrow(synonyms) == 0) {
    return(
      dplyr::bind_rows(accepted, original_rows, original_stripped_rows) |>
        dplyr::distinct()
    )
  }

  accepted_lookup <- checklist |>
    dplyr::transmute(
      accepted_id = as.character(id),
      accepted_name = .canonical_binomial(genus, specific_epithet),
      accepted_author = as.character(authority_species_author),
      accepted_genus = as.character(genus),
      accepted_species = as.character(specific_epithet)
    )

  synonym_tbl <- synonyms |>
    dplyr::mutate(mdd_species_id = as.character(mdd_species_id)) |>
    dplyr::left_join(
      accepted_lookup,
      by = c("mdd_species_id" = "accepted_id")
    ) |>
    dplyr::transmute(
      query_name = .synonym_query_name,
      query_name_clean = .synonym_query_name_clean,
      query_genus = .synonym_query_genus,
      query_species = .synonym_query_species,
      matched_name_id = as.character(mdd_syn_id),
      matched_name = query_name,
      matched_author = as.character(mdd_author),
      taxon_status = "synonym",
      match_source = "synonym",
      original_name_raw = as.character(mdd_original_combination),
      accepted_id = as.character(mdd_species_id),
      accepted_name = accepted_name,
      accepted_author = accepted_author,
      accepted_genus = accepted_genus,
      accepted_species = accepted_species,
      is_accepted_name = FALSE,
      status_rank = 1L
    ) |>
    dplyr::filter(!is.na(query_name), nzchar(query_name))

  synonym_stripped_tbl <- synonyms |>
    dplyr::mutate(mdd_species_id = as.character(mdd_species_id)) |>
    dplyr::left_join(
      accepted_lookup,
      by = c("mdd_species_id" = "accepted_id")
    ) |>
    dplyr::transmute(
      query_name = .synonym_stripped_query_name,
      query_name_clean = .synonym_stripped_query_name_clean,
      query_genus = .synonym_stripped_query_genus,
      query_species = .synonym_stripped_query_species,
      matched_name_id = as.character(mdd_syn_id),
      matched_name = query_name,
      matched_author = as.character(mdd_author),
      taxon_status = "synonym",
      match_source = "synonym_stripped_subgenus",
      original_name_raw = as.character(mdd_original_combination),
      accepted_id = as.character(mdd_species_id),
      accepted_name = accepted_name,
      accepted_author = accepted_author,
      accepted_genus = accepted_genus,
      accepted_species = accepted_species,
      is_accepted_name = FALSE,
      status_rank = 1L
    ) |>
    dplyr::filter(!is.na(query_name), nzchar(query_name))

  dplyr::bind_rows(
    accepted,
    original_rows,
    original_stripped_rows,
    synonym_tbl,
    synonym_stripped_tbl
  ) |>
    dplyr::distinct()
}

.leading_genus <- function(x) {
  x <- as.character(x)
  x <- gsub("_", " ", x, fixed = TRUE)
  x <- stringr::str_squish(x)
  first <- sub("[[:space:]].*$", "", x)
  first[!nzchar(first) | is.na(first)] <- NA_character_
  .title_case(first)
}

.mdd_candidate_genera <- function(
  df,
  checklist,
  synonyms,
  max_dist = 1,
  method = "osa"
) {
  input_genera <- unique(stats::na.omit(as.character(df$orig_genus)))
  if (length(input_genera) == 0) {
    return(character())
  }

  source_genera <- .mdd_source_genera(
    checklist = checklist,
    synonyms = synonyms
  )
  exact <- intersect(input_genera, source_genera)

  if (length(source_genera) == 0) {
    return(exact)
  }

  source_tbl <- tibble::tibble(
    query_genus = source_genera,
    query_len = nchar(source_genera)
  )
  input_tbl <- tibble::tibble(
    orig_genus = input_genera,
    orig_len = nchar(input_genera)
  )

  len_min <- min(input_tbl$orig_len) - max_dist
  len_max <- max(input_tbl$orig_len) + max_dist
  source_tbl <- dplyr::filter(
    source_tbl,
    query_len >= len_min,
    query_len <= len_max
  )

  if (nrow(source_tbl) == 0) {
    return(exact)
  }

  fuzzy_tbl <- fuzzyjoin::stringdist_left_join(
    input_tbl,
    source_tbl,
    by = c("orig_genus" = "query_genus"),
    method = method,
    max_dist = max_dist,
    distance_col = "fuzzy_genus_dist"
  ) |>
    dplyr::filter(!is.na(query_genus)) |>
    dplyr::filter(abs(orig_len - query_len) <= max_dist) |>
    dplyr::distinct(query_genus)

  unique(c(exact, fuzzy_tbl$query_genus))
}

.mdd_subset_records_for_matching <- function(
  df,
  checklist = NULL,
  synonyms = NULL,
  max_dist = 1,
  method = "osa"
) {
  prepared_checklist <- .prepare_checklist_genus_index(checklist)
  prepared_synonyms <- .prepare_synonym_genus_index(synonyms)

  candidate_genera <- .mdd_candidate_genera(
    df = df,
    checklist = prepared_checklist,
    synonyms = prepared_synonyms,
    max_dist = max_dist,
    method = method
  )

  if (length(candidate_genera) == 0) {
    return(list(
      checklist = prepared_checklist[0, , drop = FALSE],
      synonyms = prepared_synonyms[0, , drop = FALSE]
    ))
  }

  checklist_keep <- prepared_checklist$.match_genus %in%
    candidate_genera |
    prepared_checklist$.original_leading_genus %in% candidate_genera
  checklist_subset <- prepared_checklist[
    checklist_keep %in% TRUE,
    ,
    drop = FALSE
  ]

  accepted_ids <- unique(as.character(checklist_subset$id))
  synonym_keep <- prepared_synonyms$.original_leading_genus %in%
    candidate_genera |
    as.character(prepared_synonyms$mdd_species_id) %in% accepted_ids
  synonyms_subset <- prepared_synonyms[synonym_keep %in% TRUE, , drop = FALSE]

  linked_ids <- unique(as.character(synonyms_subset$mdd_species_id))
  if (length(linked_ids) > 0) {
    checklist_subset <- dplyr::bind_rows(
      checklist_subset,
      prepared_checklist[
        as.character(prepared_checklist$id) %in% linked_ids,
        ,
        drop = FALSE
      ]
    ) |>
      dplyr::distinct(id, .keep_all = TRUE)
  }

  list(
    checklist = .prepare_checklist_match_records(checklist_subset),
    synonyms = .prepare_synonym_match_records(synonyms_subset)
  )
}
