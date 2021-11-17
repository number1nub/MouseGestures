TrayMenu() {	
	icoUrl:="http://files.wsnhapps.com/mgr/" (icoName:="Mouse Gestures.ico")
	;-- Tray Menu --
	Menu, DefaultAHK, Standard
	Menu, Tray, NoStandard
	Menu, Tray, Add, Open Gestures Config File, OpenConfig
	Menu, Tray, Default, Open Gestures Config File
	RegRead, showTT, %RegPath%, showTT
	Menu, Tray, Add, Show Tooltips, showTTtoggle
	Menu, Tray, % showTT ? "Check" : "UnCheck", Show Tooltips
	Menu, Tray, Add, Gesture Editor, MgrConfig
	if (!A_IsCompiled) {
		Menu, Tray, Add
		Menu, Tray, Add, Default AHK Menu, :DefaultAHK
	}
	Menu, Tray, Add,
	Menu, Tray, Add, Reload
	Menu, Tray, Add, Exit
	;-- Tray Icon --
	if (A_IsCompiled)
		Menu, Tray, Icon, % A_ScriptFullpath, -159
	else {
		if (!FileExist(ico:=A_ScriptDir "\res\" icoName)) {
			URLDownloadToFile, %icoUrl%, %ico%
			if (ErrorLevel)
				FileDelete, %ico%
		}
		Menu, Tray, Icon, % FileExist(ico) ? ico : ""
	}
	;-- TrayTip --
	tipStr := "Mouse Gestures v" Version (A_IsAdmin ? " (Admin)":"")
	Menu, Tray, Tip, %tipStr%
	tt("RUNNING...", "title:" tipStr, "time:1", "tray", "ico:i")
}