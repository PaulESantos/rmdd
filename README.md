
# rmdd

<!-- badges: start -->

[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-green.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![CRAN
status](https://www.r-pkg.org/badges/version/rmdd)](https://CRAN.R-project.org/package=rmdd)
[![](http://cranlogs.r-pkg.org/badges/grand-total/rmdd?color=green)](https://cran.r-project.org/package=rmdd)
[![](http://cranlogs.r-pkg.org/badges/last-week/rmdd?color=green)](https://cran.r-project.org/package=rmdd)
[![R-CMD-check](https://github.com/PaulESantos/rmdd/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/PaulESantos/rmdd/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/PaulESantos/rmdd/graph/badge.svg)](https://app.codecov.io/gh/PaulESantos/rmdd)
<!-- badges: end -->

`rmdd` provides packaged Mammal Diversity Database (MDD) data for R and
a practical workflow for mammal name reconciliation, accepted-name
retrieval, distribution summaries, and distribution maps. It is designed
for analysts who need a local, reproducible interface to the current MDD
release.

## Installation

``` r
install.packages("rmdd")
```

Development version:

``` r
# install.packages("pak")
pak::pak("PaulESantos/rmdd")
```

## What is included

`rmdd` ships three lazily loaded datasets:

| Dataset | Rows | Purpose |
|----|---:|----|
| `mdd_checklist` | 6,871 | Current accepted species checklist with taxonomy, status, and distribution fields |
| `mdd_synonyms` | 64,683+ | Synonym table linking historical and alternate names to accepted species |
| `mdd_type_specimen_metadata` | 138 | Collection-level metadata for type specimen institutions cited in MDD |

## Quick start

``` r
library(rmdd)
library(dplyr)
#> 
#> Adjuntando el paquete: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

mdd_matching(c("Puma concolor", "Felis concolor", "Pumma concolor")) |>
  select(input_name, matched_name, taxon_status, accepted_name, match_stage)
#> # A tibble: 3 × 5
#>   input_name     matched_name   taxon_status accepted_name match_stage          
#>   <chr>          <chr>          <chr>        <chr>         <chr>                
#> 1 Puma concolor  Puma concolor  accepted     Puma concolor direct_match         
#> 2 Felis concolor Felis concolor synonym      Puma concolor direct_match         
#> 3 Pumma concolor Puma concolor  accepted     Puma concolor direct_match_species…
```

``` r
mdd_taxon_record("Vicugna vicugna")$taxon_tbl |>
  select(
    sci_name,
    original_name_combination,
    country_distribution,
    iucn_status
  )
#> # A tibble: 1 × 4
#>   sci_name     original_name_combination country_distribution        iucn_status
#>   <chr>        <chr>                     <chr>                       <chr>      
#> 1 Lama_vicugna Camellus Vicugna          Peru|Bolivia|Chile|Argenti… LC (as Vic…
```

``` r
mdd_distribution_summary(level = "country") |>
  arrange(desc(total_species)) |>
  slice_head(n = 5)
#> # A tibble: 5 × 7
#>   region    orders families genera living_species extinct_species total_species
#>   <chr>      <int>    <int>  <int>          <int>           <int>         <int>
#> 1 Indonesia     17       58    241            793               4           797
#> 2 Brazil        11       51    250            785               3           788
#> 3 China         12       56    259            746               0           746
#> 4 Mexico        12       45    205            585               4           589
#> 5 Peru          13       55    229            582               0           582
```

``` r
mdd_distribution_map("Lama vicugna", quiet = TRUE)
```

<img src="README_files/figure-gfm/unnamed-chunk-5-1.png" alt="Distribution map of Lama vicugna across western South America."  />

## Site structure

The pkgdown site is organized around three entry points:

- **Home**: short package overview, installation, and a minimal
  workflow.
- **Get started**: a complete walkthrough from bundled datasets to name
  matching, taxon retrieval, and distribution mapping.
- **Reference**: function documentation grouped by data access,
  reconciliation, taxon retrieval, and distribution tasks.

For the full workflow, see the [Get started
article](https://paulesantos.github.io/rmdd/articles/rmdd.html).

## Citation

Use `citation("rmdd")` to cite the package and `mdd_reference()` to cite
the bundled MDD release used by the package.

``` r
mdd_reference()
#> 
#> ── MDD Citation ──
#> 
#> Mammal Diversity Database. (2026). Mammal Diversity Database (Version 2.4)
#> [Data set]. Zenodo. https://doi.org/10.5281/zenodo.17033774
#> DOI: <https://doi.org/10.5281/zenodo.17033774>
```

## Related resources

- [Mammal Diversity Database website](https://www.mammaldiversity.org/)
- [MDD Zenodo archive](https://doi.org/10.5281/zenodo.4139722)
