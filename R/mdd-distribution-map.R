#' Generate a distribution map from MDD country distributions
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' This function is experimental and may change in future releases.
#'
#' Resolve a mammal name with [mdd_matching()] and map its
#' `country_distribution` values against an `rnaturalearth` countries layer.
#' The function preserves the package's exact vs partial input validation by
#' reporting whether the taxon input was matched directly or through a fuzzy
#' stage before plotting the accepted taxon distribution. Spatial polygons come
#' from Natural Earth through `rnaturalearth::ne_countries()`.
#'
#' @param name A single scientific name.
#' @param checklist Optional checklist data frame. Defaults to `mdd_checklist`.
#' @param synonyms Optional synonym data frame. Defaults to `mdd_synonyms`.
#' @param target_df Optional reconciliation backbone from
#'   [build_mdd_match_backbone()].
#' @param atlas Optional `sf` object with world country polygons. Defaults to
#'   `rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")`.
#' @param max_dist Maximum string distance used if the input name needs fuzzy
#'   reconciliation.
#' @param method Distance method passed to [mdd_matching()].
#' @param zoom Zoom mode. Use `"world"` for the full map, `"auto"` to zoom to
#'   the mapped distribution extent, or `"manual"` to use `xlim` and `ylim`.
#' @param xlim Optional longitude limits used when `zoom = "manual"`.
#' @param ylim Optional latitude limits used when `zoom = "manual"`.
#' @param quiet Logical. If `TRUE`, suppress `cli` progress messages.
#' @param title Optional plot title. Defaults to the accepted taxon name.
#' @param base_fill Fill color for non-selected countries.
#' @param dist_fill Fill color for mapped distribution units.
#' @param border_color Border color for mapped country outlines.
#' @param country_color Border color for non-selected country outlines.
#' @param ocean_fill Background color for the map panel.
#' @param plot_fill Background color for the full plot area.
#' @param graticule_color Color for graticule lines.
#' @param graticule_linewidth Line width for graticule lines.
#' @param graticule_alpha Alpha level for graticule lines.
#' @param country_linewidth Line width for non-selected country outlines.
#' @param dist_linewidth Line width for mapped country outlines.
#' @param title_color Color for the plot title.
#' @param title_size Size of the plot title.
#' @param title_face Font face for the plot title.
#'
#' @return A `ggplot2` map object. Additional metadata are attached in the
#'   `"mdd_distribution_info"` attribute.
#' @examples
#' if (interactive()) {
#'   mdd_distribution_map("Lama vicugna", quiet = TRUE)
#' }
#' @export
mdd_distribution_map <- function(
  name,
  checklist = NULL,
  synonyms = NULL,
  target_df = NULL,
  atlas = NULL,
  max_dist = 1,
  method = "osa",
  zoom = c("world", "auto", "manual"),
  xlim = NULL,
  ylim = NULL,
  quiet = FALSE,
  title = NULL,
  base_fill = "#E8E4DB",
  dist_fill = "#111111",
  border_color = "#111111",
  country_color = "#8B887F",
  ocean_fill = "#F7F4EE",
  plot_fill = "#F7F4EE",
  graticule_color = "#BBB5A8",
  graticule_linewidth = 0.18,
  graticule_alpha = 0.55,
  country_linewidth = 0.22,
  dist_linewidth = 0.34,
  title_color = "#111111",
  title_size = 16,
  title_face = "bold"
) {
  lifecycle::signal_stage("experimental", "mdd_distribution_map()")
  if (
    !is.character(name) ||
      length(name) != 1L ||
      is.na(name) ||
      !nzchar(stringr::str_squish(name))
  ) {
    cli::cli_abort(c(
      "{.arg name} must be a single non-empty character string.",
      "x" = "You supplied {.obj_type_friendly {name}}."
    ))
  }

  zoom <- match.arg(zoom)
  checklist <- checklist %||% .mdd_default_dataset("mdd_checklist")
  synonyms <- synonyms %||% .mdd_default_dataset("mdd_synonyms")
  atlas <- atlas %||% .mdd_default_world_sf()

  match_tbl <- mdd_matching(
    x = name,
    target_df = target_df,
    prefilter_genus = TRUE,
    allow_duplicates = TRUE,
    max_dist = max_dist,
    method = method
  )

  match_row <- tibble::as_tibble(match_tbl[1, , drop = FALSE])
  if (!isTRUE(match_row$matched[[1]])) {
    cli::cli_abort(c(
      "No MDD match found for {.val {name}}.",
      "i" = "Check the spelling or increase {.arg max_dist} if a partial match is expected."
    ))
  }

  accepted_id <- as.character(match_row$accepted_id[[1]])
  taxon_tbl <- checklist |>
    tibble::as_tibble() |>
    dplyr::filter(as.character(id) == accepted_id) |>
    dplyr::slice_head(n = 1)

  if (nrow(taxon_tbl) == 0) {
    cli::cli_abort(c(
      "Accepted taxon record not found in {.arg checklist}.",
      "x" = "Could not locate accepted id {.val {accepted_id}}."
    ))
  }

  country_value <- .mdd_tbl_get(taxon_tbl, "country_distribution")
  units_tbl <- .mdd_distribution_units(country_value)
  mapped_units <- .mdd_match_distribution_units(units_tbl, atlas)
  selected_names <- unique(stats::na.omit(mapped_units$atlas_name))

  if (length(selected_names) == 0) {
    cli::cli_abort(c(
      "No {.field country_distribution} units could be matched to the {.pkg rnaturalearth} layer.",
      "i" = "Inspect the attached distribution metadata to review unresolved place names."
    ))
  }

  selected_sf <- atlas |>
    dplyr::filter(name %in% selected_names)

  accepted_name <- as.character(match_row$accepted_name[[1]])
  matched_name <- as.character(match_row$matched_name[[1]])
  input_match <- .mdd_input_match_type(match_row)
  unresolved_units <- mapped_units |>
    dplyr::filter(is.na(atlas_name))
  zoom_info <- .mdd_map_zoom(selected_sf, zoom = zoom, xlim = xlim, ylim = ylim)

  if (!quiet) {
    .mdd_cli_distribution_summary(
      query = name,
      matched_name = matched_name,
      accepted_name = accepted_name,
      input_match = input_match,
      mapped_units = mapped_units,
      unresolved_units = unresolved_units,
      zoom_mode = zoom_info$mode
    )
  }

  graticule <- sf::st_graticule(
    lon = seq(-180, 180, by = 20),
    lat = seq(-80, 80, by = 10),
    crs = sf::st_crs(4326)
  )

  plot_title <- title %||% accepted_name

  plot_obj <- ggplot2::ggplot() +
    ggplot2::geom_sf(
      data = atlas,
      fill = base_fill,
      color = country_color,
      linewidth = country_linewidth
    ) +
    ggplot2::geom_sf(
      data = graticule,
      color = graticule_color,
      linewidth = graticule_linewidth,
      alpha = graticule_alpha
    ) +
    ggplot2::geom_sf(
      data = selected_sf,
      fill = dist_fill,
      color = border_color,
      linewidth = dist_linewidth
    ) +
    do.call(ggplot2::coord_sf, .mdd_coord_sf_args(zoom_info)) +
    ggplot2::labs(title = plot_title, subtitle = NULL, caption = NULL) +
    ggplot2::theme_void() +
    ggplot2::theme(
      legend.position = "none",
      plot.title = ggplot2::element_text(
        face = title_face,
        size = title_size,
        color = title_color,
        hjust = 0,
        margin = ggplot2::margin(b = 10)
      ),
      plot.background = ggplot2::element_rect(fill = plot_fill, color = NA),
      panel.background = ggplot2::element_rect(fill = ocean_fill, color = NA),
      panel.border = ggplot2::element_rect(color = NA, fill = NA),
      plot.margin = ggplot2::margin(14, 14, 14, 14)
    )

  attr(plot_obj, "mdd_distribution_info") <- list(
    query = name,
    matched_name = matched_name,
    accepted_name = accepted_name,
    accepted_id = accepted_id,
    input_match = input_match,
    zoom_mode = zoom_info$mode,
    xlim = zoom_info$xlim,
    ylim = zoom_info$ylim,
    match = match_row,
    taxon = taxon_tbl,
    units = mapped_units,
    mapped_sf = selected_sf,
    unresolved_units = unresolved_units
  )

  plot_obj
}

