# Return synonym records in a normalized tibble

**\[stable\]**

This function is stable and its interface is expected to remain
compatible.

## Usage

``` r
mdd_synonym_records(synonyms = NULL)
```

## Arguments

- synonyms:

  Optional synonym data frame. Defaults to `mdd_synonyms`.

## Value

A tibble.

## Examples

``` r
mdd_synonym_records()
#> # A tibble: 64,683 × 44
#>    mdd_syn_id mdd_species          mdd_root_name mdd_author             mdd_year
#>         <dbl> <chr>                <chr>         <chr>                     <dbl>
#>  1  100022090 Abditomys latidens   latidens      Sanborn                    1952
#>  2  100040650 Abditomys latidens   latidens      Musser                     1982
#>  3  100022091 Abeomelomys sevia    sevia         Tate & Archbold            1935
#>  4  100022092 Abeomelomys sevia    tatei         Hinton                     1943
#>  5  100035235 Abeomelomys sevia    sevia         Tate                       1951
#>  6  100044950 Abeomelomys sevia    tatei         Tate                       1951
#>  7  100057154 Abeomelomys sevia    sevia         Laurie & J. Edwards H…     1954
#>  8  100040581 Abeomelomys sevia    sevia         Menzies                    1990
#>  9  100017149 Abrawayaomys ruschii ruschii       F. L. de S. Cunha & J…     1979
#> 10  100017150 Abrawayaomys ruschii chebezi       Pardiñas, Teta, & D'E…     2009
#> # ℹ 64,673 more rows
#> # ℹ 39 more variables: mdd_authority_parentheses <dbl>,
#> #   mdd_nomenclature_status <chr>, mdd_validity <chr>,
#> #   mdd_original_combination <chr>, mdd_normalized_original_combination <chr>,
#> #   mdd_original_rank <chr>, mdd_authority_citation <chr>,
#> #   mdd_unchecked_authority_citation <chr>,
#> #   mdd_sourced_unverified_citations <chr>, mdd_citation_group <chr>, …
```
