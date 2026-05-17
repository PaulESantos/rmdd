# Retrieve structured MDD taxon information by name

**\[experimental\]**

This function is experimental and may change in future releases.

Resolve a mammal name against the local MDD backbone and return a
structured object built from `mdd_checklist` and `mdd_synonyms`,
including the accepted taxon record, synonym records, and grouped
sections that mirror the main information shown in MDD species pages.

## Usage

``` r
mdd_taxon_info(
  name,
  checklist = NULL,
  synonyms = NULL,
  target_df = NULL,
  max_dist = 1,
  method = "osa"
)
```

## Arguments

- name:

  A single scientific name.

- checklist:

  Optional checklist data frame. Defaults to `mdd_checklist`.

- synonyms:

  Optional synonym data frame. Defaults to `mdd_synonyms`.

- target_df:

  Optional reconciliation backbone from
  [`build_mdd_match_backbone()`](https://paulesantos.github.io/rmdd/reference/build_mdd_match_backbone.md).

- max_dist:

  Maximum string distance used if the input name needs fuzzy
  reconciliation.

- method:

  Distance method passed to
  [`mdd_matching()`](https://paulesantos.github.io/rmdd/reference/mdd_matching.md).

## Value

An object of class `mdd_taxon_info`.

## Examples

``` r
checklist <- tibble::tibble(
  id = "1",
  sci_name = "Puma_concolor",
  genus = "Puma",
  specific_epithet = "concolor",
  authority_species_author = "Linnaeus",
  authority_species_year = "1758",
  order = "Carnivora",
  family = "Felidae",
  main_common_name = "Puma"
)
synonyms <- tibble::tibble(
  mdd_syn_id = "1001",
  mdd_species_id = "1",
  mdd_author = "Linnaeus",
  mdd_original_combination = "Felis concolor",
  mdd_validity = "synonym",
  mdd_nomenclature_status = "available"
)
x <- mdd_taxon_info(
  "Felis concolor",
  checklist = checklist,
  synonyms = synonyms
)
x
#> 
#> ── Puma concolor ───────────────────────────────────────────────────────────────
#> Query: "Felis concolor"
#> Matched name: "Felis concolor" (synonym)
#> Taxon URL: <https://www.mammaldiversity.org/taxon/1/>
#> • Common name: "Puma"
#> • Authority: "Linnaeus 1758"
#> • Order / Family: "Carnivora / Felidae"
#> • IUCN / Extinct / Domestic: "NA / NA / NA"
#> • Synonym records: 1
#> 
#> ── Taxonomy ──
#> 
#> • Order: "Carnivora"
#> • Family: "Felidae"
#> • Genus: "Puma"
#> • Specific epithet: "concolor"
#> • Sci name: "Puma concolor"
#> 
#> ── Authority ──
#> 
#> • Authority species author: "Linnaeus"
#> • Authority species year: "1758"
#> • Synonym count: "1"
#> 
#> ── Status ──
#> 
#> • Main common name: "Puma"
#> 
#> ── Names and Synonyms ──
#> 
#> # A tibble: 1 × 3
#>   synonym        validity nomenclature_status
#>   <chr>          <chr>    <chr>              
#> 1 Felis concolor synonym  available          
as.list(x)
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
#> $taxon
#> $taxon$id
#> [1] "1"
#> 
#> $taxon$sci_name
#> [1] "Puma_concolor"
#> 
#> $taxon$genus
#> [1] "Puma"
#> 
#> $taxon$specific_epithet
#> [1] "concolor"
#> 
#> $taxon$authority_species_author
#> [1] "Linnaeus"
#> 
#> $taxon$authority_species_year
#> [1] "1758"
#> 
#> $taxon$order
#> [1] "Carnivora"
#> 
#> $taxon$family
#> [1] "Felidae"
#> 
#> $taxon$main_common_name
#> [1] "Puma"
#> 
#> 
#> $sections
#> $sections$taxonomy
#> $sections$taxonomy$order
#> [1] "Carnivora"
#> 
#> $sections$taxonomy$family
#> [1] "Felidae"
#> 
#> $sections$taxonomy$genus
#> [1] "Puma"
#> 
#> $sections$taxonomy$specific_epithet
#> [1] "concolor"
#> 
#> $sections$taxonomy$sci_name
#> [1] "Puma concolor"
#> 
#> 
#> $sections$authority
#> $sections$authority$authority_species_author
#> [1] "Linnaeus"
#> 
#> $sections$authority$authority_species_year
#> [1] "1758"
#> 
#> $sections$authority$synonym_count
#> [1] 1
#> 
#> 
#> $sections$type_information
#> named list()
#> 
#> $sections$distribution
#> named list()
#> 
#> $sections$status
#> $sections$status$main_common_name
#> [1] "Puma"
#> 
#> 
#> 
#> $synonyms
#> # A tibble: 1 × 6
#>   mdd_syn_id mdd_species_id mdd_author mdd_original_combination mdd_validity
#>   <chr>      <chr>          <chr>      <chr>                    <chr>       
#> 1 1001       1              Linnaeus   Felis concolor           synonym     
#> # ℹ 1 more variable: mdd_nomenclature_status <chr>
#> 
#> $url
#> [1] "https://www.mammaldiversity.org/taxon/1/"
#> 
```
