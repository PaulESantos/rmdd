# Classify mammal scientific names into taxonomic components

**\[experimental\]**

This function is experimental and may change in future releases.

Parse mammal scientific names into genus, optional subgenus, species,
optional subspecies, and trailing author text. The parser is
intentionally conservative and targets species-level MDD reconciliation
workflows.

## Usage

``` r
classify_mammal_names(splist)
```

## Arguments

- splist:

  Character vector of scientific names.

## Value

A tibble with one row per input name and standardized columns for
species-level reconciliation.

## Examples

``` r
classify_mammal_names(c(
  "Puma concolor",
  "Capromys (Pygmaeocapromys) angelcabrerai"
))
#> # A tibble: 2 × 15
#>   sorter input_name           orig_name orig_name_clean orig_genus orig_subgenus
#>    <dbl> <chr>                <chr>     <chr>           <chr>      <chr>        
#> 1      1 Puma concolor        Puma con… puma concolor   Puma       NA           
#> 2      2 Capromys (Pygmaeoca… Capromys… capromys (pygm… Capromys   Pygmaeocapro…
#> # ℹ 9 more variables: orig_species <chr>, orig_subspecies <chr>, author <chr>,
#> #   rank <dbl>, has_cf <lgl>, has_aff <lgl>, is_sp <lgl>, is_spp <lgl>,
#> #   had_hybrid <lgl>
```
