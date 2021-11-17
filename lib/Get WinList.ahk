Get_WinList(output="") {
	DetectHiddenWindowsB := A_DetectHiddenWindows
	DetectHiddenWindows, Off
	WinGet, ID, List
	Loop, % ID
	{
		ID := ID%A_Index%
		WinGetTitle, Title, ahk_id %ID%
		WinGetClass, Class, ahk_id %ID%
		If Title
			If Title not in Program manager,Startup,D?marrer
				If Class not in tooltips_class32
					IDs .= (IDs ? "," : "") ID
	}
	DetectHiddenWindows, %DetectHiddenWindowsB%
	if output
		MsgBox % IDs
	return, IDs
}