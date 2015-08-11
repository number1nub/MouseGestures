#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%
DetectHiddenWindows, On
SetTitleMatchMode, 2

global fCommands, showTT, RegPath:="Software\WSNHapps\MouseGestures"


;{===== CONIFG FILE SETTINGS ====>>>
	try {
		RegRead, ConfigDir, HKCU, %RegPath%, ConfigDir
		fCommands := ConfigDir "\Commands.ini"
	}
	catch {
		RegWrite, REG_SZ, HKCU, %RegPath%, ConfigDir, % (ConfigDir:=A_AppData "\WSNHapps\MouseGestures")
		fCommands := ConfigDir "\Commands.ini"
		CreateConfig(fCommands)
	}
;}<<<==== CONIFG FILE SETTINGS =====


;{===== REGISTER MAIN HOTKEY ====>>>
	IniRead, mainHotkey, % fCommands, Hotkeys, MainHotkey, Err
	global mainHotkey := (mainHotkey = "Err" || mainHotkey = "") ? "RButton" : RegExReplace(Trim(mainHotkey), "^\*")
	
	IniRead, disableWinList, %fCommands%, DisableIfActive, List, Err
	
	Loop, parse, disableWinList, csv
		if ((thisWin := Trim(A_LoopField)) != "")
			GroupAdd, NoRunGroup, %thisWin%
	
	Hotkey, IfWinNotActive, ahk_group NoRunGroup
	Hotkey, *%mainHotkey%, MonitorRButton
	Hotkey, IfWinActive,
;}<<<==== REGISTER MAIN HOTKEY =====


TrayMenu()
;~ CheckUpdate()
return


