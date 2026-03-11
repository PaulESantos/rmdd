test_that("mdd_distribution_map returns a ggplot for exact matches", {
  p <- mdd_distribution_map("Lama vicugna", quiet = TRUE)

  expect_s3_class(p, "ggplot")

  info <- attr(p, "mdd_distribution_info")
  expect_type(info, "list")
  expect_equal(info$accepted_name, "Lama vicugna")
  expect_equal(info$input_match, "total")
  expect_equal(info$zoom_mode, "world")
  expect_true(nrow(info$mapped_sf) >= 4)
  expect_setequal(
    sort(unique(info$units$clean_country)),
    c("Argentina", "Bolivia", "Chile", "Peru")
  )
})

test_that("mdd_distribution_map supports automatic zooming", {
  p <- mdd_distribution_map("Lama vicugna", zoom = "auto", quiet = TRUE)
  info <- attr(p, "mdd_distribution_info")

  expect_equal(info$zoom_mode, "auto")
  expect_false(is.null(info$xlim))
  expect_false(is.null(info$ylim))
  expect_lt(diff(info$xlim), 360)
  expect_lt(diff(info$ylim), 178)
})

test_that("mdd_distribution_map preserves partial taxon matching", {
  p <- mdd_distribution_map("Pumma concolor", quiet = TRUE)
  info <- attr(p, "mdd_distribution_info")

  expect_equal(info$accepted_name, "Puma concolor")
  expect_equal(info$input_match, "partial")
  expect_true(any(info$units$country_match == "unmatched"))
  expect_true("French Guiana" %in% info$unresolved_units$clean_country)
})

test_that("mdd_distribution_map cli summary is stable", {
  local_reproducible_output(width = 80)

  expect_snapshot({
    invisible(mdd_distribution_map("Lama vicugna"))
  })
})

test_that("mdd_distribution_map cli summary reports partial matches", {
  local_reproducible_output(width = 80)

  expect_snapshot({
    invisible(mdd_distribution_map("Pumma concolor"))
  })
})

test_that("mdd_distribution_map reports cli errors for invalid inputs", {
  local_reproducible_output(width = 80)

  expect_snapshot(error = TRUE, {
    mdd_distribution_map(NA_character_)
  })

  expect_snapshot(error = TRUE, {
    mdd_distribution_map("Lama vicugna", zoom = "manual")
  })
})
