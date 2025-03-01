
install.packages("gt")       # Required for gtsummary export
install.packages("webshot2") # Needed for saving as image
install.packages("usethis")

# Load libraries
library(gt)
library(webshot2)
library(haven)
library(labelled)
library(dplyr)
library(ggplot2)
library(gtsummary)

setwd("~/death-registration-matlab")

data <- read_dta("registered_deaths_matlab_complete.dta")
View(data)

# Extract and print variable labels
var_labels <- var_label(data)
print(var_labels)

# Create the new binary variable
data$registration_performer_interviewed <- ifelse(data$c5 == 2, 1, 0)

# Convert categorical variables to factors
data$d_sex <- factor(data$d_sex, levels = c(1, 2), labels = c("Male", "Female"))
data$b3a <- factor(data$b3a, levels = c(1, 2, 3), labels = c("Primary", "Secondary", "Higher"))
library(dplyr)

# \create occupation_group
data <- data %>%
  mutate(
    # Convert b4 to a labeled factor 
    b4 = factor(b4, levels = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 77, 89),
                labels = c("Farmer", "Fisherman", "Rickshaw/Van/Auto driver", "Shopkeeper", "Teacher", 
                           "Medicine Seller", "Grocers", "Dai", "Community Health Worker", "Maid", 
                           "Garment Worker", "Student", "Govt. Employee", "Private Employee", 
                           "Disabled (physical/mental)", "Business", "Other", "Refused to Answer")),
    
    # Define broader occupation categories
    occupation_group = case_when(
      b4 %in% c("Farmer", "Fisherman", "Shopkeeper", "Business", "Grocers", "Medicine Seller") ~ "Self-Employed",
      b4 %in% c("Teacher", "Govt. Employee", "Private Employee") ~ "Formal Employment",
      b4 == "Student" ~ "Student",  # Keep "Student" as its own category
      b4 %in% c("Maid", "Community Health Worker", "Dai") ~ "Domestic & Health Workers",
      b4 %in% c("Disabled (physical/mental)", "Other", "Refused to Answer") ~ "Other or Unknown",
      TRUE ~ "Unknown"  # Catch-all for any missing/unexpected values
    )
  )

# Convert occupation_group to a factor for proper formatting
data$occupation_group <- as.factor(data$occupation_group)


# Convert to factor for better formatting in tables
data$occupation_group <- as.factor(data$occupation_group)
data$registration_performer_interviewed <- factor(data$registration_performer_interviewed, 
                                                  levels = c(0, 1), 
                                                  labels = c("Yes", "No"))

var_label(data$registration_performer_interviewed) <- "Was the Registration Performer Interviewed During Initial Interview?"



# Assign characteristics based on who registered the death
data$registrar_sex <- ifelse(data$c5 == 1, data$a1, data$p3)  
data$registrar_age <- ifelse(data$c5 == 1, data$a2b, data$p4b)  
data$registrar_education <- ifelse(data$c5 == 1, data$a3a, data$p5a)  

# Assign registration experience variables
data$registration_location <- ifelse(data$c5 == 1, data$c9, data$p9)
data$registration_online <- ifelse(data$c5 == 1, data$c10, data$p8)
data$documents_submitted <- ifelse(data$c5 == 1, data$c13, data$p11)
data$difficulties_faced <- ifelse(data$c5 == 1, data$c15, data$p13)
data$registration_visits <- ifelse(data$c5 == 1, data$c16, data$p14)
data$staff_behavior <- ifelse(data$c5 == 1, data$c17, data$p15)

# Labels for registration performer characteristics
var_label(data$registrar_sex) <- "Sex of the person who registered the death"
var_label(data$registrar_age) <- "Age of the person who registered the death"
var_label(data$registrar_education) <- "Highest level of education of the person who registered the death"

# Labels for registration experience variables
var_label(data$registration_location) <- "Location where the death was registered"
var_label(data$registration_online) <- "Was the death registration completed online?"
var_label(data$documents_submitted) <- "Documents submitted for death registration"
var_label(data$difficulties_faced) <- "Difficulties faced during death registration"
var_label(data$registration_visits) <- "Number of visits to complete the death registration"
var_label(data$staff_behavior) <- "Behavior of staff at the registration office"


# Convert staff behavior to ordered factor
data$staff_behavior <- factor(data$staff_behavior, 
                              levels = c(1, 2, 3, 4, 5), 
                              labels = c("Very Pleasant", "Pleasant", "Average", "Unpleasant", "Very Unpleasant"),
                              ordered = TRUE)

# Convert '88' in registration visits to NA
data$registration_visits <- ifelse(data$registration_visits == 88, NA, data$registration_visits)

