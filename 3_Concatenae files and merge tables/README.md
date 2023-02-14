The aim of this R script is to concatenate all the files created by the macro_2
### How to use?
Place the script in the folder containing the output of the macro_2.

(This is the folder containing the AdjacencyResults”, “ColocResults and “StatisticsOfLabelmap”)

Open the R script in R studio by double clicking it.

(if you don’t have R studio download and follow instructions from [here](https://support--rstudio-com.netlify.app/products/rstudio/download/))

In line 14 and 15 of the script you need to list the comparisons used in the previous macro

[to be continued]
### FAQ

#### What are the units of the measurement outputs?
Measurements in “StatisticsOfLabelmap” files are not calibrated.

Measurements in “AdjacencyResults” and “ColocResults” are calibrated meaning that they use the same units present in the properties of the image. (The menu path to check image properties in Fiji is: Image › Properties...).

All distance measurements are based on the geometric centers except for the measurements in the “AdjacencyResultsCentersofMass” files that use the centers of mass.

#### Why did we choose to place the R file in the folder we need to process instead of setting the working directory?
This was done so that a copy of the R scrip remains with the data. This also means that if you change or add commands to the script for that specific experiment (e.g.: plots and statistics) then it is there with the actual data rather than in another directory



