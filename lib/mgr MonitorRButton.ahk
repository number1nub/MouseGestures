mgr_MonitorRButton() {
	MonitorRButton:
	MouseGetPos, mX1, mY1
	while GetKeyState(mainHotkey, "P") {
		Sleep, 10
		MouseGetPos, mX2, mY2
		if (Abs(mX2-mX1)>5 || Abs(mY2-mY1)>5) {
			if (Gesture := mgr_MonitorGesture())
				if (Command := mgr_GetCommand(Gesture))
					tooltip, %getsture%
			settimer, removetips_tmr, 1000
			mgr_Execute(Command)
			return
		}
	}
	SendInput, % "{Blind}" GetMods() "{" mainHotkey "}"
	;~ TrayTip,, % "Sent:`n`n{Blind}" GetMods() "{" mainHotkey "}", 1.5, 1
	return
}