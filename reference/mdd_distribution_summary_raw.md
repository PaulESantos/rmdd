# Summarize mammal diversity by country, continent, or subregion

**\[experimental\]**

This function is experimental and may change in future releases.

Expand MDD distribution fields and compute diversity summaries by
geographic unit. The summary reports counts of distinct orders,
families, genera, living species, and extinct species for each unit
listed in the selected MDD distribution column.

## Usage

``` r
mdd_distribution_summary_raw(
  level = c("country", "continent", "subregion"),
  checklist = NULL
)
```

## Arguments

- level:

  Geographic level to summarize. Use `"country"`, `"continent"`, or
  `"subregion"`.

- checklist:

  Optional checklist data frame. Defaults to `mdd_checklist`.

## Value

A tibble with one row per geographic unit and the columns `region`,
`orders`, `families`, `genera`, `living_species`, `extinct_species`, and
`total_species`.

## Examples

``` r
mdd_distribution_summary_raw(
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
