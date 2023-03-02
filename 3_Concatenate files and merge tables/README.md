The aim of this R script is to concatenate all the files created by the macro that measures colocalization.
## How to use?
Place the script in the folder containing the output of the macro_2.  
(This is the folder containing the AdjacencyResults”, “ColocResults and “StatisticsOfLabelmap” files)

Open the R script in R studio by double clicking it.  
(if you don’t have R studio, download and follow instructions from [here](https://support--rstudio-com.netlify.app/products/rstudio/download/))

Run the script (select the whole script `[CTRL + A]`  then run `[CTRL + Enter]`)

## FAQ
#### What are the units of the measurement outputs?
Measurements in “StatisticsOfLabelmap” files are **not** calibrated.  
Measurements in “AdjacencyResults” and “ColocResults” are calibrated meaning that they use the same units present in the properties of the image. (The menu path to check image properties in Fiji is: Image › Properties...).  
All distance measurements are based on the geometric centers except for the measurements in the “AdjacencyResultsCentersofMass” files that use the centers of mass.

#### Why did we choose to place the R file in the folder we need to process instead of setting the working directory?
This was done so that a copy of the R scrip remains with the data. This also means that if you change or add commands to the script for that specific experiment (e.g.: statistics and plots) then it is there with the actual data rather than in another directory.


## How does this scrip work?
In order, this script essentially: 
* Sets the directory to the location the R file is.
* Loads packages
* Detects what comparisons were made in macro 2 (e.g. "C2vsC3" or "C2vsC1")
* Creates a list of var_names based on the input suffixes
* Reads and concatenates all the csv files into separate data frames
* Joins the "ColocResults" data frame with the "StatisticsOfLabelmap" (only select columns) data frame based on "ImageFile" and "Label" columns
* Saves all the newly created dataframes in a subfolder called "Master_Files". (The subfolder is placed in the directory containing all the individual .csv files)

### To do
* change read_csv into a faster implementation.

## Log
V7: Order of columns amended so that  ChannelA comes before ChannelB in ColocResults_extended

v6: no longer the user needs to input the comparisons made in macro_2 (e.g.: C2vsC1).

v5: concatenation requires the user to input the comparisons made in macro_2 (e.g.: C2vsC1).

