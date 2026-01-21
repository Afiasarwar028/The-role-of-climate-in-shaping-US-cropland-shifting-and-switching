library(dplyr)
library(readxl)

# Load your data (example)
 data <- read_excel("C:\\Users\\Folder\\UDel\\Research\\HarvestGRID_Data\\20_Years_filter\\Barley_IR\\Barley_IR.xlsx")
 print(data)

# Make sure column names are clean (remove spaces if needed)
names(data) <- gsub(" ", "_", names(data))

# Calculate slope for each GEOID
slope_results <- data %>%
  group_by(GEOID) %>%
  filter(!is.na(Barley_IR_hec)) %>%
  do({
    model <- lm(Barley_IR_hec ~ year, data = .)
    data.frame(slope = coef(model)[["year"]])
  }) %>%
  ungroup()

# View results
head(slope_results)
