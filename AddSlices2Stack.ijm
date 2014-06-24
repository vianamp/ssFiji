// Matheus Viana - vianamp@gmail.com - 7.29.2013
// ==========================================================================

// This macro must be used to generate a stack of max projection from a set
// of microscope frames. In general, the max projection stack is then used
// to drawn ROIs around the cells that are going to be further analysed. 

// Selecting the folder that contains the TIFF frame files

// Matheus Viana - vianamp@gmail.com - 6.17.2014
// ==========================================================================

_RootFolder = getDirectory("Choose a Directory");

setBatchMode(true);

n = 2;
item = 0; im = 0;
_List = getFileList(_RootFolder);
while (item < _List.length)  {
	if ( endsWith(_List[item],".tif") ) {
		im++;
		open(_RootFolder + _List[item]);
		_FileName = split(_List[item],"."); 
		_FileName = _FileName[0];		
		ORIGINAL = getImageID;
		N = nSlices;

		newImage("Expanded", "8-bit black",getWidth(),getHeight(),N+2*n);
		EXPANDED = getImageID;

		max_ai = 0;
		for (s=1;s<=N;s++) {
			selectImage(ORIGINAL);
			setSlice(s);
			run("Copy");
			selectImage(EXPANDED);
			setSlice(s+n);
			run("Paste");
			getStatistics(area, mean, min, max, std);
			if (mean>max_ai) {
				max_ai = mean;
				so = s;
			}
		}
		for (s=1;s<=n;s++) {
			selectImage(ORIGINAL);
			setSlice(1);
			run("Copy");
			selectImage(EXPANDED);
			setSlice(s);
			run("Paste");	
		}
		for (s=1;s<=n;s++) {
			selectImage(ORIGINAL);
			setSlice(N);
			run("Copy");
			selectImage(EXPANDED);
			setSlice(N+n+s);
			run("Paste");	
		}
		setSlice(so);
		resetMinAndMax();
		run("Save", "save=" +  _RootFolder + "Exp-" + _FileName + ".tif");
		close();
		close();
	}
	item++;
}

setBatchMode(false);