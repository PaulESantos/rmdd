test_that("mdd_reference returns dataset citation", {
  ref <- mdd_reference()

  expect_s3_class(ref, "mdd_reference")
  expect_match(ref$dataset_citation, "Zenodo", fixed = TRUE)
  expect_match(ref$dataset_doi, "10.5281/zenodo.17033774", fixed = TRUE)
  expect_null(ref$entry_citation)
})

test_that("mdd_reference uses the execution date for a specific entry citation", {
  ref <- mdd_reference(
    taxon_id = "1001892",
    taxon_name = "Dipodomys deserti"
  )

  expected_date <- .mdd_format_citation_date(Sys.Date())
  expect_equal(ref$fetched_on, Sys.Date())
  expect_match(ref$entry_citation, "Dipodomys deserti", fixed = TRUE)
  expect_match(ref$entry_citation, "#1001892", fixed = TRUE)
  expect_match(ref$entry_citation, expected_date, fixed = TRUE)
  expect_match(
    ref$entry_citation,
    "https://www.mammaldiversity.org/taxon/1001892",
    fixed = TRUE
  )
})

test_that("mdd_reference errors when taxon citation lacks a name", {
  local_reproducible_output(width = 80)

  expect_snapshot(error = TRUE, {
    mdd_reference(taxon_id = "1001892", taxon_name = "")
  })
})
