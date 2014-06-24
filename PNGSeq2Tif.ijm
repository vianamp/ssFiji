// Matheus Viana - vianamp@gmail.com - 2.3.2014
// ==========================================================================

_RootFolder = getDirectory("Choose a Directory");

i = 0;
_FileList = getFileList(_RootFolder);
while (i < _FileList.length)  {
	if ( endsWith(_FileList[i],"/") ) {

		_SubFolderMainName = split(_FileList[i],"/"); 

		print(_SubFolderMainName[0]);

		_StackFullPath = _RootFolder + _FileList[i] + "*.bmp";

		run("Image Sequence...", "open=" + _StackFullPath + " number=200 starting=1 increment=1 scale=100 file=img sort");

		_SaveFullPath = _RootFolder + _SubFolderMainName[0] + ".tif";

		run("Save", "save=" + _SaveFullPath);

		close();

	}
	i++;
}
