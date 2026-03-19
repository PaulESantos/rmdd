#' Retrieve structured MDD taxon information by name
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' This function is experimental and may change in future releases.
#'
#' Resolve a mammal name against the local MDD backbone and return a structured
#' object built from `mdd_checklist` and `mdd_synonyms`, including the accepted
#' taxon record, synonym records, and grouped sections that mirror the main
#' information shown in MDD species pages.
#'
#' @param name A single scientific name.
#' @param checklist Optional checklist data frame. Defaults to `mdd_checklist`.
#' @param synonyms Optional synonym data frame. Defaults to `mdd_synonyms`.
#' @param target_df Optional reconciliation backbone from
#'   [build_mdd_match_backbone()].
#' @param max_dist Maximum string distance used if the input name needs fuzzy
#'   reconciliation.
#' @param method Distance method passed to [mdd_matching()].
#'
#' @return An object of class `mdd_taxon_info`.
#' @examples
#' checklist <- tibble::tibble(
#'   id = "1",
#'   sci_name = "Puma_concolor",
#'   genus = "Puma",
#'   specific_epithet = "concolor",
#'   authority_species_author = "Linnaeus",
#'   authority_species_year = "1758",
#'   order = "Carnivora",
#'   family = "Felidae",
#'   main_common_name = "Puma"
#' )
#' synonyms <- tibble::tibble(
#'   mdd_syn_id = "1001",
#'   mdd_species_id = "1",
#'   mdd_author = "Linnaeus",
#'   mdd_original_combination = "Felis concolor",
#'   mdd_validity = "synonym",
#'   mdd_nomenclature_status = "available"
#' )
#' x <- mdd_taxon_info(
#'   "Felis concolor",
#'   checklist = checklist,
#'   synonyms = synonyms
#' )
#' x
#' as.list(x)
#' @export
mdd_taxon_info <- function(
  name,
  checklist = NULL,
  synonyms = NULL,
  target_df = NULL,
  max_dist = 1,
  method = "osa"
) {
  lifecycle::signal_stage("experimental", "mdd_taxon_info()")
  record <- mdd_taxon_record(
    name = name,
    checklist = checklist,
    synonyms = synonyms,
    target_df = target_df,
    max_dist = max_dist,
    method = method
  )

  if (!isTRUE(record$matched)) {
    out <- list(
      query = record$query,
      matched = FALSE,
      match = record$match,
      taxon = NULL,
      sections = list(),
      synonyms = tibble::tibble(),
      url = record$url
    )
    class(out) <- "mdd_taxon_info"
    return(out)
  }

  taxon_tbl <- record$taxon_tbl
  synonym_tbl <- record$synonym_tbl
  taxon_row <- if (nrow(taxon_tbl) == 0) {
    NULL
  } else {
    as.list(taxon_tbl[1, , drop = FALSE])
  }

  out <- list(
    query = record$query,
    matched = TRUE,
    match = record$match,
    taxon = taxon_row,
    sections = .mdd_taxon_sections(taxon_tbl, synonym_tbl),
    synonyms = synonym_tbl,
    url = record$url
  )

  class(out) <- "mdd_taxon_info"
  out
}

#' @export
print.mdd_taxon_info <- function(x, ...) {
  if (!isTRUE(x$matched)) {
    cli::cli_h1("MDD Taxon Info")
    cli::cli_alert_warning("No MDD match found for {.val {x$query}}")
    return(invisible(x))
  }

  match_row <- x$match[1, , drop = FALSE]
  taxon <- x$taxon
  sections <- x$sections

  cli::cli_h1(as.character(match_row$accepted_name[[1]]))
  cli::cli_text("Query: {.val {x$query}}")
  cli::cli_text(
    "Matched name: {.val {match_row$matched_name[[1]]}} ({match_row$taxon_status[[1]]})"
  )
  cli::cli_text("Taxon URL: {.url {x$url}}")

  if (!is.null(taxon)) {
    common_name <- .mdd_cli_value(.mdd_list_get(taxon, "main_common_name"))
    authority <- stringr::str_squish(paste(
      .mdd_cli_value(.mdd_list_get(taxon, "authority_species_author")),
      .mdd_cli_value(.mdd_list_get(taxon, "authority_species_year"))
    ))
    order_family <- paste(
      .mdd_cli_value(.mdd_list_get(taxon, "order")),
      "/",
      .mdd_cli_value(.mdd_list_get(taxon, "family"))
    )
    status_line <- paste(
      .mdd_cli_value(.mdd_list_get(taxon, "iucn_status")),
      "/",
      .mdd_cli_value(.mdd_list_get(taxon, "extinct")),
      "/",
      .mdd_cli_value(.mdd_list_get(taxon, "domestic"))
    )
    cli::cli_ul(c(
      "Common name: {.val {common_name}}",
      "Authority: {.val {authority}}",
      "Order / Family: {.val {order_family}}",
      "IUCN / Extinct / Domestic: {.val {status_line}}",
      "Synonym records: {.val {nrow(x$synonyms)}}"
    ))
  }

  .mdd_cli_section("Taxonomy", sections$taxonomy)
  .mdd_cli_section("Authority", sections$authority)
  .mdd_cli_section("Type information", sections$type_information)
  .mdd_cli_section("Distribution", sections$distribution)
  .mdd_cli_section("Status", sections$status)

  if (nrow(x$synonyms) > 0) {
    preview <- x$synonyms |>
      dplyr::transmute(
        synonym = mdd_original_combination,
        validity = mdd_validity,
        nomenclature_status = mdd_nomenclature_status
      ) |>
      utils::head(8)
    cli::cli_h2("Names and Synonyms")
    print(preview)
    if (nrow(x$synonyms) > 8) {
      cli::cli_text(
        "... and {.val {nrow(x$synonyms) - 8}} more synonym records"
      )
    }
  }

  invisible(x)
}

