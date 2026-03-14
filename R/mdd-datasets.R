#' Current Mammal Diversity Database checklist
#'
#' Current species-level checklist from the Mammal Diversity Database (MDD).
#'
#' @format A tibble with 6,871 rows and 52 variables in the MDD v2.4 release,
#' with source column names normalized to `snake_case` during data import.
#' Variables and their original camelCase equivalents:
#'
#' \describe{
#'   \item{sci_name}{(`sciName`) Unique genus–epithet key joined by an
#'     underscore; derived programmatically from `genus` and
#'     `specific_epithet`.}
#'   \item{id}{(`id`) Unique integer identifier used for indexing and
#'     permalinking. Initial batch (14 Sep 2020) was numbered from
#'     1,000,001 upward when sorted by `phylosort`; subsequent additions
#'     start at 1,006,485.}
#'   \item{phylosort}{(`phylosort`) Numeric sort key ordering the 27
#'     extant mammal orders according to the phylogenetic hierarchy in
#'     Figure 1 of the *Illustrated Checklist of the Mammals of the
#'     World* (2020).}
#'   \item{main_common_name}{(`mainCommonName`) Primary vernacular name
#'     following the *Handbook of the Mammals of the World* style
#'     conventions: all words capitalised except pre-hyphen elements;
#'     "and" constructions use hyphens (e.g. *Black-and-white Ruffed
#'     Lemur*); directional modifiers are not hyphenated (e.g.
#'     *Southwestern Myotis*).}
#'   \item{other_common_names}{(`otherCommonNames`) Pipe-separated (`|`)
#'     list of additional vernacular names documented in the literature,
#'     following the same formatting rules as `main_common_name`;
#'     primarily English, but widely used names from other languages are
#'     occasionally included.}
#'   \item{subclass}{(`subclass`) Taxonomic subclass; `NA` when not
#'     applicable.}
#'   \item{infraclass}{(`infraclass`) Taxonomic infraclass; `NA` when
#'     not applicable.}
#'   \item{magnorder}{(`magnorder`) Taxonomic magnorder; `NA` when not
#'     applicable.}
#'   \item{superorder}{(`superorder`) Taxonomic superorder; `NA` when
#'     not applicable.}
#'   \item{order}{(`order`) Taxonomic order; present for all taxa.}
#'   \item{suborder}{(`suborder`) Taxonomic suborder; `NA` when not
#'     applicable; `"incertae sedis"` for taxa unassigned within an
#'     order that uses suborders.}
#'   \item{infraorder}{(`infraorder`) Taxonomic infraorder; `NA` when
#'     not applicable; `"incertae sedis"` when applicable but
#'     unassigned.}
#'   \item{parvorder}{(`parvorder`) Taxonomic parvorder; `NA` when not
#'     applicable; `"incertae sedis"` when applicable but unassigned.}
#'   \item{superfamily}{(`superfamily`) Taxonomic superfamily; `NA` when
#'     not applicable; `"incertae sedis"` when applicable but
#'     unassigned.}
#'   \item{family}{(`family`) Taxonomic family; present for all taxa.}
#'   \item{subfamily}{(`subfamily`) Taxonomic subfamily; `NA` when not
#'     applicable; `"incertae sedis"` when applicable but unassigned.}
#'   \item{tribe}{(`tribe`) Taxonomic tribe; `NA` when not applicable;
#'     `"incertae sedis"` when applicable but unassigned.}
#'   \item{subtribe}{(`subtribe`) Taxonomic subtribe; `NA` when not
#'     applicable; `"incertae sedis"` when applicable but unassigned.}
#'   \item{genus}{(`genus`) Taxonomic genus; present for all taxa.}
#'   \item{subgenus}{(`subgenus`) Taxonomic subgenus; `NA` when not
#'     applicable; `"incertae sedis"` when applicable but unassigned.}
#'   \item{specific_epithet}{(`specificEpithet`) Taxonomic species
#'     epithet.}
#'   \item{authority_species_author}{(`authoritySpeciesAuthor`) Author
#'     surname(s) of the original species description, sourced from
#'     `Species_Syn_Current`; all authors on the author line are
#'     included, with an Oxford comma before the last name when three or
#'     more authors are present; an `"in"` statement is added when the
#'     work appears in a volume with different editors; shared surnames
#'     are disambiguated by initials or full middle names; Chinese,
#'     Korean, and Indochinese names are written out in full with surname
#'     first and hyphens removed.}
#'   \item{authority_species_year}{(`authoritySpeciesYear`) Year of the
#'     original species description, sourced from
#'     `Species_Syn_Current`.}
#'   \item{authority_parentheses}{(`authorityParentheses`) Parenthesis
#'     flag: `0` = no parentheses; `1` = authority in parentheses
#'     (indicating the species was originally described under a
#'     different genus).}
#'   \item{original_name_combination}{(`originalNameCombination`) Name
#'     combination exactly as it appears in the original description,
#'     sourced from `Species_Syn_Current`.}
#'   \item{authority_species_citation}{(`authoritySpeciesCitation`) Full
#'     or abbreviated literature citation for the authority publication;
#'     APA format when verified by PDF or physical copy, abbreviated
#'     otherwise.}
#'   \item{authority_species_link}{(`authoritySpeciesLink`) URL to the
#'     authority publication or abstract page; Biodiversity Heritage
#'     Library page-level links are preferred when available; DOIs are
#'     used for recent publications.}
#'   \item{type_voucher}{(`typeVoucher`) Museum catalogue number(s) of
#'     the type series (holotype, syntypes, lectotype, or neotype);
#'     blank when type material has not been verified; multiple syntypes
#'     are listed when applicable.}
#'   \item{type_kind}{(`typeKind`) Category of type specimen listed in
#'     `type_voucher`: one of `"holotype"`, `"syntypes"`,
#'     `"lectotype"`, `"neotype"`, or `"nonexistent"` (the last value
#'     is used when the MDD team has confirmed no type material exists);
#'     blank when existence of type material has not been verified.}
#'   \item{type_voucher_ur_is}{(`typeVoucherURIs`) Pipe-separated links
#'     to type material records in external museum collection
#'     databases.}
#'   \item{type_locality}{(`typeLocality`) Geographic locality where the
#'     holotype was collected or observed; edited place names follow CMW
#'     2020 and are updated to current taxonomy; format may not match
#'     `Species_Syn_Current` as standardisation is ongoing.}
#'   \item{type_locality_latitude}{(`typeLocalityLatitude`) Latitude of
#'     the type locality in decimal degrees; sourced from the original
#'     description or via georeferencing (web search or GeoLocate).}
#'   \item{type_locality_longitude}{(`typeLocalityLongitude`) Longitude
#'     of the type locality in decimal degrees; sourced as for
#'     `type_locality_latitude`.}
#'   \item{nominal_names}{(`nominalNames`) Pipe-separated list of all
#'     available and unavailable specific epithets subsumed under the
#'     current species concept, each with authority and year; names
#'     originally described in a different genus are shown in
#'     parentheses; reasons for unavailability are noted in brackets;
#'     gender changes are also noted.}
#'   \item{taxonomy_notes}{(`taxonomyNotes`) Semicolon-separated notes
#'     by MDD staff documenting taxonomic changes.}
#'   \item{taxonomy_notes_citation}{(`taxonomyNotesCitation`) Pipe-
#'     separated APA citations supporting the changes described in
#'     `taxonomy_notes`.}
#'   \item{distribution_notes}{(`distributionNotes`) Detailed
#'     distributional narrative including notes on recently introduced
#'     populations; uses abbreviations: Mt/Mts, I/Is, N, S, E, W, C,
#'     and combinations (e.g. NW). **Not currently curated — reserved
#'     for future use.**}
#'   \item{distribution_notes_citation}{(`distributionNotesCitation`)
#'     Pipe-separated citations supporting `distribution_notes`.
#'     **Not currently curated — reserved for future use.**}
#'   \item{subregion_distribution}{(`subregionDistribution`) Pipe-
#'     separated (`|`) list of countries with native or reintroduced
#'     extant populations; subnational regions (currently US states only)
#'     are appended in parentheses and comma-separated; uncertain or
#'     possibly extinct occurrences are marked with `?`.}
#'   \item{country_distribution}{(`countryDistribution`) Pipe-separated
#'     list of countries where the species has a native or ancient
#'     (pre-1500 CE) introduced distribution; recent introductions are
#'     excluded; uncertain presences marked with `?`; domesticated
#'     species are listed as `"Domesticated"`; extinct species reflect
#'     their post-1500 CE range; marine species list coastal or
#'     riverine countries.}
#'   \item{continent_distribution}{(`continentDistribution`) Pipe-
#'     separated list of continents following the same rules as
#'     `country_distribution`; recognised values: `Africa`, `Antarctica`,
#'     `Asia`, `Europe`, `North America`, `Oceania`, `South America`,
#'     `Domesticated`; continental boundaries follow MDD-specific
#'     definitions (e.g. Asia–Europe split at Ural/Caucasus Mts and
#'     Ural River; Oceania east of Weber's Line).}
#'   \item{biogeographic_realm}{(`biogeographicRealm`) Pipe-separated
#'     list of biogeographic realms where the species occurs, following
#'     the same inclusion rules as `country_distribution`; realm
#'     boundaries follow the WWF schema
#'     (\url{https://en.wikipedia.org/wiki/Biogeographic_realm}).}
#'   \item{iucn_status}{(`iucnStatus`) IUCN Red List status matched to
#'     MDD species and updated to current taxonomy (IUCN 2025-2
#'     assessment); `"NE"` = not yet evaluated; standard IUCN acronyms
#'     otherwise; 19 domestic species are also not evaluated.}
#'   \item{extinct}{(`extinct`) Extinction flag: `0` = extant;
#'     `1` = extinct after 1500 CE (following the IUCN criterion).}
#'   \item{domestic}{(`domestic`) Domestication flag: `0` = wild;
#'     `1` = domesticated (19 species including *Homo sapiens*);
#'     follows the nomenclatural guidelines of Gentry, Clutton-Brock &
#'     Groves (2004, *J. Archaeol. Sci.* 31(5): 645–651).}
#'   \item{flagged}{(`flagged`) Taxonomic quality flag: `0` = valid;
#'     `1` = flagged as taxonomically questionable or actively debated
#'     in the literature.}
#'   \item{cmw_sci_name}{(`CMW_sciName`) Genus–epithet key from the
#'     *Illustrated Checklist of the Mammals of the World* (CMW),
#'     formatted identically to `sci_name`.}
#'   \item{diff_since_cmw}{(`diffSinceCMW`) CMW comparison flag:
#'     `0` = species present in CMW 2020 taxonomy;
#'     `1` = species new since CMW 2020.}
#'   \item{msw3_matchtype}{(`MSW3_matchtype`) Method by which the taxon
#'     was linked to MSW3: one of `"matched"`, `"unmatched"`, or
#'     `"manual"`.}
#'   \item{msw3_sci_name}{(`MSW3_sciName`) Scientific name as matched
#'     to the MSW3 taxonomy.}
#'   \item{diff_since_msw3}{(`diffSinceMSW3`) MSW3 comparison flag:
#'     `0` = species present in MSW3 (~2004 cutoff);
#'     `1` = species new since MSW3.}
#' }
#'
#' @details
#' The checklist is the primary tabular output of the MDD and covers all
#' extant and recently extinct (post-1500 CE) mammal species recognised
#' by the database curators. Column names have been normalised from the
#' original camelCase (`sciName`, `mainCommonName`, etc.) to `snake_case`
#' during data import; the original names are shown in parentheses in
#' each `\item` above for cross-reference with the upstream spreadsheet.
#'
#' Distribution fields operate on three nested spatial scales:
#' `subregion_distribution` (subnational units, currently US states),
#' `country_distribution`, and `continent_distribution`. Multiple values
#' within each field are pipe-separated (`|`). Only native ranges and
#' ancient introductions (before 1500 CE) are included; `?` marks
#' uncertain or possibly extirpated occurrences.
#'
#' The `distribution_notes` and `distribution_notes_citation` columns
#' are present in the data but are **not currently curated** and are
#' reserved for future use.
#'
#' Cross-release comparison is provided by three column pairs:
#' `cmw_sci_name` / `diff_since_cmw` (vs. CMW 2020) and
#' `msw3_sci_name` / `msw3_matchtype` / `diff_since_msw3`
#' (vs. MSW3, ~2004 cutoff).
#'
#' @source
#' Mammal Diversity Database release archive
#' (\url{https://www.mammaldiversity.org}). Field definitions are derived
#' from the `META_v2.4.csv` file and the column-level annotations in the
#' `MDD_Current` sheet of the official MDD spreadsheet.
"mdd_checklist"

