
/*!
	Function: TasksWindow([timeout])
	Displays the Windows Flip3D list.
	
	Parameters:
	timeout - (Optional) Max amount of time (in seconds) to wait for user to click a window
	before closing Flip3D. Default is 5 seconds.
	
*/
TasksWindow(timeout = 5) {
	SendInput, ^#{Tab}
	KeyWait, LButton, T5
	Send, % ErrorLevel ? "{Esc}" : "Click"Error
}


/*!
	Function: Win_Minimize()
	Minimize the window under the mouse, or, optionally,
	the currently active window.
	
	Parameters:
	underMouse - (Optional) Flag indicating whether the window under
	the mouse or the currently active window should be
	minimized. Default is 1 (minimize window under mouse).
*/
Win_Minimize() {
	MouseGetPos,,, WinID
	WinMinimize, ahk_id %WinID%
}


/*!
	Function: Win_Maximize()
	Maximize the window under the mouse, or, optionally,
	the currently active window.
	
	Parameters:
	underMouse - (Optional) Flag indicating whether the window under
	the mouse or the currently active window should be
	maximized. Default is 1 (maximize window under mouse).
*/
Win_Maximize() {
	MouseGetPos,,, WinID
	WinMaximize, ahk_id %WinID%
}

/*!
	Function: Win_Close([underMouse])
	Closes the window under the mouse, or optionally, 
	the active window.
*/
Win_Close() {
	MouseGetPos,,, WinID
	WinActivate, ahk_id %WinID%
	WinWaitActive, ahk_id %WinID%
	WinGetTitle, thisTitle
	WinGetClass, thisClass
	
	IniRead, closeTabWinList, %fCommands%, CloseTabIfActive, List, Err
	
	if thisTitle contains %closeTabWinList%
	{
		Send, {Blind}^{F4}
		return
	}
	if thisClass contains %closeTabWinList%
	{
		Send, {Blind}^{F4}
		return
	}
	Send, {Blind}!{F4}
}


/*!
	Function: Win_AlwaysOnTop()
	Toggle a window between AlwaysOnTop states
*/
Win_AlwaysOnTop() {
	MouseGetPos,,, WinID
	WinSet, AlwaysOnTop, Toggle, ahk_id %WinID%
}


/*!
	Function: Win_GetClass()
	Get the class of the current window & copies it to the clipboard
	
*/
Win_GetClass() {
	MouseGetPos,,, CurWinID
	WinGetClass, CurWinClass, ahk_id %CurWinID%
	Clipboard := CurWinClass
	Show_ToolTip("Window class: " CurWinClass)
} 


/*!
	Function: Win_GetTitle()
	Get the title of the current window & copies it to the clipboard
	
*/
Win_GetTitle() {
	MouseGetPos,,, CurWinID	
	WinGetTitle, CurWinTitle, ahk_id %CurWinID%
	Clipboard := CurWinTitle
	Show_ToolTip("Window Title: " CurWinTitle)
} 


