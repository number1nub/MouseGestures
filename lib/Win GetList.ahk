Win_GetList() {
	global
	DetectHiddenWindows := A_DetectHiddenWindows
	DetectHiddenWindows, Off
	
	WinGet, ID, List
	NumWins:=0, ids:="", titles:=""
	Loop, %ID%
	{
		ID := ID%A_Index%
		WinGetTitle, Title, ahk_id %ID%
		WinGetClass, Class, ahk_id %ID%
		If Title
			If Title not in Program manager,Startup,D?marrer
				If Class not in tooltips_class32
					If !(InStr(title,"Hidden Banner") || InStr(title, "WinSplitHookHiddenFrame"))
						IDs.=(IDs?"|":"") ID, TITLEs.=(TITLEs?"|":"") title, NumWins+=1
	}
	Gui, WinList:Default
	Gui, -Caption +ToolWindow +AlwaysOnTop +LabelGui
	Gui, margin, 0, 0
	Gui, font, s11 cblue, Arial
	Gui, Add, ListBox,w600 r%numWins% vprog gGotoProg, %TITLEs%
	Gui, Show, , Open Windows
	DetectHiddenWindows, % DetectHiddenWindows
	return
	
	gotoprog:
	if (A_GuiEvent = "Doubleclick") {
		gui, submit
		gui, destroy
		WinActivate, % prog
	}
	return
}