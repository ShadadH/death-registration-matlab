# CLAUDE.md

Guidance for Claude Code when working in this repository.

## Project overview

Cross-country comparative analysis of **civil death registration practices** — who registers a death, their relationship to the deceased, and their sex, compared against the deceased's age/sex, across four HDSS/survey sites:

- 🇧🇩 Bangladesh — Matlab HDSS
- 🇮🇳 India — Ballabgarh region
- 🇬🇼 Guinea-Bissau — Bissau region
- 🇰🇪 Kenya — (added Sep 2025, least developed of the four — see "Kenya gaps" below)

All analysis is R, run from RStudio via `death-registration-matlab.Rproj`. There is no build/test pipeline — scripts are run manually and interactively.

## Repository structure

- `setup.R` — loads packages via `pacman::p_load` (gt, webshot2, haven, labelled, dplyr, ggplot2, gtsummary, here, ggmosaic, patchwork) and defines the shared `relation_colors` palette used across all mosaic plots. Every script starts with `source("setup.R")`.
- `data/` — raw inputs (`.dta`, `.xlsx`) and cleaned/processed outputs (`cleaned_data_<country>.rds`), the latter produced by the `data_preprocessing_*.R` scripts.
- `scripts/` — one `data_preprocessing_<country>.R` per country (clean raw data → save `.rds`), plus per-country `relation_plot_<country>.R` (mosaic plots), `PercentagePlotMale.R` (bar plots of % male registrant by deceased sex/age), `RegistrarStatus_Table.R`, `significance_test_bangladesh.R`, and `combined_plot.R` (stitches all countries' mosaic plots into one figure via `patchwork`).
- `outputs/` — exported PNG/JPEG plots and tables. Scripts read/write here via `here::here("outputs", ...)`.
- `sandbox/` — scratch/experimental scripts, not part of the pipeline.

## Conventions

- Scripts are self-contained: `source("setup.R")` first, then load whichever `cleaned_data_<country>.rds` files are needed via `readRDS(here::here("data", ...))`.
- No required run order between country scripts; `combined_plot.R` is the one script that depends on the others (it sources all four `relation_plot_*.R` scripts to build a combined mosaic figure).
- Column naming for "who registered the death" and their sex is **not standardized across countries** — watch for this when writing cross-country code:
  - Bangladesh: `registrar_sex` (1 = male / 2 = female), `d_sex`
  - Guinea-Bissau: `registrant_sex` (1/2), `d_sex`
  - India: `registrant_sex_code` (1/2), `deceased_sex`
  - Kenya: `Who_regd_death` (categorical relationship, not a sex code), `Gender` (deceased's sex)
- `relation_colors` (in `setup.R`) is the single shared fill palette for relationship-to-deceased categories (Extended Family, Other, Parent, Child, Sibling, Spouse, Unknown) — reuse it rather than redefining colors in individual scripts.

## Latest progress (as of the most recent commit, Sep 2025)

Most recent commits, newest first:
1. `a8f8fbe` "added kenya data and plot scripts, updated colors" — added Kenya raw data, `data_preprocessing_kenya.R`, `relation_plot_kenya.R` (mosaic plot only), wired Kenya's mosaic plot into `combined_plot.R`, and touched up `relation_colors`.
2. `7113ed4` / `564900b` — added a `registrant_sex` column to the Guinea-Bissau pipeline and updated `PercentagePlotMale.R` to include Guinea-Bissau alongside Bangladesh/India.

### Kenya integration is incomplete relative to the other three countries
Kenya was bolted on but did not receive the same treatment as Bangladesh/India/Guinea-Bissau:
- **No `PercentagePlotMale.R` entry** — Kenya has no `registrant_sex`/`registrar_sex`-equivalent numeric code (only `Who_regd_death`, a categorical relationship field), so the existing "% male registrant" bar-plot pattern can't be reused as-is; it would need a rethink of what "male registrant" means for Kenya's data.
- **No dedicated Kenya output saved** — `relation_plot_kenya.R` builds `mosaic_ke` and `print()`s it but never `ggsave()`s a standalone `outputs/Kenya *.png`, unlike Bangladesh/Guinea-Bissau/India which have their own saved plots in `outputs/`. It only appears inside `combined_plot.png`.
- **No `significance_test_kenya.R`** — only Bangladesh has a significance-test script.
- **No `RegistrarStatus_Table.R` entry for Kenya.**
- **README.md is stale** — still only lists Bangladesh/India/Guinea-Bissau; doesn't mention Kenya at all.

### Likely next steps
- Decide how to represent "registrant sex" for Kenya (may require re-deriving from raw data, or accepting `Who_regd_death` relationship categories as the Kenya-specific lens instead of a sex breakdown).
- Add a standalone Kenya mosaic plot export and consider a Kenya row in `PercentagePlotMale.R` / `RegistrarStatus_Table.R` if comparable fields can be derived.
- Update `README.md` to reflect Kenya as a fourth country and correct the repo structure listing (it's missing `CLAUDE.md`, `data/Kenya_Deaths_Registered (120925).xlsx`, `cleaned_data_kenya.rds`, `relation_plot_kenya.R`, `PercentagePlotMale.R`, and current `outputs/` contents).
