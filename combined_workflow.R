lake_directory <- #Most likely the lake-forecast-repo
update_run_config <- FALSE #TRUE is used for an iterative workflow


source(file.path(lake_directory, "01_get_data.R"))

source(file.path(lake_directory, "02_process_data.R"))

source(file.path(lake_directory, "03_inflow_forecast.R"))

source(file.path(lake_directory, "04_run_flarer_forecast.R"))

source(file.path(lake_directory, "05_visualize.R"))
