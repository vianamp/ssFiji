number_of_slices = 46;
Names = newArray("GFP","RFP")
SaveFolder = "/Users/Viana/Desktop/ShyenKenji/063014_H5_24/"

ntimes = nSlices / (2*number_of_slices);

stack = 0;
for (i = 0; i < ntimes-1; i++) {
	for (channel = 0; channel <2; channel++) {
		run("Make Substack...", "delete slices=1-" + number_of_slices);
		saveAs("Tiff",SaveFolder + Names[channel] + "Stack" + IJ.pad(i,3)  + ".tif");
		close();
	}
}
close();


