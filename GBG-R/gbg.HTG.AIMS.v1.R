library(AIMS) # V1.6.0

stopifnot(R.Version()$version.string %in% "R version 3.3.2 (2016-10-31)")
stopifnot(packageVersion("AIMS") == "1.6.0")



# mapping of HTG gene names to entrez IDs, AIMS genes only
# "G:\Statistik\Bioinformatik\PenelopeB\HTG\calculate AIMS\downloads\Homo_sapiens.gene_info"
.gbg.HTG.AIMS.gene.map.v1 <- as.data.frame(matrix(c(
  "ANXA3", "306",
  "APH1B", "83464",
  "AR", "367",
  "ASPM", "259266",
  "BCL2", "596",
  "BIRC5", "332",
  "C1orf106", "55765", # see "Email from Zhou to Weber 2020-04-06.pdf"
  "CA12", "771",
  "CAV1", "857",
  "CCNB2", "9133",
  "CDC20", "991",
  "CDH3", "1001",
  "CDKN1C", "1028",
  "CDKN3", "1033",
  "CENPF", "1063",
  "CEP55", "55165",
  "CIRBP", "1153",
  "CKS2", "1164",
  "CNIH4", "29097",
  "COL17A1", "1308",
  "CRYAB", "1410",
  "CSTB", "1476",
  "CX3CL1", "6376",
  "DNAJC12", "56521",
  "ERBB2", "2064",
  "ESR1", "2099",
  "FBP1", "2203",
  "FGFR4", "2264",
  "FMO5", "2330",
  "FOXA1", "3169",
  "FOXC1", "2296",
  "GAMT", "2593",
  "GATA3", "2625",
  "GFRA1", "2674",
  "GSN", "2934",
  "GSTP1", "2950",
  "HPN", "3249",
  "HSPA14", "51182",
  "ID4", "3400",
  "IGF1", "3479",
  "IGFBP6", "3489",
  "IRS1", "3667",
  "ITM2A", "9452",
  "KIF2C", "11004",
  "KIT", "3815",
  "KRT14", "3861",
  "KRT17", "3872",
  "KRT18", "3875",
  "KRT5", "3852",
  "LAMA3", "3909",
  "LYN", "4067",
  "MAD2L1", "4085",
  "MAP2K4", "6416",
  "MAPT", "4137",
  "MCM2", "4171",
  "MELK", "9833",
  "MLPH", "79083",
  "MMP7", "4316",
  "MNAT1", "4331",
  "NAT1", "9",
  "NDC80", "10403",
  "NEK2", "4751",
  "NQO1", "1728",
  "PARP1", "142",
  "PCNA", "5111",
  "PPAP2B", "8613", # see "Email from Zhou to Weber 2020-04-06.pdf"
  "PRC1", "9055",
  "PRKX", "5613",
  "PTN", "5764",
  "PTTG1", "9232",
  "RACGAP1", "29127",
  "RBBP8", "5932",
  "RFC4", "5984",
  "RRM2", "6241",
  "S100A8", "6279",
  "SCUBE2", "57758",
  "SERPINA3", "12",
  "SFRP1", "6422",
  "SHC2", "25759",
  "SLC39A6", "25800",
  "SPDEF", "25803",
  "STC2", "8614",
  "TFF3", "7033",
  "TK1", "7083",
  "TNFRSF21", "27242",
  "TOP2A", "7153",
  "TSPAN13", "27075",
  "TSPAN7", "7102",
  "TTK", "7272",
  "TYMS", "7298",
  "UBE2C", "11065"),
  ncol = 2L, byrow = T, dimnames = list(NULL, c("HTGname", "entrezID"))), stringsAsFactors = F)
stopifnot(!duplicated(.gbg.HTG.AIMS.gene.map.v1$HTGname))
stopifnot(!duplicated(.gbg.HTG.AIMS.gene.map.v1$entrezID))



gbg.HTG.AIMS.v1 <- function(counts.mat, published.names = T) {
  # checks
  if (!is.matrix(counts.mat) || !is.integer(counts.mat)) {
    stop("HTG counts must be an integer matrix")
  }
  if (ncol(counts.mat) != 2549L || any(duplicated(colnames(counts.mat)))) {
    stop("columns must contain the genes; include housekeepers, exclude pos. and neg. controls and alien ER probe sets")
  }
  if (!all(.gbg.HTG.AIMS.gene.map.v1$HTGname %in% colnames(counts.mat))) {
    stop("one or more HTG genes needed for AIMS not contained in data matrix")
  }
  if (!all(is.finite(counts.mat))) {
    stop("HTG counts must not be missing")
  }
  if (any(counts.mat < 0L)) {
    stop("HTG counts must not be negative")
  }
  if (length(published.names) != 1L || !is.logical(published.names) || !(published.names %in% c(T, F))) {
    stop("parameter published.names must be TRUE or FALSE")
  }

  # internal check: entrez IDs used by AIMS
  entrezIDs <- unique(unlist(strsplit(AIMSmodel$all.pairs, "<", T)))
  stopifnot(length(entrezIDs) == 151L)
  stopifnot(.gbg.HTG.AIMS.gene.map.v1$entrezID %in% entrezIDs)
  rm(entrezIDs)

  # map gene symbols to entrez IDs, create genes table
  map <- .gbg.HTG.AIMS.gene.map.v1
  map <- merge(map, data.frame(HTGname = colnames(counts.mat), idx = seq_len(ncol(counts.mat)), stringsAsFactors = F), all.x = T, all.y = F)
  stopifnot(nrow(map) == nrow(.gbg.HTG.AIMS.gene.map.v1))

  # calculate AIMS results
  suppressMessages( res <- applyAIMS(t(counts.mat[, map$idx]), map$entrezID) )

  # checks on AIMS results
  stopifnot(identical(rownames(res$cl), rownames(counts.mat)))
  stopifnot(ncol(res$cl) == 1L)
  stopifnot(identical(rownames(res$prob), rownames(counts.mat)))
  stopifnot(ncol(res$prob) == 1L)
  stopifnot(length(res$all.probs) == 1L)
  stopifnot(nrow(res$all.probs[[1]]) == nrow(counts.mat))
  stopifnot(ncol(res$all.probs[[1]]) == 5L)
  stopifnot(nrow(res$rules.matrix) == 100L && ncol(res$rules.matrix) == nrow(counts.mat))
  stopifnot(rowSums(is.na(res$rules.matrix)) %in% c(0L, nrow(counts.mat)))
  stopifnot(colSums(is.na(res$rules.matrix)) == 58L) # 42 rules used
  stopifnot(identical(res$EntrezID.used, map$entrezID))
  stopifnot(res$cl %in% colnames(res$all.probs[[1]]))

  # compile output table
  tab <- data.frame(ID = rownames(res$cl),
                    AIMS_class = as.vector(res$cl),
                    stringsAsFactors = F)
  name.map <- list(LumA = "LumA", LumB = "LumB", Normal = "NormL", Basal = "BasalL", Her2 = "HER2E")
  stopifnot(!is.na(tab$AIMS_class))
  if (published.names) tab$AIMS_class <- unlist(name.map[tab$AIMS_class])
  stopifnot(!is.na(tab$AIMS_class))
  for (i in colnames(res$all.probs[[1]])) {
    tab[[paste0("AIMS_p_", ifelse(published.names, name.map[[i]], i))]] <- res$all.probs[[1]][, i]
  }
  return(tab)
}


