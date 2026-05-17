# Retrieve a normalized MDD taxon record

**\[experimental\]**

This function is experimental and may change in future releases.

Resolve a taxon by accepted MDD identifier or by scientific name against
the local MDD name index. The returned object contains the match result,
accepted taxon row, linked synonym rows, and the canonical MDD taxon
URL.

## Usage

``` r
mdd_taxon_record(
  name = NULL,
  taxon_id = NULL,
  checklist = NULL,
  synonyms = NULL,
  target_df = NULL,
  max_dist = 1,
  method = "osa"
)
```

## Arguments

- name:

  Optional scientific name.

- taxon_id:

  Optional accepted MDD taxon identifier.

- checklist:

  Optional checklist data frame.

- synonyms:

  Optional synonym data frame.

- target_df:

  Optional reconciliation backbone or name index.

- max_dist:

  Maximum string distance used if `name` needs fuzzy matching.

- method:

  Distance method passed to
  [`mdd_matching()`](https://paulesantos.github.io/rmdd/reference/mdd_matching.md).

## Value

A list of class `mdd_taxon_record`.

## Examples

``` r
checklist <- tibble::tibble(
  id = "1",
  sci_name = "Puma_concolor",
  genus = "Puma",
  specific_epithet = "concolor",
  authority_species_author = "Linnaeus"
)
synonyms <- tibble::tibble(
  mdd_syn_id = "1001",
  mdd_species_id = "1",
  mdd_author = "Linnaeus",
  mdd_original_combination = "Felis concolor"
)
mdd_taxon_record(
  name = "Felis concolor",
  checklist = checklist,
  synonyms = synonyms
)
#> $query
#> [1] "Felis concolor"
#> 
#> $matched
#> [1] TRUE
#> 
#> $match
#> # A tibble: 1 × 51
#>   input_index input_name     orig_name     orig_genus orig_subgenus orig_species
#>         <int> <chr>          <chr>         <chr>      <chr>         <chr>       
#> 1           1 Felis concolor Felis concol… Felis      NA            concolor    
#> # ℹ 45 more variables: orig_subspecies <chr>, author <chr>,
#> #   matched_name_id <chr>, matched_name <chr>, matched_author <chr>,
#> #   taxon_status <chr>, accepted_id <chr>, accepted_name <chr>,
#> #   accepted_author <chr>, is_accepted_name <lgl>, matched <lgl>,
#> #   match_stage <chr>, direct_match <lgl>, genus_match <lgl>,
#> #   fuzzy_match_genus <lgl>, direct_match_species_within_genus <lgl>,
#> #   fuzzy_match_species_within_genus <lgl>, fuzzy_genus_dist <dbl>, …
#> 
#> $taxon_tbl
#> # A tibble: 1 × 5
#>   id    sci_name      genus specific_epithet authority_species_author
#>   <chr> <chr>         <chr> <chr>            <chr>                   
#> 1 1     Puma_concolor Puma  concolor         Linnaeus                
#> 
#> $synonym_tbl
#> # A tibble: 1 × 4
#>   mdd_syn_id mdd_species_id mdd_author mdd_original_combination
#>   <chr>      <chr>          <chr>      <chr>                   
#> 1 1001       1              Linnaeus   Felis concolor          
#> 
#> $accepted_id
#> [1] "1"
#> 
#> $url
#> [1] "https://www.mammaldiversity.org/taxon/1/"
#> 
#> attr(,"class")
#> [1] "mdd_taxon_record"
```
