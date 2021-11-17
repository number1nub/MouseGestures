RunInSciTE() {
	SplitPath, A_AhkPath, AhkFileName, AhkDir
	ScitePath	:= AhkDir "\SciTE.exe"
	Path		:= SaveSelection()
	If (!FileExist(Path) || !FileExist(ScitePath))
		return
	Run, "%ScitePath%" "%Path%",, UseErrorLevel|Max
	If ErrorLevel
		MsgBox, 262160, Run :, Error with this command!`n%Path%, 1
}