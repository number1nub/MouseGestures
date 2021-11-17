AHKscriptManage(sName, cmd="Reload") {
	TMMbu := A_TitleMatchMode
	SetTitleMatchMode, 2
	DetectHiddenWindows, on
	
	if sName = input
		InputBox, sName,Kill Script,Enter name of script,,375,160,,,,,
	
	sName .= (instr(sName, ".ahk")) ? " - AutoHotkey" : ".ahk - AutoHotkey"
	
	MsgNum:= cmd = "Reload" ? 65303:cmd = "Exit" ? 65307:cmd = "Pause" ? 65306:""
	if (msgNum)
		SendMessage, 0x111, %msgNum%,,, %sName%
	sleep 100
	SetTitleMatchMode, % TMMbu
}