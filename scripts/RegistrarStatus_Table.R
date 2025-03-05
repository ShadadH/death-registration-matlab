# summary_table.R - Generate a summary table of registrar status
# Run data_preprocessing.R before this script with source(data_preprocessing.R)
source("setup.R")

# Load cleaned data
data <- readRDS(here::here("data", "cleaned_data.rds"))

# Convert occupation_group to factor
data$occupation_group <- as.factor(data$occupation_group)

data$registrar_status <- case_when(
  (data$c5 == 1) | (data$c5 == 2 & !is.na(data$p3)) ~ "Registrar Was Found",
  data$c5 == 2 & is.na(data$p3) ~ "Registrar Not Found"
)

# Generate summary table
table_summary <- data %>%
  select(d_sex, d_age5, occupation_group, registrar_status, b3a) %>%
  tbl_summary(
    by = registrar_status,  
    statistic = list(all_categorical() ~ "{n} ({p}%)"),
    missing = "no",
    label = list(
      d_sex ~ "Sex of Deceased",
      b3a ~ "Education of Deceased",
      d_age5 ~ "Age Group of Deceased",
      occupation_group ~ "Occupation Group"
    )
  ) %>%
  add_p()  

print(table_summary)

# Save as an image
gt_tbl <- as_gt(table_summary)
gtsave(gt_tbl, file = here::here("outputs", "RegistrarStatus_Table.png"))
