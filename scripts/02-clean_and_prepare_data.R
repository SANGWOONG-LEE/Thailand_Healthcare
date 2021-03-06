#### Preamble ####
# Purpose: Prepare the 1987 Thailand DHS data
# Author: SangWoong Lee, Young Suk
# Data: 31 March 2022
# Contact: sangwoong.lee@mail.utoronto.ca, young.suk@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the DHS data and extract it using OCR and save it to inputs/data

#### Workspace setup ####
library(tidyverse)
library(pointblank)
# Read in the raw data. 
extracted_data <- read_csv("inputs/data/extracted_data.csv")

#### Data Cleaning ####

# Only keep useful columns by removing total percent column.
cleaned_data <- extracted_data  |> select(-c(Total_Percent))

### Test ###
column_names_as_contracts <- 
  cleaned_data |> 
  rename(
    "chr_variable" = "Variable",
    "int_Health_Record" = "Health_Record",
    "int_Mothers_Report" = "Mothers_Report",
    "int_Received_Immunization" = "Received_Immunization",
    "int_Not_Received_Immunization" = "Not_Received_Immunization",
    "int_Childeren_Count" = "Number_of_Children",
  ) |>
  mutate(total_calculated = round(int_Health_Record + int_Mothers_Report, 1)) |>
  mutate(no_immune_calculated = round(100 - int_Received_Immunization, 1))

agent <-
  create_agent(tbl = column_names_as_contracts) |>
  col_is_character(columns = vars(chr_variable)) |>
  col_is_numeric(columns = vars(int_Health_Record,int_Mothers_Report,int_Received_Immunization,
                                int_Not_Received_Immunization,int_Childeren_Count)) |>
  col_vals_between(vars(int_Health_Record),0,100) |>
  col_vals_between(vars(int_Mothers_Report),0,100) |>
  col_vals_between(vars(int_Received_Immunization),0,100) |>
  col_vals_between(vars(int_Not_Received_Immunization),0,100) |>
  col_vals_between(vars(int_Childeren_Count),0, 2872) |>
  col_vals_in_set(columns = chr_variable,
                  set = c("Urban", "Rural", "North","NorthEast","Central","South",
                          "Bangkok","No Education","Primary","Secondary","Higher","Buddhist"
                          ,"Islam","Total")) |>
  col_vals_equal(vars(total_calculated), vars(int_Received_Immunization))|>
  col_vals_equal(vars(no_immune_calculated), vars(int_Not_Received_Immunization))|>
  interrogate()

agent

#### Save ####
write_csv(cleaned_data, "outputs/data/cleaned_data.csv")