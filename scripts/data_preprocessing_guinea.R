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
      ageatdeath >= 15 & ageatdeath <= 59 ~ "15-59 years",
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
      relation_to_deceased == 1 ~ "Spouse",               # WIFE/HUSBAND
      relation_to_deceased == 2 ~ "Parent",               # PARENT
      relation_to_deceased == 6 ~ "Child",                # SON/DAUGHTER
      relation_to_deceased == 8 ~ "Sibling",              # BROTHER/SISTER
      relation_to_deceased %in% c(5, 9, 11) ~ "Extended Family", # GRANDCHILD, GRANDPARENT, OTHER RELATIVE
      relation_to_deceased == 10 ~ "Other",               # SOMEONE ELSE NOT RELATED
      relation_to_deceased == 98 ~ "Unknown",             # DON'T KNOW
      TRUE ~ "Unknown"                                    # All others (missing, etc.)
    ),
    relation_group = factor(relation_group,
                            levels = c("Extended Family", "Other", "Parent", "Child", "Sibling", "Spouse", "Unknown"))
  )



# Save Cleaned Dataset ---------------------------------------------------

saveRDS(data, here::here("data", "cleaned_data_guinea.rds"))
