The aim of this macro is to segment foci in 2 channels then measure certain coloc-related parameters. It was designed to be used after Macro_1 although it may not be essential.


### FAQ
#### How do I know what parameters to use when running the macro for the first time?
Run the macro with the default settings and make sure to select the options to pause the macro at the end of each file and show all the intermediary results.

Once you have that inspect the images and check whether the parameters seem correct. If not, then try different thresholds for example then re-run the macro with the newly selected thresholds.
#### What are the units of the measurement outputs?
Measurements in “StatisticsOfLabelmap” files are not calibrated.

Measurements in “AdjacencyResults” and “ColocResults” are calibrated meaning that they use the same units present in the properties of the image. (The menu path to check image properties in Fiji is: Image › Properties...).

All distance measurements are based on the geometric centers except for the measurements in the “AdjacencyResultsCentersofMass” files that use the centers of mass. 

### How does this macro work?
[coming soon]
### TO DO
An option to run the macro without making the stack Isotropic. This will make the process require less GPU memory (or RAM) but it comes at the cost of a potential lower segmentation quality.
### Additional details regarding the workflow:
[coming soon]
