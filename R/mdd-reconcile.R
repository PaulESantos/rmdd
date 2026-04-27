#' Classify mammal scientific names into taxonomic components
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' This function is experimental and may change in future releases.
#'
#' Parse mammal scientific names into genus, optional subgenus, species,
#' optional subspecies, and trailing author text. The parser is intentionally
#' conservative and targets species-level MDD reconciliation workflows.
#'
#' @param splist Character vector of scientific names.
#'
#' @return A tibble with one row per input name and standardized columns for
#'   species-level reconciliation.
#' @examples
#' classify_mammal_names(c(
#'   "Puma concolor",
#'   "Capromys (Pygmaeocapromys) angelcabrerai"
#' ))
#' @export
classify_mammal_names <- function(splist) {
  lifecycle::signal_stage("experimental", "classify_mammal_names()")
  if (!is.character(splist)) {
    cli::cli_abort("{.arg splist} must be a character vector.")
  }

  if (length(splist) == 0) {
    cli::cli_abort("{.arg splist} must contain at least one name.")
  }

  parse_one <- function(x, idx) {
    raw <- as.character(x)
    has_cf <- grepl("\\bcf\\.?\\b", raw, ignore.case = TRUE, perl = TRUE)
    has_aff <- grepl("\\baff\\.?\\b", raw, ignore.case = TRUE, perl = TRUE)
    had_hybrid <- grepl(
      "(^|[[:space:]])(x|\\x{00D7})([[:space:]]|$)",
      raw,
      perl = TRUE
    )
    is_sp <- grepl("\\bsp\\.?\\b", raw, ignore.case = TRUE, perl = TRUE)
    is_spp <- grepl("\\bspp\\.?\\b", raw, ignore.case = TRUE, perl = TRUE)

    parsed <- .parse_input_name(raw)

    if (is_sp || is_spp) {
      parsed$species <- NA_character_
      parsed$subspecies <- NA_character_
      parsed$author <- ""
      rank <- 1
    } else {
      rank <- if (!is.na(parsed$subspecies)) {
        3
      } else if (!is.na(parsed$species)) {
        2
      } else {
        1
      }
    }

    tibble::tibble(
      sorter = as.numeric(idx),
      input_name = raw,
      orig_name = parsed$display_name,
      orig_name_clean = parsed$name_clean,
      orig_genus = parsed$genus,
      orig_subgenus = parsed$subgenus,
      orig_species = parsed$species,
      orig_subspecies = parsed$subspecies,
      author = parsed$author,
      rank = rank,
      has_cf = has_cf,
      has_aff = has_aff,
      is_sp = is_sp,
      is_spp = is_spp,
      had_hybrid = had_hybrid
    )
  }

  out <- lapply(seq_along(splist), function(i) parse_one(splist[[i]], i))
  dplyr::bind_rows(out)
}

.mdd_runtime_cache <- new.env(parent = emptyenv())

.mdd_default_match_backbone <- function() {
  if (
    exists("default_backbone", envir = .mdd_runtime_cache, inherits = FALSE)
  ) {
    return(get(
      "default_backbone",
      envir = .mdd_runtime_cache,
      inherits = FALSE
    ))
  }

  backbone <- mdd_name_index() |>
    dplyr::distinct()

  assign("default_backbone", backbone, envir = .mdd_runtime_cache)
  backbone
}

#' Build an MDD reconciliation backbone
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' This function is experimental and may change in future releases.
#'
#' Construct a species-level reconciliation backbone that combines accepted MDD
#' checklist names with synonym names and links every matched name to its
#' accepted species context.
#'
#' @param checklist A data frame like `mdd_checklist`.
#' @param synonyms Optional data frame like `mdd_synonyms`.
#'
#' @return A tibble used internally by [mdd_matching()].
#' @examples
#' bb <- build_mdd_match_backbone(
#'   checklist = dplyr::slice(mdd_checklist, 1:10),
#'   synonyms = dplyr::slice(mdd_synonyms, 1:20)
#' )
#' bb
#' @export
build_mdd_match_backbone <- function(checklist = NULL, synonyms = NULL) {
  lifecycle::signal_stage("experimental", "build_mdd_match_backbone()")
  if (is.null(checklist) && is.null(synonyms)) {
    return(.mdd_default_match_backbone())
  }

  mdd_name_index(checklist = checklist, synonyms = synonyms) |>
    dplyr::distinct()
}

