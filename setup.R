#Install and load required packages ---------------------------------------------

if (!require("pacman")) install.packages("pacman")
pacman::p_load(gt, webshot2, haven, labelled, dplyr, ggplot2, gtsummary, here, ggmosaic, patchwork)

relation_colors <- c(
  "Extended Family" = "#66C2A5",  # teal green
  "Other"           = "#FC8D62",  # soft orange
  "Parent"          = "#8DA0CB",  # periwinkle blue
  "Child"           = "#E78AC3",  # rose pink
  "Sibling"         = "#A6D854",  # lime green
  "Spouse"          = "#FFD92F",  # warm yellow
  "Unknown"         = "#B3B3B3"   # neutral gray
)

