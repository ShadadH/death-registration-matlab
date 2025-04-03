# 📊 Cross-Country Analysis of Death Registration Practices  
**Bangladesh · India · Guinea-Bissau**

This repository contains the data processing, analysis scripts, and outputs for a multi-country study on **civil death registration** practices and bottlenecks. The analysis focuses on who registers deaths, the relationship to the deceased, and administrative/documentation challenges across three countries.

---

## 🌍 Countries Covered

- 🇧🇩 **Bangladesh** – Matlab HDSS area  
- 🇮🇳 **India** – Ballabgarh region  
- 🇬🇼 **Guinea-Bissau** – Bissau region  

---

## 🧭 Project Objectives

- Estimate **who registers deaths** (registrar characteristics)
- Analyze **barriers to registration** (office visits, documentation, online access)
- Compare **registration completeness** by sex, age, and occupation of the deceased
- Inform **policy interventions** to increase registration rates

---

## 🗂️ Repository Structure
```
death-registration-matlab/
│
├── data/                            # Raw and cleaned survey data
│   ├── _Bissau_registered_Feb2025.dta
│   ├── Ballabgarh-registered-deaths.dta
│   ├── registered_deaths_matlab_complete.dta
│   ├── cleaned_data_bangladesh.rds
│   ├── cleaned_data_guinea.rds
│   └── cleaned_data_india.rds
│
├── outputs/                         # Exported plots and tables
│   ├── combined_plot.png
│   ├── RegistrarStatus_Table.png
│   ├── relation_plot_bd.jpeg
│   ├── relation_bar_plot_bd.png
│   ├── Hypothesis_1_Table_bd.png
│   └── Hypothesis_2_Table_bd.png
│
├── scripts/                         # All R scripts (cleaning + analysis + vizualizations)
│   ├── data_preprocessing_bangladesh.R
│   ├── data_preprocessing_india.R
│   ├── data_preprocessing_guinea.R
│   ├── relation_plot_bangladesh.R
│   ├── relation_plot_india.R
│   ├── relation_plot_guinea.R
│   ├── RegistrarStatus_Table.R
│   ├── significance_test_bangladesh.R
│   └── combined_plot.R
│
├── sandbox/                         # Experimental or draft files
│   └── DeathRegistration_initial_script.R
│
├── setup.R                          # Loads packages and sets paths
├── death-registration-matlab.Rproj  # RStudio project file
├── README.md                        # Project documentation
├── .gitignore
└── .Rhistory / .RData               # Auto-generated session files
```
---

## 👥 Contributors

[Shadad Hossain] — Data cleaning, R scripting, visualization

[Stephane Helleringer] — Principal Investigator