.mdd_default_world_sf <- function() {
  if (!requireNamespace("rnaturalearth", quietly = TRUE)) {
    cli::cli_abort(c(
      "{.pkg rnaturalearth} is required to build distribution maps.",
      "i" = "Install {.pkg rnaturalearth} to use {.fn mdd_distribution_map}."
    ))
  }

  if (!requireNamespace("rnaturalearthdata", quietly = TRUE)) {
    cli::cli_abort(c(
      "{.pkg rnaturalearthdata} is required to access Natural Earth polygons.",
      "i" = "Install {.pkg rnaturalearthdata} to use {.fn mdd_distribution_map}."
    ))
  }

  tryCatch(
    rnaturalearth::ne_countries(scale = "medium", returnclass = "sf"),
    error = function(cnd) {
      cli::cli_abort(c(
        "Could not load country polygons from {.pkg rnaturalearth}.",
        "x" = conditionMessage(cnd),
        "i" = "Install {.pkg rnaturalearth} and {.pkg rnaturalearthdata} to use {.fn mdd_distribution_map}."
      ))
    }
  )
}

.mdd_distribution_units <- function(country_value) {
  if (
    length(country_value) == 0 ||
      is.null(country_value) ||
      all(is.na(country_value))
  ) {
    cli::cli_abort(c(
      "The matched taxon does not contain {.field country_distribution} information.",
      "i" = "This taxon cannot be mapped with {.fn mdd_distribution_map}."
    ))
  }

  units <- unlist(
    strsplit(as.character(country_value[[1]]), "\\|"),
    use.names = FALSE
  )
  units <- trimws(units)
  units <- units[nzchar(units)]

  if (length(units) == 0) {
    cli::cli_abort(c(
      "The matched taxon does not contain parseable {.field country_distribution} values.",
      "i" = "Expected a pipe-delimited country list."
    ))
  }

  tibble::tibble(
    raw_country = units,
    clean_country = trimws(gsub("[?]+$", "", units)),
    uncertain = grepl("[?]+$", units),
    normalized_country = .mdd_normalize_place(trimws(gsub("[?]+$", "", units)))
  ) |>
    dplyr::distinct()
}

