source("setup.R")

data_ke <- readRDS(here::here("data", "cleaned_data_kenya.rds"))

ke_filtered <- data_ke |>
  filter(age_group_broad != "Unknown") |>
  droplevels()

# Mosaic Plot -------------------------------------------------------------
mosaic_ke <- ggplot(ke_filtered) +
  ggmosaic::geom_mosaic(
    aes(weight = 1, x = product(age_group_broad), fill = Who_regd_death),
    offset = 0
  ) +
  scale_y_continuous(
    breaks = seq(0, 1, by = 0.25),
    labels = scales::percent_format(accuracy = 1)
  ) +
  labs(
    title = "Kenya: Registrar of Death by Age Group",
    x = "\nAge Group",
    y = "Proportion (%)",
    fill = "Who Registered Death"
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