### Preamble ###
# Purpose: Obtain and prepare data about children 12 to 59 months of age according to immunization 
# status and method of reporting immunization status, by selected background characteristics. 
# Author: SangWoong Lee and Young Suk
# Email: sangwoong.lee@mail.utoronto.ca and young.suk@mail.utoronto.ca
# Date 24 March 2022
# prerequisites: - 

### Worksapce set-up ###
library(janitor)
library(lubridate)
library(tidyverse)

set.seed(777)
sample_size <- 3000
simulated_urban_rural <- 
  tibble(
    variables = 
      c(
        rep('Urban',1),
        rep('Rural',1)
      ),
    Health_record = 
      runif(n=2,
            min = 0,
            max = 100),
    Mother_record = 
      runif(n= 2,
            min = 0,
            max = 100 -Health_record),
    immunization = Mother_record + Health_record,
    non_immunization = 100 - immunization,
    number_of_childeren = 
      as.numeric(rmultinom(n = 1, size = 3000, prob = rep(1/2, 2)))
  )
simulated_region <- 
  tibble(
    variables = 
      c(
        rep('North',1),
        rep('Northeast',1),
        rep('Central',1),
        rep('South',1),
        rep('Bangkok',1)
      ),
    Health_record = 
      runif(n=5,
            min = 0,
            max = 100),
    Mother_record = 
      runif(n= 5,
            min = 0,
            max = 100 -Health_record),
    immunization = Mother_record + Health_record,
    non_immunization = 100 - immunization,
    number_of_childeren = 
      as.numeric(rmultinom(n = 1, size = 3000, prob = rep(1/5, 5)))
  )
simulated_education <- 
  tibble(
    variables = 
      c(
        rep('No_education',1),
        rep('Primary',1),
        rep('Secondary',1),
        rep('Higher',1)
      ),
    Health_record = 
      runif(n=4,
            min = 0,
            max = 100),
    Mother_record = 
      runif(n= 4,
            min = 0,
            max = 100 -Health_record),
    immunization = Mother_record + Health_record,
    non_immunization = 100 - immunization,
    number_of_childeren = 
      as.numeric(rmultinom(n = 1, size = 3000, prob = rep(1/4, 4)))
  )
simulated_religion <- 
  tibble(
    variables = 
      c(
        rep('Buddhist',1),
        rep('Islam',1)
      ),
    Health_record = 
      runif(n=2,
            min = 0,
            max = 100),
    Mother_record = 
      runif(n= 2,
            min = 0,
            max = 100 -Health_record),
    immunization = Mother_record + Health_record,
    non_immunization = 100 - immunization,
    number_of_childeren = 
      as.numeric(rmultinom(n = 1, size = 3000, prob = rep(1/2, 2)))
  )
simulated_total <- 
  tibble(
    variables = rep('total',1),
    Health_record = (simulated_urban_rural$number_of_childeren[1] * (simulated_urban_rural$Health_record[1] *0.01)
    + simulated_urban_rural$number_of_childeren[2] * (simulated_urban_rural$Health_record[2] *0.01)) / 3000 * 100,
    Mother_record = (simulated_urban_rural$number_of_childeren[1] * (simulated_urban_rural$Mother_record[1] *0.01)
                     + simulated_urban_rural$number_of_childeren[2] * (simulated_urban_rural$Mother_record[2] *0.01)) / 3000 * 100,
    immunization = Mother_record + Health_record,
    non_immunization = 100 - immunization,
    number_of_childeren = 3000
  )
simulated_immunization_data <- rbind(simulated_urban_rural, simulated_region, simulated_education, simulated_religion,simulated_total)
  
simulated_immunization_data$variables |>
  unique() == c('Urban',
                'Rural',
                'North',
                'Northeast',
                'Central',
                'South',
                'Bangkok',
                'No_education',
                'Primary',
                'Secondary',
                'Higher',
                'Buddhist',
                'Islam')
simulated_immunization_data$variables |> unique() |> length() == 14
simulated_immunization_data$Health_record |>  min() >= 0 
simulated_immunization_data$Health_record |>  max() <= 100
simulated_immunization_data$Mother_record |>  min() >= 0 
simulated_immunization_data$Mother_record |>  max() <= 100
simulated_immunization_data$immunization |>  min() >= 0 
simulated_immunization_data$immunization |>  max() <= 100
simulated_immunization_data$non_immunization |>  min() >= 0 
simulated_immunization_data$non_immunization |>  max() <= 100
simulated_immunization_data$number_of_childeren |> min() >= 0
simulated_immunization_data$Health_record + simulated_immunization_data$Mother_record == simulated_immunization_data$immunization
100 - simulated_immunization_data$immunization == simulated_immunization_data$non_immunization
simulated_immunization_data$variables |> class() =='character'
simulated_immunization_data$Health_record |> class() =='numeric'
simulated_immunization_data$Mother_record |> class() =='numeric'
simulated_immunization_data$immunization |> class() =='numeric'
simulated_immunization_data$non_immunization |> class() =='numeric'
simulated_immunization_data$number_of_childeren |> class() =='numeric'

