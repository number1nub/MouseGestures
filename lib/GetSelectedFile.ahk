/*!
	Function: getSelectedFile([ByRef SelFileObj])
		Gets the details of the currently selected file(s) and stores them in the given object.
	Parameters:
		SelFileObj - (Optional) **ByRef** Variable in which to store an object containing the selected file's full path, name, directory, extension & name w/o extension
		allowMulti - (Optional) Set to **true** to allow returning multiple files from selection. If set to false & multiple files are selected, only the first file is returned.
					 When enabled and multiple files are selected, the file count is returned instead of a path.
	returns:
		When **allowMulti** is enabled and multiple files are selected, returns the the number of files, otherwise, returns the full path of the selected file(.
	Throws:
		Throws an exception if an error occurrs
*/
GetSelectedFile(ByRef SelFileObj:="", allowMulti:="") {
	WinActivate, A
	cbb:=Clipboard, Clipboard:=""
	SendInput, ^c
	ClipWait, 0.6
	cbTxt:=Clipboard, Clipboard:=cbbx
	if (ErrorLevel || !cbTxt)
		throw {message:"Nothing found on clipboard", what:A_ThisFunc}
	if (!FileExist(cbTxt) && !(isMulti:=FileExist(tmp:=RegExReplace(cbTxt, "im)^(.+?)[\r|\n](?:.+[\r\n]?)+$", "$1"))))
		throw {message:"Selection not a valid file path", what:A_ThisFunc, extra:"Specifically:`n`n""" cbTxt """"}
	if (!isMulti) {	;--- Single File
		SplitPath, cbTxt, fName, fDir, fExt, fNameNoExt
		SelFileObj := {path:cbTxt, name:fName, dir:fDir, ext:fExt, nameNoExt:fNameNoExt}
		return cbTxt
	}				;--- Multiple Files
	if (!allowMulti) {
		cbTxt := tmp
		SplitPath, cbTxt, fName, fDir, fExt, fNameNoExt
		SelFileObj := {path:cbTxt, name:fName, dir:fDir, ext:fExt, nameNoExt:fNameNoExt}
		return cbTxt
	}
	SelFileObj:=[], fCount:=0
	for ind, file in StrSplit(cbTxt, "`n", "`r") {
		if (FileExist(file)) {
			SplitPath, file, fName, fDir, fExt, fNameNoExt
			SelFileObj.Push({path:file, name:fName, dir:fDir, ext:fExt, nameNoExt:fNameNoExt})
			fCount++
		}
	}
	return fCount
}