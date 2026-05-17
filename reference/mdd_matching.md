# Reconcile mammal names against MDD

**\[experimental\]**

This function is experimental and may change in future releases.

Run a staged species-level reconciliation pipeline against an MDD
backbone. The workflow prioritizes exact evidence first, then
progressively relaxes criteria through exact genus, fuzzy genus, exact
species-within-genus, and fuzzy species-within-genus matching.

## Usage

``` r
mdd_matching(
  x,
  target_df = NULL,
  prefilter_genus = TRUE,
  allow_duplicates = FALSE,
  max_dist = 1,
  method = "osa"
)
```

## Arguments

- x:

  Character vector of names or a data frame with parsed name columns.

- target_df:

  Optional backbone produced by
  [`build_mdd_match_backbone()`](https://paulesantos.github.io/rmdd/reference/build_mdd_match_backbone.md).

- prefilter_genus:

  Logical. If `TRUE`, restrict the backbone to exact and fuzzy candidate
  genera before the full pipeline.

- allow_duplicates:

  Logical. If `TRUE`, deduplicate internally and expand results back to
  the original rows.

- max_dist:

  Maximum string distance used in fuzzy stages.

- method:

  Distance method passed to `fuzzyjoin::stringdist_*_join()`.

## Value

A tibble with row-level traceability, pathway flags, matched name
context, accepted-name context, and fuzzy distance columns.

## Examples

``` r
checklist <- tibble::tibble(
  id = c("1", "2"),
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
backbone <- build_mdd_match_backbone(checklist, synonyms)
mdd_matching(
  c("Puma concolor", "Felis concolor", "Pumma concolor"),
  target_df = backbone
)
#> # A tibble: 3 × 51
#>   input_index input_name     orig_name     orig_genus orig_subgenus orig_species
#>         <int> <chr>          <chr>         <chr>      <chr>         <chr>       
#> 1           1 Puma concolor  Puma concolor Puma       NA            concolor    
#> 2           2 Felis concolor Felis concol… Felis      NA            concolor    
#> 3           3 Pumma concolor Pumma concol… Pumma      NA            concolor    
#> # ℹ 45 more variables: orig_subspecies <chr>, author <chr>,
#> #   matched_name_id <chr>, matched_name <chr>, matched_author <chr>,
#> #   taxon_status <chr>, accepted_id <chr>, accepted_name <chr>,
#> #   accepted_author <chr>, is_accepted_name <lgl>, matched <lgl>,
#> #   match_stage <chr>, direct_match <lgl>, genus_match <lgl>,
#> #   fuzzy_match_genus <lgl>, direct_match_species_within_genus <lgl>,
#> #   fuzzy_match_species_within_genus <lgl>, fuzzy_genus_dist <dbl>, …
```
