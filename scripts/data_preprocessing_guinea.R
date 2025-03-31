# data_cleaning.R - Load and clean data
source("setup.R")

# Read data using `here()` to avoid using setwd()
data <- read_dta(here::here("data","registered_deaths_matlab_complete.dta"))

data <- read_dta("~/Downloads/_Bissau_registered_Feb2025.dta")

# Extract and print variable labels
var_labels <- var_label(data)
print(var_labels)

data <- data %>%
  mutate(
    d_sex = factor(sex, levels = c(1, 2), labels = c("Male", "Female")))

# Define age groups
data$age_group_broad <- case_when(
  data$ageatdeath >= 15 & data$ageatdeath <= 34 ~ "15-34 years",
  data$ageatdeath >= 35 & data$ageatdeath <= 59 ~ "35-59 years",
  data$ageatdeath >= 60 & data$ageatdeath <= 79 ~ "60-79 years",
  data$ageatdeath >= 80 ~ "80+ years",
  TRUE ~ "Unknown"
)

# Convert to factor
data$age_group_broad <- as.factor(data$age_group_broad)

relation_df <- data %>%
  select(youreg, relationwdeaceased, relationregdeceased, relation_to_deceased, relation_group)

data$relation_to_deceased <- coalesce(data$relationregdeceased, data$relationwdeaceased)

#Relationship Group
data <- data %>%
  mutate(
    relation_group = case_when(
      relation_to_deceased == 9 ~ "Spouse",  # 9 = Spouse
      relation_to_deceased == 1 ~ "Parent",  # 1 = Parent
      relation_to_deceased == 7 ~ "Sibling", # 7 = Sibling
      relation_to_deceased == 11 ~ "Grandchild",  # 11 = Grandchild
      relation_to_deceased %in% c(2, 3, 4, 5, 6, 8, 10, 12) ~ "Extended Family", # In-laws, Uncle/Aunt, Grandparent, Nephew/Niece
      TRUE ~ "Unknown"  # Catch-all for missing/invalid values
    )
  )

# Convert to factor for better formatting
data$relation_group <- as.factor(data$relation_group)


# Save cleaned dataset
saveRDS(data, file = here::here("data", "cleaned_data_guinea.rds"))

