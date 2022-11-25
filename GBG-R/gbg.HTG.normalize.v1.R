# no libraries needed

stopifnot(R.Version()$version.string %in% "R version 3.3.2 (2016-10-31)")



gbg.HTG.normalize.v1 <- function(counts.mat) {
  # checks
  if (!is.matrix(counts.mat) || !is.integer(counts.mat)) {
    stop("HTG counts must be an integer matrix")
  }
  if (ncol(counts.mat) != 2549L || any(duplicated(colnames(counts.mat)))) {
    stop("columns must contain the genes; include housekeepers, exclude pos. and neg. controls and alien ER probe sets")
  }
  # NOTE: gene names are not checked, because there may be different notations (e.g. "HLA-A" or "HLA_A")
  if (!all(is.finite(counts.mat))) {
    stop("HTG counts must not be missing")
  }
  if (any(counts.mat < 0L)) {
    stop("HTG counts must not be negative")
  }

  # perform calculations according to "Normalizing_HTG_data_V2.0.pdf"
  norm.mat <- log2(1000000 * (counts.mat + 0.5) / matrix(rowSums(counts.mat) + 1, nrow(counts.mat), ncol(counts.mat), F))
  norm.mat <- pmax(norm.mat, 3)
  return(norm.mat)
}
