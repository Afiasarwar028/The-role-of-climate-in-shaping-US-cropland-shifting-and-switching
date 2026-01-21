library(dplyr)
library(readxl)

# Load your data
data <- read_excel("C:/Users/Folder/UDel/Research/HarvestGRID_Data/20_Years_filter/corn_IR/Corn_IR_RFM.xlsx")

# Step 1: Calculate average harvested area for counterfactual period (1981-1985)
initial_period <- data %>%
  filter(Year >= 1981 & Year <= 1985) %>%
  group_by(GEOID) %>%
  summarise(Average_Harvested_Area = mean(Standardized, na.rm = TRUE))

# Step 2: Join average harvested area back to the main dataset (for counterfactual use)
data_cf <- data %>%
  inner_join(initial_period, by = "GEOID")

# Step 3: Define the latest 5 years in your dataset
latest_years <- sort(unique(data$Year), decreasing = TRUE)[1:5]

# Step 4: Prepare weighted actual and counterfactual values for these 5 years
actual_vals <- data %>%
  filter(Year %in% latest_years, !is.na(Standardized), !is.na(FDF)) %>%
  mutate(weighted = FDF * Standardized) %>%
  select(GEOID, Year, weighted)

counter_vals <- data_cf %>%
  filter(Year %in% latest_years, !is.na(Average_Harvested_Area), !is.na(FDF)) %>%
  mutate(weighted = FDF * Average_Harvested_Area) %>%
  select(GEOID, Year, weighted)

# Step 5: Merge actual and counterfactual weighted values by GEOID and Year
merged <- inner_join(
  actual_vals %>% rename(actual_weighted = weighted),
  counter_vals %>% rename(counter_weighted = weighted),
  by = c("GEOID", "Year")
)

# Step 6: Run a single paired t-test on these 5 years of values
# Only if you have enough data points
if (nrow(merged) > 10) {
  t_test <- t.test(merged$actual_weighted, merged$counter_weighted, paired = TRUE)
  p_value <- t_test$p.value
} else {
  p_value <- NA  # Not enough data
}

# Step 7: Calculate average actual and counterfactual weighted values for latest 5 years
actual_avg <- mean(merged$actual_weighted, na.rm = TRUE)
counter_avg <- mean(merged$counter_weighted, na.rm = TRUE)

# Step 8: Calculate percentage difference
percentage_diff <- 100 * (actual_avg - counter_avg) / actual_avg

# Step 9: Assign color based on p-value and sign of difference
if (!is.na(p_value) && p_value < 0.05) {
  cell_color <- ifelse(percentage_diff > 0, "red", "blue")
} else {
  cell_color <- "gray"
}

# Output results
cat("Percentage difference (%):", round(percentage_diff, 2), "\n")
cat("P-value:", round(p_value, 4), "\n")
cat("Assigned color:", cell_color, "\n")
