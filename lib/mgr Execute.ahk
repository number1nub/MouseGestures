mgr_Execute(Command) {
	if (!Command:=Trim(Command))
		return
	Transform, Command, Deref, % Command
	
	if (RegExMatch(Command, "i)^\[F\]\s*(?P<Func>\w+)(\(\s*(?P<Params>.+?)\s*\)$)?", m) && IsFunc(mFunc)) {
		if (mParams)
			Loop, Parse, mParams, CSV
				param%A_Index% := mgr_Trim(A_LoopField)
		%mFunc%(param1, param2, param3, param4, param5, param6, param7, param8, param9, param10)
	}
	else if (RegExMatch(Command, "i)^\[L\]\s*\K.+", Label) && IsLabel(Label))
		Gosub, %Label%
	else if (RegExMatch(Command, "i)^\[S\]\s*\K.+", Macro))
		SendInput, {Blind}%macro%
	else if (RegExMatch(Command, "i)^\[M\]\s*\K.+", Macro)) {
		Macro .= "`n`nsleep, 50`n`nExit App"
		FileDelete, tmpMacroFile.ahk
		FileAppend, %Macro%, tmpMacroFile.ahk
		RunWait, tmpMacroFile.ahk`
	}
	else if (RegExMatch(Command, "i)^\[T\]\s*\K.+", Text)) {
		Text := StrReplace(StrReplace(StrReplace(Text, "``n", "`n"), "``r", "`r"), "``t", A_Tab)
		SendInput, {Raw}%Text%
	}
	else
		Run(Command)
}