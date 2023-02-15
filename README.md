This is a repository for nuclear foci segmentation & coloc analysis macros and R scripts.

## List of scripts
1) A [macro](https://github.com/LiorPytowski/Nuclear-Foci-Analysis-Macros/tree/main/1_Nuclear%20segmentation%20and%20masking) designed to segment nuclei and exclude all foci outside nucleus.
2) A [macro](https://github.com/LiorPytowski/Nuclear-Foci-Analysis-Macros/tree/main/2_Spot%20segmentationa%20and%20colocalization%20analysis) designed to segment foci in multiple channels then measure colocalization on two chosen channels.
3) An [R script](https://github.com/LiorPytowski/Nuclear-Foci-Analysis-Macros/tree/main/3_Concatenae%20files%20and%20merge%20tables) designed to concatenate all the outputs of the second macro, and retrieve the volume of objects that do colocalize.

More details about each script is provided by following the links above.

## How to use the macros
Download the .ijm files then drag-and drop it in the FIJI bar. Then press "Run" on the bottom of the script editor.  
(There are other ways of doing this. This is just one of them.)

## Dependencies
:heavy_exclamation_mark: The macros need certain update sites plus a manually installed plugin to run.

The update sites are:
* 3D ImageJ Suite
* Java8
* CLIJ     
* CLIJ2
* clijx-assistant
* clijx-assistant-extensions
* IJPB-plugins
* ImageScience

See this [tutorial to learn how to add update sites to ImageJ](https://imagej.net/update-sites/following).

:heavy_exclamation_mark:  Additionally please install `DiAna 1.50`. The latest version of DiAna can be found [here](https://imagej.net/plugins/distance-analysis#installation). An archived copy of `DiAna 1.50` is also in [this repository](https://github.com/LiorPytowski/Nuclear-Foci-Analysis-Macros/tree/main/DiAna).
To install please download the `.jar` file the place it in the `plugins` folder of your fiji installation. (In Windows, simply navigate with the File Explorer; in Mac, right click the FIJI app then select `Show package Contents` then navigate to the plugins folder)


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

## Acknowledgement
These macros relies heavily on the CLIJ library. Therefore this work would have been not possible in it's current form without the work of Robert Haase and colleagues:
1. Haase, R. et al. CLIJ: GPU-accelerated image processing for everyone. Nat Methods 17, 5–6 (2020).
2. Vorkel, D. & Haase, R. GPU-accelerating ImageJ Macro image processing workflows using CLIJ. arXiv:2008.11799 [cs, q-bio] (2020).
3. Haase, R. et al. Interactive design of GPU-accelerated Image Data Flow Graphs and cross-platform deployment using multi-lingual code generation. 2020.11.19.386565 https://www.biorxiv.org/content/10.1101/2020.11.19.386565v1 (2020) doi:10.1101/2020.11.19.386565.

It also relies on DiAna:
1. Gilles, J.-F., Dos Santos, M., Boudier, T., Bolte, S. & Heck, N. DiAna, an ImageJ tool for object-based 3D co-localization and distance analysis. Methods 115, 55–64 (2017).

And MorphoLibJ:
1. Legland, D., Arganda-Carreras, I. & Andrey, P. MorphoLibJ: integrated library and plugins for mathematical morphology with ImageJ. Bioinformatics 32, 3532–3534 (2016).

And finally but not least, of course:

1. Schindelin, J. et al. Fiji: an open-source platform for biological-image analysis. Nature Methods 9, 676 (2012).
2. Schindelin, J., Rueden, C. T., Hiner, M. C. & Eliceiri, K. W. The ImageJ ecosystem: An open platform for biomedical image analysis. Mol. Reprod. Dev. 82, 518–529 (2015).
3. Schneider, C. A., Rasband, W. S. & Eliceiri, K. W. NIH Image to ImageJ: 25 years of image analysis. Nat Methods 9, 671–675 (2012).
