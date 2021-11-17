Win_Maximize() {
	MouseGetPos,,, WinID
	WinMaximize, ahk_id %WinID%
}