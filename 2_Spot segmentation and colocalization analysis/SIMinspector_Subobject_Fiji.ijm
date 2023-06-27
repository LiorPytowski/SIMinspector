// Clear workspace, initialise CLIJ and clear GPU
run("Fresh Start");
run("Input/Output...", "jpeg=100 gif=-1 file=.csv copy_column save_column"); // this is for saving the results without row number

// If in debug mode
if (preview == true || pause == true) {
	run("3D Manager");
	Ext.Manager3D_Reset();
	}

// Initialize CLIJ. This has to be done after the 3D Manager
run("CLIJ2 Macro Extensions", "cl_device=");
Ext.CLIJ2_clear();

filelist = getFileList(Input_Directory);
for (i = 0; i < lengthOf(filelist); i++) {
	if (endsWith(filelist[i], ".tif")) { 
      
    // Open image, get titles and voxel information
    open(Input_Directory + File.separator + filelist[i]);
	stack_name_without_extension = File.nameWithoutExtension;
	input_image = getTitle();
	getVoxelSize(Voxel_width, Voxel_height, Voxel_depth, unit);

	// Segment channel A
	selectWindow(input_image);
  	run("Duplicate...", "title=InputC" + ChannelA + " duplicate channels=&ChannelA");
	  	// Set some paraameters then segment using function "segment_spots_function"
	  	Threshold_Method = Threshold_Method_ChannelA;
	  	Maxima_Radius = Maxima_Radius_ChannelA;
	  	Erosion_Radius = Erosion_Radius_ChannelA;
	  	Min_volume = Min_volume_ChannelA;
	  	Max_volume = Max_volume_ChannelA;
		segment_spots_function(Threshold_Method); // call the function
	rename("Segmented" + ChannelA);
	getDimensions(label_width, label_height, label_channels, label_slices, label_frames);
	
				// statistics of labelled pixels channel A
				intensity_input = "InputC" + ChannelA;
				labelmap = "Segmented" + ChannelA;
				Ext.CLIJ2_push(intensity_input);
				Ext.CLIJ2_push(labelmap);
				Ext.CLIJ2_statisticsOfLabelledPixels(intensity_input, labelmap);
				Table.deleteColumn("SUM_INTENSITY_TIMES_X");Table.deleteColumn("SUM_INTENSITY_TIMES_Y");Table.deleteColumn("SUM_INTENSITY_TIMES_Z");
				Table.deleteColumn("SUM_X");Table.deleteColumn("SUM_Y");Table.deleteColumn("SUM_Z");
				Ext.CLIJ2_clear();
			
					// generate center of mass map channel A
					centers_of_mass_map_A = "Centers_of_Mass_" + ChannelA;
					newImage(centers_of_mass_map_A, "16-bit", label_width, label_height, label_slices);
					
					Stack.setXUnit("micron");
					run("Properties...", "pixel_width=&Voxel_width pixel_height=&Voxel_height voxel_depth=&Voxel_depth");
					
					for (r = 0; r < nResults; r++) {
					CMx = getResult("MASS_CENTER_X", r);
					CMy = getResult("MASS_CENTER_Y", r);
					CMz = getResult("MASS_CENTER_Z", r);
					id_pix = getResult("IDENTIFIER", r);
					
					setSlice(CMz + 1); //we add 1 because CLIJ counts starting from 0 but Imagej from 1
					setPixel(CMx, CMy, id_pix);
					}
					run("glasbey_on_dark");
					
						// Save and close results
						saveAs("Results", Output_Directory + File.separator + stack_name_without_extension + "@StatisticsOfLabelmap_C" + ChannelA + ".csv");
						close("Results");
				
	
	// Segment channel B
	selectWindow(input_image);
  	run("Duplicate...", "title=InputC" + ChannelB + "  duplicate channels=&ChannelB");
  		// Set some parameters then segment using function "segment_spots_function"
	  	Threshold_Method = Threshold_Method_ChannelB;
	  	Maxima_Radius = Maxima_Radius_ChannelB;
	  	Erosion_Radius = Erosion_Radius_ChannelB;
	  	Min_volume = Min_volume_ChannelB;
	  	Max_volume = Max_volume_ChannelB;
		segment_spots_function(Threshold_Method); // call the function
	rename("Segmented" + ChannelB);
	getDimensions(label_width, label_height, label_channels, label_slices, label_frames);
	
				// statistics of labelled pixels channel B
				intensity_input = "InputC" + ChannelB;
				labelmap = "Segmented" + ChannelB;
				Ext.CLIJ2_push(intensity_input);
				Ext.CLIJ2_push(labelmap);
				Ext.CLIJ2_statisticsOfLabelledPixels(intensity_input, labelmap);
				Table.deleteColumn("SUM_INTENSITY_TIMES_X");Table.deleteColumn("SUM_INTENSITY_TIMES_Y");Table.deleteColumn("SUM_INTENSITY_TIMES_Z");
				Table.deleteColumn("SUM_X");Table.deleteColumn("SUM_Y");Table.deleteColumn("SUM_Z");
				Ext.CLIJ2_clear();
				
					// generate center of mass map channel B
					centers_of_mass_map_B = "Centers_of_Mass_" + ChannelB;
					newImage(centers_of_mass_map_B, "16-bit", label_width, label_height, label_slices);
						
					Stack.setXUnit("micron");
					run("Properties...", "pixel_width=&Voxel_width pixel_height=&Voxel_height voxel_depth=&Voxel_depth");
					
					for (r = 0; r < nResults; r++) {
					CMx = getResult("MASS_CENTER_X", r);
					CMy = getResult("MASS_CENTER_Y", r);
					CMz = getResult("MASS_CENTER_Z", r);
					id_pix = getResult("IDENTIFIER", r);
					
					setSlice(CMz + 1); //we add 1 because CLIJ counts starting from 0 but Imagej from 1
					setPixel(CMx, CMy, id_pix);
					}
					run("glasbey_on_dark");
					
						// Save and close results
						saveAs("Results", Output_Directory + File.separator + stack_name_without_extension + "@StatisticsOfLabelmap_C" + ChannelB + ".csv");
						close("Results");
				
		
	// Close input stack
	close(input_image);
	
	// Run distance analysis
	run("DiAna_Analyse", "img1=InputC" + ChannelA + " img2=InputC" + ChannelB + " lab1=Segmented" + ChannelA + " lab2=Segmented" + ChannelB + " coloc");
	selectWindow("ColocResults");
	saveAs("ColocResults", Output_Directory + File.separator + stack_name_without_extension + "@ColocResults_C" + ChannelA + "vsC" + ChannelB + ".csv");
	
	
	run("DiAna_Analyse", "img1=InputC" + ChannelA + " img2=InputC" + ChannelB + " lab1=Segmented" + ChannelA + " lab2=Segmented" + ChannelB + " adja kclosest=" + nb_neighbours);
	selectWindow("AdjacencyResults");
	saveAs("AdjacencyResults", Output_Directory + File.separator + stack_name_without_extension + "@AdjacencyResultsGeometricCenters_C" + ChannelA + "vsC" + ChannelB + ".csv");
	
	run("DiAna_Analyse", "img1=InputC" + ChannelA + " img2=InputC" + ChannelB + " lab1=" + centers_of_mass_map_A + " lab2=" + centers_of_mass_map_B + " adja kclosest=" + nb_neighbours);
	selectWindow("AdjacencyResults");
	Table.deleteColumn("Dist min EdgeA-EdgeB");	Table.deleteColumn("Dist min CenterA-EdgeB");	Table.deleteColumn("Dist min EdgeA-CenterB");
	saveAs("AdjacencyResults", Output_Directory + File.separator + stack_name_without_extension + "@AdjacencyResultsCentersOfMass_C" + ChannelA + "vsC" + ChannelB + ".csv");
	
	
	// If in debug mode
	if (preview == true || pause == true) {
		run("Tile");	
		waitForUser("", "Process next image in folder?");	
		} 
	
	// End file loop and save and close all images
	close(stack_name_without_extension + "@ColocResults_C" + ChannelA + "vsC" + ChannelB + ".csv");
	close(stack_name_without_extension + "@AdjacencyResultsGeometricCenters_C" + ChannelA + "vsC" + ChannelB + ".csv");
	close(stack_name_without_extension + "@AdjacencyResultsCentersOfMass_C" + ChannelA + "vsC" + ChannelB + ".csv");

	run("Close All");
	run("Clear Results");
	run("Collect Garbage");
	Ext.CLIJ2_clear();

	}
}



