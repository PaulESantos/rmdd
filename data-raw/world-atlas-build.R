# Source data for distribution maps
#
# Downloaded from topojson/world-atlas:
# https://github.com/topojson/world-atlas
#
# Files kept in data-raw/world-atlas/:
# - countries-110m.json
# - countries-10m.json
#
# Runtime asset packaged in inst/extdata/:
# - world-atlas-countries-10m.rds
#
# The packaged RDS was created by converting the TopoJSON countries object to
# GeoJSON with topojson-client, then reading it with sf and saving it via
# saveRDS(..., compress = "xz").
