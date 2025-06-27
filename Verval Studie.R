# ==============================================================================
# Before running this script, ensure all required R packages are installed.
# Use the following command to install missing packages automatically.

# Create a vector containing the required packages. Check if installed and if not, install.
packages <- c("readxl", "dplyr", "tidyr", "pheatmap", "writexl", "tibble")

# Check if required packages are installed, install if missing
installed <- packages %in% rownames(installed.packages())
if (any(!installed)) {
  install.packages(packages[!installed])
} else {
  message("Packages are already installed")
}

# --- 1. Libraries laden ------------------------------------------------------
library(readxl)
library(dplyr)
library(tidyr)
library(pheatmap)
library(writexl)
library(tibble)  # For column_to_rownames()

# --- 2. Data inladen ---------------------------------------------------------
dat <- read_excel("DATA VERVAL Scripie Leyla.xlsx", sheet = 1)

# --- 3. Zet in long format ---------------------------------------------------
long <- dat %>%
  mutate(Day = as.character(Day)) %>%
  pivot_longer(
    cols = -c(Subject, Day),
    names_to = "Area",
    values_to = "Intensity"
  ) %>%
  mutate(Intensity = as.numeric(Intensity))  # Convert intensity to numeric

# --- 4. Vergelijkingen tussen opeenvolgende dagen ---------------------------
comparisons <- list(
  c("1", "2"),
  c("2", "3"),
  c("3", "4"),
  c("4", "5")
)

results_diff <- list()     # To store raw differences per subject
results_diff_tests <- list() # To store difference significance tests

for (comp in comparisons) {
  d1 <- comp[1]
  d2 <- comp[2]
  comp_label <- paste0("Day ", d1, " vs Day ", d2)
  
  # Filter and reshape data so we get intensities side by side for d1 and d2
  comp_data <- long %>%
    filter(Day %in% c(d1, d2)) %>%
    pivot_wider(names_from = Day, values_from = Intensity)
  
  message("🔍 Vergelijking: ", comp_label)
  print(head(comp_data, 5))
  
  # Calculate per-subject difference per area
  diff_df <- comp_data %>%
    mutate(Diff = .[[d2]] - .[[d1]]) %>%
    select(Subject, Area, Diff) %>%
    mutate(Comparison = comp_label)
  
  results_diff[[comp_label]] <- diff_df
  
  # Run paired t-test on differences per Area (checking if differences differ from zero)
  diff_test <- diff_df %>%
    group_by(Area) %>%
    summarise(
      p_value_diff_test = tryCatch({
        vals <- Diff
        if (length(na.omit(vals)) < 2) {
          NA
        } else {
          t.test(vals, mu = 0)$p.value
        }
      }, error = function(e) NA),
      .groups = "drop"
    ) %>%
    mutate(
      Comparison = comp_label,
      Significant_diff = ifelse(!is.na(p_value_diff_test) & p_value_diff_test < 0.05, "Yes", "No")
    )
  
  results_diff_tests[[comp_label]] <- diff_test
}

# --- 5. Combineer en exporteer ------------------------------------------------
df_differences <- bind_rows(results_diff) %>%
  arrange(Subject, Area, Comparison)

df_diff_tests <- bind_rows(results_diff_tests) %>%
  select(Area, Comparison, p_value_diff_test, Significant_diff)

write_xlsx(
  list(
    Differences_Per_Subject = df_differences,
    Difference_TTests_Per_Area = df_diff_tests
  ),
  path = "Data Analysis Verval Studie.xlsx"
)





