main_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(main_dir)

# Check if tidyverse, tidyr, and dplyr are installed, if not then install them then load them
if (!require("tidyverse")) {  install.packages("tidyverse") }
if (!require("tidyr")) {      install.packages("tidyr")     }
if (!require("dplyr")) {      install.packages("dplyr")     }
library(tidyverse)
library(tidyr)
library(dplyr)

# Input sufixes for analysis

comparison_suffixes <- data.frame(ChannelA = c("C2", "C2"),   ## in here we are comparing C2 vs C1 and C2 vs C3. Add or remove as necessary
                                  ChannelB = c("C1", "C3"))

individual_suffixes <- unique(c(comparison_suffixes$ChannelA, comparison_suffixes$ChannelB))

# Create a list of var_names based on the input suffixes
var_names <- c()
for (suffix in individual_suffixes) {
  var_names <- c(var_names, paste("StatisticsOfLabelmap", "_", suffix, sep=""))
}
for (i in 1:nrow(comparison_suffixes)) {
  suffix <- paste(comparison_suffixes[i, "ChannelA"], "vs", comparison_suffixes[i, "ChannelB"], sep="")
  var_names <- c(var_names, paste("AdjacencyResultsGeometricCenters", "_", suffix, sep=""))
  var_names <- c(var_names, paste("AdjacencyResultsCentersOfMass", "_", suffix, sep=""))
  var_names <- c(var_names, paste("ColocResults", "_", suffix, sep=""))
}


# Read in and process each csv file into a separate data frame
for (i in seq_along(var_names)) {
  filelist <- list.files(pattern = paste(var_names[i],".csv",sep=""))
  datalist <- lapply(filelist, function(x) read_csv(file = x, id = "FileName"))
  temp_df <- do.call("rbind", datalist)
  temp_df <- separate(data = temp_df, col = "FileName", into = c("ImageFile", "AnalysisType"), sep = "@")
  assign(var_names[i], temp_df)
}

# Extended Coloc results with volume of each object
# First select the desired columns from the "StatisticsOfLabelmap" data frame
for (suffix in individual_suffixes) {
  assign(paste("StatisticsOfLabelmap_short", "_", suffix, sep=""),
         select(get(paste("StatisticsOfLabelmap", "_", suffix, sep="")), ImageFile, IDENTIFIER, PIXEL_COUNT, MEAN_INTENSITY, SUM_INTENSITY))
}



# Join the "ColocResults_C2vsC1_extended" data frame with the "StatisticsOfLabelmap_short" data frame on "ImageFile" and "Label" columns
extend_and_merge <- function(ColocResults, StatisticsOfLabelmap_1, StatisticsOfLabelmap_2, suffix1, suffix2) {
  ColocResults_extended <- ColocResults %>%
    mutate(Label = gsub("objA", "", Label)) %>%
    mutate(Label = gsub("objB", "", Label)) %>%
    separate(Label, into = c("LabelA", "LabelB"), sep = "_") %>%
    mutate(LabelA = as.numeric(LabelA)) %>%
    mutate(LabelB = as.numeric(LabelB))
  
  ColocResults_extended_final <- merge(ColocResults_extended, StatisticsOfLabelmap_1,
                                       by.x = c("ImageFile", "LabelA"), by.y = c("ImageFile", "IDENTIFIER"))
  
  ColocResults_extended_final <- merge(ColocResults_extended_final, StatisticsOfLabelmap_2,
                                       by.x = c("ImageFile", "LabelB"), by.y = c("ImageFile", "IDENTIFIER"),
                                       suffix = c(suffix1, suffix2))
  return(ColocResults_extended_final)
}


for (i in 1:nrow(comparison_suffixes)) {
  suffix <- paste(comparison_suffixes[i, "ChannelA"], "vs", comparison_suffixes[i, "ChannelB"], sep="")
  assign(paste("ColocResults_", suffix, "extended", sep=""),
         extend_and_merge(get(paste("ColocResults_", suffix, sep="")),
                          get(paste("StatisticsOfLabelmap_short_", comparison_suffixes[i, "ChannelA"], sep="")),
                          get(paste("StatisticsOfLabelmap_short_", comparison_suffixes[i, "ChannelB"], sep="")),
                          paste(".", comparison_suffixes[i, "ChannelA"], sep=""),
                          paste(".", comparison_suffixes[i, "ChannelB"], sep="")))
}



#We will now save all the dataframes except
rm(datalist, temp_df, comparison_suffixes)
# Create the subfolder and set the Working directory there
Output_folder <- "Master_Files"
dir.create(Output_folder)
output_path <- file.path(main_dir, Output_folder)
setwd(output_path)

# retrieve all data frames in the current workspace then Save each data frame to the subfolder as a CSV file
df_list <- Filter(function(x) is.data.frame(get(x)), ls())
for(df_name in df_list) {
  write.csv(get(df_name), file = paste0(df_name, ".csv"), row.names = FALSE)
}