#' Reconcile mammal names against MDD
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' This function is experimental and may change in future releases.
#'
#' Run a staged species-level reconciliation pipeline against an MDD backbone.
#' The workflow prioritizes exact evidence first, then progressively relaxes
#' criteria through exact genus, fuzzy genus, exact species-within-genus, and
#' fuzzy species-within-genus matching.
#'
#' @param x Character vector of names or a data frame with parsed name columns.
#' @param target_df Optional backbone produced by [build_mdd_match_backbone()].
#' @param prefilter_genus Logical. If `TRUE`, restrict the backbone to exact and
#'   fuzzy candidate genera before the full pipeline.
#' @param allow_duplicates Logical. If `TRUE`, deduplicate internally and expand
#'   results back to the original rows.
#' @param max_dist Maximum string distance used in fuzzy stages.
#' @param method Distance method passed to `fuzzyjoin::stringdist_*_join()`.
#'
#' @return A tibble with row-level traceability, pathway flags, matched name
#'   context, accepted-name context, and fuzzy distance columns.
#' @examples
#' checklist <- tibble::tibble(
#'   id = c("1", "2"),
#'   sci_name = c("Puma_concolor", "Vicugna_vicugna"),
#'   genus = c("Puma", "Vicugna"),
#'   specific_epithet = c("concolor", "vicugna"),
#'   authority_species_author = c("Linnaeus", "Molina")
#' )
#' synonyms <- tibble::tibble(
#'   mdd_syn_id = c("1001", "1002"),
#'   mdd_species_id = c("1", "2"),
#'   mdd_author = c("Linnaeus", "Molina"),
#'   mdd_original_combination = c("Felis concolor", "Auchenia vicugna")
#' )
#' backbone <- build_mdd_match_backbone(checklist, synonyms)
#' mdd_matching(
#'   c("Puma concolor", "Felis concolor", "Pumma concolor"),
#'   target_df = backbone
#' )
#' @export
mdd_matching <- function(
  x,
  target_df = NULL,
  prefilter_genus = TRUE,
  allow_duplicates = FALSE,
  max_dist = 1,
  method = "osa"
) {
  lifecycle::signal_stage("experimental", "mdd_matching()")
  df <- .mdd_check_input(x)
  df$input_index <- seq_len(nrow(df))
  df$.dedup_key <- ifelse(
    !is.na(df$orig_name_clean) & nzchar(df$orig_name_clean),
    df$orig_name_clean,
    ifelse(
      is.na(df$orig_species),
      paste0("ROW|", df$input_index),
      paste(df$orig_genus, df$orig_species, sep = "|")
    )
  )

  had_duplicates <- any(duplicated(df$.dedup_key))
  if (had_duplicates && !isTRUE(allow_duplicates)) {
    cli::cli_abort(c(
      "Duplicate genus-species keys detected.",
      "i" = "Use {.code allow_duplicates = TRUE} to keep all rows."
    ))
  }

  df_work <- if (had_duplicates && isTRUE(allow_duplicates)) {
    df |>
      dplyr::group_by(.dedup_key) |>
      dplyr::slice_head(n = 1) |>
      dplyr::ungroup()
  } else {
    df
  }

  target_df <- target_df %||%
    {
      subset_records <- .mdd_subset_records_for_matching(
        df_work,
        max_dist = max_dist,
        method = method
      )
      build_mdd_match_backbone(
        checklist = subset_records$checklist,
        synonyms = subset_records$synonyms
      )
    }
  target_df <- .normalize_mdd_backbone(target_df)

  if (isTRUE(prefilter_genus)) {
    target_df <- .mdd_prefilter_target_by_genus(
      df_work,
      target_df = target_df,
      include_fuzzy = TRUE,
      max_dist = max_dist,
      method = method
    )
  }

  node_1 <- .mdd_direct_match(df_work, target_df)
  n1_true <- dplyr::filter(node_1, direct_match)
  n1_false <- dplyr::filter(node_1, !direct_match)

  node_2 <- .mdd_genus_match(n1_false, target_df)
  n2_true <- dplyr::filter(node_2, genus_match)
  n2_false <- dplyr::filter(node_2, !genus_match)

  node_3 <- .mdd_fuzzy_match_genus(
    n2_false,
    target_df,
    max_dist = max_dist,
    method = method
  )
  ambiguous_genus <- attr(node_3, "ambiguous_genus")
  n3_true <- dplyr::filter(node_3, fuzzy_match_genus)
  n3_false <- dplyr::filter(node_3, !fuzzy_match_genus)

  node_4_in <- dplyr::bind_rows(n2_true, n3_true)
  node_4 <- .mdd_direct_match_species_within_genus(node_4_in, target_df)
  n4_true <- dplyr::filter(node_4, direct_match_species_within_genus)
  n4_false <- dplyr::filter(node_4, !direct_match_species_within_genus)

  node_5 <- .mdd_fuzzy_match_species_within_genus(
    n4_false,
    target_df,
    max_dist = max_dist,
    method = method
  )
  ambiguous_species <- attr(node_5, "ambiguous_species")
  n5_true <- dplyr::filter(node_5, fuzzy_match_species_within_genus)
  n5_false <- dplyr::filter(node_5, !fuzzy_match_species_within_genus)

  retry_genus_in <- dplyr::filter(n5_false, genus_match & !fuzzy_match_genus)
  retry_genus <- .mdd_fuzzy_match_genus(
    retry_genus_in,
    target_df,
    max_dist = max_dist,
    method = method,
    exclude_current = TRUE
  )
  ambiguous_genus_retry <- attr(retry_genus, "ambiguous_genus")
  retry_genus_true <- dplyr::filter(retry_genus, fuzzy_match_genus)
  retry_genus_false <- dplyr::filter(retry_genus, !fuzzy_match_genus)

  retry_direct <- .mdd_direct_match_species_within_genus(
    retry_genus_true,
    target_df
  )
  retry_direct_true <- dplyr::filter(
    retry_direct,
    direct_match_species_within_genus
  )
  retry_direct_false <- dplyr::filter(
    retry_direct,
    !direct_match_species_within_genus
  )

  retry_fuzzy_species <- .mdd_fuzzy_match_species_within_genus(
    retry_direct_false,
    target_df,
    max_dist = max_dist,
    method = method
  )
  ambiguous_species_retry <- attr(retry_fuzzy_species, "ambiguous_species")
  retry_fuzzy_species_true <- dplyr::filter(
    retry_fuzzy_species,
    fuzzy_match_species_within_genus
  )
  retry_fuzzy_species_false <- dplyr::filter(
    retry_fuzzy_species,
    !fuzzy_match_species_within_genus
  )

  matched <- dplyr::bind_rows(
    n1_true,
    n4_true,
    n5_true,
    retry_direct_true,
    retry_fuzzy_species_true
  )
  unmatched <- dplyr::bind_rows(
    n3_false,
    dplyr::filter(n5_false, !(genus_match & !fuzzy_match_genus)),
    retry_genus_false,
    retry_fuzzy_species_false
  )

  res <- dplyr::bind_rows(matched, unmatched) |>
    dplyr::mutate(
      matched = !is.na(matched_name),
      match_stage = dplyr::case_when(
        direct_match ~ "direct_match",
        direct_match_species_within_genus ~ "direct_match_species_within_genus",
        fuzzy_match_species_within_genus ~ "fuzzy_match_species_within_genus",
        genus_match ~ "genus_match_only",
        fuzzy_match_genus ~ "fuzzy_genus_only",
        TRUE ~ "unmatched"
      )
    ) |>
    dplyr::arrange(sorter)

  if (had_duplicates && isTRUE(allow_duplicates)) {
    result_cols <- setdiff(names(res), names(df))
    res <- df |>
      dplyr::select(.dedup_key, dplyr::everything()) |>
      dplyr::left_join(
        res |>
          dplyr::select(.dedup_key, dplyr::all_of(result_cols)),
        by = ".dedup_key"
      ) |>
      dplyr::arrange(sorter)
  }

  res <- res |>
    dplyr::select(-dplyr::any_of(".dedup_key")) |>
    dplyr::relocate(
      input_index,
      input_name,
      orig_name,
      orig_genus,
      dplyr::any_of("orig_subgenus"),
      orig_species,
      dplyr::any_of("orig_subspecies"),
      author,
      matched_name_id,
      matched_name,
      matched_author,
      taxon_status,
      accepted_id,
      accepted_name,
      accepted_author,
      is_accepted_name,
      matched,
      match_stage,
      dplyr::any_of(c(
        "direct_match",
        "genus_match",
        "fuzzy_match_genus",
        "direct_match_species_within_genus",
        "fuzzy_match_species_within_genus",
        "fuzzy_genus_dist",
        "fuzzy_species_dist"
      ))
    )

  ambiguous_genus_all <- dplyr::bind_rows(
    ambiguous_genus,
    ambiguous_genus_retry
  )

  if (!is.null(ambiguous_genus_all) && nrow(ambiguous_genus_all) > 0) {
    attr(res, "ambiguous_genus") <- ambiguous_genus_all
  }

  ambiguous_species_all <- dplyr::bind_rows(
    ambiguous_species,
    ambiguous_species_retry
  )

  if (!is.null(ambiguous_species_all) && nrow(ambiguous_species_all) > 0) {
    attr(res, "ambiguous_species") <- ambiguous_species_all
  }

  res
}

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

