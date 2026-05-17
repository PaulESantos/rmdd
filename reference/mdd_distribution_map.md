# Generate a distribution map from MDD country distributions

**\[experimental\]**

This function is experimental and may change in future releases.

Resolve a mammal name with
[`mdd_matching()`](https://paulesantos.github.io/rmdd/reference/mdd_matching.md)
and map its `country_distribution` values against an `rnaturalearth`
countries layer. The function preserves the package's exact vs partial
input validation by reporting whether the taxon input was matched
directly or through a fuzzy stage before plotting the accepted taxon
distribution. Spatial polygons come from Natural Earth through
[`rnaturalearth::ne_countries()`](https://docs.ropensci.org/rnaturalearth/reference/ne_countries.html).

## Usage

``` r
mdd_distribution_map(
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
)
```

## Arguments

- name:

  A single scientific name.

- checklist:

  Optional checklist data frame. Defaults to `mdd_checklist`.

- synonyms:

  Optional synonym data frame. Defaults to `mdd_synonyms`.

- target_df:

  Optional reconciliation backbone from
  [`build_mdd_match_backbone()`](https://paulesantos.github.io/rmdd/reference/build_mdd_match_backbone.md).

- atlas:

  Optional `sf` object with world country polygons. Defaults to
  `rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")`.

- max_dist:

  Maximum string distance used if the input name needs fuzzy
  reconciliation.

- method:

  Distance method passed to
  [`mdd_matching()`](https://paulesantos.github.io/rmdd/reference/mdd_matching.md).

- zoom:

  Zoom mode. Use `"world"` for the full map, `"auto"` to zoom to the
  mapped distribution extent, or `"manual"` to use `xlim` and `ylim`.

- xlim:

  Optional longitude limits used when `zoom = "manual"`.

- ylim:

  Optional latitude limits used when `zoom = "manual"`.

- quiet:

  Logical. If `TRUE`, suppress `cli` progress messages.

- title:

  Optional plot title. Defaults to the accepted taxon name.

- base_fill:

  Fill color for non-selected countries.

- dist_fill:

  Fill color for mapped distribution units.

- border_color:

  Border color for mapped country outlines.

- country_color:

  Border color for non-selected country outlines.

- ocean_fill:

  Background color for the map panel.

- plot_fill:

  Background color for the full plot area.

- graticule_color:

  Color for graticule lines.

- graticule_linewidth:

  Line width for graticule lines.

- graticule_alpha:

  Alpha level for graticule lines.

- country_linewidth:

  Line width for non-selected country outlines.

- dist_linewidth:

  Line width for mapped country outlines.

- title_color:

  Color for the plot title.

- title_size:

  Size of the plot title.

- title_face:

  Font face for the plot title.

## Value

A `ggplot2` map object. Additional metadata are attached in the
`"mdd_distribution_info"` attribute.

## Examples

``` r
if (interactive()) {
  mdd_distribution_map("Lama vicugna", quiet = TRUE)
}
```
