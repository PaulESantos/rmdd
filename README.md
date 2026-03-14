
# rmdd

`rmdd` is a development-stage R package for mammal taxonomic name
resolution using the Mammal Diversity Database (MDD).

## Installation

When `rmdd` is available on CRAN, install it with:

``` r
pak::pak("rmdd")
```

Install the development version from GitHub with:

``` r
# install.packages("pak")
pak::pak("PaulESantos/rmdd")
```

## Planned features

- Download and cache current MDD source files
- Read MDD exports into tidy tibbles
- Standardize input names
- Perform exact and approximate matching
- Report accepted names, unmatched names, and match diagnostics

## Current bootstrap

The project currently includes:

- Core package metadata and license files
- Initial functions for download, load, and simple matching
- Unit tests using `testthat`
- `pkgdown` and `lintr` configuration stubs

## Example

``` r
library(rmdd)

sample_path <- system.file("extdata", "mdd_sample.csv", package = "rmdd")
mdd_tbl <- mdd_load(sample_path)

mdd_match_names(
  names = c("Puma concolor", "Vicugna vicugna", "Puma concolr"),
  data = mdd_tbl,
  method = "agrep"
)
#> # A tibble: 3 × 4
#>   submitted_name  matched_name    match_status match_distance
#>   <chr>           <chr>           <chr>                 <dbl>
#> 1 Puma concolor   Puma concolor   exact                0     
#> 2 Vicugna vicugna Vicugna vicugna exact                0     
#> 3 Puma concolr    Puma concolor   approximate          0.0769
```

## Reference

``` r
mdd_reference()
#> # A tibble: 1 × 3
#>   source                    url                              notes              
#>   <chr>                     <chr>                            <chr>              
#> 1 Mammal Diversity Database https://www.mammaldiversity.org/ Replace with a sta…
```
