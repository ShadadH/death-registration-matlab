source("setup.R")

# Load cleaned data
data_ind <- readRDS(here::here("data", "cleaned_data_india.rds"))

# Filter out unknown relationships
data_filtered_ind <- data_ind %>%
  filter(relation_group != "Unknown")

data_filtered_ind$relation_group <- droplevels(data_filtered_ind$relation_group)

# Relationship Mosaic Plot
mosiac_ind <- ggplot(data_filtered_ind) +  
  geom_mosaic(aes(weight = 1, x = product(age_group_broad), fill = relation_group),
              offset = 0) +  
  scale_y_continuous(
    breaks = seq(0, 1, by = 0.25),
    labels = c("0%", "25%", "50%", "75%", "100%")
  ) +
  labs(
    title = "India",
    x = "\nAge Group of Deceased",
    y = "Proportion (%)",
    fill = "Relationship Type"
  ) +
  theme_minimal() +
  theme(
    axis.text.y = element_text(size = 10),
    axis.ticks.y = element_line(),
    axis.ticks.x = element_line(),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 10),
    axis.text.x = element_text(angle = 90, hjust = 1, size = 8)
  ) +
  facet_wrap(~ deceased_sex)

