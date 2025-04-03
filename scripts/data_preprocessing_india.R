# data_preprocessing.R — Load and Clean India Dataset -------------------------

source("setup.R")

# Load Raw Data ----------------------------------------------------------

data <- read_dta(here::here("data", "Ballabgarh-registered-deaths.dta"))

# View Variable Labels ---------------------------------------------------

var_labels <- var_label(data)
print(var_labels)

# Create Broad Age Groups ------------------------------------------------

data <- data %>%
  mutate(
    age_group_broad = case_when(
      deceased_current_age >= 15 & deceased_current_age <= 34 ~ "15-34 years",
      deceased_current_age >= 35 & deceased_current_age <= 59 ~ "35-59 years",
      deceased_current_age >= 60 & deceased_current_age <= 79 ~ "60-79 years",
      deceased_current_age >= 80 ~ "80+ years",
      TRUE ~ "Unknown"
    ),
    age_group_broad = factor(age_group_broad)
  )

# Create Relationship Grouping -------------------------------------------

data <- data %>%
  mutate(
    relation_group = case_when(
      respondent_relation == 9 ~ "Spouse",
      respondent_relation == 1 ~ "Parent",
      respondent_relation == 7 ~ "Sibling",
      respondent_relation == 11 ~ "Grandchild",
      respondent_relation %in% c(2, 3, 4, 5, 6, 8, 10, 12) ~ "Extended Family",
      TRUE ~ "Unknown"
    ),
    relation_group = factor(relation_group)
  )

# Save Cleaned Dataset ---------------------------------------------------

saveRDS(data, here::here("data", "cleaned_data_india.rds"))
