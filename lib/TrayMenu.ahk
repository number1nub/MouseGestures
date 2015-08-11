TrayMenu() {	
	icoUrl := "http://files.wsnhapps.com/mgr/" (icoName:="MGR.ico")
	RegRead, showTT, HKCU, %RegPath%, showTT

	Menu, DefaultAHK, Standard
	Menu, Tray, NoStandard
	Menu, Tray, Add, Show Tooltips, showTTtoggle
	Menu, Tray, % showTT ? "Check" : "UnCheck", Show Tooltips
	if (!A_IsCompiled) {
		Menu, Tray, Add
		Menu, Tray, Add, Default AHK Menu, :DefaultAHK
	}
	Menu, Tray, Add,
	Menu, Tray, Add, Reload
	Menu, Tray, Add, Exit
	Menu, Tray, Default, Show Tooltips
	
	if (A_IsCompiled)
		Menu, Tray, Icon, % A_ScriptFullpath, -159
	else {
		if (!FileExist(ico:=A_ScriptDir "\" icoName)) {
			URLDownloadToFile, %icoUrl%, %ico%
			if (ErrorLevel)
				FileDelete, %ico%
		}
		Menu, Tray, Icon, % FileExist(ico) ? ico : ""
	}
	
	tt("RUNNING...", "title:Mouse Gestures", "time:1", "tray", "ico:i")
}