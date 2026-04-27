## Test environments

* Windows 11 x64, R 4.5.3 (2026-03-11 ucrt)

## R CMD check results

* `devtools::check(cran = TRUE)`
* 0 errors | 0 warnings | 0 notes

## Resubmission

This is the first submission of `rmdd` to CRAN.

## Notes

* `rmdd` provides access to packaged Mammal Diversity Database (MDD) data and tools for mammal name reconciliation, taxon summaries, distribution summaries, and distribution maps.
* The package has no compiled code.
* The package uses `rnaturalearth` for map layers generated at runtime instead of shipping bundled large spatial files.
* `urlchecker::url_check()` may report a 403 Forbidden error for `https://doi.org/10.1093/jmammal/gyx147` and `https://doi.org/10.1101/2025.02.27.640393`. These are false positives caused by anti-scraping protections on the DOI resolution destinations (Oxford Academic and bioRxiv). The URLs resolve correctly in a web browser.
