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

# The function is going to take an input of a page
get_data <- function(i){
  # i = 467
  # Just look at the page of interest
  # Based on Bob Rudis: https://stackoverflow.com/a/47793617
  just_page_102 <- stri_split_lines(all_content[[102]])[[102]] 
  
  just_page_i <- just_page_i[just_page_i != ""]
  
  # Grab the name of the location
  area <- just_page_i[3] |> str_squish()
  area <- str_to_title(area)
  
  # Grab the type of table
  type_of_table <- just_page_i[2] |> str_squish()
  
  # Get rid of the top matter
  # Manually for now, but could create some rules if needed
  just_page_i_no_header <- just_page_i[5:length(just_page_i)] 
  
  # Get rid of the bottom matter
  # Manually for now, but could create some rules if needed
  just_page_i_no_header_no_footer <- just_page_i_no_header[1:62] 
  
  # Convert into a tibble
  demography_data <- tibble(all = just_page_i_no_header_no_footer)
  
  # Split columns
  demography_data <-
    demography_data |>
    mutate(all = str_squish(all)) |> # Any space more than two spaces is reduced
    mutate(all = str_replace(all, "10 -14", "10-14")) |> # One specific issue
    mutate(all = str_replace(all, "Not Stated", "NotStated")) |> # And another
    separate(col = all,
             into = c("age", "male", "female", "total", "age_2", "male_2", "female_2", "total_2"),
             sep = " ", # Works fine because the tables are nicely laid out
             remove = TRUE,
             fill = "right",
             extra = "drop"
    )
  
  # They are side by side at the moment, need to append to bottom
  demography_data_long <-
    rbind(demography_data |> select(age, male, female, total),
          demography_data |>
            select(age_2, male_2, female_2, total_2) |>
            rename(age = age_2, male = male_2, female = female_2, total = total_2)
    )
  
  # There is one row of NAs, so remove it
  demography_data_long <- 
    demography_data_long |> 
    remove_empty(which = c("rows"))
  
  # Add the area and the page
  demography_data_long$area <- area
  demography_data_long$table <- type_of_table
  demography_data_long$page <- i
  
  rm(just_page_i,
     i,
     area,
     type_of_table,
     just_page_i_no_header,
     just_page_i_no_header_no_footer,
     demography_data)
  
  return(demography_data_long)
}