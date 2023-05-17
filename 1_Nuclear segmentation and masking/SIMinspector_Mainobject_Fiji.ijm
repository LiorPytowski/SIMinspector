run("Fresh Start");
run("CLIJ2 Macro Extensions", "cl_device=");
Ext.CLIJ2_clear();

filelist = getFileList(Input_directory) 
for (i = 0; i < lengthOf(filelist); i++) {
    if (endsWith(filelist[i], ".tif")) { 
        open(Input_directory + File.separator + filelist[i]);
		
		// Identify multi-channel input, extract Channel_for_mask_creation then push to GPU
		Input_image = getTitle(); 
		getDimensions(width, height, channels, slices, frames);
		run("Duplicate...", "duplicate channels=&Channel_for_mask_creation");
		
		image_1 = getTitle();
		Ext.CLIJ2_pushCurrentZStack(image_1); // This is only the channel to make the masks
		Ext.CLIJ2_pushCurrentZStack(Input_image); // This is the whole input multi-channel image
		
		// Gaussian Blur3D
		sigma_x = Gaussian_blur;
		sigma_y = Gaussian_blur;
		sigma_z = 0.0;
		Ext.CLIJ2_gaussianBlur3D(image_1, image_2, sigma_x, sigma_y, sigma_z);
		Ext.CLIJ2_release(image_1);
			if (preview == true) {		Ext.CLIJ2_pull(image_2);}

		// Automatic Threshold
		method = Threshold_Method;
		Ext.CLIJ2_automaticThreshold(image_2, image_3, method);
		Ext.CLIJ2_release(image_2);
			if (preview == true) {		Ext.CLIJ2_pull(image_3);}

		// Binary Fill Holes Slice By Slice
		Ext.CLIJx_binaryFillHolesSliceBySlice(image_3, image_4);
		Ext.CLIJ2_release(image_3);
			if (preview == true) {		Ext.CLIJ2_pull(image_4);}

		// Connected Components Labeling Box
		Ext.CLIJ2_connectedComponentsLabelingBox(image_4, image_5);
		Ext.CLIJ2_release(image_4);
		Ext.CLIJ2_pull(image_5);
		Ext.CLIJ2_release(image_5);
		
		// Here we keep only the largest object present in the label map. This creates a new image with the label set to 255. We then subtract 254 to make the image 0 & 1
		run("Keep Largest Label");
		run("Subtract...", "value=254 stack");
		mask = getTitle();
		
		// Section below will create a selection around the nucleus that will be then used to crop the image
		run("Z Project...", "projection=[Max Intensity]");
		setThreshold(1, 65535);
		run("Create Selection");
		
		// Create a stack with the mask
		if (channels == 2) {	run("Merge Channels...", "c1=&mask c2=&mask create");		}
		if (channels == 3) {	run("Merge Channels...", "c1=&mask c2=&mask c3=&mask create");		}
		if (channels == 4) {	run("Merge Channels...", "c1=&mask c2=&mask c3=&mask c4=&mask create");		}
		if (channels == 5) {	run("Merge Channels...", "c1=&mask c2=&mask c3=&mask c4=&mask c5=&mask create");		}
		if (channels == 1 || channels > 5) { print("This macro is designed for stacks with 2 to 5 channels only. Macro aborted.");	exit;	}
		multi_channel_mask = getTitle();
		
		// Multiply the Mask to the input stack. This will remove all the background.
		imageCalculator("Multiply create stack", Input_image, multi_channel_mask);
				
		// Section below will create a selection around the nucleus then crop the image
		run("Restore Selection");
		run("Enlarge...", "enlarge=&border");
		run("Crop");
		run("Select None");
		
		// If in debug mode
		if (preview == true || pause == true) {
				run("Tile");	
				waitForUser("", "Process next image in folder?");	
				} 
				
		// Save and close images		
		saveAs("Tiff", Output_directory + File.separator + Input_image);  
		run("Close All");
		Ext.CLIJ2_clear();
		}
	}


//Log printing
if (print_log == true ) {
	getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
	print("\\Clear");
	print("Macro run on (YYYY/MM/DD): " + year + "/" + month+1 + "/" + dayOfMonth);
	print("Input_directory: " + Input_directory);
	print("Output_directory: " + Output_directory);
	print("Channel for mask creation: " + Channel_for_mask_creation);
	print("Gaussian blur sigma before thresholding: " + Gaussian_blur);
	print("Threshold method: " + Threshold_Method);
	print("Border around nucleus: " + border);

	selectWindow("Log"); 
	save(Output_directory + File.separator + "Log.txt");
	}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Below the dialog is defined
#@ File(label="Input directory", style="directory") Input_directory
#@ File(label="Output directory", style="directory") Output_directory

#@ Integer(label="Channel for mask creation", value = 1) Channel_for_mask_creation

#@ String(value="A gaussian blur is used to smoothen the image in XY before thresholding (default is 10).", visibility="MESSAGE") TextP1
#@ Integer(label="Gaussian blur sigma before thresholding", value = 10) Gaussian_blur

#@ String(value="Threshold method to create the mask (default is Huang).", visibility="MESSAGE") TextP2
#@ String(label="Threshold method", choices={"Huang", "Default", "Intermodes", "IsoData", "IJ_IsoData", "Li", "MaxEntropy", "Mean", "MinError", "Minimum", "Moments", "Otsu", "Percentile", "RenyiEntropy", "Shanbhag", "Triangle", "Yen"}, style="list") Threshold_Method

#@ String(value="Space left around the nucleus after croping (in calibrated units).", visibility="MESSAGE") TextP4
#@ Double(label="Border around nucleus", value = 0) border

#@ String(value=" ", visibility="MESSAGE") TextP5
#@ String(value="Displaying intermediary images is useful for optimisation or debugging.", visibility="MESSAGE") TextP6
#@ Boolean(label="Pause macro at the end of each file?") pause
#@ Boolean(label="Show all intermediary images?") preview

#@ String(value=" ", visibility="MESSAGE") TextP12
#@ Boolean(label="Save a log with the settings used to run this macro?") print_log

#@ String(value=" ", visibility="MESSAGE") TextP7
#@ String(value="This macro requires the updates sites CLIJ, CLIJ2 and IJPB-plugins to run.", visibility="MESSAGE") TextP8
#@ String(value="Check their documentation to see how to cite.", visibility="MESSAGE") TextP9

#@ String(value=" ", visibility="MESSAGE") TextP10
#@ String(value="Macro created by Lior Pytowski. Jan 2023", visibility="MESSAGE") TextP11

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