.mdd_default_dataset <- function(name) {
  pkg_name <- "rmdd"

  ns <- tryCatch(asNamespace(pkg_name), error = function(e) NULL)
  if (!is.null(ns)) {
    obj <- get0(name, envir = ns, inherits = FALSE, ifnotfound = NULL)
    if (!is.null(obj)) {
      return(obj)
    }
  }

  data_env <- new.env(parent = emptyenv())
  loaded <- tryCatch(
    utils::data(list = name, package = pkg_name, envir = data_env),
    error = function(e) NULL
  )

  if (!is.null(loaded) && exists(name, envir = data_env, inherits = FALSE)) {
    return(get(name, envir = data_env, inherits = FALSE))
  }

  if (exists(name, envir = .GlobalEnv, inherits = FALSE)) {
    return(get(name, envir = .GlobalEnv, inherits = FALSE))
  }

  NULL
}

.assert_has_columns <- function(x, cols, object_name) {
  missing_cols <- setdiff(cols, names(x))
  if (length(missing_cols) > 0) {
    cli::cli_abort(c(
      "Missing required columns in {.var {object_name}}",
      "x" = "Missing {length(missing_cols)} column{?s}: {.field {missing_cols}}"
    ))
  }
}

.join_ready_left <- function(x, target_df, keep = character(0)) {
  overlap <- setdiff(intersect(names(x), names(target_df)), keep)
  dplyr::select(x, -dplyr::any_of(overlap))
}

