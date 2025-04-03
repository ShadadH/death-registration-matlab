# registrar_status_summary.R — Summary Table by Registrar Status ----------

source("setup.R")

# Load Cleaned Data ------------------------------------------------------

data <- readRDS(here::here("data", "cleaned_data_bangladesh.rds"))

# Format Variables -------------------------------------------------------

data <- data %>%
  mutate(
    occupation_group = as.factor(occupation_group),
    
    registrar_status = case_when(
      c5 == 1 | (c5 == 2 & !is.na(p3)) ~ "Registrar Was Found",
      c5 == 2 & is.na(p3) ~ "Registrar Not Found",
      TRUE ~ NA_character_
    )
  )

# Generate Summary Table -------------------------------------------------

table_summary <- data %>%
  select(d_sex, d_age5, occupation_group, registrar_status, b3a) %>%
  tbl_summary(
    by = registrar_status,
    statistic = list(all_categorical() ~ "{n} ({p}%)"),
    missing = "no",
    label = list(
      d_sex ~ "Sex of Deceased",
      d_age5 ~ "Age Group of Deceased",
      b3a ~ "Education of Deceased",
      occupation_group ~ "Occupation Group"
    )
  ) %>%
  add_p()  # Add p-values for group comparisons

# Output Table -----------------------------------------------------------

gt_tbl <- as_gt(table_summary)

# Save Table as PNG ------------------------------------------------------

gtsave(
  gt_tbl,
  filename = here::here("outputs", "RegistrarStatus_Table_Bangladesh.png")
)
