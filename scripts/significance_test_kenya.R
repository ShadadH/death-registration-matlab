
source("setup.R")

# Load cleaned data
data <- readRDS(here::here("data", "cleaned_data_kenya.rds"))

#Hypothesis 1

# Split data by Gender
male_data <- subset(data, Gender == "Male")
female_data <- subset(data, Gender == "Female")

# Cross-tabulate Relationship and AgeGroup for males
table_male <- table(male_data$age_group_broad, male_data$relation_group)

# Remove columns and rows with all zeros
table_male_clean <- table_male[rowSums(table_male) > 0, colSums(table_male) > 0, drop = FALSE]
test_male <- chisq.test(table_male_clean)

# Repeat for females
table_female <- table(female_data$age_group_broad, female_data$relation_group)
table_female_clean <- table_female[rowSums(table_female) > 0, colSums(table_female) > 0, drop = FALSE]
test_female <- chisq.test(table_female_clean)

hyp1_results <- data.frame(
  Gender = c("Male", "Female"),
  Chi_Squared = c(test_male$statistic, test_female$statistic),
  df = c(test_male$parameter, test_female$parameter),
  p_value = c(test_male$p.value, test_female$p.value),
  Significant = ifelse(
    c(test_male$p.value, test_female$p.value) < 0.05, "Yes", "No"
  )
)

Hyp1_Table <- hyp1_results %>%
  mutate(p_value = round(p_value, 5)) %>%
  gt() %>%
  tab_header(
    title = "Kenya — Hypothesis 1: Association Between Age Group and Type of Registrant",
    subtitle = "Tested separately for each gender"
  ) %>%
  cols_label(
    Gender = "Gender",
    Chi_Squared = "Chi-squared",
    df = "Degrees of Freedom",
    p_value = "p-value",
    Significant = "Significant (p < 0.05)"
  ) %>%
  data_color(
    columns = c(Significant),
    colors = scales::col_factor(
      palette = c("No" = "lightgray", "Yes" = "lightgreen"),
      domain = c("No", "Yes")
    )
  )

gtsave(Hyp1_Table, filename = here::here("outputs", "Hypothesis_1_Table_ke.png"))


#Hypothesis 2

# Get unique age groups
age_groups <- unique(data$age_group_broad)

results_list <- list()

for (group in age_groups) {
  subset_group <- subset(data, age_group_broad == group)

  # Remove missing gender or relationship
  subset_group <- subset_group[!is.na(subset_group$Gender) & !is.na(subset_group$relation_group), ]

  tbl <- table(subset_group$Gender, subset_group$relation_group)
  tbl_clean <- tbl[rowSums(tbl) > 0, colSums(tbl) > 0, drop = FALSE]

  if (nrow(tbl_clean) > 1 && ncol(tbl_clean) > 1) {
    test_result <- chisq.test(tbl_clean)

    results_list[[group]] <- data.frame(
      Age_Group = group,
      Chi_Squared = round(test_result$statistic, 2),
      df = test_result$parameter,
      p_value = round(test_result$p.value, 4),
      Significant = ifelse(test_result$p.value < 0.05, "Yes", "No")
    )
  }
}

results_df <- do.call(rbind, results_list)

Hyp2_Table <- results_df %>%
  gt() %>%
  tab_header(
    title = "Kenya — Chi-squared Test: Relationship Type by Gender (within Age Group)",
    subtitle = "Significance of difference in registrant type between Male and Female for each age group"
  ) %>%
  fmt_number(columns = c(p_value), decimals = 4) %>%
  data_color(
    columns = c(Significant),
    colors = scales::col_factor(
      palette = c("No" = "lightgray", "Yes" = "lightgreen"),
      domain = c("No", "Yes")
    )
  )

gtsave(Hyp2_Table, filename = here::here("outputs", "Hypothesis_2_Table_ke.png"))
