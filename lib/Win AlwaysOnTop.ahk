Win_AlwaysOnTop() {
	MouseGetPos,,, WinID
	WinSet, AlwaysOnTop, Toggle, ahk_id %WinID%
}