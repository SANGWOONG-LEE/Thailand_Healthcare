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
  #immune_data <- extract(immune_data, raw_text, into=c('v1', 'v2'), '(\\d+)(\\D+)', convert=TRUE)
  
  
  # Grab the type of table
  #gettype_of_table <- just_page_i[2] |> str_squish()
  
  # Get rid of the top matter
  # Manually for now, but could create some rules if needed
  # no_header <- text[7:length(text)]
  
  # Get rid of the bottom matter
  # Manually for now, but could create some rules if needed
  # table_header_no_footer <- no_header[1:25] 
  
  # Convert into a tibble
  # demography_data <- tibble(all = table_header_no_footer)
  
  # Split columns
  immune_data <-
    immune_data |>
    mutate(raw_text = str_squish(raw_text)) |> # Any space more than two spaces is reduced
    mutate(raw_text = str_replace(raw_text, "Urban-rual residence", "Urban-ruralResidence")) |> # One specific issue
    mutate(raw_text = str_replace(raw_text, "5 Northeast", "NorthEast")) |> # And another
    mutate(raw_text = str_replace(raw_text, "N Central", "Central")) |>
    mutate(raw_text = str_replace(raw_text, "No education", "NoEducation")) |>
    mutate(raw_text = str_replace(raw_text, "15-1", "15.1")) |>
    separate(col = raw_text,
             into = c("Variable", "Health_Record", "Mothers_Report", "Received_Immunization", "Not_Received_Immunization", "Total_Percent", "Number_of_Children"),
             sep = " ", # Works fine because the tables are nicely laid out
             remove = TRUE,
             fill = "right",
             extra = "drop"
    )
  
  immune_data <- immune_data[complete.cases(immune_data),] |> 
    #select("Health_Record", "Mother's_Report", "Received_Immunization", "Not_Received_Immunization", "Total_Percent", "Number_of_Children") |>
    mutate_at(vars(Health_Record, Mothers_Report, Received_Immunization, Not_Received_Immunization, Total_Percent, Number_of_Children), ~str_remove_all(., ",")) |>
    #mutate_at(vars(Health_Record, Mothers_Report, Received_Immunization, Not_Received_Immunization, Total_Percent, Number_of_Children), ~str_replace(., "_", "0")) |>
    #mutate_at(vars(Health_Record, Mothers_Report, Received_Immunization, Not_Received_Immunization, Total_Percent, Number_of_Children), ~str_replace(., "-", "0")) |>
    mutate_at(vars(Health_Record, Mothers_Report, Received_Immunization, Not_Received_Immunization, Total_Percent, Number_of_Children), ~as.double(.)) |>
    column_to_rownames(var = "Variable")
  
  # They are side by side at the moment, need to append to bottom
  # demography_data_long <-
  #   rbind(demography_data |> select(age, male, female, total),
  #         demography_data |>
  #           select(age_2, male_2, female_2, total_2) |>
  #           rename(age = age_2, male = male_2, female = female_2, total = total_2)
  #   )
  
  # There is one row of NAs, so remove it
  # demography_data_long <- 
  #   demography_data_long |> 
  #   remove_empty(which = c("rows"))
  
  # Add the area and the page
  # demography_data_long$area <- area
  # demography_data_long$table <- type_of_table
  # demography_data_long$page <- i
  
  # rm(just_page_i,
  #    i,
  #    area,
  #    type_of_table,
  #    just_page_i_no_header,
  #    just_page_i_no_header_no_footer,
  #    demography_data)
  
  return(immune_data)
}
extracted_data <- get_data(text)

#### Save ####
write_csv(extracted_data, "inputs/data/extracted_data.csv")
