# Verval-Studie: VOC Stability in Nalophan Bags

This repository contains the code and data used in the time trend analysis of volatile organic compound (VOC) degradation in Nalophan bags. The study investigates how VOC signals change over consecutive days, providing insight into sample stability in breathomics research.

**Title:**  
VOC Degradation Patterns in Nalophan Sample Bags Across Multiple Days

**Authors:**  
Bart Bruijnen, BSc Biomedical Sciences  
Maastricht University, FHML

Leyla Vervoort, BSc Biomedical Sciences  
Maastricht University, FHML

**Date:**  
2025

## Repository Structure

```
├── DATA VERVAL Scripie Leyla.xlsx       # Original VOC intensity dataset (per subject, day, and area)
├── Data Analysis Verval Studie.xlsx     # Output from R: differences and significance results
├── VOC_TimeTrend_Results.xlsx           # Additional summary statistics or per-area trends
├── PVALUE (4).ipynb                     # Jupyter Notebook: Python significance & heatmap analysis
├── Verval Studie.R                      # R script for time series and statistical comparisons
├── README.md                            # Project documentation (this file)
```

## Project Description

VOC samples were collected and stored in Nalophan bags and analyzed over five consecutive days. The study aimed to determine:

- The **magnitude of VOC signal change** over time
- The **statistical significance** of these changes per subject and area
- The **consistency of signal loss or degradation** across compound classes

This is relevant for ensuring the reliability of GC-IMS breath data in clinical workflows when immediate analysis isn't possible.

---

## Key Analysis Scripts

### `Verval Studie.R`  
This R script processes and analyzes day-to-day differences in VOC intensity using:

- Data reshaping (`pivot_longer`, `pivot_wider`)
- Paired difference computation
- Paired t-tests or Wilcoxon tests (depending on assumptions)
- Output export to Excel for reporting

### `PVALUE (4).ipynb`  
This Python notebook performs:

- Heatmap visualizations of absolute VOC changes per subject
- Paired t-tests across all area columns for each subject
- -log10(p) heatmaps to highlight significant degradation patterns
- Full VOC area matrix plotting with seaborn and matplotlib

---

## Example Visuals

**1. Mean VOC Signal Change per Subject**  
Each cell reflects the average absolute difference in signal between two days for a subject.

**2. Significance Heatmaps**  
- `-log10(p-value)` per subject for each day comparison  
- Stronger color = more statistically significant change

These plots help visualize both **effect size** and **significance** of temporal degradation.

---

## How to Run

### 1. R (for preprocessing and basic analysis)

Install necessary packages if not yet available:

```r
packages <- c("readxl", "dplyr", "tidyr", "pheatmap", "writexl", "tibble")
installed <- packages %in% rownames(installed.packages())
if (any(!installed)) install.packages(packages[!installed])

### 2. R (Main Analysis)

Run the main script in R:

```r
source("Verval Studie.R")
```

This will output:

- **Data Analysis Verval Studie.xlsx**:  
  Includes per-subject differences and per-area statistical tests.

### 3. Python (for heatmaps and extended stats)

Required libraries:

```bash
pip install pandas numpy matplotlib seaborn scipy
```

Then open `PVALUE (4).ipynb` in Jupyter Notebook or VSCode and run all cells.

---

## Background

Nalophan bags are commonly used for breath sample collection. However, storage time may lead to VOC degradation due to diffusion, chemical reaction, or adsorption.  
This project tests the temporal stability of VOC signatures and supports best practices for sample handling.

---

## License

This repository is for academic use only. Contact the author for reuse or collaboration.

---

## Contact

**Bart Bruijnen**  
GitHub: [@Bardootjeb](https://github.com/Bardootjeb)  
Maastricht University – FHML
