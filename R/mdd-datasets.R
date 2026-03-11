#' Current Mammal Diversity Database checklist
#'
#' Current species-level checklist from the Mammal Diversity Database (MDD).
#' This dataset is generated from the release file matching
#' `MDD_...species.csv` and stores one row per currently recognized species.
#'
#' @format A tibble with 6,871 rows and 52 variables in the MDD v2.4 release,
#' with source column names normalized to snake_case during data import.
#'
#' @details According to `META_v2.4.csv`, the checklist includes these main
#' column groups: identifiers (`sci_name`, `id`, `phylosort`); taxonomic
#' classification from subclass to genus and species epithet; authority and
#' original-combination fields; type specimen and type locality fields;
#' nomenclatural and taxonomic notes; native distribution summaries at
#' subregion, country, continent, and biogeographic realm scales; conservation
#' and status flags (`iucn_status`, `extinct`, `domestic`, `flagged`); and
#' cross-release comparison fields linking the checklist to CMW and MSW3.
#'
#' Key examples include `sci_name` as the underscore-delimited species key used
#' by MDD, `main_common_name` and `other_common_names` for vernacular names,
#' `authority_species_author` and `authority_species_year` for species
#' authority, `type_voucher` and `type_kind` for type material, and
#' `country_distribution` and `continent_distribution` for summarized native
#' range.
#' @source Mammal Diversity Database release archive; field definitions are
#' summarized from `META_v2.4.csv`.
"mdd_checklist"

#' Mammal Diversity Database synonym table
#'
#' Synonymy and nomenclatural table from the Mammal Diversity Database (MDD).
#' This dataset is generated from the release file matching
#' `Species_Syn_...csv` and includes species- and subspecies-level names,
#' authority metadata, type information, and links back to accepted species.
#'
#' @format A tibble with 44 variables in the MDD v2.4 release, with source
#' column names normalized to snake_case during data import.
#'
#' @details According to `META_v2.4.csv`, this table covers all names
#' applicable to species- and subspecies-level mammal taxa and is designed to
#' align with the online nomenclature database Hesperomys. The main column
#' groups include synonym identifiers and accepted-species links
#' (`mdd_syn_id`, `mdd_species`, `mdd_species_id`, `hesp_id`); root name,
#' authority, year, and parentheses fields; nomenclatural and taxonomic status
#' fields; original combination and original rank; verified and unverified
#' citation metadata and page links; type locality, type specimen, and type
#' geography fields; taxonomic placement from order to subspecies; variant and
#' homonym linkage fields; later name usages; and free-text comments.
#'
#' Key examples include `mdd_root_name` for the standardized epithet root,
#' `mdd_nomenclature_status` and `mdd_validity` for ICZN-based interpretation,
#' `mdd_original_combination` and `mdd_original_rank` for the original name
#' context, `mdd_holotype` and `mdd_type_kind` for type material,
#' `mdd_order`, `mdd_family`, `mdd_genus`, and `mdd_specific_epithet` for
#' current placement, and `mdd_variant_of` or `mdd_senior_homonym` for linked
#' nomenclatural relationships.
#' @source Mammal Diversity Database release archive; field definitions are
#' summarized from `META_v2.4.csv`.
"mdd_synonyms"

#' Mammal Diversity Database type specimen metadata
#'
#' Auxiliary table of museum and type specimen metadata distributed with an MDD
#' release. This dataset is generated from the release file matching
#' `TypeSpecimenMetadata_...csv` when present.
#'
#' @format A tibble with one row per type specimen metadata record and cleaned
#' snake_case column names.
#' @source Mammal Diversity Database release archive.
"mdd_type_specimen_metadata"
