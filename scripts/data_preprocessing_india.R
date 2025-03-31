# data_cleaning.R - Load and clean data
source("setup.R")

# Read data using `here()` 
data <- read_dta(here::here("data","Ballabgarh-registered-deaths.dta"))

# Extract and print variable labels
var_labels <- var_label(data)
print(var_labels)

# Define age groups
data$age_group_broad <- case_when(
  data$deceased_current_age >= 15 & data$deceased_current_age <= 34 ~ "15-34 years",
  data$deceased_current_age >= 35 & data$deceased_current_age <= 59 ~ "35-59 years",
  data$deceased_current_age >= 60 & data$deceased_current_age <= 79 ~ "60-79 years",
  data$deceased_current_age >= 80 ~ "80+ years",
  TRUE ~ "Unknown"
)

# Convert to factor
data$age_group_broad <- as.factor(data$age_group_broad)

# Create broader relationship categories from respnonded_relation
data <- data %>%
  mutate(
    relation_group = case_when(
      respondent_relation == 9 ~ "Spouse",  # 9 = Spouse
      respondent_relation == 1 ~ "Parent",  # 1 = Parent
      respondent_relation == 7 ~ "Sibling", # 7 = Sibling
      respondent_relation == 11 ~ "Grandchild",  # 11 = Grandchild
      respondent_relation %in% c(2, 3, 4, 5, 6, 8, 10, 12) ~ "Extended Family", # In-laws, Uncle/Aunt, Grandparent, Nephew/Niece
      TRUE ~ "Unknown"  # Catch-all for missing/invalid values
    )
  )

# Convert to factor for better formatting
data$relation_group <- as.factor(data$relation_group)

# Save cleaned dataset
saveRDS(data, file = here::here("data", "cleaned_data_india.rds"))
