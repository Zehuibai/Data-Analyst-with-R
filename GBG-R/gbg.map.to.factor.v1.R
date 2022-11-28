# no libraries needed

gbg.map.to.factor.v1 <- function(x, map, na.values = NULL) {
  # checks
  if (!(is.numeric(x) || is.character(x) || is.factor(x) || is.logical(x))) {
    stop("bad data type")
  }
  if (!is.list(map)) {
    stop("map must be a list")
  }
  if (!is.null(na.values)) {
    if (is.numeric(x) != is.numeric(na.values) ||
        (is.character(x) || is.factor(x)) != (is.character(na.values) || is.factor(na.values)) ||
        is.logical(x) != is.logical(na.values)) {
      stop("na.values must have the same data type as x")
    }
  }

  # check for non-unique mappings
  all.mappings <- na.values
  for (i in names(map)) {
    # if mapping values are a factor, convert to character
    if (is.factor(map[[i]]))
      map[[i]] <- as.character(map[[i]])

    if (is.numeric(x) != is.numeric(map[[i]]) ||
        (is.character(x) || is.factor(x)) != (is.character(map[[i]]) || is.factor(map[[i]])) ||
        is.logical(x) != is.logical(map[[i]])) {
      stop("mapping values must have the same data type as x")
    }
    all.mappings <- c(all.mappings, map[[i]])
  }
  if (any(duplicated(all.mappings))) {
    stop("a value is mapped twice")
  }

  # detect explicite missings
  if (!is.null(na.values)) {
    x[x %in% na.values] <- NA
  }

  # perform mapping
  f <- factor(x)
  levels(f) <- map
  if (!all(is.na(x) == is.na(f))) {
    stop("bad value detected")
  }
  return(f)
}