.drop_match_distance_cols <- function(x) {
  dplyr::select(x, -dplyr::any_of(c("fuzzy_genus_dist", "fuzzy_species_dist")))
}

.clean_name_for_match <- function(x) {
  x <- as.character(x)
  x <- gsub("_", " ", x, fixed = TRUE)
  x <- stringr::str_squish(x)
  tolower(x)
}

.canonical_binomial <- function(genus, species) {
  ifelse(
    is.na(genus) | is.na(species),
    NA_character_,
    paste(as.character(genus), as.character(species), sep = " ")
  )
}

.canonical_name <- function(
  genus,
  species,
  subspecies = NA_character_,
  subgenus = NA_character_
) {
  genus <- as.character(genus)
  species <- as.character(species)
  subspecies <- as.character(subspecies)
  subgenus <- as.character(subgenus)

  out <- ifelse(
    is.na(genus) | !nzchar(genus),
    NA_character_,
    genus
  )

  has_subgenus <- !is.na(subgenus) & nzchar(subgenus)
  out <- ifelse(has_subgenus, paste0(out, " (", subgenus, ")"), out)

  has_species <- !is.na(species) & nzchar(species)
  out <- ifelse(has_species, paste(out, species), out)

  has_subspecies <- !is.na(subspecies) & nzchar(subspecies)
  out <- ifelse(has_subspecies, paste(out, subspecies), out)

  ifelse(is.na(out) | !nzchar(out), NA_character_, stringr::str_squish(out))
}

.strip_subgenus <- function(x) {
  x <- as.character(x)
  x <- gsub("\\s*\\([^)]*\\)", "", x, perl = TRUE)
  stringr::str_squish(x)
}

.parse_input_name <- function(x) {
  cleaned <- as.character(x)
  cleaned <- gsub("_", " ", cleaned, fixed = TRUE)
  cleaned <- gsub("\\bcf\\.?\\b", " ", cleaned, ignore.case = TRUE, perl = TRUE)
  cleaned <- gsub(
    "\\baff\\.?\\b",
    " ",
    cleaned,
    ignore.case = TRUE,
    perl = TRUE
  )
  cleaned <- gsub(
    "(^|[[:space:]])(x|\\x{00D7})([[:space:]]|$)",
    " ",
    cleaned,
    perl = TRUE
  )
  cleaned <- stringr::str_squish(cleaned)

  if (!nzchar(cleaned)) {
    return(list(
      genus = NA_character_,
      subgenus = NA_character_,
      species = NA_character_,
      subspecies = NA_character_,
      author = "",
      display_name = NA_character_,
      name_clean = NA_character_
    ))
  }

  tokens <- strsplit(cleaned, "[[:space:]]+")[[1]]
  genus <- if (length(tokens) >= 1) .title_case(tokens[[1]]) else NA_character_
  idx <- 2L
  subgenus <- NA_character_

  if (length(tokens) >= 2 && grepl("^\\([^()]+\\)$", tokens[[2]])) {
    subgenus <- .title_case(gsub("^\\(|\\)$", "", tokens[[2]]))
    idx <- 3L
  }

  species <- if (length(tokens) >= idx) {
    tolower(tokens[[idx]])
  } else {
    NA_character_
  }
  remaining <- if (length(tokens) > idx) {
    tokens[(idx + 1):length(tokens)]
  } else {
    character(0)
  }

  subspecies <- NA_character_
  author <- ""
  if (length(remaining) >= 1) {
    first_extra <- remaining[[1]]
    looks_like_subspecies <- grepl("^[[:lower:]-]+$", first_extra)
    if (looks_like_subspecies) {
      subspecies <- tolower(first_extra)
      if (length(remaining) > 1) {
        author <- paste(remaining[-1], collapse = " ")
      }
    } else {
      author <- paste(remaining, collapse = " ")
    }
  }

  display_name <- .canonical_name(
    genus = genus,
    species = species,
    subspecies = subspecies,
    subgenus = subgenus
  )

  list(
    genus = genus,
    subgenus = subgenus,
    species = species,
    subspecies = subspecies,
    author = author,
    display_name = display_name,
    name_clean = .clean_name_for_match(display_name)
  )
}

