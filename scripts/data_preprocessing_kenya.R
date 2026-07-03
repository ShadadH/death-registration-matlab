# data_cleaning_guinea.R — Load and Clean Kenya Dataset ----------

source("setup.R")

raw_ke <- read_excel("data/Kenya_Deaths_Registered (120925).xlsx")

ke <- raw_ke |>
  mutate(
    # numeric age, ignoring units for now
    age_num = suppressWarnings(as.numeric(Age)),

    age_group_broad = case_when(
      age_num >= 15 & age_num <= 29 ~ "15-29 years",
      age_num >= 30 & age_num <= 59 ~ "30-59 years",
      age_num >= 60 & age_num <= 79 ~ "60-79 years",
      age_num >= 80                 ~ "80+ years",
      TRUE                          ~ "Unknown"
    ),
    age_group_broad = factor(age_group_broad,
                             levels = c("15-29 years", "30-59 years", "60-79 years", "80+ years", "Unknown")),

    Gender         = factor(Gender, levels = c("Female","Male")),
    Who_regd_death = ifelse(
      Who_regd_death %in% c("", "NA", "N/A", "Unknown", "Not Stated"),
      "Unknown", Who_regd_death
    ),
    Who_regd_death = factor(Who_regd_death),

    # Kenya's question asks "relative to the deceased, who was the registrant?"
    # while Bangladesh/Guinea-Bissau ask "relative to the registrant, who was
    # the deceased?" -- these are inverse framings of the same relationship,
    # so Parent/Child must be swapped to harmonize with the other sites'
    # convention (relation_group values elsewhere describe the deceased's
    # relationship to the registrant).
    relation_group = case_when(
      Who_regd_death == "Child"  ~ "Parent",
      Who_regd_death == "Parent" ~ "Child",
      TRUE                       ~ as.character(Who_regd_death)
    ),
    relation_group = factor(relation_group,
                            levels = c("Extended Family", "Other", "Parent", "Child", "Sibling", "Spouse", "Unknown"))
  )

saveRDS(ke, here::here("data", "cleaned_data_kenya.rds"))
