Win_GetTitle() {
	MouseGetPos,,, CurWinID
	WinGetTitle, CurWinTitle, ahk_id %CurWinID%
	Clipboard := ""
	Clipboard := CurWinTitle
	Show_ToolTip("Window Title: " CurWinTitle)
}