.parse_backbone_name <- function(x) {
  parsed <- lapply(as.character(x), .parse_input_name)
  tibble::tibble(
    query_name = vapply(parsed, `[[`, character(1), "display_name"),
    query_name_clean = vapply(parsed, `[[`, character(1), "name_clean"),
    query_genus = vapply(parsed, `[[`, character(1), "genus"),
    query_species = vapply(parsed, `[[`, character(1), "species")
  )
}

.title_case <- function(x) {
  x <- as.character(x)
  ifelse(
    is.na(x) | !nzchar(x),
    NA_character_,
    paste0(toupper(substr(tolower(x), 1, 1)), substr(tolower(x), 2, nchar(x)))
  )
}

.mdd_check_input <- function(x) {
  if (is.character(x)) {
    return(classify_mammal_names(x))
  }

  if (!inherits(x, "data.frame")) {
    cli::cli_abort("{.arg x} must be a character vector or a data frame.")
  }

  df <- tibble::as_tibble(x)

  if (all(c("orig_genus", "orig_species") %in% names(df))) {
    out <- df
  } else if (all(c("Orig.Genus", "Orig.Species") %in% names(df))) {
    out <- dplyr::rename(
      df,
      orig_genus = Orig.Genus,
      orig_species = Orig.Species
    )
  } else if (all(c("genus", "species") %in% names(df))) {
    out <- dplyr::rename(df, orig_genus = genus, orig_species = species)
  } else if (all(c("Genus", "Species") %in% names(df))) {
    out <- dplyr::rename(df, orig_genus = Genus, orig_species = Species)
  } else {
    cli::cli_abort(c(
      "Input data must contain genus/species columns.",
      "i" = "Or use {.fn classify_mammal_names} first."
    ))
  }

  n <- nrow(out)
  if (!"sorter" %in% names(out)) {
    out$sorter <- as.numeric(seq_len(n))
  }
  if (!"input_name" %in% names(out)) {
    out$input_name <- .canonical_binomial(out$orig_genus, out$orig_species)
  }
  if (!"orig_name" %in% names(out)) {
    out$orig_name <- .canonical_binomial(out$orig_genus, out$orig_species)
  }
  if (!"orig_name_clean" %in% names(out)) {
    out$orig_name_clean <- .clean_name_for_match(out$orig_name)
  }
  if (!"author" %in% names(out)) {
    out$author <- rep("", n)
  }
  if (!"rank" %in% names(out)) {
    out$rank <- ifelse(is.na(out$orig_species), 1, 2)
  }
  if (!"orig_subgenus" %in% names(out)) {
    out$orig_subgenus <- rep(NA_character_, n)
  }
  if (!"orig_subspecies" %in% names(out)) {
    out$orig_subspecies <- rep(NA_character_, n)
  }
  for (nm in c("has_cf", "has_aff", "is_sp", "is_spp", "had_hybrid")) {
    if (!nm %in% names(out)) out[[nm]] <- rep(FALSE, n)
  }

  out |>
    dplyr::mutate(
      orig_genus = .title_case(orig_genus),
      orig_subgenus = ifelse(
        is.na(orig_subgenus),
        NA_character_,
        .title_case(orig_subgenus)
      ),
      orig_species = ifelse(
        is.na(orig_species),
        NA_character_,
        tolower(as.character(orig_species))
      ),
      orig_subspecies = ifelse(
        is.na(orig_subspecies),
        NA_character_,
        tolower(as.character(orig_subspecies))
      ),
      input_name = as.character(input_name),
      orig_name = as.character(orig_name),
      orig_name_clean = .clean_name_for_match(orig_name),
      author = as.character(author)
    )
}

.normalize_mdd_backbone <- function(target_df) {
  target_df <- tibble::as_tibble(target_df)
  .assert_has_columns(
    target_df,
    c(
      "query_name",
      "query_name_clean",
      "query_genus",
      "query_species",
      "matched_name_id",
      "matched_name",
      "taxon_status",
      "accepted_id",
      "accepted_name",
      "accepted_genus",
      "accepted_species",
      "is_accepted_name"
    ),
    "target_df"
  )

  if (!"matched_author" %in% names(target_df)) {
    target_df$matched_author <- NA_character_
  }
  if (!"accepted_author" %in% names(target_df)) {
    target_df$accepted_author <- NA_character_
  }
  if (!"match_source" %in% names(target_df)) {
    target_df$match_source <- target_df$taxon_status
  }
  if (!"status_rank" %in% names(target_df)) {
    target_df$status_rank <- dplyr::if_else(
      target_df$taxon_status == "accepted",
      2L,
      1L,
      missing = 0L
    )
  }

  target_df |>
    dplyr::mutate(
      query_name_clean = .clean_name_for_match(query_name),
      query_genus = .title_case(query_genus),
      query_species = ifelse(
        is.na(query_species),
        NA_character_,
        tolower(as.character(query_species))
      )
    )
}

