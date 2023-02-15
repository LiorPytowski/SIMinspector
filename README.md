This is a temporary repository for nuclear foci segmentation & coloc analysis macros and R scripts.


## List of scripts
1) A [macro](https://github.com/LiorPytowski/Nuclear-Foci-Analysis-Macros/tree/main/1_Nuclear%20segmentation%20and%20masking) designed to segment nuclei and exclude all foci outside nucleus.
2) A [macro](https://github.com/LiorPytowski/Nuclear-Foci-Analysis-Macros/tree/main/2_Spot%20segmentationa%20and%20colocalization%20analysis) designed to segment foci in multiple channels then measure colocalization on two chosen channels.
3) An [R script](https://github.com/LiorPytowski/Nuclear-Foci-Analysis-Macros/tree/main/3_Concatenae%20files%20and%20merge%20tables) designed to concatenate all the outputs of the second macro, and retrieve the volume of objects that do colocalize.

More details about each script is provided by following the links above.


## How to use the macros
Download the .ijm files then drag-and drop it in the FIJI bar. Then press "Run" on the bottom of the script editor.  
(There are other ways of doing this. This is just one of them.)

## Dependencies
:heavy_exclamation_mark: The macros need certain updates sites plus a manually installed plugin to run.

The update sites are:
* 3D ImageJ Suite
* Java8
* CLIJ     
* CLIJ2` 
* clijx-assistant` 
* clijx-assistant-extensions
* IJPB-plugins
* ImageScience

See this [tutorial to learn how to add update sites to ImageJ](https://imagej.net/update-sites/following).

Additionally please install `DiAna 1.50`


## To do
* Improve the input dialogs.
* Provide sample images to run the scripts.
* Create an update site so that user can install and update automatically the macros (?)


## FAQ
### How do I download files from here?
You can download the files from the last [release](https://github.com/LiorPytowski/Nuclear-Foci-Analysis-Macros/releases).

Alternatively, have a look at [this](https://blog.hubspot.com/website/download-from-github?hubs_content=blog.hubspot.com%2Fwebsite%2Fdownload-from-github&hubs_content-cta=downloading%20a%20file) 
### Why are the macros written in ImageJ macro language?
This language was chosen because it is the easiest to edit by non-coding experts.
### Why would I want to edit the macro?
No macro is perfect. And no macro is suited for all images. You may need to change commands in the macros. Hopefully this is not necessary, but it may happen.