/*!
	Function: Win_Last()
	Activates the last window
*/
Win_Last() {
	IDs := Get_WinList()
	StringSplit, ID, IDs, `,
	WinActivate, % "ahk_id" ID3
}


/*!
	Function: Win_Activate(win)
	Activates the specified window, if it exists.
	
	Parameters:
	win - A window title (or class; see the winClass parameter) to match & activate.
	winClass - (Optional) A flag indicating that the win parameter specifies a class
	rather than a title.
*/
Win_Activate(win, winClass = 0) {
	TMM := A_TitleMatchMode
	SetTitleMatchMode, 2
	if WinExist((winClass ? "ahk_class " : "") win)
		WinActivate, % (winClass ? "ahk_class " : "") win
	SetTitleMatchMode, %TMM%
}



/*!
	Function: Get_WinList([output])
	Returns a comma-separated list of the currently open windows.
	
	Parameters:
	output - (Optional) Flag indicating that the window list should be displayed in a MsgBox.
*/
Get_WinList(output="") {
	DetectHiddenWindowsB := A_DetectHiddenWindows
	DetectHiddenWindows, Off
	WinGet, ID, List
	Loop, % ID
	{
		ID := ID%A_Index%
		WinGetTitle, Title, ahk_id %ID%
		WinGetClass, Class, ahk_id %ID%
		If Title
			If Title not in Program manager,Startup,D?marrer
				If Class not in tooltips_class32
					IDs .= (IDs ? "," : "") ID
	}
	DetectHiddenWindows, %DetectHiddenWindowsB%
	if output
		MsgBox % IDs
	return, IDs
}



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


GuiClose() {
	Gui, %A_Gui%:Destroy
}


GuiEscape() {
	Gui, %A_Gui%:Destroy
}


Cpbd_PastePlainText() {	
	MouseGetPos,,, CurrentWindowID
	WinActivate, ahk_id %CurrentWindowID%
	Clipboard := Clipboard
	Send, ^v
}


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


Cpbd_PastePlainTextInLastWindow() {	
	Clipboard := GetSelection()
	Win_Last()
	Cpbd_PastePlainText()
	SendInput, `n`n
	Sleep, 500
	Win_Last()
}



/*!
	Function: GetSelection([PlainText])
	Get the user's selection and converts it to text format
	
	Parameters:
	PlainText - (Optional) This flag determines if the return value will be
	treated as plain text or returned in the standard format. Defaults to true &
	returns plain text unless either 0, false or an empty string ("") is specified
	RestoreCB - (Optional) Flag that sets whether or not to restore the clipboard to its
	original content. Default is 0 ([b]don't[/b] restore clipboard)
	
	Returns:
	Returns the selection (as plaintext or default formatting, depending on value of the [b]PlainText[/b] flag
	passed (default is plain text).
	
	Throws:
	Throws an exception if an error is encountered (i.e. unable to copy selection to
	
*/
GetSelection(PlainText = 1, RestoreCB = 0) {	
	cbBU := ClipboardAll	; Save the previous clipboard
	Clipboard := ""					; Start off empty to allow ClipWait to detect when the text has arrived
	SendInput, {Blind}^c					; Simulate the Copy hotkey (Ctrl+C)
	ClipWait, 1, 1					; Wait 2 seconds for the clipboard to contain text
	If ErrorLevel
		throw { what: "GetSelection", message: "Unable to copy selection to clipboard" }
	If !(PlainText)
		return, ClipboardAll
	Selection := Clipboard			; Put the clipboard in the variable Selection
	Clipboard := RestoreCB ? cbBU : Clipboard			; Restore the previous clipboard
	return, Selection				; return the selection
}



/*!
	Function: SaveSelection()
	Saves the user's selection in a txt file
	
	Parameters:
	fPath - (Optional) The path of the file in which to save the selection. If blank
				or omitted, a file save dialog will be displayed to the user.
*/
SaveSelection(fPath:="") {
	try {
		sel := GetSelection()
		FileSelectFile, fPath, S 24,, Where should the file be saved?, Text Files (*.txt)
		FileDelete, % fPath
		FileAppend, % sel, % fPath
	}
	catch e {
		errAction := InStr(e.what, "GetSelection") ? "Get the current selection."
				 : ((InStr(e.what, "SelectFile") ? "Invalid file selection:"
				   : InStr(e.what, "Delete") ? "Delete the specified file:"
				   : InStr(e.what, "Append") ? "Write the selection to the file:") "`n`t""" fPath """")		
		m("Oops..`n", "An error occurred while trying to " errAction, "!")
	}
}




/*!
	Function: CopyToNotepad()
	Copies the selected text into a new Notepad window
*/
CopyToNotepad() {
	try Selection := GetSelection()
	catch
		return
	Path := A_Temp "\AutoHotkey\CopyToNotepad.txt"
	FileDelete, % Path
	FileAppend, %Selection%, %Path%
	run, notepad "%path%"
}



