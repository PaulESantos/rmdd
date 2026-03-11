library(testthat)
library(rmdd)

test_that("build_mdd_match_backbone combines checklist and synonyms", {
  checklist <- tibble::tibble(
    id = c(1, 2),
    sci_name = c("Puma_concolor", "Vicugna_vicugna"),
    genus = c("Puma", "Vicugna"),
    specific_epithet = c("concolor", "vicugna"),
    authority_species_author = c("Linnaeus", "Molina")
  )

  synonyms <- tibble::tibble(
    mdd_syn_id = c("1001", "1002"),
    mdd_species_id = c("1", "2"),
    mdd_author = c("Linnaeus", "Molina"),
    mdd_original_combination = c("Felis concolor", "Auchenia vicugna")
  )

  backbone <- build_mdd_match_backbone(checklist = checklist, synonyms = synonyms)

  expect_true(all(c("accepted", "synonym") %in% backbone$taxon_status))
  expect_true(all(c("Puma concolor", "Felis concolor") %in% backbone$query_name))
})

test_that("mdd_matching resolves accepted and synonym names", {
  checklist <- tibble::tibble(
    id = c(1, 2),
    sci_name = c("Puma_concolor", "Vicugna_vicugna"),
    genus = c("Puma", "Vicugna"),
    specific_epithet = c("concolor", "vicugna"),
    authority_species_author = c("Linnaeus", "Molina")
  )

  synonyms <- tibble::tibble(
    mdd_syn_id = c("1001", "1002"),
    mdd_species_id = c("1", "2"),
    mdd_author = c("Linnaeus", "Molina"),
    mdd_original_combination = c("Felis concolor", "Auchenia vicugna")
  )

  backbone <- build_mdd_match_backbone(checklist = checklist, synonyms = synonyms)
  out <- mdd_matching(c("Puma concolor", "Felis concolor"), target_df = backbone)

  expect_true(all(out$matched))
  expect_equal(out$taxon_status, c("accepted", "synonym"))
  expect_equal(out$accepted_name, c("Puma concolor", "Puma concolor"))
  expect_equal(out$match_stage, c("direct_match", "direct_match"))
})

test_that("mdd_matching supports fuzzy genus and fuzzy species stages", {
  checklist <- tibble::tibble(
    id = c(1, 2),
    sci_name = c("Puma_concolor", "Vicugna_vicugna"),
    genus = c("Puma", "Vicugna"),
    specific_epithet = c("concolor", "vicugna"),
    authority_species_author = c("Linnaeus", "Molina")
  )

  synonyms <- tibble::tibble(
    mdd_syn_id = c("1001"),
    mdd_species_id = c("1"),
    mdd_author = c("Linnaeus"),
    mdd_original_combination = c("Felis concolor")
  )

  backbone <- build_mdd_match_backbone(checklist = checklist, synonyms = synonyms)
  out <- mdd_matching(
    c("Pumma concolor", "Puma concolro"),
    target_df = backbone,
    prefilter_genus = FALSE,
    max_dist = 1,
    method = "osa"
  )

  expect_true(all(out$matched))
  expect_true(out$fuzzy_match_genus[[1]])
  expect_equal(out$match_stage[[1]], "direct_match_species_within_genus")
  expect_true(out$fuzzy_match_species_within_genus[[2]])
  expect_equal(out$accepted_name[[2]], "Puma concolor")
})
