GetVersion() {
	if (!A_IsCompiled)
		return
	FileGetVersion, fVer, %A_ScriptFullPath%
	return (ErrorLevel || !fVer) ? "" : fVer
}