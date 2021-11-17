Cpbd_PasteInLastWindow() {
	Clipboard := ""
	SendInput, ^c
	ClipWait, 2, 1
	If (!Clipboard || ErrorLevel)
		return
	Win_Last()
	SendInput, ^v
	Win_Last()
}