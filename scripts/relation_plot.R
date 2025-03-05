# relation_plot.R - Relationship between deceased and registrants
# Run data_preprocessing.R before this script with source(data_preprocessing.R)

source("setup.R")

# Load cleaned data
data <- readRDS(here::here("data", "cleaned_data.rds"))

# Filter out unknown relationships
data_filtered <- data %>%
  filter(relation_group != "Unknown")

# Relationship Mosaic Plot
ggplot(data_filtered) +
  geom_mosaic(aes(weight = 1, x = product(age_group_broad), fill = relation_group)) +
  labs(
    title = "Relationship Between Deceased and Registrar by Age Group",
    x = "\nAge Group of Deceased",
    y = "Proportion",
    fill = "Relationship Type"
  ) +
  theme_minimal() +
  theme(
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 10),
    axis.text.x = element_text(angle = 90, hjust = 1, size = 8)
  ) +
  facet_wrap(~ d_sex)

# Save the plot
ggsave(here::here("outputs", "relation_plot.jpeg"), width = 8, height = 6)

# Bar Plot
ggplot(data, aes(y = age_group_broad, fill = relation_group)) +
  geom_bar(position = "fill") +
  labs(
    title = "Distribution of Relationship to Deceased by Age Group",
    y = "Age Group of Deceased",
    x = "Proportion",
    fill = "Relationship Type"
  ) +
  theme_minimal() +
  facet_wrap(~ d_sex)

# Save the bar plot
ggsave(here::here("outputs", "relation_bar_plot.png"), width = 8, height = 6)
