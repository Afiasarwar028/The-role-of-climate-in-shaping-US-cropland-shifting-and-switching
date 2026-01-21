
library(Rssa)

file_path <- "C:\\Users\\Folder\\UDel\\Cass_ha_state_de.csv"
data <- read.csv(file_path)

ts_data <- data$yield


ssa_result <- ssa(ts_data)

trend <- reconstruct(ssa_result, groups = list(1))$F1

detrended_data <- ts_data - trend

year <- data$Year
state <- data$State   

detrended_df <- data.frame(
  Year = year,
  State = state,
  yield = ts_data,
  Detrended = detrended_data
)


print(detrended_df)

output_path <- "C:\\Users\\Folder\\UDel\\Research\\Cass_ha_state_yield_detrended.csv"
write.csv(detrended_df, output_path, row.names = FALSE)
