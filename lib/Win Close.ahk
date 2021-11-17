Win_Close() {
	MouseGetPos,,, WinID
	WinActivate, ahk_id %WinID%
	WinWaitActive, ahk_id %WinID%
	WinGetTitle, thisTitle
	WinGetClass, thisClass
	
	IniRead, closeTabWinList, %fCommands%, CloseTabIfActive, List, Err
	
	if thisTitle contains %closeTabWinList%
	{
		Send, {Blind}^{F4}
		return
	}
	if thisClass contains %closeTabWinList%
	{
		Send, {Blind}^{F4}
		return
	}
	Send, {Blind}!{F4}
}