The aim of this macro is to segment the nucleus, mask it, crop the image then save it.
## Important
This macro will assume that the largest object in the image is the nucleus that needs to be saved. If there is more that one nucleus per image then only the largest one will be kept. If you have more than one nucleus then simply either loose one or separate them before running the macro.
## How does this macro work?
When running the macro the first step is to populate the dialog:

<img src="https://github.com/LiorPytowski/Nuclear-Foci-Analysis-Macros/blob/main/Images%20for%20wiki/Macro1_dialog.png" alt="DialogMacro1" width="550" height="650">

You need to choose the directory that contains the images to mask. (No other files should be in that directory!)

Choose a different folder where the new masked images will be saved.

Select the channels used to create the mask.

A Gaussian blur is applied on the selected channel before thresholding. Set the desired value (default is 10)

Set the threshold (see below for “How do I know which parameters to use”)

Define how much space will be left around the nucleus after cropping (0 is usually sufficient because of the blur)

Final options:

Pause macro at the end of each file: This is useful when optimising the settings and to ensure all is working as expected. This will display the main images in the workflow (start and end).
Show Intermediary images: this will display all intermediary images. Good for optimising parameters.

Save log with settings: This will save a small text file with the settings selected in the dialog.

 

## Additional details regarding the workflow:
[coming soon]
