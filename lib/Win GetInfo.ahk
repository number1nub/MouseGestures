Win_GetInfo(getTitle:="", getClass:="") {
	MouseGetPos,,, CurWinID
	WinGetTitle, CurWinTitle, ahk_id %CurWinID%
	WinGetClass, CurWinClass, ahk_id %CurWinID%
	Clipboard := ""
	Clipboard := CurWinTitle "`n" CurWinClass
	
	if !(getTitle && getClass) {
		Show_ToolTip("Window Title: " CurWinTitle "`nWindow Class: " CurWinClass)
	}
}