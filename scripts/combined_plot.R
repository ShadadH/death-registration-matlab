# Load Dependencies -------------------------------------------------------

source("setup.R")
source("scripts/relation_plot_bangladesh.R")
source("scripts/relation_plot_india.R")
source("scripts/relation_plot_guinea.R")


# Combine Country Plots --------------------------------------------------

final_plot <- (mosaic_bd) /
  (mosaic_gb) +
  plot_annotation(title = "Relationship Between Deceased and Registrant by Age Group")

# Display Plot -----------------------------------------------------------

final_plot

# Save Plot --------------------------------------------------------------

ggsave(
  filename = here::here("outputs", "combined_plot.png"),
  plot = final_plot,
  width = 8,
  height = 16,
  units = "in",
  dpi = 300
)
