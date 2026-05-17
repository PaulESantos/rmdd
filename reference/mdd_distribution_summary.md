# Summarize mammal diversity by country, continent, or subregion

**\[experimental\]**

This function is experimental and may change in future releases.

Wrapper around
[`mdd_distribution_summary_raw()`](https://paulesantos.github.io/rmdd/reference/mdd_distribution_summary_raw.md)
that optionally excludes domesticated species and species considered
widespread at the requested geographic level.

## Usage

``` r
mdd_distribution_summary(
  level = c("country", "continent", "subregion"),
  checklist = NULL,
  exclude_domesticated = FALSE,
  exclude_widespread = FALSE,
  widespread_threshold = NULL
)
```

## Arguments

- level:

  Geographic level to summarize. Use `"country"`, `"continent"`, or
  `"subregion"`.

- checklist:

  Optional checklist data frame. Defaults to `mdd_checklist`.

- exclude_domesticated:

  Logical. If `TRUE`, drop rows where `domestic == 1`.

- exclude_widespread:

  Logical. If `TRUE`, drop species whose distribution spans more than
  `widespread_threshold` units at the chosen level.

- widespread_threshold:

  Optional threshold used to define widespread species. If `NULL`, a
  level-specific default is used.

## Value

A tibble with one row per geographic unit and the columns `region`,
`orders`, `families`, `genera`, `living_species`, `extinct_species`, and
`total_species`.

## Examples

``` r
mdd_distribution_summary(
  level = "country",
  checklist = dplyr::slice(mdd_checklist, 1:50)
)
#> # A tibble: 28 × 7
#>    region    orders families genera living_species extinct_species total_species
#>    <chr>      <int>    <int>  <int>          <int>           <int>         <int>
#>  1 Brazil         1        1      7             21               0            21
#>  2 Peru           2        2      9             21               0            21
#>  3 Colombia       2        2      8             17               0            17
#>  4 Ecuador        2        2      6             17               0            17
#>  5 Venezuela      2        2      7             14               0            14
#>  6 Bolivia        2        2      7             12               0            12
#>  7 Costa Ri…      1        1      5              9               0             9
#>  8 Guyana         1        1      6              9               0             9
#>  9 Argentina      1        1      5              8               0             8
#> 10 French G…      1        1      5              8               0             8
#> # ℹ 18 more rows
```
