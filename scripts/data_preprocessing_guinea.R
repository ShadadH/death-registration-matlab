# data_cleaning_guinea.R — Load and Clean Guinea-Bissau Dataset ----------

source("setup.R")

# Load Raw Data ----------------------------------------------------------

data <- read_dta(here::here("data", "_Bissau_registered_Feb2025.dta"))

# View Variable Labels ---------------------------------------------------

var_labels <- var_label(data)
print(var_labels)

# Standardize Sex --------------------------------------------------------

data <- data %>%
  mutate(
    d_sex = factor(sex, levels = c(1, 2), labels = c("Male", "Female"))
  )

# Create Broad Age Groups ------------------------------------------------

data <- data %>%
  mutate(
    age_group_broad = case_when(
      ageatdeath >= 15 & ageatdeath <= 34 ~ "15-34 years",
      ageatdeath >= 35 & ageatdeath <= 59 ~ "35-59 years",
      ageatdeath >= 60 & ageatdeath <= 79 ~ "60-79 years",
      ageatdeath >= 80 ~ "80+ years",
      TRUE ~ "Unknown"
    ),
    age_group_broad = factor(age_group_broad)
  )

# Determine Relationship to Deceased -------------------------------------

data <- data %>%
  mutate(
    relation_to_deceased = coalesce(relationregdeceased, relationwdeaceased),
    relation_group = case_when(
      relation_to_deceased == 9 ~ "Spouse",
      relation_to_deceased == 1 ~ "Parent",
      relation_to_deceased == 7 ~ "Sibling",
      relation_to_deceased == 11 ~ "Grandchild",
      relation_to_deceased %in% c(2, 3, 4, 5, 6, 8, 10, 12) ~ "Extended Family",
      TRUE ~ "Unknown"
    ),
    relation_group = factor(relation_group)
  )

# Save Cleaned Dataset ---------------------------------------------------

saveRDS(data, here::here("data", "cleaned_data_guinea.rds"))
