Cpbd_PastePlainText() {
	MouseGetPos,,, CurrentWindowID
	WinActivate, ahk_id %CurrentWindowID%
	Clipboard := Clipboard
	Send, ^v
}