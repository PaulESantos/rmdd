# Mammal Diversity Database synonym table

Synonymy and nomenclatural table from the Mammal Diversity Database
(MDD), covering all names applicable to species- and subspecies-level
mammal taxa within Class Mammalia. Designed to align with the online
nomenclature database Hesperomys (<https://hesperomys.com>).

## Usage

``` r
mdd_synonyms
```

## Format

A tibble with 44 variables in the MDD v2.4 release, with source column
names normalized to `snake_case` during data import. Variables and their
original naming equivalents:

- mdd_syn_id:

  (`MDD_syn_ID`) Unique MDD synonym identification number assigned to
  each synonym, starting from `100000001` and incrementing as new
  synonyms are added.

- mdd_species:

  (`MDD_species`) Genus and specific epithet of the accepted species to
  which this synonym is assigned, with a space between the two elements;
  listed as `"genus incertae_sedis"` or
  `"incertae_sedis incertae_sedis"` for nomina dubia, nomina inquirenda,
  and names based on composite or hybrid type material.

- mdd_species_id:

  (`MDD_species_id`) Identification number of the accepted species as
  listed in `mdd_checklist` (the `MDD_Current` sheet).

- hesp_id:

  (`Hesp_id`) Identification number of the matching entry in the
  Hesperomys nomenclature database (<https://hesperomys.com>), used to
  link and synchronise data between MDD and Hesperomys.

- mdd_root_name:

  (`MDD_root_name`) Specific epithet used as the root to form a valid
  taxon name; spelling is adjusted to match generic gender when the
  epithet is an adjective, or Latinised when originally written in
  non-Latin characters.

- mdd_author:

  (`MDD_author`) Author surname(s) of the original description,
  following the same formatting conventions as
  `authority_species_author` in `mdd_checklist`: all authors on the
  author line are included; Oxford comma before the last name when three
  or more authors are present; an `"in"` statement is added when the
  work appears in a volume with different editors; shared surnames are
  disambiguated by initials or full middle names; Chinese, Korean, and
  Indochinese names are written with surname first and hyphens removed.

- mdd_year:

  (`MDD_year`) Year of the original description as given in the original
  publication.

- mdd_authority_parentheses:

  (`MDD_authority_parentheses`) Parenthesis flag: `0` = no parentheses;
  `1` = authority in parentheses (indicating the species was originally
  described under a different genus).

- mdd_nomenclature_status:

  (`MDD_nomenclature_status`) Nomenclatural status of the name under the
  ICZN Code; indicates whether the name is available, a spelling
  variant, a name combination, or unavailable (with the specific reason
  given); see `Nomenclature_Taxonomy_Metadata` in the MDD spreadsheet
  for full value definitions.

- mdd_validity:

  (`MDD_validity`) Taxonomic status of the name under the ICZN Code and
  primary literature; indicates whether the name is a valid species or
  subspecies, or is a nomen dubium, nomen inquirendum, or based on
  composite or hybrid type material; see
  `Nomenclature_Taxonomy_Metadata` for full value definitions.

- mdd_original_combination:

  (`MDD_original_combination`) Name combination exactly as it appears in
  the original description; all parts of the scientific name are written
  in full even if abbreviated in the source.

- mdd_original_rank:

  (`MDD_original_rank`) Taxonomic rank at which the name was first
  described; one of `"species"`, `"subspecies"`, `"form"`, `"variety"`,
  `"infrasubspecific"`, `"unranked"`, `"synonym"`, or `"other"`.

- mdd_authority_citation:

  (`MDD_authority_citation`) Full APA citation of the original
  description, including specific month and day of publication when
  known; populated only when the MDD team has verified the citation by
  obtaining a PDF or physical copy.

- mdd_unchecked_authority_citation:

  (`MDD_unchecked_authority_citation`) Unverified original description
  citation in non-standardised format, often abbreviated from regional
  or global taxonomic compendia; set to `NA` once
  `mdd_authority_citation` is filled.

- mdd_sourced_unverified_citations:

  (`MDD_sourced_unverified_citations`) Same as
  `mdd_unchecked_authority_citation` but includes the sources from which
  the citation was obtained; retained as an internal reference for the
  MDD team.

- mdd_citation_group:

  (`MDD_citation_group`) Journal name or city of publication (for books)
  of the original description; used internally by the MDD team when
  locating citation materials.

- mdd_citation_kind:

  (`MDD_citation_kind`) Whether the MDD team holds a physical,
  electronic, or no copy of the original description; used internally by
  the MDD team.

- mdd_authority_page:

  (`MDD_authority_page`) Page number where the scientific name first
  appears in the original description; special cases (footnotes,
  unnumbered pages, figures, plates) are noted in parentheses.

- mdd_authority_link:

  (`MDD_authority_link`) URL to an online copy of the original
  description; older publications link to the Biodiversity Heritage
  Library or other archives; newer publications use a DOI.

- mdd_authority_page_link:

  (`MDD_authority_page_link`) URL to the exact first page where the name
  appears in an online copy; primarily applicable to records in the
  Biodiversity Heritage Library, HathiTrust, Gallica, or the Internet
  Archive.

- mdd_unchecked_authority_page_link:

  (`MDD_unchecked_authority_page_link`) Candidate page links identified
  programmatically from the Biodiversity Heritage Library but not yet
  manually verified for inclusion of the name; multiple links separated
  by `|`.

- mdd_old_type_locality:

  (`MDD_old_type_locality`) Type locality as it appeared in the MDD
  synonym sheet before harmonisation with Hesperomys; retained for
  internal reference only — not for general use.

- mdd_original_type_locality:

  (`MDD_original_type_locality`) Verbatim type locality transcribed from
  the original description and verified by the MDD team; blank when a
  type locality is not applicable.

- mdd_unchecked_type_locality:

  (`MDD_unchecked_type_locality`) Verbatim type locality from
  non-original sources, with source attribution appended; multiple
  entries from different sources separated by `|`; blank when not
  applicable.

- mdd_emended_type_locality:

  (`MDD_emended_type_locality`) Verbatim emended type locality from
  sources making a restriction, emendation, or declaration, followed by
  the reference; **currently empty — reserved for future curation**;
  blank when not applicable.

- mdd_type_latitude:

  (`MDD_type_latitude`) Latitude of the type locality in decimal
  degrees; georeferenced from the original description or via web search
  / GeoLocate; blank when not applicable.

- mdd_type_longitude:

  (`MDD_type_longitude`) Longitude of the type locality in decimal
  degrees; sourced as for `mdd_type_latitude`; blank when not
  applicable.

- mdd_type_country:

  (`MDD_type_country`) Modern country containing the type locality; see
  `Distribution_List` in the MDD spreadsheet for the full list of
  country names used; blank when not applicable.

- mdd_type_subregion:

  (`MDD_type_subregion`) First-level subnational unit containing the
  type locality (state, province, territory, or island group for larger
  countries); blank when not applicable.

- mdd_type_subregion2:

  (`MDD_type_subregion2`) Second-level subnational unit within
  `mdd_type_subregion`; primarily US counties and individual islands
  within archipelagoes; blank when not applicable.

- mdd_holotype:

  (`MDD_holotype`) Museum catalogue number(s) of the type series
  (holotype, syntypes, lectotype, or neotype); multiple syntypes are
  comma-separated; blank when type material has not been verified.

- mdd_type_kind:

  (`MDD_type_kind`) Category of type specimen listed in `mdd_holotype`:
  one of `"holotype"`, `"syntypes"`, `"lectotype"`, `"neotype"`, or
  `"nonexistent"` (confirmed absence of type material); blank when
  existence of type material has not been verified.

- mdd_type_specimen_link:

  (`MDD_type_specimen_link`) URL(s) to type material records in external
  museum collection databases.

- mdd_order:

  (`MDD_order`) Taxonomic order; `"incertae_sedis"` when not assigned to
  an order.

- mdd_family:

  (`MDD_family`) Taxonomic family; `"incertae_sedis"` when not assigned
  to a family.

- mdd_genus:

  (`MDD_genus`) Taxonomic genus; `"incertae_sedis"` when not assigned to
  a genus.

- mdd_specific_epithet:

  (`MDD_specificEpithet`) Specific epithet of the accepted species;
  `"incertae_sedis"` when not assigned to a species.

- mdd_subspecific_epithet:

  (`MDD_subspecificEpithet`) Subspecific epithet of the accepted
  subspecies; blank when no subspecies are recognised within the
  species. **Note:** this field currently contains a tentative, unvetted
  subspecies list — assignments are incomplete and subject to revision.

- mdd_variant_of:

  (`MDD_variant_of`) For spelling variants and name combinations, the
  name they are a variant of, given with its original name combination,
  authority, and MDD synonym ID.

- mdd_senior_homonym:

  (`MDD_senior_homonym`) For preoccupied names (primary or secondary
  homonymy), the senior homonym that preoccupies the name, given with
  its original name combination, authority, and MDD synonym ID.

- mdd_name_usages:

  (`MDD_name_usages`) Later citations using the exact spelling of the
  name as given in `mdd_original_combination`; each citation is
  abbreviated to authors, year, and page number.

- mdd_comments:

  (`MDD_comments`) Free-text comments on the nomenclature or taxonomy of
  the name.

## Source

Mammal Diversity Database release archive
(<https://www.mammaldiversity.org>). Field definitions are derived from
the `META_v2.4.csv` file and the column-level annotations in the
`Species_Syn_Current` sheet of the official MDD spreadsheet.

## Details

This table covers every name — valid, synonymised, or otherwise — that
has been applied to a species- or subspecies-level mammal taxon and is
recognised by the MDD. It serves as the primary nomenclatural backbone
for the checklist in `mdd_checklist` and is designed to interoperate
with the Hesperomys database (<https://hesperomys.com>) via `hesp_id`.

Column names have been normalised from the original mixed-case
convention (`MDD_syn_ID`, `MDD_specificEpithet`, etc.) to `snake_case`
during data import; the original names are shown in parentheses in each
`\item` above for cross-reference with the upstream spreadsheet.

Citation verification follows a two-tier structure:
`mdd_authority_citation` holds APA-formatted, MDD-verified citations,
while `mdd_unchecked_authority_citation` holds unverified or abbreviated
citations from secondary sources and is set to `NA` once the verified
field is populated.

Several fields are retained for internal MDD team reference and should
not be used for analysis: `mdd_old_type_locality`,
`mdd_sourced_unverified_citations`, `mdd_citation_group`, and
`mdd_citation_kind`. The `mdd_emended_type_locality` and
`mdd_subspecific_epithet` fields are present but **not yet fully
curated**.
