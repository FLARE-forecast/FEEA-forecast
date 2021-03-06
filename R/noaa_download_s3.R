# function to download a list of 35-day NOAA forecasts from FLARE s3 bucket

noaa_download_s3 <- function(siteID, # LOWERCASE e.g. sunp
                             date, # start date of noaa forecasts
                             cycle, # noaa forecast cycle, e.g. 00, 06, 12, 18
                             noaa_horizon, # numeric, either 16 or 35 depending on NOAA forecasts desired
                             noaa_directory, # place where forecasts will be downloaded
                             noaa_model, #which noaa model you want to download (e.g., noaa/NOAAGEFS_6hr)
                             noaa_hour #numeric, whether you want 1hr or 6hr forecasts, e.g. 6
){
  
  Sys.setenv("AWS_S3_ENDPOINT" = "tacc.jetstream-cloud.org:8080/")
  
  # currently not able to get 35 day forecasts downloaded but the setup is here
  if(noaa_horizon == 16) {
    end_date <- as.Date(date) + 16
  }else if(noaa_horizon == 35) {
    end_date <- as.Date(date) + 35
    end_date_00 <- as.Date(date) + 16
  }
  
  prefix <- paste0("drivers/", noaa_model)
  
  
  ens <- formatC(seq(0, 30), width = 2, flag = 0)
  file_names <- file.path(prefix, siteID, date, cycle, paste0("NOAAGEFS_", noaa_hour, "hr_", siteID, "_", date, "T", cycle, "_", end_date, "T", cycle, "_ens", ens, ".nc"))
  if(noaa_horizon == 35){
    file_names[1] <- file.path(prefix, siteID, date, cycle, paste0("NOAAGEFS_", noaa_hour, "hr_", siteID, "_", date, "T00_", end_date_00, "T00_ens", ens, ".nc"))
  }
  
  #Download a specific file from the server and save it locally (in this example, "localfile.nc"):
  for(i in 1:length(file_names)){
    
    if(aws.s3::object_exists(object = file_names[i], bucket = "flare", region = "")) {
      tryCatch({
        aws.s3::save_object(region = "", 
                            file_names[i], 
                            file = file.path(noaa_directory, gsub(paste0(prefix, "/"), "", file_names[i])), 
                            #file = file.path(noaa_directory, gsub("drivers/noaa-point/NOAAGEFS_1hr/", "", file_names[i])), 
                            bucket = "flare")
      }, error = function(e) {warning("Cannot download ", file_names[i], " from the AWS server.")})
    } else {
      warning("File ", file_names[i], " not found!")
    }
  }
}

# For checking the bucket
# library(aws.s3)
# df <- get_bucket_df(bucket = "flare", prefix = "drivers/noaa/NOAAGEFS_6hr/fcre/2021-07-08", region = "", max = Inf)
# tail(df$Key)
# 
# save_object(object = df$Key[1], bucket = "flare", file = "test.nc", overwrite = TRUE, region = "")
