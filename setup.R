#Install and load required packages ---------------------------------------------

if (!require("pacman")) install.packages("pacman")
pacman::p_load(gt, webshot2, haven, labelled, dplyr, ggplot2, gtsummary, here, ggmosaic, patchwork)

relation_colors <- c(
  "Extended Family" = "#F4A582",
  "Other"           = "#BEBE4A",
  "Parent"          = "#92C5DE",
  "Child"           = "#FF0000",
  "Sibling"         = "#4393C3",
  "Spouse"          = "#C27BA0",
  "Unknown"         = "#CCCCCC"
)