.mdd_prefilter_target_by_genus <- function(
  df,
  target_df,
  include_fuzzy = TRUE,
  max_dist = 1,
  method = "osa"
) {
  input_genera <- df |>
    dplyr::filter(!is.na(orig_genus)) |>
    dplyr::distinct(orig_genus)

  if (nrow(input_genera) == 0) {
    return(target_df)
  }

  target_genera <- target_df |>
    dplyr::distinct(query_genus) |>
    dplyr::mutate(query_len = nchar(query_genus))

  exact_genera <- input_genera |>
    dplyr::inner_join(target_genera, by = c("orig_genus" = "query_genus")) |>
    dplyr::pull(orig_genus)

  fuzzy_genera <- character(0)
  fuzzy_inputs <- input_genera |>
    dplyr::mutate(orig_len = nchar(orig_genus))

  if (isTRUE(include_fuzzy) && nrow(fuzzy_inputs) > 0) {
    len_min <- min(fuzzy_inputs$orig_len) - max_dist
    len_max <- max(fuzzy_inputs$orig_len) + max_dist
    fuzzy_target_genera <- target_genera |>
      dplyr::filter(query_len >= len_min, query_len <= len_max)

    fuzzy_tbl <- fuzzyjoin::stringdist_left_join(
      fuzzy_inputs,
      fuzzy_target_genera,
      by = c("orig_genus" = "query_genus"),
      method = method,
      max_dist = max_dist,
      distance_col = "fuzzy_genus_dist"
    ) |>
      dplyr::filter(!is.na(query_genus)) |>
      dplyr::filter(abs(orig_len - query_len) <= max_dist) |>
      dplyr::distinct(orig_genus, query_genus, fuzzy_genus_dist)

    fuzzy_genera <- unique(fuzzy_tbl$query_genus)
  }

  candidate_genera <- unique(c(exact_genera, fuzzy_genera))
  if (length(candidate_genera) == 0) {
    return(target_df)
  }

  dplyr::filter(target_df, query_genus %in% candidate_genera)
}

.mdd_empty_match_columns <- function(df) {
  defaults <- list(
    matched_genus = NA_character_,
    matched_species = NA_character_,
    matched_name_id = NA_character_,
    matched_name = NA_character_,
    matched_author = NA_character_,
    taxon_status = NA_character_,
    match_source = NA_character_,
    accepted_id = NA_character_,
    accepted_name = NA_character_,
    accepted_author = NA_character_,
    accepted_genus = NA_character_,
    accepted_species = NA_character_,
    is_accepted_name = as.logical(NA),
    direct_match = FALSE,
    genus_match = FALSE,
    fuzzy_match_genus = FALSE,
    direct_match_species_within_genus = FALSE,
    fuzzy_match_species_within_genus = FALSE,
    fuzzy_genus_dist = NA_real_,
    fuzzy_species_dist = NA_real_
  )

  for (nm in names(defaults)) {
    if (!nm %in% names(df)) df[[nm]] <- defaults[[nm]]
  }

  df
}

.pick_best_target <- function(x, row_id = ".row_id", dist_col = NULL) {
  if (!row_id %in% names(x)) {
    return(x)
  }

  x <- dplyr::mutate(x, .status_rank = dplyr::coalesce(status_rank, 0L))
  grouped <- dplyr::group_by(x, !!rlang::sym(row_id))

  if (!is.null(dist_col) && dist_col %in% names(x)) {
    grouped |>
      dplyr::arrange(
        .data[[dist_col]],
        dplyr::desc(.status_rank),
        matched_name_id,
        .by_group = TRUE
      ) |>
      dplyr::slice_head(n = 1) |>
      dplyr::ungroup() |>
      dplyr::select(-.status_rank)
  } else {
    grouped |>
      dplyr::arrange(
        dplyr::desc(.status_rank),
        matched_name_id,
        .by_group = TRUE
      ) |>
      dplyr::slice_head(n = 1) |>
      dplyr::ungroup() |>
      dplyr::select(-.status_rank)
  }
}

.mdd_direct_match <- function(df, target_df) {
  df <- .mdd_empty_match_columns(df)
  if (nrow(df) == 0) {
    return(df)
  }

  df_work <- dplyr::mutate(df, .row_id = dplyr::row_number())
  matched_full <- dplyr::left_join(
    .join_ready_left(df_work, target_df),
    target_df,
    by = c("orig_name_clean" = "query_name_clean"),
    suffix = c("", ".target")
  ) |>
    dplyr::filter(!is.na(query_name))

  matched_binomial <- df_work |>
    dplyr::anti_join(matched_full |> dplyr::select(.row_id), by = ".row_id") |>
    dplyr::left_join(
      target_df,
      by = c("orig_genus" = "query_genus", "orig_species" = "query_species"),
      suffix = c("", ".target")
    ) |>
    dplyr::filter(!is.na(query_name))

  matched_raw <- dplyr::bind_rows(matched_full, matched_binomial)

  matched <- .pick_best_target(matched_raw, dist_col = NULL) |>
    dplyr::mutate(
      direct_match = TRUE,
      matched_genus = query_genus,
      matched_species = query_species
    )

  unmatched <- df_work |>
    dplyr::anti_join(matched |> dplyr::select(.row_id), by = ".row_id") |>
    dplyr::select(-.row_id)

  dplyr::bind_rows(
    matched |>
      dplyr::select(
        -dplyr::any_of(c(
          '.row_id',
          'query_name',
          'query_name_clean',
          'query_genus',
          'query_species'
        ))
      ),
    unmatched
  ) |>
    dplyr::arrange(sorter)
}

