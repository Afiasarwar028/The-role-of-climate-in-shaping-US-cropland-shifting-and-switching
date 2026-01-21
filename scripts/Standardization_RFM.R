
library(openxlsx)


file_path <- "C:\\Users\\Folder\\UDel\\Research\\Cass_ha_state_yield_detrended.csv"


detrended_data <- read.csv(file_path)

detrended_column <- detrended_data$Detrended


detrended_column <- as.numeric(detrended_column)


sd_detrended <- sd(detrended_column)


standardized_detrended <- detrended_column / sd_detrended


detrended_data$Standardized <- standardized_detrended


output_file <- "C:\\Users\\Folder\\UDel\\Research\\Cass_ha_state_yield_standardized.csv"


write.csv(detrended_data, output_file, row.names = FALSE)


