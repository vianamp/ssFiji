i = 0;
_RootFolder = getDirectory("Choose a Directory");
_FileList = getFileList(_RootFolder);
while (i < _FileList.length)  {
	if ( endsWith(_FileList[i],"/") ) {
		run("Image Sequence...", "open=" + _RootFolder + _FileList[i] + " sort");
		for (s=1;s<=nSlices;s++) {
			setSlice(s);
			doWand(0,0.5*getHeight());
			run("Enlarge...", "enlarge=-3");
			run("Make Band...", "band=3");
			getStatistics(area, mean, min, max, std);
			doWand(0,0.5*getHeight());
			run("Make Inverse");
			run("Add...", "value=" + round(mean) + " slice");
			run("Add Specified Noise...", "slice standard=" + 0.5*std);	
		}
		
		_FileName = split(_FileList[i],"/"); 
		_FileName = _FileName[0];
		run("Save", "save=" + _RootFolder + "/" + _FileName + ".tif");
				
		print(_RootFolder + "/" + _FileName + ".tif");

		close();
	}
	i++;
}

