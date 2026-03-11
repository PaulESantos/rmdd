test_that("mdd_distribution_summary aggregates country diversity", {
  checklist <- tibble::tibble(
    sci_name = c("A_a", "B_b", "C_c"),
    order = c("O1", "O1", "O2"),
    family = c("F1", "F2", "F3"),
    genus = c("A", "B", "C"),
    country_distribution = c("Peru|Chile", "Peru", "Chile"),
    continent_distribution = c("South America", "South America", "South America"),
    subregion_distribution = c("Peru(CUS)|Chile", "Peru(LIM)", "Chile"),
    extinct = c(0, 1, 0),
    domestic = c(0, 0, 0)
  )

  out <- mdd_distribution_summary(
    level = "country",
    checklist = checklist,
    exclude_domesticated = FALSE,
    exclude_widespread = FALSE
  )

  expect_equal(out$region, c("Chile", "Peru"))
  expect_equal(out$orders, c(2, 1))
  expect_equal(out$families, c(2, 2))
  expect_equal(out$genera, c(2, 2))
  expect_equal(out$living_species, c(2, 1))
  expect_equal(out$extinct_species, c(0, 1))
  expect_equal(out$total_species, c(2, 2))
})

test_that("mdd_distribution_summary excludes domesticated and widespread species", {
  checklist <- tibble::tibble(
    sci_name = c("A_a", "B_b", "C_c"),
    order = c("O1", "O1", "O2"),
    family = c("F1", "F2", "F3"),
    genus = c("A", "B", "C"),
    country_distribution = c("Peru|Chile|Bolivia", "Peru", "Chile"),
    continent_distribution = c("South America", "South America", "South America"),
    subregion_distribution = c("Peru|Chile|Bolivia", "Peru", "Chile"),
    extinct = c(0, 0, 0),
    domestic = c(0, 1, 0)
  )

  out <- mdd_distribution_summary(
    level = "country",
    checklist = checklist,
    exclude_domesticated = TRUE,
    exclude_widespread = TRUE,
    widespread_threshold = 2
  )

  expect_equal(out$region, "Chile")
  expect_equal(out$total_species, 1)
  expect_equal(out$living_species, 1)
})

test_that("mdd_distribution_summary errors clearly for bad thresholds", {
  local_reproducible_output(width = 80)

  expect_snapshot(error = TRUE, {
    mdd_distribution_summary(widespread_threshold = 0)
  })
})
