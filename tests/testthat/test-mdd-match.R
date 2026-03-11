test_that("exact matching finds canonical names", {
  mammal_tbl <- tibble::tibble(
    scientificName = c("Puma concolor", "Vicugna vicugna")
  )

  out <- mdd_match_names(
    names = c("Puma concolor", "Vicugna vicugna"),
    data = mammal_tbl
  )

  expect_equal(out$match_status, c("exact", "exact"))
  expect_equal(out$matched_name, c("Puma concolor", "Vicugna vicugna"))
})

test_that("approximate matching returns a close candidate", {
  mammal_tbl <- tibble::tibble(
    scientificName = c("Puma concolor", "Vicugna vicugna")
  )

  out <- mdd_match_names(
    names = c("Pumma concolor"),
    data = mammal_tbl,
    method = "agrep",
    max_distance = 0.2
  )

  expect_equal(out$match_status, "approximate")
  expect_equal(out$matched_name, "Puma concolor")
})
