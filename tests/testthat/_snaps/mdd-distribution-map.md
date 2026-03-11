# mdd_distribution_map cli summary is stable

    Code
      invisible(mdd_distribution_map("Lama vicugna"))
    Message
      
      -- Distribution Map --
      
      v Exact input match: "Lama vicugna"
      i Accepted taxon used for mapping: "Lama vicugna"
      i Zoom mode: "world"
      v Mapped 4 of 4 distribution units.

# mdd_distribution_map cli summary reports partial matches

    Code
      invisible(mdd_distribution_map("Pumma concolor"))
    Message
      
      -- Distribution Map --
      
      ! Partial input match: "Pumma concolor" -> "Puma concolor"
      i Accepted taxon used for mapping: "Puma concolor"
      i Zoom mode: "world"
      v Mapped 22 of 23 distribution units.
    Condition
      Warning:
      1 distribution unit could not be located in world-atlas.
      ! 1 unit remains unresolved.
    Message
      * "French Guiana"

# mdd_distribution_map reports cli errors for invalid inputs

    Code
      mdd_distribution_map(NA_character_)
    Condition
      Error in `mdd_distribution_map()`:
      ! `name` must be a single non-empty character string.
      x You supplied a character `NA`.

---

    Code
      mdd_distribution_map("Lama vicugna", zoom = "manual")
    Condition
      Error in `.mdd_map_zoom()`:
      ! When `zoom = 'manual'`, both `xlim` and `ylim` must be numeric vectors of length 2.
      x Received and .