TrayMenu() {	
	icoUrl := "http://files.wsnhapps.com/mgr/" (icoName:="MGR.ico")
	RegRead, showTT, HKCU, %RegPath%, showTT

	Menu, DefaultAHK, Standard
	Menu, Tray, NoStandard
	Menu, Tray, Add, Show Tooltips, showTTtoggle
	Menu, Tray, % showTT ? "Check" : "UnCheck", Show Tooltips
	if (!A_IsCompiled) {
		Menu, Tray, Add
		Menu, Tray, Add, Default AHK Menu, :DefaultAHK
	}
	Menu, Tray, Add,
	Menu, Tray, Add, Reload
	Menu, Tray, Add, Exit
	Menu, Tray, Default, Show Tooltips
	
	if (A_IsCompiled)
		Menu, Tray, Icon, % A_ScriptFullpath, -159
	else {
		if (!FileExist(ico:=A_ScriptDir "\" icoName)) {
			URLDownloadToFile, %icoUrl%, %ico%
			if (ErrorLevel)
				FileDelete, %ico%
		}
		Menu, Tray, Icon, % FileExist(ico) ? ico : ""
	}
	
	tt("RUNNING...", "title:Mouse Gestures", "time:1", "tray", "ico:i")
}


showTTtoggle() {
	showTT := !showTT
	RegWrite, REG_SZ, HKCU, %RegPath%, showTT, %showTT%
	Menu, Tray, ToggleCheck, Show Tooltips
}


Exit() {
	ExitApp
}


Reload() {
	Reload
	Pause
}

mgr_MonitorRButton() {
	MonitorRButton:
	MouseGetPos, mX1, mY1
	while GetKeyState(mainHotkey, "P") {
		Sleep, 10
		MouseGetPos, mX2, mY2
		If (Abs(mX2-mX1)>5 || Abs(mY2-mY1)>5) {
			If (Gesture := mgr_MonitorGesture())
				If (Command := mgr_GetCommand(Gesture))
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

mgr_MonitorGesture() { ; Monitor the mouse directions to get the gesture
	While GetKeyState(mainHotkey, "P") {
		MouseGetPos, x1, y1
		While GetKeyState(mainHotkey, "P") {
			Sleep, 10
			MouseGetPos, x2, y2
			If (Sqrt((x2-x1)**2+(y2-y1)**2)>=15)							; If the module is greater or equal than 35,
			{
				Direction := mgr_GetDirection(x2-x1, y2-y1)					;	Get hotkey modifiers & the mouse movement direction
				x1 := x2 , y1 := y2											;	Update the origin point
				If (Direction && LastDirection && Direction<>LastDirection)	;	If the direction has changed,
					Break														;		get the next direction
				Gesture	:= GetMods() mgr_RemoveDups(Directions "-" Direction, "-")	; Set the gesture with the different directions
				Command	:= mgr_GetCommand(Gesture, 1)							;	If there is a description, get the description instead of the command
				If (Gesture && Gesture<>LastGesture) 							;	If the gesture has changed,
					if (showTT) {
						ToolTip, % Command ? Command : Gesture						;		display the command else display the gesture
						LastGesture := Gesture											;	Usefull to know if the gesture has changed
						SetTimer, RemoveTips_tmr, 1000									;	Remove tooltips (+ traytips) after 1.5 seconds
					}
			}
			LastDirection := Direction	; Usefull to know if the direction has changed
		}
		Directions .= "-" LastDirection
		LastDirection := Direction	:= ""
	}
	;~ traytip, % Command ? Command : Gesture
	;~ SetTimer, RemoveTips_tmr, 1000
	return, Gesture
}

mgr_RemoveTips_tmr() {
	RemoveTips_tmr:
	ToolTip
	TrayTip
	SetTimer, RemoveTips_tmr, Off
	return
}

GetMods() {
	Modifiers := ""
	Modifiers .= GetKeyState("Ctrl",	"P") ? "^" : ""
	Modifiers .= GetKeyState("Alt",	"P") ? "!" : ""
	Modifiers .= GetKeyState("Shift",	"P") ? "+" : ""
	Modifiers .= GetKeyState("LWin",	"P") ? "#" : ""
	return, Modifiers
}


mgr_GetDirection(X_Offset, Y_Offset) {
	static dirList := ["R", "UR", "U", "UL", "L", "DL", "D", "DR", "R"]
	
	Module    := Sqrt((X_Offset**2)+(Y_Offset**2))		; Distance between the center and the mouse cursor
	Argument  := ACos(X_Offset/Module)*(45/ATan(1))		; Angle between the mouse and the X-axis from the center
	Argument  := Y_Offset<0 ? Argument : 360-Argument	; (Screen Y-axis is inverted)
	Direction := Ceil((Argument-22.5)/45)				; Converts the argument into a slice number
	;~ Direction := Direction=0 ? "R" : Direction=1 ? "UR" : Direction=2 ? "U" : Direction=3 ? "UL" : Direction=4 ? "L" : Direction=5 ? "DL" : Direction=6 ? "D" : Direction=7 ? "DR" : Direction=8 ? "R" : ""
	return dirList[Direction+1]
}

mgr_RemoveDups(list1, separator="") { ; Remove duplicate followed values
	Loop, Parse, list1, % separator
	{
		If (A_LoopField != Last_LoopField)
			list2 .= separator A_LoopField
		Last_LoopField := A_LoopField
	}
	return % mgr_Trim(list2, separator)
}


;---------------------------------------------------------------------------------------------------
; mgr_GetCommand
;	Get the command associated with the gesture and the active window
;
;	Parameters:
;		Gesture - The string representation of a gesture
;		ReturnDescription - (Optional) Flag indicating whether the command description
;							should be returned. If set to 1, the description is returned,
;							otherwise, the command is returned.
;---------------------------------------------------------------------------------------------------
mgr_GetCommand(Gesture, ReturnDescription=0) {
	; Save the current setting and set it to 2
	TitleMatchMode := A_TitleMatchMode
	SetTitleMatchMode, 2
	
	; Gets the class of the current window where the mouse is
	MouseGetPos, mx, my, WinID
	WinGetClass, WindowClass, ahk_id %WinID%
	WinGetTitle, WindowTitle, ahk_id %WinID%
	
	; Restore the last settings
	SetTitleMatchMode, %TitleMatchMode%
	
	; Checks if there is an associated command for the current window or a general command
	;~ fCommands := "Commands" (instr(computername, "compaq") ? "cpq.ini" : ".ini")
	IniRead, Sections, % fCommands
	Loop, Parse, Sections, `n
	{
		If RegExMatch(A_LoopField, "i)^" WindowClass ":\K.+", TitlePart)
			If RegExMatch(WindowTitle, "i)" TitlePart)
				Section := A_LoopField
	}
	IniRead, ClassAssocCMD,		% fCommands, %	WindowClass,	% Gesture, 0
	IniRead, TitleAssocCMD,		% fCommands, %	Section,		% Gesture, 0
	IniRead, GeneralCMD,		% fCommands,	Commands,		% Gesture, 0
	
	; Gives the priority to the title associated commands
	AssocCMD := TitleAssocCMD ? TitleAssocCMD : ClassAssocCMD
	
	; Gives the priority to the associated commands
	Command := AssocCMD  ? AssocCMD  : GeneralCMD
	
	; Deletes duplicated spaces and tabs
	Command := RegExReplace(Command, "\s+", " ")
	
	; Extracts the description if there is one
	RegExMatch(Command, ";\K.+?$", Description)
	
	; Removes the description from the command
	Command := RegExReplace(Command, ";" Description "$")
	
	; Trims beginning/ending spaces and tabs (= Trim())
	return, mgr_Trim((Description && ReturnDescription) ? Description : Command)
}

mgr_Trim(str, omitchars=" `t") { ; Allow to use Trim() with AutoHotkey basic
	If !StrLen(omitchars)
		return, str
	str := RegExReplace(str, "^[" omitchars "]+") ; Trims from the beginning
	str := RegExReplace(str, "[" omitchars "]+$")	; Trims from the end
	return, str
}

mgr_Execute(Command) {
	If (!Command)
		return
	Transform, Command, Deref, % Command
	
	If (RegExMatch(Command, "i)^\[F\]\s*(?P<Func>\w+)(\(\s*(?P<Params>.+?)\s*\)$)?", m) && IsFunc(mFunc)) {
		If mParams
		{
			Loop, Parse, mParams, CSV
				param%A_Index% := mgr_Trim(A_LoopField)
		}
		%mFunc%(param1, param2, param3, param4, param5, param6, param7, param8, param9, param10)
	}
	else If (RegExMatch(Command, "i)^\[L\]\s*\K.+", Label) && IsLabel(Label))
		Gosub, %Label%
	else If RegExMatch(Command, "i)^\[S\]\s*\K.+", Macro)
		SendInput, {Blind}%macro%
	else If RegExMatch(Command, "i)^\[M\]\s*\K.+", Macro) {
		Macro .= "`n`nsleep, 50`n`nExit App"
		FileDelete, tmpMacroFile.ahk
		FileAppend, %Macro%, tmpMacroFile.ahk
		RunWait, tmpMacroFile.ahk`
	}
	else If RegExMatch(Command, "i)^\[T\]\s*\K.+", Text) {
		StringReplace, Text, Text, ``n, `n, All
		StringReplace, Text, Text, ``r, `r, All
		StringReplace, Text, Text, ``t, %A_Tab%, All
		SendInput, {Raw}%Text%
	}
	else
		Run(Command)
}

CreateConfig(fPath) {
	TrayTip, Mouse Gestures, Setting up for first time use..., 800
	
	cfgTemplate=
	(
	;********************************************************************
	; MAIN HOTKEY
	;
	;	Set the main hotkey for Mouse Gestures. Gestures are recorded
	;	while key is held; when released, the associated action (if any)
	;	is triggered, *unless* the active window matches a  window in
	;	the "Disable if Active" list (see below).
	;
	;	* MUST RELOAD MGR FOR SETTING TO TAKE EFFECT *
	;********************************************************************
	[Hotkeys]
	MainHotkey = RButton


	;********************************************************************
	; DISABLE IF ACTIVE WINDOWS
	;
	;	A comma separated list of window titles or classes that, when
	;	active, will disable to main hotkey.
	;
	;	* MUST RELOAD MGR FOR SETTING TO TAKE EFFECT *
	;********************************************************************
	[DisableIfActive]
	List = SmartGUI Creator for SciTE4AutoHotkey,Creo Parametric


	;********************************************************************
	; CLOSE TAB IF ACTIVE WINDOWS
	;
	;	If a window in this list is active when the win_close
	;	function is called via a mouse gesture, then a "close tab"
	;	command (Ctrl + F4) will be sent instead of the standard
	;	close (Alt + F4) command.
	;
	;	* MUST RELOAD MGR FOR SETTING TO TAKE EFFECT *
	;********************************************************************
	[CloseTabIfActive]
	List = IEFrame,Chrome_WidgetWin_1,MozillaWindowClass


	;********************************************************************
	; GLOBAL GESTURE COMMANDS
	;
	;	Contains list of mouse gestures to watch for and the command
	;	to execute when the gesture is triggered.
	;
	;	A gesture is entered using a combination of the 8 direction
	;	codes shown below, separated with dashes (-) to signify
	;	direction changes. Any combination of modifier key symbols
	;	may also be entered before the gesture code to further customize
	;	the trigger.
	;
	;	A simple command (i.e. a file/folder path) will be executed
	;	using a simple 'run' command. To customize the handling
	;	of commands, a command type can be specified by enclosing
	;	one of the type codes shown below in brackets ([]) at the
	;	beginning of the command.
	;
	;	DIRECTION CODES:
	;		U - Up                 UL - 45? left of up
	;		D - Down               UR - 45? right of up
	;		L - Left               DL - 45? left of down
	;		R - Right              DR - 45? right of down
	;
	;	COMMAND TYPE CODES:
	;		S - Send characters
	;		F - Call a function
	;		L - Call a label
	;		T - Send text
	;		M - Execute custom macro
	;********************************************************************
	[Commands]
	D        = [F] win_minimize	;Minimize window
	U        = [F] win_maximize	;Maximize window
	L        = [S] ^!{NumPad4}	;WinSplit Left
	R        = [S] ^!{NumPad6}	;WinSplit Right
	UR		 = [S] ^!{NumPad9}	;WinSplit Upper-Right
	UL		 = [s] ^!{NumPad7}	;WinSplit Upper-Left
	DL		 = [s] ^!{NumPad1}	;WinSplit Bottom-Left
	DR		 = [s] ^!{NumPad3}	;WinSplit Bottom-Right

	L-R		 = [S] ^{Right}		;WinSplit Move to Right monitor
	R-L		 = [S] ^{Left}		;WinSplit Move to Left monitor

	U-D		 = C:\SkyDrive\AHK\Tools\Incremental Window Switch.ahk
	+U-D	 = [S] ^#{Tab}

	DR-UL    = [F] editcode		;Edit selected file
	R-L-R    = [S] !{F4}		;Close Window
	UR-DL    = [F] win_close	;Close Tab/Window
	UR-DL-UR = [F] win_getclass	;Get window's class

	+R       = `%fCommands`%									;MGR Settings
	+L-R     = [F] EditCode(edit, `%A_ScriptfullPath`%)			;Edit MGR.ahk
	+R-L     = [F] EditCode(edit, `%a_Scriptdir`%\mgr_udf.ahk)	;Edit MGR_UDF.ahk
	+R-L-R   = [F] ManageScript(Reload)						;Reload MGR.ahk


	;____________________________________________________________________
	;********************************************************************
	; CONTEXT-SENSITIVE GESTURE COMMANDS
	;
	;	The gestures defined below are only active/applied when their
	;	respective section name matches the class of the active window.
	;
	;	The context-sensitive commands specified below take priority over
	;	any duplicate global assignments from the [Commands] section.
	;********************************************************************

	;Internet Explorer
	[IEFrame]
	DL       = [S] {Browser_Back}		;IExplore - Back
	UR       = [S] {Browser_Forward}	;IExplore - Forward
	D-U      = [S] ^t					;IExplore - New tab

	;Google Chrome
	[Chrome_WidgetWin_1]
	DL       = [S] {Browser_Back}		;Chrome - Back
	UR       = [S] {Browser_Forward}	;Chrome - Forward
	D-U      = [S] ^t					;Chrome - New Tab

	;Windows Explorer
	[CabinetWClass]
	DL       = [S] {Browser_Back}		;Explorer - Back
	DR       = [S] {Browser_Forward}	;Explorer - Forward
	UL       = [S] !{Up}				;Explorer - Go Up a level

	;VLC PLayer
	[QWidget]
	U-D      =[S] {Space}		;VLC - Play
	D-U		 =[S] ^h			;VLC - Minimal Interface
	DL-UR	 =[S] {Right}		;VLC - Jump foreward
	DR-UL	 =[S] {Left}		;VLC - Jump back
	UR-DL-UR =[S] ^+{Right}		;VLC - Jump foreward big
	UL-DR-UL =[S] ^+{Left}		;VLC - Jump back big
	R-L-R	 =[S] +				;VLC - Faster
	L-R-L    =[S] -				;VLC - Slower
	R-L-R-L  =[S] =				;VLC - Normal
	)
	
	try {
		SplitPath, fPath, fName, fDir
		if (FileExist(fPath)) {
			if (m("File """ fName """ already exists in " fDir ".`n", "Overwrite with a new default config file??", "title:Mouse Gestures - Create New Config", "ico:!", "btn:yn") = "No")
				return
			FileDelete, %fPath%
		}
		if (!FileExist(fDir))
			FileCreateDir, %fDir%
		FileAppend, %cfgTemplate%, %fPath%
	}
	catch e
		throw "Error while creating new config file...`n`nSpecifically during: " e.what
}



#Include lib\CheckUpdate.ahk
#Include lib\m.ahk
#Include lib\MGR_UDF.ahk
#Include lib\tt.ahk