stopifnot(R.Version()$version.string %in% "R version 3.3.2 (2016-10-31)")

# no libraries needed

# definition of GBG colors
# see "G:\Vorlagen\Corporate Design inkl Logos\Corporate Design Handbuch.pdf" (file date: 2019-06-19)
gbg.colors.MAGENTA.v1 <- "#E6007E"
gbg.colors.GREEN.v1 <- "#BCCC2F"
gbg.colors.GREY.v1 <- "#646464"

# make colors brighter or darker
gbg.colors.brighter.v1 <- function(colors, shift) {
  # checks
  if (!is.character(colors)) {
    stop("parameter 'colors' must be of type character")
  }
  if (!is.numeric(shift) || length(shift) != 1L || is.na(shift)) {
    stop("parameter 'shift' must be a numeric scalar and not missing")
  }

  # calculate
  rgb <- col2rgb(colors)
  if (shift > 0)
    rgb <- 255 - (255 - rgb) / exp(shift)
  else
    rgb <- rgb / exp(-shift)
  return(rgb(t(round(rgb)), maxColorValue = 255L))
}
