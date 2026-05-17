# Return checklist records in a normalized tibble

**\[stable\]**

This function is stable and its interface is expected to remain
compatible.

## Usage

``` r
mdd_checklist_records(checklist = NULL)
```

## Arguments

- checklist:

  Optional checklist data frame. Defaults to `mdd_checklist`.

## Value

A tibble.

## Examples

``` r
mdd_checklist_records()
#> # A tibble: 6,871 × 52
#>    sci_name            id phylosort main_common_name other_common_names subclass
#>    <chr>            <dbl>     <dbl> <chr>            <chr>              <chr>   
#>  1 Ornithorhynchu… 1.00e6         1 Platypus         Duck-billed Platy… Prototh…
#>  2 Tachyglossus_a… 1.00e6         1 Short-beaked Ec… Australian Echidn… Prototh…
#>  3 Zaglossus_atte… 1.00e6         1 Attenborough's … Attenborough's Ec… Prototh…
#>  4 Zaglossus_bart… 1.00e6         1 Eastern Long-be… Barton's Long-bea… Prototh…
#>  5 Zaglossus_brui… 1.00e6         1 Western Long-be… Long-beaked Echid… Prototh…
#>  6 Caenolestes_ca… 1.00e6         2 Gray-bellied Sh… Gray-bellied Caen… Theria  
#>  7 Caenolestes_co… 1.00e6         2 Condor Shrew-op… Andean Caenolestid Theria  
#>  8 Caenolestes_co… 1.00e6         2 Blackish Shrew-… Northern Caenoles… Theria  
#>  9 Caenolestes_fu… 1.00e6         2 Dusky Shrew-opo… Common Gray Shrew… Theria  
#> 10 Caenolestes_sa… 1.00e6         2 Sangay Shrew-op… NA                 Theria  
#> # ℹ 6,861 more rows
#> # ℹ 46 more variables: infraclass <chr>, magnorder <chr>, superorder <chr>,
#> #   order <chr>, suborder <chr>, infraorder <chr>, parvorder <chr>,
#> #   superfamily <chr>, family <chr>, subfamily <chr>, tribe <chr>,
#> #   subtribe <chr>, genus <chr>, subgenus <chr>, specific_epithet <chr>,
#> #   authority_species_author <chr>, authority_species_year <dbl>,
#> #   authority_parentheses <dbl>, original_name_combination <chr>, …
```