if (print_log == true ) {
	save_settings() ;
		}




/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Below the dialog is defined
#@ File(label="Input directory", style="directory") Input_Directory
#@ File(label="Output directory", style="directory") Output_Directory

#@ Integer(label="Channel A", value = 1) ChannelA
#@ Integer(label="Channel B", value = 2) ChannelB

#@ String(label="Segmentation algorithm channel A", choices={"Default", "Huang", "Intermodes", "IsoData", "IJ_IsoData", "Li", "MaxEntropy", "Mean", "MinError", "Minimum", "Moments", "Otsu", "Percentile", "RenyiEntropy", "Shanbhag", "Triangle", "Yen"}, style="list") Threshold_Method_ChannelA
#@ String(label="Segmentation algorithm channel B", choices={"Default", "Huang", "Intermodes", "IsoData", "IJ_IsoData", "Li", "MaxEntropy", "Mean", "MinError", "Minimum", "Moments", "Otsu", "Percentile", "RenyiEntropy", "Shanbhag", "Triangle", "Yen"}, style="list") Threshold_Method_ChannelB

#@ String(value=" ", visibility="MESSAGE") TextP1
#@ String(value="Min and Max spot volume. In voxels. In original stack.", visibility="MESSAGE") hints
#@ String(value="Channel A:", visibility="MESSAGE") hints1
#@ Integer(label="Minimum spot volume in voxels", value = 7) Min_volume_ChannelA
#@ Integer(label="Maximum spot volume in voxels", value = 1000) Max_volume_ChannelA
#@ String(value="Channel B:", visibility="MESSAGE") hints2
#@ Integer(label="Minimum spot volume in voxels", value = 7) Min_volume_ChannelB
#@ Integer(label="Maximum spot volume in voxels", value = 1000) Max_volume_ChannelB

