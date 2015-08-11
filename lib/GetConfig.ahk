GetConfig(fName:="Commands.ini") {
	RegRead, cfgDir, HKCU, %RegPath%, ConfigDir
	if (!ErrorLevel && FileExist(cfgDir))
		return (RegExReplace(cfgDir, "\\$") "\" fName)

	;Config not found - Initial setup
	tt("Setting up for first time use...", "time:1", "ico:i", "tray")
	cfgDir := A_AppData "\WSNHapps\MouseGestures"

	cfgTemplate=
	(LTrim
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
		cfgDir  := RegExReplace(cfgDir, "\\$")
		cfgPath := cfgDir "\" fName
		RegWrite, REG_SZ, HKCU, %RegPath%, ConfigDir, %cfgDir%
		if (FileExist(cfgPath)) {
			if (m(Format("{The file ""{1}"" already exists in ""{2}"".`n", fName, cfgDir), "Overwrite the existing file with the default config??", "title:Are You Sure??", "!", "btn:yn", "def:2")!="YES")
				return
			FileDelete, %cfgPath%
		}
		if (!FileExist(cfgDir))
			FileCreateDir, %cfgDir%
		FileAppend, %cfgTemplate%, %cfgPath%
		return cfgPath
	}
	catch e {
		m("Error while creating new config file... ", e.extra,"", e.what, "!")
		ExitApp
	}
}