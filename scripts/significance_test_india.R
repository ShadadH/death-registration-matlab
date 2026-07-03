
source("setup.R")

# Load cleaned data
data <- readRDS(here::here("data", "cleaned_data_india.rds"))

#Hypothesis 1

# NOTE: as of this data pull, `deceased_sex` in the raw .dta file is "Male"
# for all 149 records (0 females) -- this looks like a data export issue in
# the source file rather than a true sex distribution, and should be
# reverified against the original survey data. Hypothesis 1 needs both sexes
# represented, so it's skipped with a placeholder row when a sex level is
# entirely missing, rather than crashing or fabricating a result.

male_data <- subset(data, deceased_sex == "Male")
female_data <- subset(data, deceased_sex == "Female")

run_chisq_by_group <- function(subset_data) {
  if (nrow(subset_data) == 0) return(NULL)
  tbl <- table(subset_data$age_group_broad, subset_data$relation_group)
  tbl_clean <- tbl[rowSums(tbl) > 0, colSums(tbl) > 0, drop = FALSE]
  if (nrow(tbl_clean) < 2 || ncol(tbl_clean) < 2) return(NULL)
  chisq.test(tbl_clean)
}

test_male <- run_chisq_by_group(male_data)
test_female <- run_chisq_by_group(female_data)

na_row <- function(test, label) {
  if (is.null(test)) {
    data.frame(Gender = label, Chi_Squared = NA, df = NA, p_value = NA, Significant = "Not computable (insufficient data)")
  } else {
    data.frame(
      Gender = label,
      Chi_Squared = test$statistic,
      df = test$parameter,
      p_value = test$p.value,
      Significant = ifelse(test$p.value < 0.05, "Yes", "No")
    )
  }
}

hyp1_results <- rbind(
  na_row(test_male, "Male"),
  na_row(test_female, "Female")
)

Hyp1_Table <- hyp1_results %>%
  mutate(p_value = round(p_value, 5)) %>%
  gt() %>%
  tab_header(
    title = "India — Hypothesis 1: Association Between Age Group and Type of Registrant",
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
      palette = c("No" = "lightgray", "Yes" = "lightgreen", "Not computable (insufficient data)" = "lightyellow"),
      domain = c("No", "Yes", "Not computable (insufficient data)")
    )
  )

gtsave(Hyp1_Table, filename = here::here("outputs", "Hypothesis_1_Table_ind.png"))


#Hypothesis 2

# Get unique age groups
age_groups <- unique(data$age_group_broad)

results_list <- list()

for (group in age_groups) {
  subset_group <- subset(data, age_group_broad == group)

  # Remove missing gender or relationship
  subset_group <- subset_group[!is.na(subset_group$deceased_sex) & !is.na(subset_group$relation_group), ]

  tbl <- table(subset_group$deceased_sex, subset_group$relation_group)
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

if (is.null(results_df)) {
  # deceased_sex has only one level ("Male") in the current data pull, so
  # every age group is skipped -- see note above Hypothesis 1.
  results_df <- data.frame(
    Age_Group = "All",
    Chi_Squared = NA,
    df = NA,
    p_value = NA,
    Significant = "Not computable (deceased_sex has only one level in source data)"
  )
}

Hyp2_Table <- results_df %>%
  gt() %>%
  tab_header(
    title = "India — Chi-squared Test: Relationship Type by Gender (within Age Group)",
    subtitle = "Significance of difference in registrant type between Male and Female for each age group"
  ) %>%
  fmt_number(columns = c(p_value), decimals = 4) %>%
  data_color(
    columns = c(Significant),
    colors = scales::col_factor(
      palette = c(
        "No" = "lightgray",
        "Yes" = "lightgreen",
        "Not computable (deceased_sex has only one level in source data)" = "lightyellow"
      ),
      domain = c("No", "Yes", "Not computable (deceased_sex has only one level in source data)")
    )
  )

gtsave(Hyp2_Table, filename = here::here("outputs", "Hypothesis_2_Table_ind.png"))
