# Package index

## Package overview and data

Package-level documentation, packaged datasets, and helpers for loading
or citing MDD data.

- [`rmdd`](https://paulesantos.github.io/rmdd/reference/rmdd-package.md)
  [`rmdd-package`](https://paulesantos.github.io/rmdd/reference/rmdd-package.md)
  : rmdd: Mammal Diversity Database Tools
- [`mdd_download()`](https://paulesantos.github.io/rmdd/reference/mdd_download.md)
  **\[stable\]** : Download a Mammal Diversity Database file
- [`mdd_load()`](https://paulesantos.github.io/rmdd/reference/mdd_load.md)
  **\[stable\]** : Load an MDD comma-separated export
- [`mdd_cache_dir()`](https://paulesantos.github.io/rmdd/reference/mdd_cache_dir.md)
  **\[stable\]** : Return the default rmdd cache directory
- [`mdd_reference()`](https://paulesantos.github.io/rmdd/reference/mdd_reference.md)
  **\[stable\]** : Reference citations for the Mammal Diversity Database
- [`mdd_checklist`](https://paulesantos.github.io/rmdd/reference/mdd_checklist.md)
  : Current Mammal Diversity Database checklist
- [`mdd_synonyms`](https://paulesantos.github.io/rmdd/reference/mdd_synonyms.md)
  : Mammal Diversity Database synonym table
- [`mdd_type_specimen_metadata`](https://paulesantos.github.io/rmdd/reference/mdd_type_specimen_metadata.md)
  : Mammal Diversity Database type specimen metadata
- [`mdd_checklist_records()`](https://paulesantos.github.io/rmdd/reference/mdd_checklist_records.md)
  **\[stable\]** : Return checklist records in a normalized tibble
- [`mdd_synonym_records()`](https://paulesantos.github.io/rmdd/reference/mdd_synonym_records.md)
  **\[stable\]** : Return synonym records in a normalized tibble
- [`mdd_release_records()`](https://paulesantos.github.io/rmdd/reference/mdd_release_records.md)
  **\[stable\]** : Return release records used by rmdd

## Name parsing and reconciliation

Tools for parsing mammal names and resolving them against accepted
names, synonyms, and original combinations in MDD.

- [`classify_mammal_names()`](https://paulesantos.github.io/rmdd/reference/classify_mammal_names.md)
  **\[experimental\]** : Classify mammal scientific names into taxonomic
  components
- [`build_mdd_match_backbone()`](https://paulesantos.github.io/rmdd/reference/build_mdd_match_backbone.md)
  **\[experimental\]** : Build an MDD reconciliation backbone
- [`mdd_name_index()`](https://paulesantos.github.io/rmdd/reference/mdd_name_index.md)
  **\[experimental\]** : Build a normalized MDD name index
- [`mdd_matching()`](https://paulesantos.github.io/rmdd/reference/mdd_matching.md)
  **\[experimental\]** : Reconcile mammal names against MDD

## Taxon retrieval

Functions for retrieving structured accepted-taxon summaries and
detailed taxon records.

- [`mdd_taxon_record()`](https://paulesantos.github.io/rmdd/reference/mdd_taxon_record.md)
  **\[experimental\]** : Retrieve a normalized MDD taxon record
- [`mdd_taxon_info()`](https://paulesantos.github.io/rmdd/reference/mdd_taxon_info.md)
  **\[experimental\]** : Retrieve structured MDD taxon information by
  name

## Distribution and mapping

Functions for summarizing and mapping MDD geographic distribution data.

- [`mdd_distribution_summary_raw()`](https://paulesantos.github.io/rmdd/reference/mdd_distribution_summary_raw.md)
  **\[experimental\]** : Summarize mammal diversity by country,
  continent, or subregion
- [`mdd_distribution_summary()`](https://paulesantos.github.io/rmdd/reference/mdd_distribution_summary.md)
  **\[experimental\]** : Summarize mammal diversity by country,
  continent, or subregion
- [`mdd_distribution_map()`](https://paulesantos.github.io/rmdd/reference/mdd_distribution_map.md)
  **\[experimental\]** : Generate a distribution map from MDD country
  distributions

## S3 methods

Printing and coercion helpers for rmdd objects.

- [`print(`*`<mdd_reference>`*`)`](https://paulesantos.github.io/rmdd/reference/print.mdd_reference.md)
  : Print mdd_reference object
- [`print(`*`<mdd_taxon_info>`*`)`](https://paulesantos.github.io/rmdd/reference/print.mdd_taxon_info.md)
  : Print mdd_taxon_info object
- [`as.list(`*`<mdd_taxon_info>`*`)`](https://paulesantos.github.io/rmdd/reference/as.list.mdd_taxon_info.md)
  : Convert mdd_taxon_info to list
