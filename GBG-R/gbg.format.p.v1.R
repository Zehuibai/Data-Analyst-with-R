# no libraries needed

gbg.format.p.v1 <- function(p, num.digits = 4, na.value = "NA") {
  # checks
  stopifnot(is.numeric(p) && length(p) == 1)
  stopifnot((p >= 0 && p <= 1) || is.na(p))
  stopifnot(is.numeric(num.digits) && length(num.digits) == 1)
  stopifnot(is.character(na.value) && length(na.value) == 1)

  # case p-value is NA
  if (is.na(p)) {
    return(na.value)
  }

  # format finite p-value
  if (!is.double(p)) p <- as.double(p)
  if (num.digits == 4) {
	  return(ifelse(p < 0.0001, "<.0001", format(p, width=6, digits=0, nsmall=4)))
  } else if (num.digits == 3) {
	  return(ifelse(p < 0.001, "<.001", format(p, width=5, digits=0, nsmall=3)))
  } else {
	  stop("num.digits must be 3 or 4")
  }
}