#' Mammal Diversity Database synonym table
#'
#' Synonymy and nomenclatural table from the Mammal Diversity Database (MDD),
#' covering all names applicable to species- and subspecies-level mammal taxa
#' within Class Mammalia. Designed to align with the online nomenclature
#' database Hesperomys (\url{https://hesperomys.com}).
#'
#' @format A tibble with 44 variables in the MDD v2.4 release, with source
#' column names normalized to `snake_case` during data import.
#' Variables and their original naming equivalents:
#'
#' \describe{
#'
#'   \item{mdd_syn_id}{(`MDD_syn_ID`) Unique MDD synonym identification
#'     number assigned to each synonym, starting from `100000001` and
#'     incrementing as new synonyms are added.}
#'   \item{mdd_species}{(`MDD_species`) Genus and specific epithet of the
#'     accepted species to which this synonym is assigned, with a space
#'     between the two elements; listed as `"genus incertae_sedis"` or
#'     `"incertae_sedis incertae_sedis"` for nomina dubia, nomina
#'     inquirenda, and names based on composite or hybrid type material.}
#'   \item{mdd_species_id}{(`MDD_species_id`) Identification number of the
#'     accepted species as listed in `mdd_checklist` (the `MDD_Current`
#'     sheet).}
#'   \item{hesp_id}{(`Hesp_id`) Identification number of the matching entry
#'     in the Hesperomys nomenclature database
#'     (\url{https://hesperomys.com}), used to link and synchronise data
#'     between MDD and Hesperomys.}
#'
#'   \item{mdd_root_name}{(`MDD_root_name`) Specific epithet used as the
#'     root to form a valid taxon name; spelling is adjusted to match
#'     generic gender when the epithet is an adjective, or Latinised when
#'     originally written in non-Latin characters.}
#'   \item{mdd_author}{(`MDD_author`) Author surname(s) of the original
#'     description, following the same formatting conventions as
#'     `authority_species_author` in `mdd_checklist`: all authors on the
#'     author line are included; Oxford comma before the last name when
#'     three or more authors are present; an `"in"` statement is added
#'     when the work appears in a volume with different editors; shared
#'     surnames are disambiguated by initials or full middle names; Chinese,
#'     Korean, and Indochinese names are written with surname first and
#'     hyphens removed.}
#'   \item{mdd_year}{(`MDD_year`) Year of the original description as given
#'     in the original publication.}
#'   \item{mdd_authority_parentheses}{(`MDD_authority_parentheses`)
#'     Parenthesis flag: `0` = no parentheses; `1` = authority in
#'     parentheses (indicating the species was originally described under a
#'     different genus).}
#'
#'   \item{mdd_nomenclature_status}{(`MDD_nomenclature_status`)
#'     Nomenclatural status of the name under the ICZN Code; indicates
#'     whether the name is available, a spelling variant, a name
#'     combination, or unavailable (with the specific reason given); see
#'     `Nomenclature_Taxonomy_Metadata` in the MDD spreadsheet for full
#'     value definitions.}
#'   \item{mdd_validity}{(`MDD_validity`) Taxonomic status of the name
#'     under the ICZN Code and primary literature; indicates whether the
#'     name is a valid species or subspecies, or is a nomen dubium, nomen
#'     inquirendum, or based on composite or hybrid type material; see
#'     `Nomenclature_Taxonomy_Metadata` for full value definitions.}
#'
#'   \item{mdd_original_combination}{(`MDD_original_combination`) Name
#'     combination exactly as it appears in the original description; all
#'     parts of the scientific name are written in full even if abbreviated
#'     in the source.}
#'   \item{mdd_original_rank}{(`MDD_original_rank`) Taxonomic rank at
#'     which the name was first described; one of `"species"`,
#'     `"subspecies"`, `"form"`, `"variety"`, `"infrasubspecific"`,
#'     `"unranked"`, `"synonym"`, or `"other"`.}
#'
#'   \item{mdd_authority_citation}{(`MDD_authority_citation`) Full APA
#'     citation of the original description, including specific month and
#'     day of publication when known; populated only when the MDD team has
#'     verified the citation by obtaining a PDF or physical copy.}
#'   \item{mdd_unchecked_authority_citation}{(`MDD_unchecked_authority_citation`)
#'     Unverified original description citation in non-standardised format,
#'     often abbreviated from regional or global taxonomic compendia; set
#'     to `NA` once `mdd_authority_citation` is filled.}
#'   \item{mdd_sourced_unverified_citations}{(`MDD_sourced_unverified_citations`)
#'     Same as `mdd_unchecked_authority_citation` but includes the sources
#'     from which the citation was obtained; retained as an internal
#'     reference for the MDD team.}
#'   \item{mdd_citation_group}{(`MDD_citation_group`) Journal name or city
#'     of publication (for books) of the original description; used
#'     internally by the MDD team when locating citation materials.}
#'   \item{mdd_citation_kind}{(`MDD_citation_kind`) Whether the MDD team
#'     holds a physical, electronic, or no copy of the original description;
#'     used internally by the MDD team.}
#'
#'   \item{mdd_authority_page}{(`MDD_authority_page`) Page number where the
#'     scientific name first appears in the original description; special
#'     cases (footnotes, unnumbered pages, figures, plates) are noted in
#'     parentheses.}
#'   \item{mdd_authority_link}{(`MDD_authority_link`) URL to an online copy
#'     of the original description; older publications link to the
#'     Biodiversity Heritage Library or other archives; newer publications
#'     use a DOI.}
#'   \item{mdd_authority_page_link}{(`MDD_authority_page_link`) URL to the
#'     exact first page where the name appears in an online copy; primarily
#'     applicable to records in the Biodiversity Heritage Library,
#'     HathiTrust, Gallica, or the Internet Archive.}
#'   \item{mdd_unchecked_authority_page_link}{(`MDD_unchecked_authority_page_link`)
#'     Candidate page links identified programmatically from the
#'     Biodiversity Heritage Library but not yet manually verified for
#'     inclusion of the name; multiple links separated by `|`.}
#'
#'   \item{mdd_old_type_locality}{(`MDD_old_type_locality`) Type locality
#'     as it appeared in the MDD synonym sheet before harmonisation with
#'     Hesperomys; retained for internal reference only — not for general
#'     use.}
#'   \item{mdd_original_type_locality}{(`MDD_original_type_locality`)
#'     Verbatim type locality transcribed from the original description and
#'     verified by the MDD team; blank when a type locality is not
#'     applicable.}
#'   \item{mdd_unchecked_type_locality}{(`MDD_unchecked_type_locality`)
#'     Verbatim type locality from non-original sources, with source
#'     attribution appended; multiple entries from different sources
#'     separated by `|`; blank when not applicable.}
#'   \item{mdd_emended_type_locality}{(`MDD_emended_type_locality`)
#'     Verbatim emended type locality from sources making a restriction,
#'     emendation, or declaration, followed by the reference; **currently
#'     empty — reserved for future curation**; blank when not applicable.}
#'   \item{mdd_type_latitude}{(`MDD_type_latitude`) Latitude of the type
#'     locality in decimal degrees; georeferenced from the original
#'     description or via web search / GeoLocate; blank when not
#'     applicable.}
#'   \item{mdd_type_longitude}{(`MDD_type_longitude`) Longitude of the
#'     type locality in decimal degrees; sourced as for
#'     `mdd_type_latitude`; blank when not applicable.}
#'   \item{mdd_type_country}{(`MDD_type_country`) Modern country
#'     containing the type locality; see `Distribution_List` in the MDD
#'     spreadsheet for the full list of country names used; blank when not
#'     applicable.}
#'   \item{mdd_type_subregion}{(`MDD_type_subregion`) First-level
#'     subnational unit containing the type locality (state, province,
#'     territory, or island group for larger countries); blank when not
#'     applicable.}
#'   \item{mdd_type_subregion2}{(`MDD_type_subregion2`) Second-level
#'     subnational unit within `mdd_type_subregion`; primarily US counties
#'     and individual islands within archipelagoes; blank when not
#'     applicable.}
#'
#'   \item{mdd_holotype}{(`MDD_holotype`) Museum catalogue number(s) of
#'     the type series (holotype, syntypes, lectotype, or neotype); multiple
#'     syntypes are comma-separated; blank when type material has not been
#'     verified.}
#'   \item{mdd_type_kind}{(`MDD_type_kind`) Category of type specimen
#'     listed in `mdd_holotype`: one of `"holotype"`, `"syntypes"`,
#'     `"lectotype"`, `"neotype"`, or `"nonexistent"` (confirmed absence
#'     of type material); blank when existence of type material has not
#'     been verified.}
#'   \item{mdd_type_specimen_link}{(`MDD_type_specimen_link`) URL(s) to
#'     type material records in external museum collection databases.}
#'
#'   \item{mdd_order}{(`MDD_order`) Taxonomic order; `"incertae_sedis"`
#'     when not assigned to an order.}
#'   \item{mdd_family}{(`MDD_family`) Taxonomic family; `"incertae_sedis"`
#'     when not assigned to a family.}
#'   \item{mdd_genus}{(`MDD_genus`) Taxonomic genus; `"incertae_sedis"`
#'     when not assigned to a genus.}
#'   \item{mdd_specific_epithet}{(`MDD_specificEpithet`) Specific epithet
#'     of the accepted species; `"incertae_sedis"` when not assigned to a
#'     species.}
#'   \item{mdd_subspecific_epithet}{(`MDD_subspecificEpithet`) Subspecific
#'     epithet of the accepted subspecies; blank when no subspecies are
#'     recognised within the species. **Note:** this field currently
#'     contains a tentative, unvetted subspecies list — assignments are
#'     incomplete and subject to revision.}
#'
#'   \item{mdd_variant_of}{(`MDD_variant_of`) For spelling variants and
#'     name combinations, the name they are a variant of, given with its
#'     original name combination, authority, and MDD synonym ID.}
#'   \item{mdd_senior_homonym}{(`MDD_senior_homonym`) For preoccupied
#'     names (primary or secondary homonymy), the senior homonym that
#'     preoccupies the name, given with its original name combination,
#'     authority, and MDD synonym ID.}
#'   \item{mdd_name_usages}{(`MDD_name_usages`) Later citations using the
#'     exact spelling of the name as given in `mdd_original_combination`;
#'     each citation is abbreviated to authors, year, and page number.}
#'
#'   \item{mdd_comments}{(`MDD_comments`) Free-text comments on the
#'     nomenclature or taxonomy of the name.}
#' }
#'
#' @details
#' This table covers every name — valid, synonymised, or otherwise — that
#' has been applied to a species- or subspecies-level mammal taxon and is
#' recognised by the MDD. It serves as the primary nomenclatural backbone
#' for the checklist in `mdd_checklist` and is designed to interoperate
#' with the Hesperomys database (\url{https://hesperomys.com}) via
#' `hesp_id`.
#'
#' Column names have been normalised from the original mixed-case convention
#' (`MDD_syn_ID`, `MDD_specificEpithet`, etc.) to `snake_case` during data
#' import; the original names are shown in parentheses in each `\item` above
#' for cross-reference with the upstream spreadsheet.
#'
#' Citation verification follows a two-tier structure: `mdd_authority_citation`
#' holds APA-formatted, MDD-verified citations, while
#' `mdd_unchecked_authority_citation` holds unverified or abbreviated
#' citations from secondary sources and is set to `NA` once the verified
#' field is populated.
#'
#' Several fields are retained for internal MDD team reference and should
#' not be used for analysis: `mdd_old_type_locality`,
#' `mdd_sourced_unverified_citations`, `mdd_citation_group`, and
#' `mdd_citation_kind`. The `mdd_emended_type_locality` and
#' `mdd_subspecific_epithet` fields are present but **not yet fully
#' curated**.
#'
#' @source
#' Mammal Diversity Database release archive
#' (\url{https://www.mammaldiversity.org}). Field definitions are derived
#' from the `META_v2.4.csv` file and the column-level annotations in the
#' `Species_Syn_Current` sheet of the official MDD spreadsheet.
"mdd_synonyms"

