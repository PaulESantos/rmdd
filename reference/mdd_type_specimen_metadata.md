# Mammal Diversity Database type specimen metadata

Auxiliary reference table of natural history museum collection metadata
distributed with an MDD release. Each row corresponds to one institution
that holds or has held type material cited in the MDD synonym table
(`mdd_synonyms`).

## Usage

``` r
mdd_type_specimen_metadata
```

## Format

A tibble with 138 rows and 5 variables, with source column names
normalized to `snake_case` during data import:

- abbreviation:

  Standard acronym or abbreviation used to identify the collection in
  the MDD and broader taxonomic literature (e.g. `"AMNH"`, `"MNHN"`,
  `"USNM"`); corresponds to the collection codes cited in the
  `mdd_holotype` and `mdd_type_specimen_link` fields of `mdd_synonyms`.

- full_name:

  Full official name of the institution or collection (e.g.
  `"American Museum of Natural History"`,
  `"Museum National d'Histoire Naturelle"`).

- city_and_country:

  City and country where the institution is located, formatted as
  `"City, Country"` (e.g. `"New York, United States of America"`).

- synonyms_notes:

  Alternative or historical names by which the collection has been known
  in the synonymic literature (e.g. `"British Museum (Natural History)"`
  for `BM`, `"United States National Museum"` for `USNM`); `NA` when no
  alternative name is recorded.

- online_website_database_if_available:

  URL to the institution's online specimen database or collection
  portal, when publicly available; `NA` when no online resource has been
  identified.

## Source

Mammal Diversity Database release archive
(<https://www.mammaldiversity.org>), distributed as
`TypeSpecimenMetadata_...csv` within each versioned release.

## Details

This table serves as a lookup reference linking collection abbreviations
used throughout `mdd_synonyms` to their full institutional names,
geographic locations, and online portals. It covers 138 institutions
spanning all major zoogeographic regions, from large international
collections such as AMNH, MNHN, and USNM to regional and national
natural history museums in Latin America, Asia, Africa, and Oceania.

The `synonyms_notes` column documents historical or colloquial
collection names that may appear in older taxonomic literature, aiding
users who encounter non-standard abbreviations in pre-MDD sources.
Notable examples include `BM` (formerly *British Museum (Natural
History)*), `MCZ` (*Museum of Comparative Zoology, Harvard*), and `ZMA`
(*Zoölogisch Museum, Amsterdam*, merged with RMNH in 2010).

URLs in `online_website_database_if_available` link directly to
mammalogy or specimen-search pages where possible, and to general
institutional pages otherwise. Link availability and validity may change
over time.
