# Load an MDD comma-separated export

**\[stable\]**

This function is stable and its interface is expected to remain
compatible.

## Usage

``` r
mdd_load(path)
```

## Arguments

- path:

  Path to a local CSV export from MDD.

## Value

A tibble.

## Examples

``` r
sample_path <- system.file("extdata", "mdd_sample.csv", package = "rmdd")
mdd_load(sample_path)
#> # A tibble: 2 × 2
#>   scientificName  commonName
#>   <chr>           <chr>     
#> 1 Puma concolor   Cougar    
#> 2 Vicugna vicugna Vicuna    
```
