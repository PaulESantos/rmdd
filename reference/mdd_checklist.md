# Current Mammal Diversity Database checklist

Current species-level checklist from the Mammal Diversity Database
(MDD).

## Usage

``` r
mdd_checklist
```

## Format

A tibble with 6,871 rows and 52 variables in the MDD v2.4 release, with
source column names normalized to `snake_case` during data import.
Variables and their original camelCase equivalents:

- sci_name:

  (`sciName`) Unique genus–epithet key joined by an underscore; derived
  programmatically from `genus` and `specific_epithet`.

- id:

  (`id`) Unique integer identifier used for indexing and permalinking.
  Initial batch (14 Sep 2020) was numbered from 1,000,001 upward when
  sorted by `phylosort`; subsequent additions start at 1,006,485.

- phylosort:

  (`phylosort`) Numeric sort key ordering the 27 extant mammal orders
  according to the phylogenetic hierarchy in Figure 1 of the
  *Illustrated Checklist of the Mammals of the World* (2020).

- main_common_name:

  (`mainCommonName`) Primary vernacular name following the *Handbook of
  the Mammals of the World* style conventions: all words capitalised
  except pre-hyphen elements; "and" constructions use hyphens (e.g.
  *Black-and-white Ruffed Lemur*); directional modifiers are not
  hyphenated (e.g. *Southwestern Myotis*).

- other_common_names:

  (`otherCommonNames`) Pipe-separated (`|`) list of additional
  vernacular names documented in the literature, following the same
  formatting rules as `main_common_name`; primarily English, but widely
  used names from other languages are occasionally included.

- subclass:

  (`subclass`) Taxonomic subclass; `NA` when not applicable.

- infraclass:

  (`infraclass`) Taxonomic infraclass; `NA` when not applicable.

- magnorder:

  (`magnorder`) Taxonomic magnorder; `NA` when not applicable.

- superorder:

  (`superorder`) Taxonomic superorder; `NA` when not applicable.

- order:

  (`order`) Taxonomic order; present for all taxa.

- suborder:

  (`suborder`) Taxonomic suborder; `NA` when not applicable;
  `"incertae sedis"` for taxa unassigned within an order that uses
  suborders.

- infraorder:

  (`infraorder`) Taxonomic infraorder; `NA` when not applicable;
  `"incertae sedis"` when applicable but unassigned.

- parvorder:

  (`parvorder`) Taxonomic parvorder; `NA` when not applicable;
  `"incertae sedis"` when applicable but unassigned.

- superfamily:

  (`superfamily`) Taxonomic superfamily; `NA` when not applicable;
  `"incertae sedis"` when applicable but unassigned.

- family:

  (`family`) Taxonomic family; present for all taxa.

- subfamily:

  (`subfamily`) Taxonomic subfamily; `NA` when not applicable;
  `"incertae sedis"` when applicable but unassigned.

- tribe:

  (`tribe`) Taxonomic tribe; `NA` when not applicable;
  `"incertae sedis"` when applicable but unassigned.

- subtribe:

  (`subtribe`) Taxonomic subtribe; `NA` when not applicable;
  `"incertae sedis"` when applicable but unassigned.

- genus:

  (`genus`) Taxonomic genus; present for all taxa.

- subgenus:

  (`subgenus`) Taxonomic subgenus; `NA` when not applicable;
  `"incertae sedis"` when applicable but unassigned.

- specific_epithet:

  (`specificEpithet`) Taxonomic species epithet.

- authority_species_author:

  (`authoritySpeciesAuthor`) Author surname(s) of the original species
  description, sourced from `Species_Syn_Current`; all authors on the
  author line are included, with an Oxford comma before the last name
  when three or more authors are present; an `"in"` statement is added
  when the work appears in a volume with different editors; shared
  surnames are disambiguated by initials or full middle names; Chinese,
  Korean, and Indochinese names are written out in full with surname
  first and hyphens removed.

- authority_species_year:

  (`authoritySpeciesYear`) Year of the original species description,
  sourced from `Species_Syn_Current`.

- authority_parentheses:

  (`authorityParentheses`) Parenthesis flag: `0` = no parentheses; `1` =
  authority in parentheses (indicating the species was originally
  described under a different genus).

- original_name_combination:

  (`originalNameCombination`) Name combination exactly as it appears in
  the original description, sourced from `Species_Syn_Current`.

- authority_species_citation:

  (`authoritySpeciesCitation`) Full or abbreviated literature citation
  for the authority publication; APA format when verified by PDF or
  physical copy, abbreviated otherwise.

- authority_species_link:

  (`authoritySpeciesLink`) URL to the authority publication or abstract
  page; Biodiversity Heritage Library page-level links are preferred
  when available; DOIs are used for recent publications.

- type_voucher:

  (`typeVoucher`) Museum catalogue number(s) of the type series
  (holotype, syntypes, lectotype, or neotype); blank when type material
  has not been verified; multiple syntypes are listed when applicable.

- type_kind:

  (`typeKind`) Category of type specimen listed in `type_voucher`: one
  of `"holotype"`, `"syntypes"`, `"lectotype"`, `"neotype"`, or
  `"nonexistent"` (the last value is used when the MDD team has
  confirmed no type material exists); blank when existence of type
  material has not been verified.

- type_voucher_ur_is:

  (`typeVoucherURIs`) Pipe-separated links to type material records in
  external museum collection databases.

- type_locality:

  (`typeLocality`) Geographic locality where the holotype was collected
  or observed; edited place names follow CMW 2020 and are updated to
  current taxonomy; format may not match `Species_Syn_Current` as
  standardisation is ongoing.

