// Matheus Viana - vianamp@gmail.com - 2.3.2014
// ==========================================================================

_RootFolder = getDirectory("Choose a Directory");

setBatchMode(true);

i = 0;
_ItemsList = getFileList(_RootFolder);

while (i < _ItemsList.length)  {
	
	if ( endsWith(_ItemsList[i],"/") ) {

		_FolderName = split(_ItemsList[i],"/"); 

		print(_FolderName[0]);

		_ItemsList2 = getFileList(_RootFolder+_FolderName[0]);

		if (_ItemsList2.length > 0) {
	
			_StackFullPath = _RootFolder + _ItemsList[i] + "*.tif";
	
			run("Image Sequence...", "open=" + _StackFullPath + " number=200 starting=1 increment=1 scale=100 file=RFP sort");
	
			_SaveFullPath = _RootFolder + _FolderName[0] + ".tif";
	
			run("Save", "save=" + _SaveFullPath);
	
			close();

			run("Image Sequence...", "open=" + _StackFullPath + " number=200 starting=1 increment=1 scale=100 file=BF sort");
	
			_SaveFullPath = _RootFolder + "BF-" + _FolderName[0] + ".tif";
	
			run("Save", "save=" + _SaveFullPath);
	
			close();
			
		}

	}
	i++;
}
