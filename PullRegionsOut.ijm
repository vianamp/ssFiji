// Matheus Viana - vianamp@gmail.com - 10.08.2014
// ==========================================================================

ORIGINAL = getImageID;

roiManager("Select",0);
getStatistics(area);
h = round(sqrt(area));

newImage("ROIs","16-bit Black",h,h,roiManager("count"));

ROIS = getImageID;

// For each ROI (cell)

for (roi = 1; roi <= roiManager("count"); roi++) {
	roiManager("Select",roi-1);
	run("Copy");
	selectImage(ROIS);
	setSlice(roi);
	run("Paste");
	selectImage(ORIGINAL);
}

// It wasn't working for first ROI. Then I'm running it bellow.
roiManager("Select",0);
run("Copy");
selectImage(ROIS);
setSlice(1);
run("Paste");
selectImage(ORIGINAL);