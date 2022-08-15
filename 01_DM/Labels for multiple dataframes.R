




## Load Library
library(haven)
library(tidyverse)
library(kableExtra)

 
## get the SAS.labels for single data.frame
airline <- read_sas("http://www.principlesofeconometrics.com/sas/airline.sas7bdat")

label_lookup_map <- tibble(
  col_name = airline %>% names(),
  labels = airline %>% map_chr(attr_getter("label"))
)
label_lookup_map %>%
  kable(caption = "get the SAS.labels for single data.frame", format = "html") %>%
  kable_styling(latex_options = "striped")









## get the SAS.labels for multiple data.frames
airline <- read_sas("http://www.principlesofeconometrics.com/sas/airline.sas7bdat")
cola <- read_sas("http://www.principlesofeconometrics.com/sas/cola.sas7bdat")
data(iris)

list_of_tbl <- list(airline, cola, iris)

get_labels <- attr_getter("label")

has_labels <- function(df) {
  !all(sapply(lapply(df, get_labels), is.null))
}

label_lookup_map <- function(df) {
  
  df_labels <- NA
  if (has_labels(df)) {
    df_labels <- df %>% map_chr(get_labels)
  }
  
  tibble(
    col_name = df %>% names,
    labels = df_labels
  )
}

list_of_labels <- lapply(list_of_tbl, label_lookup_map)

list_of_labels[2] %>%
  kable(caption = "get the SAS.labels for multiple data.frames", format = "html") %>%
  kable_styling(latex_options = "striped")


