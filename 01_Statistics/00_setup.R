setup <- function(title){
  ---
  title: 'As-a-Statistician-Sample Size Calculation'
  author: "Zehui Bai"
  date: '`r format(Sys.time())`'
  output:
    html_document:
    df_print: paged
  number_sections: no
  toc: yes
  toc_float: yes
  word_document:
    toc: yes
  pdf_document:
    toc: yes
  fontsize: 10pt
  editor_options:
    chunk_output_type: console
  colorlinks: yes
  ---
    
  ```{r setup, include=FALSE, echo = FALSE,message = FALSE, error = FALSE, warning = FALSE}
  knitr::opts_chunk$set(echo = TRUE)
  
  # <!-- ---------------------------------------------------------------------- -->
  # <!--                    1. load the required packages                       -->
  # <!-- ---------------------------------------------------------------------- --> 
  
  ## if(!require(psych)){install.packages("psych")}
  
  packages<-c("tidyverse", "knitr", "papeR")
  ipak <- function(pkg){
    new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
    if (length(new.pkg)) 
      install.packages(new.pkg, dependencies = TRUE)
    sapply(pkg, require, character.only = TRUE)
  }
  ipak(packages)
  # <!-- ---------------------------------------------------------------------- --> 
  
  
  # <!-- ---------------------------------------------------------------------- -->
  # <!--                        2. Basic system settings                        -->
  # <!-- ---------------------------------------------------------------------- -->
  setwd(dirname(rstudioapi::getSourceEditorContext()$path))
  getwd()
  Sys.setlocale("LC_ALL","English")
  
  ## convert backslash to forward slash in R
  # gsub('"', "", gsub("\\\\", "/", readClipboard()))
  
  ### get the path
  # rstudioapi::getSourceEditorContext()$path
  # dirname(rstudioapi::getSourceEditorContext()$path)
  
  ### set working directory
  # getwd()
  # setwd("c:/Users/zbai/Desktop")
  # Sys.setlocale("LC_ALL","English")
  
  ### get the R Version
  # paste(R.Version()[c("major", "minor")], collapse = ".")
  
  ### convert backslash to forward slash 
  # scan("clipboard",what="string")
  # gsub('"', "", gsub("\\\\", "/", readClipboard()))
  # <!-- ---------------------------------------------------------------------- --> 
  
  
  
  # <!-- ---------------------------------------------------------------------- -->
  # <!--     3. Load the SASmarkdown package if the SAS output is required      -->
  # <!-- ---------------------------------------------------------------------- -->
  # library(SASmarkdown)
  # ### Set SAS output
  # ### Reset engine to R
  # saspath <- "C:/SASHome/SASFoundation/9.4/sas.exe"
  # sasopts <- "-nosplash -linesize 75"
  # knitr::opts_chunk$set(engine="sashtml", engine.path=saspath,
  #         engine.opts=sasopts, comment=NA)
  # 
  # # run these commands to convince yourself that
  # # within this knitr session the engine changed.
  # knitr::opts_chunk$get()$engine
  # knitr::opts_chunk$get()$engine.path
  # knitr::opts_chunk$get()$engine.opts
  # <!-- ---------------------------------------------------------------------- -->
  
  
  
  # <!-- ---------------------------------------------------------------------- -->
  # <!--                         4. Import the datasets                         -->
  # <!-- ---------------------------------------------------------------------- -->
  ### Import csv data
  # pfad <- "~/Desktop/SASUniversityEdition/myfolders/Daten"
  # mydata1 <- read.csv(file.path(pfad, "yourcsv_data.csv"), 
  #                     sep=";", 
  #                     header=TRUE)   
  
  ### Import xlsx data
  # library(readxl)
  # mydata2 <- read_excel("C:/Users/zbai/Documents/GitHub/R-Projects/SAS/Yimeng/results-text.xlsx")
  
  ### Import sas data
  # library(sas7bdat)
  # mydata3 <- read.sas7bdat("~/Desktop/SASUniversityEdition/myfolders/Daten/uis.sas7bdat")
  
  ### Import from copyboard
  # copdat <- read.delim("clipboard")
  # Data_D01 <- copdat
  
  # <!-- ---------------------------------------------------------------------- -->
  # <!--                           5. Some Tools                                -->
  # <!-- ---------------------------------------------------------------------- -->
  
  ## To check out vignettes for one specific package
  # browseVignettes("ggplot2")
  
  
  # <!-- ---------------------------------------------------------------------- -->
  ```
}