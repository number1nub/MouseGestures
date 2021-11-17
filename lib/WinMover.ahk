WinMover(win:="") {
	if (!FileExist(fPath:=GetOneDrivePath() "\AHK\GUI Tools\WinMover\WinMover.ahk"))
		return m("ico:!", "Couldn't get user's OneDrive folder path or WinMover.ahk wasn't found...")
	try {
		win := (win && WinExist(tmp:="ahk_id " WinExist(win))) ? tmp : "ahk_id " WinExist("A")
		;~ WinGetTitle, wTitle, %win%
		;~ Run, % fPath ((ErrorLevel || !wTitle) ? "" : " """ wTitle """")
		Run, "%fPath%" "%win%"
	} catch e
		throw Exception("Failed to launch the application.`n`n" e.message, A_ThisFunc, e.extra)
}