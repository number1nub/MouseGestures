Win_GetTitleAndClass() {
	MouseGetPos,,, CurWinID
	WinGetTitle, CurWinTitle, ahk_id %CurWinID%
	WinGetClass, CurWinClass, ahk_id %CurWinID%
	WinGet, CurWinProc, ProcessName, ahk_id %CurWinID%
	Clipboard := ""
	Clipboard := CurWinTitle " ahk_class " CurWinClass
	Show_ToolTip("Window Title: " CurWinTitle "`nWindow Class: " CurWinClass "`n`nPROCESS: " CurWinProc)
}