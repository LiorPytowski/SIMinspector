This is a temporary repository for nuclear foci segmentation & coloc analysis macros and R scripts.


## List of macros
1) a [macro](https://github.com/LiorPytowski/Nuclear-Foci-Analysis-Macros/tree/main/1_Nuclear%20segmentation%20and%20masking) designed to segment nuclei and exclude all foci in cytoplasm.
2) a [macro](https://github.com/LiorPytowski/Nuclear-Foci-Analysis-Macros/tree/main/2_Spot%20segmentationa%20and%20colocalization%20analysis) designed to segment foci in multiple channels then measure colocalization on two chosen channels.
3) an [R script](https://github.com/LiorPytowski/Nuclear-Foci-Analysis-Macros/tree/main/3_Concatenae%20files%20and%20merge%20tables) designed to concatenate all the outputs of the second macro, and retrieve the volume of objects that do colocalize.

More details about each script is provided by following the links above.


## How to use the macros
Download the .ijm file then drag-and drop it in the FIJI bar. Then press "Run" on the bottom of the script editor.
(There are other ways of doing this. This is just one of them.)



## To do 
_Improve the input dialogs.

_Provide sample images to run the scripts.

_ Create an update site so that user can install and update automatically the macros (?)


## FAQ
### Why are the macros written in ImageJ macro language?
This language was chosen because it is the easiest to edit by non-coding experts.
### Why would I want to edit the macro?
No macro is perfect. And no macro is suited for all images. You may need to change commands in the macros. Hopefully this is not necessary, but it may happen.