#@ String(value=" ", visibility="MESSAGE") TextP2
#@ String(value="Number of neighbours for distance analysis", visibility="MESSAGE") Text5
#@ Integer(label="Number of neighbours for distance analysis", value = 1) nb_neighbours

#@ String(value=" ", visibility="MESSAGE") TextP3
#@ String(value="Displaying intermediary images is useful for optimisation or debugging.", visibility="MESSAGE") TextP4
#@ Boolean(label="Pause macro at the end of each file?") pause
#@ Boolean(label="Show all intermediary images?") preview

#@ String(value="Advanced options:", visibility="MESSAGE") Text6

#@ String(value="XYZ Radius for maxima detection. Default is 2 voxels. The lower the value the more watersheded objects there are.", visibility="MESSAGE") Text7
#@ Integer(label="Maxima radius channel A", value = 2) Maxima_Radius_ChannelA
#@ Integer(label="Maxima radius channel B", value = 2) Maxima_Radius_ChannelB

#@ String(value="Label erosion in isotropic stack. Default is 0 voxel. Usually [0-3].", visibility="MESSAGE") Text8
#@ Integer(label="Label erosion channel A", value = 0) Erosion_Radius_ChannelA
#@ Integer(label="Label erosion channel B", value = 0) Erosion_Radius_ChannelB

#@ String(value=" ", visibility="MESSAGE") TextP9
#@ Boolean(label="Save a log with the settings used to run this macro?") print_log


#@ String(value=" ", visibility="MESSAGE") TextP11
#@ String(value="This macro requires the updates sites 3D ImageJ Suite, Java8, CLIJ and CLIJ2, IJPB-plugins, clijx-assistant-extensions and DiAna 1.50 to run.", visibility="MESSAGE") TextP12
#@ String(value="Check their documentation to see how to cite.", visibility="MESSAGE") TextP13

