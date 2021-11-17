ConfigTemplate() {
	cfgTemplate =	;{
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
	List = SmartGUI Creator for SciTE4AutoHotkey

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
	List = IEFrame,Chrome_WidgetWin_1,Visual Studio,SciTEWindow,MozillaWindowClass,Notepad++

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
	;		U - Up                 UL - 45Ã‚Â° left of up
	;		D - Down               UR - 45Ã‚Â° right of up
	;		L - Left               DL - 45Ã‚Â° left of down
	;		R - Right              DR - 45Ã‚Â° right of down
	;
	;	COMMAND TYPE CODES:
	;		S - Send characters
	;		F - Call a function
	;		L - Call a label
	;		T - Send text
	;		M - Execute custom macro
	;********************************************************************
	[Commands]
	; Window Commands
	D         = [F] win_minimize	;Minimize window
	U         = [F] win_maximize	;Maximize window
	L         = [S] #{Left}			;WinSplit Left
	R         = [S] #{Right}		;WinSplit Right
	L-R		  = [S] +#{Right}		;WinSplit Move to Right monitor
	R-L		  = [S] +#{Left}		;WinSplit Move to Left monitor
	R-L-R     = [S] !{F4}			;Close Window
	UR-DL     = [F] win_close		;Close Tab/Window

	; Window Switching
	U-D		  = [S] #{Tab}		;Application Switch/Task View
	+U-D	  = [F] win_last	;Swith to last window

	; Window Info Commands
	UR-DL-UR  = [F] win_getclass	;Get window's class
	+UR-DL-UR = [F] win_gettitle	;Get window's title

	; MGR Commands
	+R        = %fCommands%									    ;MGR Settings
	+L-R      = [F] EditCode(edit, %A_ScriptfullPath%)			;Edit MGR.ahk
	+R-L      = [F] EditCode(edit, %a_Scriptdir%\mgr_udf.ahk)	;Edit MGR_UDF.ahk
	+R-L-R    = [F] ManageScript( Reload )						;Reload MGR.ahk

	; Other stuff
	DR-UL     = [F] editnotepad		;Edit selected file


	;___________________________________________________________________________
	;***************************************************************************
	; CONTEXT-SENSITIVE GESTURE COMMANDS
	;
	;	The sections below define gesture commands that are only active
	;	if the window class specified by the section name is active.
	;	If a gesture has a global command assigned, the context-sensitive
	;	command below will take priority and be executed instead.
	;***************************************************************************
	;Internet Explorer
	[IEFrame]
	DL       = [S] {Browser_Back}		;IExplore - Back
	UR       = [S] {Browser_Forward}	;IExplore - Forward
	D-U      = [S] ^t					;IExplore - New tab

	;Chrome/MSEdge Browser
	[Chrome_WidgetWin_1]
	DL       = [S] {Browser_Back}		;Chrome - Back
	UR       = [S] {Browser_Forward}	;Chrome - Forward
	D-U      = [S] ^t					;Chrome - New Tab

	;Firefox Browser
	[MozillaWindowClass]
	DL       = [S] {Browser_Back}		;Chrome - Back
	UR       = [S] {Browser_Forward}	;Chrome - Forward
	D-U      = [S] ^t					;Chrome - New Tab

	;Windows File Explorer
	[CabinetWClass]
	DL       = [S] {Browser_Back}		;Explorer - Back
	DR       = [S] {Browser_Forward}	;Explorer - Forward
	UL       = [S] !{Up}				;Explorer - Go Up a level
	)	;}
	
	return cfgTemplate
}