# Boxplot for number of visits vs. staff behavior (excluding 88)
ggplot(data, aes(x = staff_behavior, y = registration_visits)) +
  geom_boxplot(fill = "lightblue") +
  labs(title = "Effect of Registration Visits on Staff Behavior",
       x = "Staff Behavior",
       y = "Number of Visits") +
  theme_minimal()


data$registrar_status <- case_when(
  (data$c5 == 1) | (data$c5 == 2 & !is.na(data$p3)) ~ "Registrar Was Found",
  data$c5 == 2 & is.na(data$p3) ~ "Registrar Not Found"
)



# Generate summary table comparing registrar status
table_summary <- data %>%
  select(d_sex, d_age5, occupation_group, registrar_status, b3a) %>%
  tbl_summary(
    by = registrar_status,  # Compare "Registrar Was Found" vs "Registrar Not Found"
    statistic = list(
      all_categorical() ~ "{n} ({p}%)"
    ),
    missing = "no",
    label = list(
      d_sex ~ "Sex of Deceased",
      b3a ~ "Education of Deceased",
      d_age5 ~ "Age Group of Deceased",
      occupation_group ~ "Occupation Group"
    )
  ) %>%
  add_p()  # Adds p-values for statistical comparison

# Print the table
table_summary

gt_tbl <- as_gt(table_summary)

# Save as an image
gtsave(gt_tbl, file = "gtsummary_table.png")

#Relation to Deceased

data$relation_to_deceased <- case_when(
  data$c5 == 1 ~ as.character(data$b1),  # If informant registered, use B1
  data$c5 == 2 ~ as.character(data$p6),  # If different registrant, use P6
  TRUE ~ "Unknown"
)

# Convert to factor
data$relation_to_deceased <- as.factor(data$relation_to_deceased)

# Check if it worked
table(data$relation_to_deceased, useNA = "always")


# Define age groups
data$age_group_broad <- case_when(
  data$d_age >= 15 & data$d_age <= 34 ~ "15-34 years",
  data$d_age >= 35 & data$d_age <= 59 ~ "35-59 years",
  data$d_age >= 60 & data$d_age <= 79 ~ "60-79 years",
  data$d_age >= 80 ~ "80+ years",
  TRUE ~ "Unknown"
)

# Convert to factor
data$age_group_broad <- as.factor(data$age_group_broad)

# Check distribution
table(data$age_group_broad, useNA = "always")



# Define broader relationship categories
data$relation_to_deceased <- case_when(
  data$c5a %in% c(1, 5, 7, 9) ~ "Immediate Family (Parents, Sibling, Spouse, Child)",
  data$c5a %in% c(2, 3, 4, 6, 8, 10, 12) ~ "Extended Family (In-laws, Nephew/Niece, Grandparent, Uncle/Aunt)",
  data$c5a == 11 ~ "Grandchild",
  data$c5a == 77 ~ "Other",
  TRUE ~ "Unknown"
)

data$relation_to_deceased <- as.factor(data$relation_to_deceased)

# Check distribution
table(data$relation_to_deceased, useNA = "always")

# Create broader relationship categories from relation_to_deceased
data <- data %>%
  mutate(
    relation_group = case_when(
      relation_to_deceased == 9 ~ "Spouse",  # 9 = Spouse
      relation_to_deceased == 1 ~ "Parent",  # 1 = Parent
      relation_to_deceased == 7 ~ "Sibling", # 7 = Sibling
      relation_to_deceased == 11 ~ "Grandchild",  # 11 = Grandchild
      relation_to_deceased %in% c(2, 3, 4, 5, 6, 8, 10, 12) ~ "Extended Family", # In-laws, Uncle/Aunt, Grandparent, Nephew/Niece
      relation_to_deceased == 77 ~ "Other",       # 77 = Other
      TRUE ~ "Unknown"  # Catch-all for missing/invalid values
    )
  )

# Convert to factor for better formatting
data$relation_group <- as.factor(data$relation_group)

# Check the distribution
table(data$relation_group, useNA = "always")

#Plots

ggplot(data, aes(y = age_group_broad, fill = relation_group)) +
  geom_bar(position = "fill") +  # Stacked proportion bars
  labs(
    title = "Distribution of Relationship to Deceased by Age Group",
    y = "Age Group of Deceased",
    x = "Proportion",
    fill = "Relationship Type"
  ) +
  theme_minimal() +
  facet_wrap(~ d_sex)  # Separate plots by gender

# Cross Tabulation
table_c5a_p6 <- table(data$c5a, data$p6, useNA = "always")

# Print the table, the resulting matrix should tell us about discrepancies
table_c5a_p6



