# Return the default rmdd cache directory

**\[stable\]**

This function is stable and its interface is expected to remain
compatible.

## Usage

``` r
mdd_cache_dir(path = NULL)
```

## Arguments

- path:

  Optional path. If `NULL`, a user cache directory is constructed.

## Value

A scalar character path.

## Examples

``` r
mdd_cache_dir(tempdir())
#> [1] "/tmp/Rtmpx8DHtd"
```
