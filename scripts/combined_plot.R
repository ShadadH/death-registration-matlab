source("setup.R")

final_plot <- (mosiac_bd) / 
  (mosiac_ind) / 
  (mosiac_gb)

final_plot <- final_plot + plot_annotation(title = "Relationship Between Deceased and Registrant by Age Group")

final_plot

ggsave(here::here("outputs", "combined_plot.png"), 
       plot = final_plot, 
       width = 8, 
       height = 16, 
       units = "in", 
       dpi = 300)
