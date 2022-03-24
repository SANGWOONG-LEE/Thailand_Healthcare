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
simulated_immunization_data <- 
  tibble(
    variables = 
      c(
        rep('Urban',1),
        rep('Rural',1),
        rep('North',1),
        rep('Northeast',1),
        rep('Central',1),
        rep('South',1),
        rep('Bangkok',1),
        rep('No_education',1),
        rep('Primary',1),
        rep('Secondary',1),
        rep('Higher',1),
        rep('Buddhist',1),
        rep('Islam',1)
      ),
    Health_record = 
      runif(n=13,
            min = 0,
            max = 100),
    Mother_record = 
      runif(n= 13,
            min = 0,
            max = 100 -Health_record),
    immunization = Mother_record + Health_record,
    non_immunization = 100 - immunization
  )




