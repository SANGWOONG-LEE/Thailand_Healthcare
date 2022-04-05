library(janitor)
library(pdftools)
library(purrr)
library(tidyverse)
library(stringi)
library(tesseract)

text <- tesseract::ocr(here::here("inputs/data/figure_6.9.png"), engine = tesseract("eng"))
cat(text)
  
get_data <- function(text){
  
  immune_data <- tibble(raw_text = text)
  immune_data <- 
    separate_rows(immune_data, raw_text, sep = "\\n", convert = FALSE)
  
  immune_data <- immune_data[-c(1:7),]
  immune_data <- immune_data[-c(19:20),]
  
  # Split columns
  immune_data <-
    immune_data |>
    mutate(raw_text = str_squish(raw_text)) |> # Any space more than two spaces is reduced
    mutate(raw_text = str_replace(raw_text, "Urban-rual residence", "Urban-ruralResidence")) |> # One specific issue
    mutate(raw_text = str_replace(raw_text, "5 Northeast", "NorthEast")) |> # And another
    mutate(raw_text = str_replace(raw_text, "N Central", "Central")) |>
    mutate(raw_text = str_replace(raw_text, "No education", "NoEducation")) |>
    mutate(raw_text = str_replace(raw_text, "15-1", "15.1")) |>
    mutate(raw_text = str_replace(raw_text, "Islan", "Islam")) |>
    mutate(raw_text = str_replace(raw_text, "10.6", "70.6")) |>
    separate(col = raw_text,
             into = c("Variable", "Health_Record", "Mothers_Report", "Received_Immunization", "Not_Received_Immunization", "Total_Percent", "Number_of_Children"),
             sep = " ", # Works fine because the tables are nicely laid out
             remove = TRUE,
             fill = "right",
             extra = "drop"
    )
  
  immune_data <- immune_data[complete.cases(immune_data),] |> 
    mutate_at(vars(Health_Record, Mothers_Report, Received_Immunization, Not_Received_Immunization, Total_Percent, Number_of_Children), ~str_remove_all(., ",")) |>
    mutate_at(vars(Health_Record, Mothers_Report, Received_Immunization, Not_Received_Immunization, Total_Percent, Number_of_Children), ~as.double(.))
  
  immune_data[8, 1] = "No Education"
  
  return(immune_data)
}
extracted_data <- get_data(text)

#### Save ####
write_csv(extracted_data, "inputs/data/extracted_data.csv")