.mdd_genus_match <- function(df, target_df) {
  df <- .mdd_empty_match_columns(df)
  if (nrow(df) == 0) {
    return(df)
  }

  genera <- target_df |>
    dplyr::distinct(query_genus) |>
    dplyr::pull(query_genus)

  df |>
    dplyr::mutate(
      genus_match = !is.na(orig_genus) & orig_genus %in% genera,
      matched_genus = dplyr::if_else(genus_match, orig_genus, matched_genus)
    )
}

.mdd_fuzzy_match_genus <- function(
  df,
  target_df,
  max_dist = 1,
  method = "osa",
  exclude_current = FALSE
) {
  df <- .mdd_empty_match_columns(df)
  if (nrow(df) == 0) {
    return(df)
  }

  df_work <- dplyr::mutate(df, .row_id = dplyr::row_number())
  df_work_clean <- .drop_match_distance_cols(df_work) |>
    dplyr::mutate(orig_len = nchar(orig_genus))

  genera <- target_df |>
    dplyr::distinct(query_genus) |>
    dplyr::mutate(query_len = nchar(query_genus))

  len_min <- min(df_work_clean$orig_len, na.rm = TRUE) - max_dist
  len_max <- max(df_work_clean$orig_len, na.rm = TRUE) + max_dist
  genera <- dplyr::filter(genera, query_len >= len_min, query_len <= len_max)

  matched_temp <- fuzzyjoin::stringdist_left_join(
    df_work_clean,
    genera,
    by = c("orig_genus" = "query_genus"),
    method = method,
    max_dist = max_dist,
    distance_col = "fuzzy_genus_dist"
  ) |>
    dplyr::filter(!is.na(query_genus)) |>
    dplyr::filter(abs(orig_len - query_len) <= max_dist) |>
    dplyr::filter(
      !exclude_current | is.na(matched_genus) | query_genus != matched_genus
    ) |>
    dplyr::group_by(.row_id) |>
    dplyr::slice_min(order_by = fuzzy_genus_dist, with_ties = TRUE) |>
    dplyr::ungroup()

  ambiguous_keys <- matched_temp |>
    dplyr::count(.row_id, name = "n") |>
    dplyr::filter(n > 1)

  ambiguous_genus <- NULL
  if (nrow(ambiguous_keys) > 0) {
    cli::cli_warn(c(
      "!" = "Multiple fuzzy matches for some genera (tied distances).",
      "i" = "The first match is selected."
    ))
    ambiguous_genus <- matched_temp |>
      dplyr::semi_join(ambiguous_keys, by = ".row_id") |>
      dplyr::arrange(.row_id, fuzzy_genus_dist, query_genus)
  }

  matched <- matched_temp |>
    dplyr::group_by(.row_id) |>
    dplyr::slice_head(n = 1) |>
    dplyr::ungroup() |>
    dplyr::mutate(
      fuzzy_match_genus = TRUE,
      matched_genus = query_genus
    ) |>
    dplyr::select(-query_genus, -orig_len, -query_len)

  unmatched <- df_work |>
    dplyr::anti_join(matched |> dplyr::select(.row_id), by = ".row_id")

  out <- dplyr::bind_rows(
    matched |>
      dplyr::select(-.row_id),
    unmatched |>
      dplyr::select(-.row_id)
  ) |>
    dplyr::arrange(sorter)

  if (!is.null(ambiguous_genus) && nrow(ambiguous_genus) > 0) {
    attr(out, "ambiguous_genus") <- ambiguous_genus
  }

  out
}

.mdd_direct_match_species_within_genus <- function(df, target_df) {
  df <- .mdd_empty_match_columns(df)
  if (nrow(df) == 0) {
    return(df)
  }

  candidates <- target_df |>
    dplyr::select(-query_name_clean) |>
    dplyr::distinct()

  df_work <- dplyr::mutate(df, .row_id = dplyr::row_number())
  matched_raw <- dplyr::left_join(
    .join_ready_left(df_work, candidates),
    candidates,
    by = c("matched_genus" = "query_genus", "orig_species" = "query_species"),
    suffix = c("", ".target")
  ) |>
    dplyr::filter(!is.na(query_name))

  matched <- .pick_best_target(matched_raw) |>
    dplyr::mutate(
      direct_match_species_within_genus = TRUE,
      matched_species = orig_species
    )

  unmatched <- df_work |>
    dplyr::anti_join(matched |> dplyr::select(.row_id), by = ".row_id")

  dplyr::bind_rows(
    matched |>
      dplyr::select(
        -dplyr::any_of(c(
          '.row_id',
          'query_name',
          'query_genus',
          'query_species'
        ))
      ),
    unmatched |>
      dplyr::select(-.row_id)
  ) |>
    dplyr::arrange(sorter)
}

