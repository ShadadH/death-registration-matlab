# data_cleaning_guinea.R — Load and Clean Kenya Dataset ----------

source("setup.R")
library(stringr)
library(readxl)

raw_ke <- read_excel("data/Kenya_Deaths_Registered (120925).xlsx")

ke <- raw_ke |>
  mutate(
    # numeric age, ignoring units for now
    age_num = suppressWarnings(as.numeric(Age)),
    
    age_group_broad = case_when(
      age_num >= 15 & age_num <= 59 ~ "15–59 years",
      age_num >= 60 & age_num <= 79 ~ "60–79 years",
      age_num >= 80                 ~ "80+ years",
      TRUE                          ~ "Unknown"
    ),
    age_group_broad = factor(age_group_broad,
                             levels = c("15–59 years","60–79 years","80+ years","Unknown")),
    
    Gender         = factor(Gender, levels = c("Female","Male")),
    Who_regd_death = ifelse(
      Who_regd_death %in% c("", "NA", "N/A", "Unknown", "Not Stated"),
      "Unknown", Who_regd_death
    ),
    Who_regd_death = factor(Who_regd_death)
  )

saveRDS(ke, here::here("data", "cleaned_data_kenya.rds"))