.mdd_match_distribution_units <- function(units_tbl, atlas) {
  atlas_lookup <- atlas |>
    sf::st_drop_geometry() |>
    dplyr::transmute(
      atlas_name = name,
      normalized_atlas = .mdd_normalize_place(name)
    ) |>
    dplyr::distinct()

  exact_name <- atlas_lookup$atlas_name[match(
    units_tbl$normalized_country,
    atlas_lookup$normalized_atlas
  )]
  alias_name <- .mdd_naturalearth_alias(units_tbl$normalized_country)
  resolved_name <- ifelse(!is.na(alias_name), alias_name, exact_name)

  dplyr::mutate(
    units_tbl,
    atlas_name = resolved_name,
    country_match = dplyr::case_when(
      !is.na(alias_name) ~ "alias",
      !is.na(exact_name) ~ "exact",
      TRUE ~ "unmatched"
    )
  )
}

.mdd_input_match_type <- function(match_row) {
  stage <- as.character(match_row$match_stage[[1]])
  has_fuzzy <- grepl("fuzzy", stage) ||
    (!is.null(match_row$fuzzy_genus_dist) &&
      !is.na(match_row$fuzzy_genus_dist[[1]])) ||
    (!is.null(match_row$fuzzy_species_dist) &&
      !is.na(match_row$fuzzy_species_dist[[1]]))

  if (has_fuzzy) "partial" else "total"
}

.mdd_map_zoom <- function(
  selected_sf,
  zoom = "world",
  xlim = NULL,
  ylim = NULL
) {
  zoom <- match.arg(zoom, choices = c("world", "auto", "manual"))

  if (identical(zoom, "world")) {
    return(list(mode = "world", xlim = NULL, ylim = NULL))
  }

  if (identical(zoom, "manual")) {
    if (
      is.null(xlim) || is.null(ylim) || length(xlim) != 2L || length(ylim) != 2L
    ) {
      cli::cli_abort(c(
        "When {.code zoom = 'manual'}, both {.arg xlim} and {.arg ylim} must be numeric vectors of length 2.",
        "x" = "Received {.val {xlim}} and {.val {ylim}}."
      ))
    }

    return(list(
      mode = "manual",
      xlim = sort(as.numeric(xlim)),
      ylim = sort(as.numeric(ylim))
    ))
  }

  bbox <- sf::st_bbox(sf::st_transform(selected_sf, 4326))
  width <- unname(bbox$xmax - bbox$xmin)
  height <- unname(bbox$ymax - bbox$ymin)

  if (is.na(width) || is.na(height) || width >= 220 || height >= 120) {
    return(list(mode = "world", xlim = NULL, ylim = NULL))
  }

  x_pad <- max(6, width * 0.18)
  y_pad <- max(4, height * 0.18)

  list(
    mode = "auto",
    xlim = c(max(-180, bbox$xmin - x_pad), min(180, bbox$xmax + x_pad)),
    ylim = c(max(-89, bbox$ymin - y_pad), min(89, bbox$ymax + y_pad))
  )
}