.mdd_fuzzy_match_species_within_genus <- function(
  df,
  target_df,
  max_dist = 1,
  method = "osa"
) {
  df <- .mdd_empty_match_columns(df)
  if (nrow(df) == 0) {
    return(df)
  }

  df_work <- dplyr::mutate(
    dplyr::select(df, -dplyr::any_of("species_key_tmp")),
    .row_id = dplyr::row_number(),
    species_key_tmp = paste(matched_genus, orig_species),
    .orig_len = nchar(orig_species)
  )
  df_work_clean <- .drop_match_distance_cols(df_work) |>
    dplyr::select(-dplyr::any_of(c("species_key_tmp.x", "species_key_tmp.y")))

  genus_bounds <- df_work |>
    dplyr::filter(!is.na(matched_genus), !is.na(.orig_len)) |>
    dplyr::group_by(matched_genus) |>
    dplyr::summarise(
      min_orig_len = min(.orig_len),
      max_orig_len = max(.orig_len),
      .groups = "drop"
    )

  db_subset <- .drop_match_distance_cols(target_df) |>
    dplyr::select(
      -dplyr::any_of(c(
        "species_key_tmp",
        "species_key_tmp.x",
        "species_key_tmp.y"
      ))
    ) |>
    dplyr::semi_join(
      df_work |> dplyr::distinct(matched_genus),
      by = c("query_genus" = "matched_genus")
    ) |>
    dplyr::mutate(.cand_len = nchar(query_species)) |>
    dplyr::inner_join(genus_bounds, by = c("query_genus" = "matched_genus")) |>
    dplyr::filter(
      .cand_len >= (min_orig_len - max_dist),
      .cand_len <= (max_orig_len + max_dist)
    ) |>
    dplyr::mutate(species_key_tmp = paste(query_genus, query_species)) |>
    dplyr::distinct()

  matched_temp <- fuzzyjoin::stringdist_left_join(
    .join_ready_left(df_work_clean, db_subset, keep = "species_key_tmp"),
    db_subset,
    by = c("species_key_tmp" = "species_key_tmp"),
    method = method,
    max_dist = max_dist,
    distance_col = "fuzzy_species_dist"
  ) |>
    dplyr::filter(!is.na(query_species)) |>
    dplyr::filter(abs(.orig_len - .cand_len) <= max_dist) |>
    dplyr::filter(
      .orig_len > 7 |
        .orig_len == .cand_len |
        fuzzy_species_dist <= 1
    ) |>
    dplyr::group_by(.row_id) |>
    dplyr::slice_min(order_by = fuzzy_species_dist, with_ties = TRUE) |>
    dplyr::ungroup()

  ambiguous_keys <- matched_temp |>
    dplyr::count(.row_id, name = "n") |>
    dplyr::filter(n > 1)

  ambiguous_species <- NULL
  if (nrow(ambiguous_keys) > 0) {
    cli::cli_warn(c(
      "!" = "Multiple fuzzy matches for some species within genus (tied distances).",
      "i" = "The first match is selected."
    ))
    ambiguous_species <- matched_temp |>
      dplyr::semi_join(ambiguous_keys, by = ".row_id") |>
      dplyr::arrange(.row_id, fuzzy_species_dist, query_species)
  }

  matched <- .pick_best_target(matched_temp, dist_col = "fuzzy_species_dist") |>
    dplyr::mutate(
      fuzzy_match_species_within_genus = TRUE,
      matched_species = query_species
    )

  unmatched <- df_work |>
    dplyr::anti_join(matched |> dplyr::select(.row_id), by = ".row_id")

  out <- dplyr::bind_rows(
    matched |>
      dplyr::select(
        -dplyr::any_of(c(
          ".row_id",
          "query_name",
          "query_name_clean",
          "query_genus",
          "query_species",
          ".orig_len",
          ".cand_len",
          "species_key_tmp",
          "min_orig_len",
          "max_orig_len"
        ))
      ),
    unmatched |>
      dplyr::select(
        -dplyr::any_of(c(".row_id", ".orig_len", "species_key_tmp"))
      )
  ) |>
    dplyr::arrange(sorter)

  if (!is.null(ambiguous_species) && nrow(ambiguous_species) > 0) {
    attr(out, "ambiguous_species") <- ambiguous_species
  }

  out
}