/*!
	Function: CopyToRun()
	Copies the selected text into a Run prompt
*/
CopyToRun() {
	try Selection := GetSelection()
	catch
		return	
	TTM := A_TitleMatchMode
	SetTitleMatchMode, 3
	Send, {Blind}#r
	WinWait, Run,,1.5
	If !(ErrorLevel)	
		Send, {Blind}^v
	SetTitleMatchMode, %TTM%
}



/*!
	Function: GetSciTEpath()
	Returns the full path to SciTE on the current machine.
	
	Returns:
	Returns the full path to the SciTE4AutoHotkey executable (if found).
	If SciTE isn't found then an empty string is returned.
*/
GetSciTEpath() {
	ahkDir := Trim(RegExReplace(Trim(A_AhkPath), "i)\\AutoHotkey.exe$"))
	SciTEdir := ""
	Loop, %ahkDir%\*, 1
	{
		if instr(A_LoopFileName, "SciTE") {
			FileGetAttrib, attribs, %A_LoopFileFullPath%
			if instr(attribs, "D") {
				SciTEdir := A_LoopFileFullPath
				break
			}
		}
	}
	if !(SciTEdir)
		return
	loop, %SciTEdir%\*
		if (instr(A_LoopFileName, "SciTE") && (A_LoopFileExt = "exe"))
			return A_LoopFileFullPath
	return
}


RunInSciTE() {
	SplitPath, A_AhkPath, AhkFileName, AhkDir
	ScitePath	:= AhkDir "\SciTE.exe"
	Path		:= SaveSelection()
	If (!FileExist(Path) || !FileExist(ScitePath))
		return	
	Run, "%ScitePath%" "%Path%",, UseErrorLevel|Max
	If ErrorLevel
		MsgBox, 262160, Run :, Error with this command!`n%Path%, 1
}


Run(Path) {
	Run, % Path,, UseErrorLevel
	If ErrorLevel
		MsgBox, 262160, Run :, Error with this command!`n%Path%, 1
}



/*!
		Function: ManageScript(Command)
	Performs one of the available script functions on the current script.
	
	Parameters:
	Command - See list below.
	
	## Comands:
	- Edit
	- Suspend
	- Reload
	- Pause
	- Exit
*/
ManageScript(Command = "Edit") {
	If (Command="Edit" && !A_IsCompiled)
		Edit
	Else If (Command="Suspend")
		Suspend
	Else If (Command="Reload")
		Reload
	Else If (Command="Exit")
		ExitApp
}




/*!
	Function: Function([param1, param2, param3, param4, param5, param6, param7, param8, param9, param10])
	Calls a specified function and passes the given parameters.
	
	Parameters:
	param1 - (Optional) Name of the function to call
	param2 - (Optional) First parameter to be passed to the specified function
	param3 - (Optional) Second parameter to be passed to the specified function
	param4 - (Optional) Third parameter to be passed to the specified function
	param5 - (Optional) Fourth parameter to be passed to the specified function
	param6 - (Optional) Fifth parameter to be passed to the specified function
	param7 - (Optional) Sixth parameter to be passed to the specified function
	param8 - (Optional) Seventh parameter to be passed to the specified function
	param9 - (Optional) Eighth parameter to be passed to the specified function
	param10 - (Optional) Ninth parameter to be passed to the specified function
*/
Function(param1="", param2="", param3="", param4="", param5="", param6="", param7="", param8="", param9="", param10="") {
	MsgBox, % "Function:`n" param1 "`n" param2 "`n" param3 "`n" param4 "`n" param5 "`n" param6 "`n" param7 "`n" param8 "`n" param9 "`n" param10 "`nEND!!!"
}


