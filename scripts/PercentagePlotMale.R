source("setup.R")

# Load Data --------------------------------------------------------------

data_bd <- readRDS(here::here("data", "cleaned_data_bangladesh.rds"))
data_gb <- readRDS(here::here("data", "cleaned_data_guinea.rds"))
data_ind <- readRDS(here::here("data", "cleaned_data_india.rds"))

var_labels <- var_label(data_ind)
print(var_labels)

# Plot the Graph ---------------------------------------

bd_plot <- data_bd %>%
  filter(registrar_sex %in% c(1, 2), !is.na(d_sex), !is.na(age_group_broad)) %>%
  group_by(d_sex, age_group_broad) %>%
  summarise(pct_male = mean(registrar_sex == 1) * 100, .groups = "drop") %>%
  ggplot(aes(x = age_group_broad, y = pct_male, fill = d_sex)) +
  geom_col(position = "dodge", width = 0.7) +
  geom_hline(yintercept = 50, linetype = "dashed", color = "red") +
  labs(
    title = "Bangladesh: % of Deaths Registered by Male",
    x = "Age Group of Deceased",
    y = "Percent Male Registrants",
    fill = "Sex of Deceased"
  ) +
  ylim(0, 100) +
  theme_minimal()


gb_plot <- data_gb %>%
  filter(
    registrant_sex %in% c(1, 2),                # Keep only known registrant sex
    !is.na(d_sex), 
    !is.na(age_group_broad), 
    age_group_broad != "Unknown"
  ) %>%
  group_by(d_sex, age_group_broad) %>%
  summarise(pct_male = mean(registrant_sex == 1) * 100, .groups = "drop") %>%
  ggplot(aes(x = age_group_broad, y = pct_male, fill = d_sex)) +
  geom_col(position = "dodge", width = 0.7) +
  geom_hline(yintercept = 50, linetype = "dashed", color = "red") +
  labs(
    title = "Guinea-Bissau: % of Deaths Registered by Male",
    x = "Age Group of Deceased",
    y = "Percent Male Registrants",
    fill = "Sex of Deceased"
  ) +
  ylim(0, 100) +
  theme_minimal()


ind_plot <- data_ind %>%
  filter(registrant_sex_code %in% c(1, 2), !is.na(deceased_sex), !is.na(age_group_broad), !(age_group_broad=="Unknown")) %>%
  group_by(deceased_sex, age_group_broad) %>%
  summarise(pct_male = mean(registrant_sex_code == 1) * 100, .groups = "drop") %>%
  ggplot(aes(x = age_group_broad, y = pct_male, fill = deceased_sex)) +
  geom_col(position = "dodge", width = 0.7) +
  geom_hline(yintercept = 50, linetype = "dashed", color = "red") +
  labs(
    title = "India: % of Deaths Registered by Male",
    x = "Age Group of Deceased",
    y = "Percent Male Registrants",
    fill = "Sex of Deceased"
  ) +
  ylim(0, 100) +
  theme_minimal()

ind_plot
gb_plot
bd_plot