#@ String(value=" ", visibility="MESSAGE") TextP14
#@ String(value="Macro created by Lior Pytowski. Jan 2023", visibility="MESSAGE") TextP15



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Below the function to segment the spots is defined
function segment_spots_function (Threshold_Method) {
	Ext.CLIJ2_clear();
    getDimensions(width, height, channels, slices, frames);
	input_image_c1 = getTitle();
	Ext.CLIJ2_pushCurrentZStack(input_image_c1);
	
	// Make Isotropic // This assumes that X and Y are equal
	original_voxel_size_x = Voxel_width;
	original_voxel_size_y = Voxel_height;
	original_voxel_size_z = Voxel_depth;
	new_voxel_size = Voxel_width;
	Ext.CLIJ2_makeIsotropic(input_image_c1, isotropic_input, original_voxel_size_x, original_voxel_size_y, original_voxel_size_z, new_voxel_size);
	Ext.CLIJ2_release(input_image_c1);
		if (preview == true) {		Ext.CLIJ2_pull(isotropic_input);}
	
	// Automatic Threshold
	method = Threshold_Method;
	Ext.CLIJ2_automaticThreshold(isotropic_input, binary_mask, method);
	 	if (preview == true) {		Ext.CLIJ2_pull(binary_mask); 	print(Threshold_Method);}
	
	// Detect Maxima3D Box
	radiusX = Maxima_Radius;
	radiusY = Maxima_Radius;
	radiusZ = Maxima_Radius;
	Ext.CLIJ2_detectMaxima3DBox(isotropic_input, image_maxima_spots, radiusX, radiusY, radiusZ);
	Ext.CLIJ2_release(isotropic_input);
		if (preview == true) {		Ext.CLIJ2_pull(image_maxima_spots);}
	
	// Label Spots
	Ext.CLIJ2_labelSpots(image_maxima_spots, labelled_spots);
	Ext.CLIJ2_release(image_maxima_spots);			
		if (preview == true) {		Ext.CLIJ2_pull(labelled_spots);}
	
	// Marker Controlled Watershed
	Ext.CLIJx_morphoLibJMarkerControlledWatershed(binary_mask, labelled_spots, binary_mask, Watersheded_labels);
	Ext.CLIJ2_release(labelled_spots);
	Ext.CLIJ2_release(binary_mask);
		if (preview == true) {		Ext.CLIJ2_pull(Watersheded_labels);}
	
	// Erode Labels
	radius = Erosion_Radius;
	relabel_islands = 1.0;
	Ext.CLIJ2_erodeLabels(Watersheded_labels, eroded_labels, radius, relabel_islands);
	Ext.CLIJ2_release(Watersheded_labels);
	Ext.CLIJ2_pull(eroded_labels);
	Ext.CLIJ2_release(eroded_labels);
	
	// Clear GPU memory
	Ext.CLIJ2_clear();	
		
	// Reslice to original z sice
	run("Scale...", "width=" + width + " height=" + height + " depth=" + slices +" interpolation=None process create");
	resliced_image_labels = getTitle();
		if (preview != true) {		close(eroded_labels);}
				
	// Exclude Labels Outside Size Range
	Ext.CLIJ2_pushCurrentZStack(resliced_image_labels);
	minimum_size = Min_volume;
	maximum_size = Max_volume;
	Ext.CLIJ2_excludeLabelsOutsideSizeRange(resliced_image_labels, Labels_size_filtered, minimum_size, maximum_size);
	Ext.CLIJ2_release(resliced_image_labels);
		if (preview != true) {		close(resliced_image_labels);}
	
	// Convert U Int16
	Ext.CLIJ2_convertUInt16(Labels_size_filtered, Labels_size_filtered_U16);
	Ext.CLIJ2_release(Labels_size_filtered);
	Ext.CLIJ2_pull(Labels_size_filtered_U16)
	Ext.CLIJ2_release(Labels_size_filtered_U16);
	run("glasbey_on_dark");
	Image_final_labels = getTitle();
		
	// Clear GPU memory
	Ext.CLIJ2_clear();
	
	// Set the original voxel dimensions
	Stack.setXUnit("micron");
	run("Properties...", "pixel_width=&Voxel_width pixel_height=&Voxel_height voxel_depth=&Voxel_depth");
	
}


///////////////////////
//Log printing
function save_settings () {
	getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
	print("\\Clear");
	print("Input_Directory: " + Input_Directory);
	print("Output_Directory: " + Output_Directory);
	print("Channel A: " + ChannelA);
	print("Channel B: " + ChannelB);
	print("Segmentation algorithm Channel A: " + Threshold_Method_ChannelA);
	print("Segmentation algorithm Channel B: " + Threshold_Method_ChannelB);
	print("Min and Max spot volume. In voxels. In original stack.: "  );
	print("Channel A:  "  );
	print("Minimum spot volume in voxels: " + Min_volume_ChannelA);
	print("Maximum spot volume in voxels: " + Max_volume_ChannelA);
	print("Channel B: "  );
	print("Minimum spot volume in voxels: " + Min_volume_ChannelB);
	print("Maximum spot volume in voxels: " + Max_volume_ChannelB);
	print("Number of neighbours for distance analysis: " + nb_neighbours);
	print("Maxima Radius Channel A: " + Maxima_Radius_ChannelA);
	print("Maxima Radius Channel B: " + Maxima_Radius_ChannelB);
	print("Label erosion Channel A: " + Erosion_Radius_ChannelA);
	print("Label erosion Channel B: " + Erosion_Radius_ChannelB);

	selectWindow("Log"); 
	save(Output_Directory + File.separator + "Log C" + ChannelA + "vsC" + ChannelB + ".txt");
	}

