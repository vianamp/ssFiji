// Matheus Viana - vianamp@gmail.com - 7.29.2013
// ==========================================================================

// This macro is used to crop cells from microscope frames that in general contains
// more than one cell.
// 1. Use the macro GenFramesMaxProjs.ijm to generate the file MaxProjs.tiff
// 2. Use the stack MaxProjs.tiff to drawn ROIs around the cells that must be
//    analysed.
// 3. Save the ROIs as RoiSet.zip

// Selecting the folder that contains the TIFF frame files plus the RoiSet.zip and
// MaxProjs.tiff files.

// Defining the size of the singl cell images:
_xy = 200;

_RootFolder = getDirectory("Choose a Directory");

setBatchMode(true);
// Prevent generation of 32bit images
run("RandomJ Options", "  adopt progress");

run("ROI Manager...");
roiManager("Reset");
roiManager("Open",_RootFolder + "RoiSet.zip");

open("MaxProjs.tif");
MAXP = getImageID;

// For each ROI (cell)

for (roi = 0; roi < roiManager("count"); roi++) {

	roiManager("Select",roi);
	_FileName = getInfo("slice.label");

	open(_FileName + ".tif");
	ORIGINAL = getImageID;

	run("Restore Selection");

	newImage("CELL","16-bit Black",_xy,_xy,nSlices);
	CELL = getImageID;

	// Estimating the noise distribution
	
	selectImage(ORIGINAL);
	n = 1000;
	V = newArray(10*n);
	for (i=0;i<10*n;i++) {
		s = 1+round((nSlices-1)*random());
		setSlice(s);
		x = round((getWidth()-1)*random());
		y = round((getHeight()-1)*random());
		V[i] = getPixel(x,y);
	}
	Array.sort(V);
	vm = 0.0; v2 = 0.0;
	for (i=0;i<n;i++) {
		vm += V[i];
		v2 += V[i]*V[i];
	}
	vm /= n; v2 /= n; std = sqrt(v2-vm*vm);
	print("<v> = " + vm + ", std = " + std);
	
	// Adding the estimated noise distribution
	
	selectImage(CELL);
	run("Select All");	
	//run("Add...", "value=" + vm + " stack");
	//run("Add Specified Noise...", "stack standard=" + std);
	run("RandomJ Poisson", "mean=" + vm + " insertion=additive");
	CELLNOISE = getImageID;

	max_ai = 0;
	for (s = 1; s <= nSlices; s++) {
		selectImage(MAXP);
		selectImage(ORIGINAL);
		setSlice(s);
		run("Restore Selection");
		run("Copy");
		selectImage(CELLNOISE);
		setSlice(s);
		run("Select None");
		run("Paste");
		getStatistics(area, mean, min, max, std);
		if (mean>max_ai) {
			max_ai = mean;
			slice_max_ai = s;
		}
	}
	setSlice(slice_max_ai);
	
	run("Select None");
	resetMinAndMax();
	//run("16-bit");

	save(_RootFolder + _FileName + "_" + roi + ".tif");

	//File.makeDirectory(_RootFolder + _FileName + "_" + roi);
	//run("Save", "save=" + _RootFolder + _FileName + "_" + roi + "/" + _FileName + ".tiff");

	selectImage(CELLNOISE); close();
	selectImage(CELL); close();
	selectImage(ORIGINAL); close();

}

setBatchMode(false);