# data_preprocessing_bangladesh.R — Load and Clean Bangladesh Dataset --------------------

source("setup.R")

# Load Data --------------------------------------------------------------

data <- read_dta(here::here("data", "registered_deaths_matlab_complete.dta"))

# View Variable Labels ---------------------------------------------------

var_labels <- var_label(data)
print(var_labels)

# Create Binary Variable: Registration Performer Interviewed -------------

data <- data %>%
  mutate(registration_performer_interviewed = ifelse(c5 == 2, 1, 0))

# Convert and Label Categorical Variables --------------------------------

data <- data %>%
  mutate(
    d_sex = factor(d_sex, levels = c(1, 2), labels = c("Male", "Female")),
    b3a = factor(b3a, levels = c(1, 2, 3), labels = c("Primary", "Secondary", "Higher")),
    
    # Occupational Categories
    b4 = factor(
      b4,
      levels = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 77, 89),
      labels = c(
        "Farmer", "Fisherman", "Rickshaw/Van/Auto driver", "Shopkeeper",
        "Teacher", "Medicine Seller", "Grocers", "Dai", "Community Health Worker",
        "Maid", "Garment Worker", "Student", "Govt. Employee", "Private Employee",
        "Disabled (physical/mental)", "Business", "Other", "Refused to Answer"
      )
    ),
    
    occupation_group = case_when(
      b4 %in% c("Farmer", "Fisherman", "Shopkeeper", "Business", "Grocers", "Medicine Seller") ~ "Self-Employed",
      b4 %in% c("Teacher", "Govt. Employee", "Private Employee") ~ "Formal Employment",
      b4 == "Student" ~ "Student",
      b4 %in% c("Maid", "Community Health Worker", "Dai") ~ "Domestic & Health Workers",
      b4 %in% c("Disabled (physical/mental)", "Other", "Refused to Answer") ~ "Other or Unknown",
      TRUE ~ "Unknown"
    )
  )

# Merge Information on the Person Who Registered the Death --------------

data <- data %>%
  mutate(
    registrar_sex = ifelse(c5 == 1, a1, p3),
    registrar_age = ifelse(c5 == 1, a2b, p4b),
    registrar_education = ifelse(c5 == 1, a3a, p5a),
    registration_location = ifelse(c5 == 1, c9, p9),
    registration_online = ifelse(c5 == 1, c10, p8),
    documents_submitted = ifelse(c5 == 1, c13, p11),
    difficulties_faced = ifelse(c5 == 1, c15, p13),
    registration_visits = ifelse(c5 == 1, c16, p14),
    staff_behavior = ifelse(c5 == 1, c17, p15)
  )

# Add Variable Labels ----------------------------------------------------

var_label(data$registrar_sex) <- "Sex of the person who registered the death"
var_label(data$registrar_age) <- "Age of the person who registered the death"
var_label(data$registrar_education) <- "Highest level of education of the person who registered the death"

var_label(data$registration_location) <- "Location where the death was registered"
var_label(data$registration_online) <- "Was the death registration completed online?"
var_label(data$documents_submitted) <- "Documents submitted for death registration"
var_label(data$difficulties_faced) <- "Difficulties faced during death registration"
var_label(data$registration_visits) <- "Number of visits to complete the death registration"
var_label(data$staff_behavior) <- "Behavior of staff at the registration office"

# Fix and Format Specific Variables --------------------------------------

data <- data %>%
  mutate(
    staff_behavior = factor(
      staff_behavior,
      levels = c(1, 2, 3, 4, 5),
      labels = c("Very Pleasant", "Pleasant", "Average", "Unpleasant", "Very Unpleasant"),
      ordered = TRUE
    ),
    registration_visits = ifelse(registration_visits == 88, NA, registration_visits)
  )

# Relationship to Deceased -----------------------------------------------

data <- data %>%
  mutate(
    relation_to_deceased = case_when(
      c5 == 1 ~ as.character(b1),
      c5 == 2 ~ as.character(p6),
      TRUE ~ "Unknown"
    ),
    relation_to_deceased = factor(relation_to_deceased)
  )

# Create Age Groups ------------------------------------------------------

data <- data %>%
  mutate(
    age_group_broad = case_when(
      d_age >= 15 & d_age <= 34 ~ "15-34 years",
      d_age >= 35 & d_age <= 59 ~ "35-59 years",
      d_age >= 60 & d_age <= 79 ~ "60-79 years",
      d_age >= 80 ~ "80+ years",
      TRUE ~ "Unknown"
    ),
    age_group_broad = factor(age_group_broad)
  )

# Categorize Relationship Types ------------------------------------------

data <- data %>%
  mutate(
    relation_group = case_when(
      relation_to_deceased == 9 ~ "Spouse",
      relation_to_deceased == 1 ~ "Parent",
      relation_to_deceased == 7 ~ "Sibling",
      relation_to_deceased == 11 ~ "Grandchild",
      relation_to_deceased %in% c(2, 3, 4, 5, 6, 8, 10, 12) ~ "Extended Family",
      relation_to_deceased == 77 ~ "Other",
      TRUE ~ "Unknown"
    ),
    relation_group = factor(relation_group)
  )

# Save Cleaned Data ------------------------------------------------------

saveRDS(data, here::here("data", "cleaned_data_bangladesh.rds"))
