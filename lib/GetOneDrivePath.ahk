GetOneDrivePath() {
	RegRead, odPath, HKCU\SOFTWARE\Microsoft\OneDrive, UserFolder
	if (ErrorLevel || !odPath)
		return
	return RegExReplace(odPath, "\\$")
}