.mdd_taxon_sections <- function(taxon_tbl, synonym_tbl) {
  if (nrow(taxon_tbl) == 0) {
    return(list())
  }

  row <- taxon_tbl[1, , drop = FALSE]

  get_col <- function(nm) .mdd_tbl_get(row, nm)

  list(
    taxonomy = .compact_named_list(list(
      subclass = get_col("subclass"),
      infraclass = get_col("infraclass"),
      magnorder = get_col("magnorder"),
      superorder = get_col("superorder"),
      order = get_col("order"),
      suborder = get_col("suborder"),
      infraorder = get_col("infraorder"),
      parvorder = get_col("parvorder"),
      superfamily = get_col("superfamily"),
      family = get_col("family"),
      subfamily = get_col("subfamily"),
      tribe = get_col("tribe"),
      subtribe = get_col("subtribe"),
      genus = get_col("genus"),
      subgenus = get_col("subgenus"),
      specific_epithet = get_col("specific_epithet"),
      subspecies = get_col("subspecies"),
      sci_name = gsub("_", " ", get_col("sci_name"), fixed = TRUE)
    )),
    authority = .compact_named_list(list(
      authority_species_author = get_col("authority_species_author"),
      authority_species_year = get_col("authority_species_year"),
      authority_parentheses = get_col("authority_parentheses"),
      original_name_combination = get_col("original_name_combination"),
      authority_species_citation = get_col("authority_species_citation"),
      authority_species_link = get_col("authority_species_link"),
      nominal_names = get_col("nominal_names"),
      synonym_count = nrow(synonym_tbl)
    )),
    type_information = .compact_named_list(list(
      type_voucher = get_col("type_voucher"),
      type_kind = get_col("type_kind"),
      type_voucher_uris = get_col("type_voucher_uris"),
      type_locality = get_col("type_locality"),
      type_locality_latitude = get_col("type_locality_latitude"),
      type_locality_longitude = get_col("type_locality_longitude")
    )),
    distribution = .compact_named_list(list(
      distribution_notes = get_col("distribution_notes"),
      subregion_distribution = get_col("subregion_distribution"),
      country_distribution = get_col("country_distribution"),
      continent_distribution = get_col("continent_distribution"),
      biogeographic_realm = get_col("biogeographic_realm")
    )),
    status = .compact_named_list(list(
      main_common_name = get_col("main_common_name"),
      other_common_names = get_col("other_common_names"),
      iucn_status = get_col("iucn_status"),
      extinct = get_col("extinct"),
      domestic = get_col("domestic"),
      flagged = get_col("flagged"),
      diff_since_cmw = get_col("diff_since_cmw"),
      msw3_matchtype = get_col("msw3_matchtype"),
      diff_since_msw3 = get_col("diff_since_msw3")
    ))
  )
}

.compact_named_list <- function(x) {
  keep <- vapply(
    x,
    function(val) {
      if (length(val) == 0 || is.null(val)) {
        return(FALSE)
      }
      if (all(is.na(val))) {
        return(FALSE)
      }
      txt <- stringr::str_squish(as.character(val[[1]]))
      nzchar(txt) && !identical(txt, "NA")
    },
    logical(1)
  )

  x[keep]
}

.mdd_cli_section <- function(title, values) {
  if (length(values) == 0) {
    return(invisible(NULL))
  }

  cli::cli_h2(title)
  bullets <- vapply(
    names(values),
    function(nm) {
      paste0(.mdd_cli_label(nm), ": {.val ", .mdd_cli_value(values[[nm]]), "}")
    },
    character(1)
  )
  cli::cli_ul(bullets)
  invisible(NULL)
}

.mdd_cli_label <- function(x) {
  x <- gsub("_", " ", x, fixed = TRUE)
  x <- trimws(x)
  paste0(toupper(substr(x, 1, 1)), substr(x, 2, nchar(x)))
}

.mdd_cli_value <- function(x) {
  if (length(x) == 0 || is.null(x) || all(is.na(x))) {
    return(NA_character_)
  }
  stringr::str_squish(as.character(x[[1]]))
}

.mdd_list_get <- function(x, name) {
  if (is.null(x[[name]])) {
    return(NA)
  }
  x[[name]]
}

.mdd_tbl_get <- function(tbl, name) {
  if (!name %in% names(tbl)) {
    return(NA)
  }
  tbl[[name]]
}

#' @export
as.list.mdd_taxon_info <- function(x, ...) {
  unclass(x)
}
