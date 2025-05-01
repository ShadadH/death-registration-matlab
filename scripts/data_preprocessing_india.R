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
      deceased_current_age >= 15 & deceased_current_age <= 59 ~ "15-59 years",
      deceased_current_age >= 60 & deceased_current_age <= 79 ~ "60-79 years",
      deceased_current_age >= 80 ~ "80+ years",
      TRUE ~ "Unknown"
    ),
    age_group_broad = factor(age_group_broad)
  )

# Create Relationship Grouping -------------------------------------------

data <- data %>%
  mutate(
    # Step 1: Create a unified relationship code
    relation_code = case_when(
      q8_2 == 1 ~ 0,                   # Respondent
      q8_2 == -888 ~ q8_2_oth,         # Use q8_2_oth if not respondent
      TRUE ~ NA_real_
    ),
    
    # Step 2: Map to grouped relation categories
    relation_group = case_when(
      relation_code == 0 ~ "Other",  # Respondent itself – classify as Other
      relation_code == 1 ~ "Spouse",                # Wife/Husband
      relation_code == 2 ~ "Child",                 # Son/Daughter
      relation_code == 4 ~ "Parent",                # Parent
      relation_code == 7 ~ "Sibling",               # Brother/Sister
      relation_code %in% c(3, 5, 6, 8, 9, 10, 11, 12) ~ "Extended Family",
      relation_code %in% c(13, 14) ~ "Other",
      relation_code %in% c(-777) ~ "Unknown",
      TRUE ~ "Unknown"
    ),
    
    # Step 3: Set factor levels for ordering
    relation_group = factor(relation_group,
                            levels = c("Extended Family", "Other", "Parent", "Child", "Sibling", "Spouse", "Unknown"))
  )

# Create Resp Sex ---------------------------------------------------

data <- data %>%
  mutate(
    # Step 1: Use q8_2_sex when available, otherwise fallback to resp_sex
    registrant_sex_code = if_else(!is.na(q8_2_sex), q8_2_sex, respondent_sex),
    
    # Step 2: Label the values as "Male" or "Female"
    registrant_sex = case_when(
      registrant_sex_code == 1 ~ "Male",
      registrant_sex_code == 2 ~ "Female",
      TRUE ~ NA_character_
    ),
    
    # Step 3: Make it a factor with defined order
    registrant_sex = factor(registrant_sex, levels = c("Male", "Female"))
  )

# Save Cleaned Dataset ---------------------------------------------------

saveRDS(data, here::here("data", "cleaned_data_india.rds"))
