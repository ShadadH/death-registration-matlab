source("setup.R")

data_ke <- readRDS(here::here("data", "cleaned_data_kenya.rds"))

ke_filtered <- data_ke |>
  filter(age_group_broad != "Unknown", relation_group != "Unknown") |>
  droplevels()

# Mosaic Plot -------------------------------------------------------------
mosaic_ke <- ggplot(ke_filtered) +
  ggmosaic::geom_mosaic(
    aes(weight = 1, x = product(age_group_broad), fill = relation_group),
    offset = 0,
    color = "black"
  ) +
  scale_y_continuous(
    breaks = seq(0, 1, by = 0.25),
    labels = scales::percent_format(accuracy = 1)
  ) +
  labs(
    title = "Kenya",
    x = "\nAge Group of Deceased",
    y = "Proportion (%)",
    fill = "Relationship Type"
  ) +
  scale_fill_manual(values = relation_colors) +
  theme_minimal() +
  theme(
    axis.text.y   = element_text(size = 10),
    axis.ticks.y  = element_line(),
    axis.ticks.x  = element_line(),
    legend.title  = element_text(size = 12),
    legend.text   = element_text(size = 10),
    axis.text.x   = element_text(angle = 90, hjust = 1, size = 8)
  ) +
  facet_wrap(~ Gender)

print(mosaic_ke)

# Save Mosaic Plot -------------------------------------------------------

ggsave(
  filename = here::here("outputs", "relation_plot_ke.jpeg"),
  plot = mosaic_ke,
  width = 8,
  height = 6,
  dpi = 300
)