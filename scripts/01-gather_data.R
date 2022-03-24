library(janitor)
library(pdftools)
library(purrr)
library(tidyverse)
library(stringi)

download.file(
  "https://dhsprogram.com/pubs/pdf/FR37/FR37.pdf", 
  "1987_thailand_dhs.pdf",
  mode="wb")

all_content <- pdf_text("2019_Kenya_census.pdf")