# Return release records used by rmdd

**\[stable\]**

This function is stable and its interface is expected to remain
compatible.

## Usage

``` r
mdd_release_records(
  checklist = NULL,
  synonyms = NULL,
  type_specimen_metadata = NULL
)
```

## Arguments

- checklist:

  Optional checklist data frame.

- synonyms:

  Optional synonym data frame.

- type_specimen_metadata:

  Optional type specimen metadata table.

## Value

A named list of tibbles.

## Examples

``` r
x <- mdd_release_records()
names(x)
#> [1] "checklist"              "synonyms"               "type_specimen_metadata"
```