.mdd_coord_sf_args <- function(zoom_info) {
  args <- list(
    crs = sf::st_crs("+proj=robin +lon_0=0 +datum=WGS84 +units=m +no_defs"),
    default_crs = sf::st_crs(4326),
    expand = FALSE,
    clip = "on"
  )

  if (!is.null(zoom_info$xlim)) {
    args$xlim <- zoom_info$xlim
  }

  if (!is.null(zoom_info$ylim)) {
    args$ylim <- zoom_info$ylim
  }

  args
}

.mdd_cli_distribution_summary <- function(
  query,
  matched_name,
  accepted_name,
  input_match,
  mapped_units,
  unresolved_units,
  zoom_mode
) {
  n_mapped <- length(unique(stats::na.omit(mapped_units$atlas_name)))
  n_total <- nrow(mapped_units)
  n_unresolved <- nrow(unresolved_units)

  cli::cli_h2("Distribution Map")
  if (identical(input_match, "total")) {
    cli::cli_alert_success("Exact input match: {.val {query}}")
  } else {
    cli::cli_alert_warning(
      "Partial input match: {.val {query}} -> {.val {matched_name}}"
    )
  }

  cli::cli_inform(c(
    "i" = "Accepted taxon used for mapping: {.val {accepted_name}}",
    "i" = "Zoom mode: {.val {zoom_mode}}",
    "v" = "Mapped {n_mapped} of {n_total} distribution unit{?s}."
  ))

  if (n_unresolved > 0) {
    cli::cli_warn(c(
      "{n_unresolved} distribution unit{?s} could not be located in {.pkg rnaturalearth}.",
      "!" = "{n_unresolved} unit{?s} {?remains/remain} unresolved."
    ))
    preview <- utils::head(unresolved_units$clean_country, 8)
    cli::cli_ul(vapply(
      preview,
      function(x) paste0("{.val ", x, "}"),
      character(1)
    ))
    if (n_unresolved > 8) {
      cli::cli_text("... and {n_unresolved - 8} more.")
    }
  }
}

.mdd_normalize_place <- function(x) {
  x <- enc2utf8(as.character(x))
  x <- trimws(x)
  x <- iconv(x, from = "", to = "ASCII//TRANSLIT")
  x <- tolower(x)
  x <- gsub("&", "and", x, fixed = TRUE)
  x <- gsub("'", "", x, fixed = TRUE)
  x <- gsub("\\bsaint\\b", "st", x)
  x <- gsub("[^a-z0-9]+", " ", x)
  x <- gsub("\\s+", " ", x)
  trimws(x)
}

.mdd_naturalearth_alias <- function(x) {
  aliases <- c(
    "antigua and barbuda" = "Antigua and Barb.",
    "bosnia and herzegovina" = "Bosnia and Herz.",
    "british virgin islands" = "British Virgin Is.",
    "cape verde" = "Cabo Verde",
    "cayman islands" = "Cayman Is.",
    "central african republic" = "Central African Rep.",
    "cook islands" = "Cook Is.",
    "czech republic" = "Czechia",
    "democratic republic of the congo" = "Dem. Rep. Congo",
    "dominican republic" = "Dominican Rep.",
    "east timor" = "Timor-Leste",
    "equatorial guinea" = "Eq. Guinea",
    "falkland islands" = "Falkland Is.",
    "faroe" = "Faeroe Is.",
    "french polynesia" = "Fr. Polynesia",
    "french southern and antarctic lands" = "Fr. S. Antarctic Lands",
    "marshall islands" = "Marshall Is.",
    "north macedonia" = "Macedonia",
    "northern marianas" = "N. Mariana Is.",
    "pitcairn" = "Pitcairn Is.",
    "republic of the congo" = "Congo",
    "solomon islands" = "Solomon Is.",
    "south georgia and the south sandwich islands" = "S. Geo. and the Is.",
    "south sudan" = "S. Sudan",
    "st vincent and the grenadines" = "St. Vin. and Gren.",
    "turks and caicos islands" = "Turks and Caicos Is.",
    "united states" = "United States of America",
    "united states virgin islands" = "U.S. Virgin Is.",
    "wallis and futuna" = "Wallis and Futuna Is."
  )

  out <- unname(aliases[x])
  out[is.na(x)] <- NA_character_
  out
}
