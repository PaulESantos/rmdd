library(testthat)
library(rmdd)

test_that("mdd_taxon_info returns structured local information", {
  checklist <- tibble::tibble(
    id = c(1006017),
    sci_name = c("Puma_concolor"),
    main_common_name = c("Cougar"),
    other_common_names = c("Mountain Lion|Puma"),
    subclass = c("Theria"),
    infraclass = c("Eutheria"),
    magnorder = c(NA_character_),
    superorder = c("Laurasiatheria"),
    order = c("Carnivora"),
    suborder = c("Feliformia"),
    infraorder = c(NA_character_),
    parvorder = c(NA_character_),
    superfamily = c("Feloidea"),
    family = c("Felidae"),
    subfamily = c("Felinae"),
    tribe = c(NA_character_),
    subtribe = c(NA_character_),
    genus = c("Puma"),
    subgenus = c(NA_character_),
    specific_epithet = c("concolor"),
    authority_species_author = c("Linnaeus"),
    authority_species_year = c(1771),
    authority_parentheses = c(1),
    original_name_combination = c("Felis concolor"),
    authority_species_citation = c("Example citation"),
    authority_species_link = c("https://example.org"),
    type_voucher = c("N/A"),
    type_kind = c("holotype"),
    type_voucher_uris = c("https://example.org/specimen"),
    type_locality = c("South America"),
    type_locality_latitude = c(NA_real_),
    type_locality_longitude = c(NA_real_),
    nominal_names = c("Felis concolor"),
    taxonomy_notes = c("Example note"),
    taxonomy_notes_citation = c("Example note citation"),
    distribution_notes = c("Widely distributed"),
    distribution_notes_citation = c("Example distribution citation"),
    subregion_distribution = c("USA(CA)|Argentina"),
    country_distribution = c("United States|Argentina"),
    continent_distribution = c("North America|South America"),
    biogeographic_realm = c("Nearctic|Neotropical"),
    iucn_status = c("LC"),
    extinct = c(0),
    domestic = c(0),
    flagged = c(0),
    cmw_sci_name = c("Puma_concolor"),
    diff_since_cmw = c(0),
    msw3_matchtype = c("matched"),
    msw3_sci_name = c("Puma concolor"),
    diff_since_msw3 = c(0)
  )

  synonyms <- tibble::tibble(
    mdd_syn_id = c("100004688"),
    mdd_species_id = c("1006017"),
    mdd_root_name = c("concolor"),
    mdd_author = c("Linnaeus"),
    mdd_year = c(1771),
    mdd_nomenclature_status = c("available"),
    mdd_validity = c("species"),
    mdd_original_combination = c("Felis concolor"),
    mdd_order = c("Carnivora"),
    mdd_family = c("Felidae"),
    mdd_genus = c("Puma"),
    mdd_specific_epithet = c("concolor")
  )

  info <- mdd_taxon_info("Puma concolor", checklist = checklist, synonyms = synonyms)

  expect_s3_class(info, "mdd_taxon_info")
  expect_true(info$matched)
  expect_equal(info$match$accepted_name[[1]], "Puma concolor")
  expect_equal(info$taxon$main_common_name[[1]], "Cougar")
  expect_equal(info$sections$taxonomy$order[[1]], "Carnivora")
  expect_equal(nrow(info$synonyms), 1)
  expect_equal(info$url, "https://www.mammaldiversity.org/taxon/1006017/")
})

test_that("mdd_taxon_info returns unmatched object when no taxon is found", {
  checklist <- tibble::tibble(
    id = c(1),
    sci_name = c("Puma_concolor"),
    genus = c("Puma"),
    specific_epithet = c("concolor"),
    authority_species_author = c("Linnaeus")
  )

  synonyms <- tibble::tibble(
    mdd_syn_id = character(),
    mdd_species_id = character(),
    mdd_original_combination = character(),
    mdd_author = character()
  )

  info <- mdd_taxon_info("Not_a_real_name", checklist = checklist, synonyms = synonyms)

  expect_s3_class(info, "mdd_taxon_info")
  expect_false(info$matched)
  expect_null(info$taxon)
  expect_equal(nrow(info$synonyms), 0)
})
