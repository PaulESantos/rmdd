if (getRversion() >= "2.15.1") {
  utils::globalVariables(c(
    ".cand_len", ".data", ".dedup_key", ".orig_len", ".row_id",
    ".status_rank", "accepted_author", "accepted_genus", "accepted_id",
    "accepted_name", "accepted_species", "atlas_name", "author",
    "authority_species_author", "direct_match",
    "direct_match_species_within_genus", "fuzzy_genus_dist",
    "fuzzy_match_genus", "fuzzy_match_species_within_genus",
    "fuzzy_species_dist", "genus", "genus_match", "id", "input_index",
    "input_name", "is_accepted_name", "match_stage", "matched_author",
    "matched_genus", "matched_name", "matched_name_id", "mdd_author",
    "mdd_nomenclature_status", "mdd_original_combination",
    "mdd_species_id", "mdd_syn_id", "mdd_validity", "n", "name",
    "orig_genus", "orig_name", "orig_species", "query_genus",
    "query_name", "query_name_clean", "query_species", "sorter",
    "species", "specific_epithet", "status_rank", "taxon_status",
    "Genus", "Orig.Genus", "Orig.Species", "Species"
  ))
}
