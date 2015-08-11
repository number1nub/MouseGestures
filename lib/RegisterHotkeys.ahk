RegisterHotkeys() {
	IniRead, mainHotkey, %fCommands%, Hotkeys, MainHotkey, % ""
	mainHotkey := mainHotkey ? RegExReplace(Trim(mainHotkey),"^\*") : "RButton"	
	IniRead, disableWinList, %fCommands%, DisableIfActive, List, % ""
	Loop, parse, disableWinList, CSV
		if ((thisWin:=Trim(A_LoopField)) != "")
			GroupAdd, NoRunGroup, %thisWin%
	
	Hotkey, IfWinNotActive, ahk_group NoRunGroup
	Hotkey, *%mainHotkey%, MonitorRButton
	Hotkey, IfWinActive
}