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
# Read in the raw data. 
extracted_data <- read_csv("inputs/data/extracted_data.csv")

#### Data Cleaning ####

# Only keep useful columns
cleaned_data <- extracted_data %>%
  select("Health_Record", "Mothers_Report", "Received_Immunization", "Not_Received_Immunization", "Number_of_Children")

#### Save ####