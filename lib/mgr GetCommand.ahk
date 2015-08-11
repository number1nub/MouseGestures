mgr_GetCommand(Gesture, ReturnDescription:=0) {
	TitleMatchMode := A_TitleMatchMode
	SetTitleMatchMode, 2
	MouseGetPos, mx, my, WinID
	WinGetClass, WindowClass, ahk_id %WinID%
	WinGetTitle, WindowTitle, ahk_id %WinID%
	SetTitleMatchMode, %TitleMatchMode%
	
	;~ fCommands := "Commands" (instr(computername, "compaq") ? "cpq.ini" : ".ini")
	IniRead, Sections, % fCommands
	Loop, Parse, Sections, `n
	{
		if (RegExMatch(A_LoopField, "i)^" WindowClass ":\K.+", TitlePart))
			if (RegExMatch(WindowTitle, "i)" TitlePart))
				Section := A_LoopField
	}
	IniRead, ClassAssocCMD,		% fCommands, %	WindowClass,	% Gesture, 0
	IniRead, TitleAssocCMD,		% fCommands, %	Section,		% Gesture, 0
	IniRead, GeneralCMD,		% fCommands,	Commands,		% Gesture, 0
	
	AssocCMD := TitleAssocCMD ? TitleAssocCMD : ClassAssocCMD
	Command := AssocCMD  ? AssocCMD  : GeneralCMD
	Command := RegExReplace(Command, "\s+", " ")
	RegExMatch(Command, ";\K.+?$", Description)
	Command := RegExReplace(Command, ";" Description "$")
	return mgr_Trim((Description && ReturnDescription) ? Description : Command)
}