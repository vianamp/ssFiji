// Matheus Viana, 11.20.2013
// --------------------------------------

//setBatchMode(true);
_RootFolder = getDirectory("Choose a Directory");

_List = getFileList(_RootFolder);
for (item = 0; item < _List.length; item++) {
	if ( endsWith(_List[item],".tif")) {

		_FileName = split(_List[item],"/");
		_FileName = _FileName[_FileName.length-1];
		_FileName = split(_FileName,".");
		_FileName = _FileName[0];
		print(_FileName);
	
		open(_RootFolder + "/" + _FileName + ".tif");

		gmax = 0;
		for (s=1;s<=nSlices;s++) {
			setSlice(s);
			getStatistics(area, mean, min, max, std);
			if (max>gmax) {
				gmax = max;
				smax = s;
			}
		}
		setSlice(smax);
		resetMinAndMax();
		run("8-bit");
		File.makeDirectory(_RootFolder + "/" + _FileName);
		run("Image Sequence... ", "format=TIFF name=im start=0 digits=2 save=" + _RootFolder + "/" + _FileName + "/im00.tif");

		run("Close");
		
	}
}
