SaveSelection(fPath:="") {
	try {
		sel := GetSelection()
		FileSelectFile, fPath, S 24,, Where should the file be saved?, Text Files (*.txt)
		FileDelete, % fPath
		FileAppend, % sel, % fPath
	}
	catch e {
		errAction := InStr(e.what, "GetSelection") ? "Get the current selection."
		: ((InStr(e.what, "SelectFile") ? "Invalid file selection:"
		: InStr(e.what, "Delete") ? "Delete the specified file:"
		: InStr(e.what, "Append") ? "Write the selection to the file:") "`n`t""" fPath """")
		m("Oops..`n", "An error occurred while trying to " errAction, "!")
	}
}