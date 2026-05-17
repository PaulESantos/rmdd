# Build a normalized MDD name index

**\[experimental\]**

This function is experimental and may change in future releases.

Create a reusable name index that combines accepted checklist names,
checklist original combinations, and synonym names while preserving the
accepted-species linkage for each row.

## Usage

``` r
mdd_name_index(checklist = NULL, synonyms = NULL)
```

## Arguments

- checklist:

  Optional checklist data frame. Defaults to `mdd_checklist`.

- synonyms:

  Optional synonym data frame. Defaults to `mdd_synonyms`.

## Value

A tibble with one row per queryable accepted name or synonym.

## Examples

``` r
idx <- mdd_name_index(
  checklist = dplyr::slice(mdd_checklist, 1:10),
  synonyms = dplyr::slice(mdd_synonyms, 1:20)
)
idx
#> # A tibble: 70 × 17
#>    query_name         query_name_clean query_genus query_species matched_name_id
#>    <chr>              <chr>            <chr>       <chr>         <chr>          
#>  1 Ornithorhynchus a… ornithorhynchus… Ornithorhy… anatinus      1000001        
#>  2 Tachyglossus acul… tachyglossus ac… Tachygloss… aculeatus     1000002        
#>  3 Zaglossus attenbo… zaglossus atten… Zaglossus   attenboroughi 1000003        
#>  4 Zaglossus bartoni  zaglossus barto… Zaglossus   bartoni       1000004        
#>  5 Zaglossus bruijnii zaglossus bruij… Zaglossus   bruijnii      1000005        
#>  6 Caenolestes caniv… caenolestes can… Caenolestes caniventer    1000006        
#>  7 Caenolestes condo… caenolestes con… Caenolestes condorensis   1000007        
#>  8 Caenolestes conve… caenolestes con… Caenolestes convelatus    1000008        
#>  9 Caenolestes fulig… caenolestes ful… Caenolestes fuliginosus   1000009        
#> 10 Caenolestes sangay caenolestes san… Caenolestes sangay        1000010        
#> # ℹ 60 more rows
#> # ℹ 12 more variables: matched_name <chr>, matched_author <chr>,
#> #   taxon_status <chr>, match_source <chr>, original_name_raw <chr>,
#> #   accepted_id <chr>, accepted_name <chr>, accepted_author <chr>,
#> #   accepted_genus <chr>, accepted_species <chr>, is_accepted_name <lgl>,
#> #   status_rank <int>
```
