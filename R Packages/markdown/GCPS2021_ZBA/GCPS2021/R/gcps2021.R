#'GCPS Report template for pdfs
#'
#'Some time in the future, this will help adding more features and templates
#'Right now it is not used
#'
#'See `bookdown::pdf_book()` for options
#'@inheritParams bookdown::pdf_book
#'
#'@export
#'@importFrom bookdown pdf_book
gcps2021 <- function(...){

  template <- system.file(
    "rmarkdown/templates/gcps2021/resources/template.tex",
    package = "GCPS2021"
  )
  bookdown::pdf_book(..., template = template)
}
