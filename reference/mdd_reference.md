# Reference citations for the Mammal Diversity Database

**\[stable\]**

This function is stable and its interface is expected to remain
compatible.

Return the recommended citation for the current MDD Zenodo release and,
optionally, format a citation for a specific MDD taxon entry.

## Usage

``` r
mdd_reference(taxon_id = NULL, taxon_name = NULL)
```

## Arguments

- taxon_id:

  Optional MDD taxon identifier for a specific entry.

- taxon_name:

  Optional scientific name to use in the entry citation. If `NULL` and
  `taxon_id` is provided, the function tries to recover the accepted
  name from `mdd_checklist`.

## Value

An object of class `mdd_reference` containing dataset-level and, when
requested, entry-level citation strings.

## Examples

``` r
mdd_reference()
#> 
#> ── MDD Citation ──
#> 
#> Mammal Diversity Database. (2026). Mammal Diversity Database (Version 2.4)
#> [Data set]. Zenodo. https://doi.org/10.5281/zenodo.17033774
#> DOI: <https://doi.org/10.5281/zenodo.17033774>
mdd_reference(taxon_id = "1001892", taxon_name = "Dipodomys deserti")
#> 
#> ── MDD Citation ──
#> 
#> Mammal Diversity Database. (2026). Mammal Diversity Database (Version 2.4)
#> [Data set]. Zenodo. https://doi.org/10.5281/zenodo.17033774
#> DOI: <https://doi.org/10.5281/zenodo.17033774>
#> 
#> ── Specific Entry 
#> Dipodomys deserti (ASM Mammal Diversity Database #1001892) fetched May 17,
#> 2026. Mammal Diversity Database. 2026.
#> https://www.mammaldiversity.org/taxon/1001892
```
