Cpbd_PastePlainTextInLastWindow() {
	Clipboard := GetSelection()
	Win_Last()
	Cpbd_PastePlainText()
	SendInput, `n`n
	Sleep, 500
	Win_Last()
}