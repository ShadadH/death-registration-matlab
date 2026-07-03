# Load Dependencies -------------------------------------------------------

source("setup.R")

# Load Data ---------------------------------------------------------------

data_gb <- readRDS(here::here("data", "cleaned_data_guinea.rds"))

# Filter Data -------------------------------------------------------------

data_filtered_gb <- data_gb %>%
  filter(relation_group != "Unknown") %>%
  droplevels()

data_filtered_gb <- droplevels(data_filtered_gb)

# Create Mosaic Plot ------------------------------------------------------

mosaic_gb <- ggplot(data_filtered_gb) +
  geom_mosaic(
    aes(weight = 1, x = product(age_group_broad), fill = relation_group),
    offset = 0,
    color = "black"
  ) +
  scale_y_continuous(
    breaks = seq(0, 1, by = 0.25),
    labels = c("0%", "25%", "50%", "75%", "100%")
  ) +
  labs(
    title = "Guinea-Bissau",
    x = "\nAge Group of Deceased",
    y = "Proportion (%)",
    fill = "Relationship Type"
  ) +
  scale_fill_manual(values = relation_colors) +
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
  filename = here::here("outputs", "relation_plot_gb.jpeg"),
  plot = mosaic_gb,
  width = 8,
  height = 6,
  dpi = 300
)
