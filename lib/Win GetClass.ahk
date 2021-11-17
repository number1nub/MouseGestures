Win_GetClass() {
	MouseGetPos,,, CurWinID
	WinGetClass, CurWinClass, ahk_id %CurWinID%
	Clipboard := ""
	Clipboard := "ahk_class " CurWinClass
	Show_ToolTip("Window class: " CurWinClass)
	
}