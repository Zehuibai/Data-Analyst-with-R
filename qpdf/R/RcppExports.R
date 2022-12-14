# Generated by using Rcpp::compileAttributes() -> do not edit by hand
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

cpp_pdf_length <- function(infile, password) {
    .Call('_qpdf_cpp_pdf_length', PACKAGE = 'qpdf', infile, password)
}

cpp_pdf_split <- function(infile, outprefix, password) {
    .Call('_qpdf_cpp_pdf_split', PACKAGE = 'qpdf', infile, outprefix, password)
}

cpp_pdf_select <- function(infile, outfile, which, password) {
    .Call('_qpdf_cpp_pdf_select', PACKAGE = 'qpdf', infile, outfile, which, password)
}

cpp_pdf_combine <- function(infiles, outfile, password) {
    .Call('_qpdf_cpp_pdf_combine', PACKAGE = 'qpdf', infiles, outfile, password)
}

cpp_pdf_compress <- function(infile, outfile, linearize, password) {
    .Call('_qpdf_cpp_pdf_compress', PACKAGE = 'qpdf', infile, outfile, linearize, password)
}

cpp_pdf_rotate_pages <- function(infile, outfile, which, angle, relative, password) {
    .Call('_qpdf_cpp_pdf_rotate_pages', PACKAGE = 'qpdf', infile, outfile, which, angle, relative, password)
}

cpp_pdf_overlay <- function(infile, stampfile, outfile, password) {
    .Call('_qpdf_cpp_pdf_overlay', PACKAGE = 'qpdf', infile, stampfile, outfile, password)
}

