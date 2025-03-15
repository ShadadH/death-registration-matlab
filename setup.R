#Install and load required packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(gt, webshot2, haven, labelled, dplyr, ggplot2, gtsummary, here, ggmosaic)
