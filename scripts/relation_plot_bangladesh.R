#Visualization of Relationship Between Deceased and Registrants --------
# Load Dependencies -------------------------------------------------------

source("setup.R")

# Load Data --------------------------------------------------------------

data_bd <- readRDS(here::here("data", "cleaned_data_bangladesh.rds"))

# Filter Out Unknown Relationships ---------------------------------------

data_filtered_bd <- data_bd %>%
  filter(relation_group != "Unknown") %>%
  mutate(relation_group = droplevels(relation_group))

# Mosaic Plot ------------------------------------------------------------

mosaic_bd <- ggplot(data_filtered_bd) +
  geom_mosaic(
    aes(weight = 1, x = product(age_group_broad), fill = relation_group),
    offset = 0
  ) +
  scale_y_continuous(
    breaks = seq(0, 1, by = 0.25),
    labels = c("0%", "25%", "50%", "75%", "100%")
  ) +
  labs(
    title = "Bangladesh",
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
  facet_wrap(~d_sex)

# Save Mosaic Plot -------------------------------------------------------

ggsave(
  filename = here::here("outputs", "relation_plot_bd.jpeg"),
  plot = mosaic_bd,
  width = 8,
  height = 6,
  dpi = 300
)

# Bar Plot ---------------------------------------------------------------

bar_plot_bd <- ggplot(data_filtered_bd, aes(y = age_group_broad, fill = relation_group)) +
  geom_bar(position = "fill") +
  labs(
    title = "Distribution of Relationship to Deceased by Age Group",
    y = "Age Group of Deceased",
    x = "Proportion",
    fill = "Relationship Type"
  ) +
  theme_minimal() +
  facet_wrap(~d_sex)

# Save Bar Plot ----------------------------------------------------------

ggsave(
  filename = here::here("outputs", "relation_bar_plot_bd.png"),
  plot = bar_plot_bd,
  width = 8,
  height = 6,
  dpi = 300
)
