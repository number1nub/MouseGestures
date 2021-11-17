WinSplit(wsKeys) {
	static keys:={"^!Numpad4":"#{Left}", "^!Numpad6":"#{Right}", "+!{Right}":"+#{Right}", "+!{Left}":"+#{Left}"}
	
	Process, Exist, WinSplit.exe
	if (ErrorLevel)
		SendInput, {Blind}%wsKeys%
	else if (ObjHasKey(keys, wsKeys))
		SendInput, % "{Blind}" keys[wsKeys]
}