/*!
	Function: AHKscriptManage(sName [, cmd])
	Performs one of the available script functions on the specified script.
	
	Parameters:
	sName - Name of the script file to manipulate
	cmd - (Optional) Action to take on script; can be *Reload,* *Exit* or *Pause.*
	If not specified, the default action is *Reload*.
*/
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



/*!
		Function: EditCode(cmd [, fPath])
	Opens the specified file in its default editor.
	
	Parameters:
	fPath - (Optional) Path of a file to edit. If blank or omitted, the currently
	selected file is used.
	
	Throws:
	If an error occurs, or no file is specified nor selected, function will throw
		an exception.
*/
EditCode(fPath:="") {
	try {
		fPath := fPath ? fPath : getSelectedFile()
		run, *edit `"%fPath%`"
	}
	catch e
	{
		if (e.what = "getSelectedFile")
			return
		if (e.what = "Run")
			run, `"%script%`"
		else
			MsgBox, 4144, , % e.extra
	}	
}



/*!
	Function: getSelectedFile()
	Returns the file Path of the selected/highlighted file.
	
	Throws:
	Throws an exception if unable to get selected file.
*/
getSelectedFile() {
	WinActivate, A
	cbb := Clipboard
	Clipboard := ""
	SendInput, ^c
	ClipWait, 0.5
	If ErrorLevel
		throw { message: "Can't get selected file", what: A_ThisFunc }
	script_Path := Clipboard
	Clipboard := cbb
	return script_Path
}




CompileScript(outFile="", inFile="", IconFile="") {
	if !(inFile) {	;Get input file from clipboard
		inFile := getSelectedFile() ? getSelectedFile() : ""
		IfEqual, inFile,,return	
	} 
	else if !(SubStr(inFile,(StrLen(inFile)-2))="ahk")
		return
	if ((instr(infile, "quickCWI.ahk")) || (instr(infile, "CWI search LITE.ahk")) || (instr(inFile, "cwiLoad.ahk"))) {
		SplitPath, inFile,,,,fName
		outFile := "C:\Dropbox\Public\WD RTA Manager sheet\" fName ".exe"
		iconFile := "C:\Dropbox\AHK\icons\cwi.ico"
		run, cmd /c ahk2exe /in `"%inFile%`" /out `"%outFile% /icon `"%iconFile%
	}
	if (outFIle = "C")
		FileSelectFile, outFile,,, Select compile location, Application (*.exe)	
	if !((outFile) || (InStr(outFile, ".exe")))
		StringReplace, outFile, inFile, .ahk, .exe
	if !(IconFile)
		FileSelectFile, IconFile, , %A_Desktop%\AHK\Icons, Select an Icon, Icons (*.ico; *.png)
	iconParam := iconFile ? " /icon """ IconFile """" : ""
	run, cmd /c ahk2exe /in `"%inFile%`" /out `"%outFile%`"%iconParam%
}	


StringReplace(ByRef InputVar, SearchText, ReplaceText = "", All = "") {
	StringReplace, v, InputVar, %SearchText%, %ReplaceText%, %All%
	return, v
}


SplitPath(InputVar, ByRef OutFileName:="", ByRef OutDir:="", ByRef OutExtension:="", ByRef OutNameNoExt:="", ByRef OutDrive:="") {
	SplitPath, InputVar, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
}


IfIn(ByRef var, MatchList) {
	If var in %MatchList%
		return 1
}


/*!
	Function: Show_ToolTip(_Text [, _Seconds])
	Displays a tooltip at the mouse position with the given text for the specified time
	
	Parameters:
	_Text - Main tooltip text
	_Seconds - (Optional) Number of seconds to display tooltip. Default is 1.5 seconds.
	
*/
Show_ToolTip(_Text, _Seconds:=1.5) {
	t1 := A_TickCount
	
	While (Seconds < _Seconds) {
		Sleep, 10
		t2		:= A_TickCount
		Seconds	:= (t2-t1) // 1000
		ToolTip, % _Text
	}
	ToolTip	
}

