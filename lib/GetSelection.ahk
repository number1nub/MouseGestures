GetSelection(cut:="") {
	cbb:=Clipboard, Clipboard:=""
	SendInput, % (cut ? "^x" : "^c")
	ClipWait, 0.6
	sel:=Clipboard, Clipboard:=cbb
	return (ErrorLevel ? "" : sel)
}