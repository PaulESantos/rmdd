# rmdd

`rmdd` is a development-stage R package project for mammal taxonomic name
resolution using the Mammal Diversity Database (MDD).

## Goal

The package is intended to provide a mammal-focused workflow analogous to
plant-oriented TNRS tools, while following tidyverse package conventions and
CRAN-oriented development practices.

## Planned features

- Download and cache current MDD source files
- Read MDD exports into tidy tibbles
- Standardize input names
- Perform exact and approximate matching
- Report accepted names, unmatched names, and match diagnostics

## Current bootstrap

The project currently includes:

- An RStudio project
- Core package metadata and license files
- Initial functions for download, load, and simple matching
- Unit tests using `testthat`
- `pkgdown` and `lintr` configuration stubs
