Win_Minimize() {
	MouseGetPos,,, WinID
	WinMinimize, ahk_id %WinID%
}