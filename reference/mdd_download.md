# Download a Mammal Diversity Database file

**\[stable\]**

This function is stable and its interface is expected to remain
compatible.

## Usage

``` r
mdd_download(url, dest_dir = mdd_cache_dir(), dest_file = NULL, mode = "wb")
```

## Arguments

- url:

  URL to the source file.

- dest_dir:

  Destination directory for the downloaded file.

- dest_file:

  Optional output filename.

- mode:

  Transfer mode passed to
  [`utils::download.file()`](https://rdrr.io/r/utils/download.file.html).

## Value

The downloaded file path, invisibly.

## Examples

``` r
if (interactive()) {
  mdd_download(
    url = "https://www.mammaldiversity.org/robots.txt",
    dest_dir = tempdir()
  )
}
```
