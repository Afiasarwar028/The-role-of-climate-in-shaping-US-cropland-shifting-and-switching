install.packages("dplyr")
library(dplyr)
library(readxl)
install.packages("writexl")
library(writexl)

barley <- "C:\\Users\\Folder\\UDel\\Research\\HarvestGRID_Data\\HG_original_Files\\Corn_IR.csv"
data <- read.csv(barley)
print(data)

# Create a list of counties with at least 20 years of data
counties_with_20_years_data <- data %>%
  group_by(GEOID) %>%
  filter(n_distinct(year) >= 20) %>%
  ungroup() %>%
  select(GEOID) %>%
  distinct()

# Filter the original data based on counties with 20 years of data
filtered_original_data <- data %>%
  semi_join(counties_with_20_years_data, by = ("GEOID"))

print(filtered_original_data)

# Save the filtered original data to a new CSV file
path <- "C:\\Users\\Folder\\UDel\\Research\\HarvestGRID_Data\\20_Years_filter\\Corn_IR.xlsx"
write_xlsx(filtered_original_data, path)