- type_locality_latitude:

  (`typeLocalityLatitude`) Latitude of the type locality in decimal
  degrees; sourced from the original description or via georeferencing
  (web search or GeoLocate).

- type_locality_longitude:

  (`typeLocalityLongitude`) Longitude of the type locality in decimal
  degrees; sourced as for `type_locality_latitude`.

- nominal_names:

  (`nominalNames`) Pipe-separated list of all available and unavailable
  specific epithets subsumed under the current species concept, each
  with authority and year; names originally described in a different
  genus are shown in parentheses; reasons for unavailability are noted
  in brackets; gender changes are also noted.

- taxonomy_notes:

  (`taxonomyNotes`) Semicolon-separated notes by MDD staff documenting
  taxonomic changes.

- taxonomy_notes_citation:

  (`taxonomyNotesCitation`) Pipe- separated APA citations supporting the
  changes described in `taxonomy_notes`.

- distribution_notes:

  (`distributionNotes`) Detailed distributional narrative including
  notes on recently introduced populations; uses abbreviations: Mt/Mts,
  I/Is, N, S, E, W, C, and combinations (e.g. NW). **Not currently
  curated — reserved for future use.**

- distribution_notes_citation:

  (`distributionNotesCitation`) Pipe-separated citations supporting
  `distribution_notes`. **Not currently curated — reserved for future
  use.**

- subregion_distribution:

  (`subregionDistribution`) Pipe- separated (`|`) list of countries with
  native or reintroduced extant populations; subnational regions
  (currently US states only) are appended in parentheses and
  comma-separated; uncertain or possibly extinct occurrences are marked
  with `?`.

- country_distribution:

  (`countryDistribution`) Pipe-separated list of countries where the
  species has a native or ancient (pre-1500 CE) introduced distribution;
  recent introductions are excluded; uncertain presences marked with
  `?`; domesticated species are listed as `"Domesticated"`; extinct
  species reflect their post-1500 CE range; marine species list coastal
  or riverine countries.

- continent_distribution:

  (`continentDistribution`) Pipe- separated list of continents following
  the same rules as `country_distribution`; recognised values: `Africa`,
  `Antarctica`, `Asia`, `Europe`, `North America`, `Oceania`,
  `South America`, `Domesticated`; continental boundaries follow
  MDD-specific definitions (e.g. Asia–Europe split at Ural/Caucasus Mts
  and Ural River; Oceania east of Weber's Line).

- biogeographic_realm:

  (`biogeographicRealm`) Pipe-separated list of biogeographic realms
  where the species occurs, following the same inclusion rules as
  `country_distribution`; realm boundaries follow the WWF schema
  (<https://en.wikipedia.org/wiki/Biogeographic_realm>).

- iucn_status:

  (`iucnStatus`) IUCN Red List status matched to MDD species and updated
  to current taxonomy (IUCN 2025-2 assessment); `"NE"` = not yet
  evaluated; standard IUCN acronyms otherwise; 19 domestic species are
  also not evaluated.

- extinct:

  (`extinct`) Extinction flag: `0` = extant; `1` = extinct after 1500 CE
  (following the IUCN criterion).

- domestic:

  (`domestic`) Domestication flag: `0` = wild; `1` = domesticated (19
  species including *Homo sapiens*); follows the nomenclatural
  guidelines of Gentry, Clutton-Brock & Groves (2004, *J. Archaeol.
  Sci.* 31(5): 645–651).

- flagged:

  (`flagged`) Taxonomic quality flag: `0` = valid; `1` = flagged as
  taxonomically questionable or actively debated in the literature.

- cmw_sci_name:

  (`CMW_sciName`) Genus–epithet key from the *Illustrated Checklist of
  the Mammals of the World* (CMW), formatted identically to `sci_name`.

- diff_since_cmw:

  (`diffSinceCMW`) CMW comparison flag: `0` = species present in CMW
  2020 taxonomy; `1` = species new since CMW 2020.

- msw3_matchtype:

  (`MSW3_matchtype`) Method by which the taxon was linked to MSW3: one
  of `"matched"`, `"unmatched"`, or `"manual"`.

- msw3_sci_name:

  (`MSW3_sciName`) Scientific name as matched to the MSW3 taxonomy.

- diff_since_msw3:

  (`diffSinceMSW3`) MSW3 comparison flag: `0` = species present in MSW3
  (~2004 cutoff); `1` = species new since MSW3.

## Source

Mammal Diversity Database release archive
(<https://www.mammaldiversity.org>). Field definitions are derived from
the `META_v2.4.csv` file and the column-level annotations in the
`MDD_Current` sheet of the official MDD spreadsheet.

## Details

The checklist is the primary tabular output of the MDD and covers all
extant and recently extinct (post-1500 CE) mammal species recognised by
the database curators. Column names have been normalised from the
original camelCase (`sciName`, `mainCommonName`, etc.) to `snake_case`
during data import; the original names are shown in parentheses in each
`\item` above for cross-reference with the upstream spreadsheet.

Distribution fields operate on three nested spatial scales:
`subregion_distribution` (subnational units, currently US states),
`country_distribution`, and `continent_distribution`. Multiple values
within each field are pipe-separated (`|`). Only native ranges and
ancient introductions (before 1500 CE) are included; `?` marks uncertain
or possibly extirpated occurrences.

The `distribution_notes` and `distribution_notes_citation` columns are
present in the data but are **not currently curated** and are reserved
for future use.

Cross-release comparison is provided by three column pairs:
`cmw_sci_name` / `diff_since_cmw` (vs. CMW 2020) and `msw3_sci_name` /
`msw3_matchtype` / `diff_since_msw3` (vs. MSW3, ~2004 cutoff).
