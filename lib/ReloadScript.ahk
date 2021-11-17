ReloadScript(scrName) {
	if (!id:=GetAhkPID(scrName))
		return
	PostMessage, 0x111, 65400,,, ahk_pid %id%
}