#' Mammal Diversity Database type specimen metadata
#'
#' Auxiliary reference table of natural history museum collection metadata
#' distributed with an MDD release. Each row corresponds to one institution
#' that holds or has held type material cited in the MDD synonym table
#' (`mdd_synonyms`).
#'
#' @format A tibble with 138 rows and 5 variables, with source column names
#' normalized to `snake_case` during data import:
#'
#' \describe{
#'   \item{abbreviation}{Standard acronym or abbreviation used to identify
#'     the collection in the MDD and broader taxonomic literature (e.g.
#'     `"AMNH"`, `"MNHN"`, `"USNM"`); corresponds to the collection codes
#'     cited in the `mdd_holotype` and `mdd_type_specimen_link` fields of
#'     `mdd_synonyms`.}
#'   \item{full_name}{Full official name of the institution or collection
#'     (e.g. `"American Museum of Natural History"`,
#'     `"Museum National d'Histoire Naturelle"`).}
#'   \item{city_and_country}{City and country where the institution is
#'     located, formatted as `"City, Country"` (e.g.
#'     `"New York, United States of America"`).}
#'   \item{synonyms_notes}{Alternative or historical names by which the
#'     collection has been known in the synonymic literature (e.g.
#'     `"British Museum (Natural History)"` for `BM`,
#'     `"United States National Museum"` for `USNM`); `NA` when no
#'     alternative name is recorded.}
#'   \item{online_website_database_if_available}{URL to the institution's
#'     online specimen database or collection portal, when publicly
#'     available; `NA` when no online resource has been identified.}
#' }
#'
#' @details
#' This table serves as a lookup reference linking collection abbreviations
#' used throughout `mdd_synonyms` to their full institutional names,
#' geographic locations, and online portals. It covers 138 institutions
#' spanning all major zoogeographic regions, from large international
#' collections such as AMNH, MNHN, and USNM to regional and national
#' natural history museums in Latin America, Asia, Africa, and Oceania.
#'
#' The `synonyms_notes` column documents historical or colloquial collection
#' names that may appear in older taxonomic literature, aiding users who
#' encounter non-standard abbreviations in pre-MDD sources. Notable examples
#' include `BM` (formerly *British Museum (Natural History)*), `MCZ`
#' (*Museum of Comparative Zoology, Harvard*), and `ZMA` (*Zoölogisch Museum,
#' Amsterdam*, merged with RMNH in 2010).
#'
#' URLs in `online_website_database_if_available` link directly to
#' mammalogy or specimen-search pages where possible, and to general
#' institutional pages otherwise. Link availability and validity may
#' change over time.
#'
#' @source
#' Mammal Diversity Database release archive
#' (\url{https://www.mammaldiversity.org}), distributed as
#' `TypeSpecimenMetadata_...csv` within each versioned release.
"mdd_type_specimen_metadata"
