#' Retrieve a normalized MDD taxon record
#'
#' Resolve a taxon by accepted MDD identifier or by scientific name against
#' the local MDD name index. The returned object contains the match result,
#' accepted taxon row, linked synonym rows, and the canonical MDD taxon URL.
#'
#' @param name Optional scientific name.
#' @param taxon_id Optional accepted MDD taxon identifier.
#' @param checklist Optional checklist data frame.
#' @param synonyms Optional synonym data frame.
#' @param target_df Optional reconciliation backbone or name index.
#' @param max_dist Maximum string distance used if `name` needs fuzzy matching.
#' @param method Distance method passed to [mdd_matching()].
#'
#' @return A list of class `mdd_taxon_record`.
#' @examples
#' mdd_taxon_record(name = "Puma concolor")
#' @export
mdd_taxon_record <- function(
  name = NULL,
  taxon_id = NULL,
  checklist = NULL,
  synonyms = NULL,
  target_df = NULL,
  max_dist = 1,
  method = "osa"
) {
  checklist <- mdd_checklist_records(checklist)
  synonyms <- mdd_synonym_records(synonyms)
  target_df <- target_df %||%
    build_mdd_match_backbone(checklist = checklist, synonyms = synonyms)

  if (!is.null(taxon_id)) {
    taxon_id <- as.character(taxon_id)
    taxon_tbl <- checklist |>
      dplyr::filter(as.character(id) == taxon_id) |>
      dplyr::slice_head(n = 1)

    if (nrow(taxon_tbl) == 0) {
      out <- list(
        query = taxon_id,
        matched = FALSE,
        match = tibble::tibble(),
        taxon_tbl = tibble::tibble(),
        synonym_tbl = tibble::tibble(),
        accepted_id = taxon_id,
        url = paste0("https://www.mammaldiversity.org/taxon/", taxon_id, "/")
      )
      class(out) <- "mdd_taxon_record"
      return(out)
    }

    synonym_tbl <- synonyms |>
      dplyr::filter(as.character(mdd_species_id) == taxon_id)

    match_tbl <- tibble::tibble(
      input_name = name %||%
        .canonical_binomial(taxon_tbl$genus, taxon_tbl$specific_epithet),
      matched_name = .canonical_binomial(
        taxon_tbl$genus,
        taxon_tbl$specific_epithet
      ),
      taxon_status = "accepted",
      accepted_id = taxon_id,
      accepted_name = .canonical_binomial(
        taxon_tbl$genus,
        taxon_tbl$specific_epithet
      ),
      is_accepted_name = TRUE,
      matched = TRUE,
      match_stage = "taxon_id"
    )

    out <- list(
      query = name %||% taxon_id,
      matched = TRUE,
      match = match_tbl,
      taxon_tbl = taxon_tbl,
      synonym_tbl = synonym_tbl,
      accepted_id = taxon_id,
      url = paste0("https://www.mammaldiversity.org/taxon/", taxon_id, "/")
    )
    class(out) <- "mdd_taxon_record"
    return(out)
  }

  if (
    !is.character(name) ||
      length(name) != 1L ||
      is.na(name) ||
      !nzchar(stringr::str_squish(name))
  ) {
    rlang::abort(
      "`name` must be a single non-empty character string when `taxon_id` is not supplied."
    )
  }

  match_tbl <- mdd_matching(
    x = name,
    target_df = target_df,
    prefilter_genus = TRUE,
    allow_duplicates = TRUE,
    max_dist = max_dist,
    method = method
  )

  match_row <- match_tbl[1, , drop = FALSE]

  if (!isTRUE(match_row$matched[[1]])) {
    out <- list(
      query = name,
      matched = FALSE,
      match = tibble::as_tibble(match_row),
      taxon_tbl = tibble::tibble(),
      synonym_tbl = tibble::tibble(),
      accepted_id = NA_character_,
      url = NA_character_
    )
    class(out) <- "mdd_taxon_record"
    return(out)
  }

  accepted_id <- as.character(match_row$accepted_id[[1]])
  taxon_tbl <- checklist |>
    dplyr::filter(as.character(id) == accepted_id) |>
    dplyr::slice_head(n = 1)

  synonym_tbl <- synonyms |>
    dplyr::filter(as.character(mdd_species_id) == accepted_id)

  out <- list(
    query = name,
    matched = TRUE,
    match = tibble::as_tibble(match_row),
    taxon_tbl = taxon_tbl,
    synonym_tbl = synonym_tbl,
    accepted_id = accepted_id,
    url = paste0("https://www.mammaldiversity.org/taxon/", accepted_id, "/")
  )
  class(out) <- "mdd_taxon_record"
  out
}
