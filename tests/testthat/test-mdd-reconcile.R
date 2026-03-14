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

  backbone <- build_mdd_match_backbone(
    checklist = checklist,
    synonyms = synonyms
  )

  expect_true(all(c("accepted", "synonym") %in% backbone$taxon_status))
  expect_true(all(
    c("Puma concolor", "Felis concolor") %in% backbone$query_name
  ))
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

  backbone <- build_mdd_match_backbone(
    checklist = checklist,
    synonyms = synonyms
  )
  out <- mdd_matching(
    c("Puma concolor", "Felis concolor"),
    target_df = backbone
  )

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

  backbone <- build_mdd_match_backbone(
    checklist = checklist,
    synonyms = synonyms
  )
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

test_that("mdd_matching allows a single-edit fuzzy species match for short epithets", {
  checklist <- tibble::tibble(
    id = c(1),
    sci_name = c("Panthera_onca"),
    genus = c("Panthera"),
    specific_epithet = c("onca"),
    authority_species_author = c("Linnaeus")
  )

  synonyms <- tibble::tibble(
    mdd_syn_id = character(),
    mdd_species_id = character(),
    mdd_author = character(),
    mdd_original_combination = character()
  )

  out <- mdd_matching(
    "Panthera onkca",
    target_df = build_mdd_match_backbone(
      checklist = checklist,
      synonyms = synonyms
    ),
    prefilter_genus = FALSE,
    max_dist = 1,
    method = "osa"
  )

  expect_true(out$matched[[1]])
  expect_equal(out$accepted_name[[1]], "Panthera onca")
  expect_true(out$fuzzy_match_species_within_genus[[1]])
  expect_equal(out$fuzzy_species_dist[[1]], 1)
})


test_that("mdd_name_index preserves accepted and synonym rows", {
  checklist <- tibble::tibble(
    id = c(1),
    sci_name = c("Puma_concolor"),
    genus = c("Puma"),
    specific_epithet = c("concolor"),
    authority_species_author = c("Linnaeus")
  )

  synonyms <- tibble::tibble(
    mdd_syn_id = c("1001"),
    mdd_species_id = c("1"),
    mdd_author = c("Linnaeus"),
    mdd_original_combination = c("Felis concolor")
  )

  idx <- mdd_name_index(checklist = checklist, synonyms = synonyms)

  expect_equal(sort(unique(idx$taxon_status)), c("accepted", "synonym"))
  expect_true(all(c("original_name_raw", "status_rank") %in% names(idx)))
})


test_that("mdd_matching resolves checklist original combinations with subspecies", {
  checklist <- tibble::tibble(
    id = c(1000039),
    sci_name = c("Marmosa_demerarae"),
    genus = c("Marmosa"),
    specific_epithet = c("demerarae"),
    authority_species_author = c("O. Thomas"),
    original_name_combination = c("Marmosa cinerea demerarae")
  )

  synonyms <- tibble::tibble(
    mdd_syn_id = character(),
    mdd_species_id = character(),
    mdd_author = character(),
    mdd_original_combination = character()
  )

  out <- mdd_matching(
    "Marmosa cinerea demerarae",
    target_df = build_mdd_match_backbone(
      checklist = checklist,
      synonyms = synonyms
    )
  )

  expect_true(out$matched[[1]])
  expect_equal(out$accepted_name[[1]], "Marmosa demerarae")
  expect_equal(out$taxon_status[[1]], "original_combination")
  expect_equal(out$match_stage[[1]], "direct_match")
})

test_that("mdd_matching resolves checklist original combinations with subgenus", {
  checklist <- tibble::tibble(
    id = c(1001381),
    sci_name = c("Mesocapromys_angelcabrerai"),
    genus = c("Mesocapromys"),
    specific_epithet = c("angelcabrerai"),
    authority_species_author = c("Varona"),
    original_name_combination = c("Capromys (Pygmaeocapromys) angelcabrerai")
  )

  synonyms <- tibble::tibble(
    mdd_syn_id = character(),
    mdd_species_id = character(),
    mdd_author = character(),
    mdd_original_combination = character()
  )

  out <- mdd_matching(
    "Capromys (Pygmaeocapromys) angelcabrerai",
    target_df = build_mdd_match_backbone(
      checklist = checklist,
      synonyms = synonyms
    )
  )

  expect_true(out$matched[[1]])
  expect_equal(out$accepted_name[[1]], "Mesocapromys angelcabrerai")
  expect_equal(out$taxon_status[[1]], "original_combination")
  expect_equal(out$match_stage[[1]], "direct_match")
})


test_that("subset records keeps only relevant candidate genera", {
  checklist <- tibble::tibble(
    id = c(1, 2, 3),
    sci_name = c("Puma_concolor", "Vicugna_vicugna", "Homo_sapiens"),
    genus = c("Puma", "Vicugna", "Homo"),
    specific_epithet = c("concolor", "vicugna", "sapiens"),
    authority_species_author = c("Linnaeus", "Molina", "Linnaeus"),
    original_name_combination = c(NA, NA, NA)
  )

  synonyms <- tibble::tibble(
    mdd_syn_id = c("1001", "1002"),
    mdd_species_id = c("1", "2"),
    mdd_author = c("Linnaeus", "Molina"),
    mdd_original_combination = c("Felis concolor", "Auchenia vicugna")
  )

  parsed <- classify_mammal_names("Pumma concolor")
  subset_records <- rmdd:::.mdd_subset_records_for_matching(
    parsed,
    checklist = checklist,
    synonyms = synonyms,
    max_dist = 1,
    method = "osa"
  )

  expect_equal(sort(unique(subset_records$checklist$genus)), "Puma")
  expect_equal(sort(unique(subset_records$synonyms$mdd_species_id)), "1")
})
