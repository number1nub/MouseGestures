#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%
DetectHiddenWindows, On
SetTitleMatchMode, 2
CheckAdmin()

;______________________________________________________________________________
;******************************************************************************
; SET APP INFO & COMILER DIRECTIVES
; NOTE: Do not change, remove or reorder any lines starting with ";@Ahk2Exe"
;******************************************************************************
AppName    := "Mouse Gestures"
;@Ahk2Exe-Let AppName = %A_PriorLine~U)^(.+"){1}(.+)".*$~$2%

AppVersion := "3.2.4.0"
;@Ahk2Exe-Let AppVersion = %A_PriorLine~U)^(.+"){1}(.+)".*$~$2%

AppCompany := "WSNHapps"
;@Ahk2Exe-Let AppCompany = %A_PriorLine~U)^(.+"){1}(.+)".*$~$2%

AppDesc    := "Automate anything with a swipe of the mouse."
;@Ahk2Exe-Let AppDesc = %A_PriorLine~U)^(.+"){1}(.+)".*$~$2%

;@Ahk2Exe-ExeName %A_ScriptDir%\build\%A_ScriptName~\.[^\.]+$~.exe%
;@Ahk2Exe-Let IcoPath = %A_ScriptDir%\res\%A_ScriptName~\.[^\.]+$~.ico%
;@Ahk2Exe-SetMainIcon %U_IcoPath%
;@Ahk2Exe-SetProductName %U_AppName%
;@Ahk2Exe-SetOrigFilename %U_AppName%
;@Ahk2Exe-SetInternalName %U_AppName%
;@Ahk2Exe-SetVersion %U_AppVersion%
;@Ahk2Exe-SetCompanyName %U_AppCompany%
;@Ahk2Exe-SetDescription %U_AppDesc%
;@Ahk2Exe-Obey U_year, FormatTime U_year`,`, yyyy
;@Ahk2Exe-SetCopyright Copyright © %U_year% %U_AppCompany%
;______________________________________________________________________________
;******************************************************************************


global fCommands
	 , mainHotkey
	 , startPos:=[]
	 , showTT
	 , RegPath
	 , Version := AppVersion

fCommands := GetConfig()
RegisterHotkeys()
TrayMenu()
CheckUpdate()
ReloadScript("TheCloser")
return


#Include <AHKscriptManage>
#Include <CheckUpdate>
#Include <CompileScript>
#Include <ConfigTemplate>
#Include <CopyToRun>
#Include <Cpbd PasteInLastWindow>
#Include <Cpbd PastePlainText>
#Include <Cpbd PastePlainTextInLastWindow>
#Include <Ditto>
#Include <EditCode>
#Include <EditNotepad>
#Include <Exit>
#Include <Explore>
#Include <Function>
#Include <Get WinList>
#Include <GetAhkPID>
#Include <GetConfig>
#Include <GetMods>
#Include <GetOneDrivePath>
#Include <GetSciTEpath>
#Include <GetSelectedFile>
#Include <GetSelection>
#Include <GetVersion>
#Include <GuiClose>
#Include <GuiEscape>
#Include <IfIn>
#Include <ManageScript>
#Include <mgr Execute>
#Include <mgr GetCommand>
#Include <mgr GetDirection>
#Include <mgr MonitorGesture>
#Include <mgr MonitorRButton>
#Include <mgr RemoveDups>
#Include <mgr RemoveTips tmr>
#Include <mgr Trim>
#Include <MgrConfig>
#Include <OpenConfig>
#Include <RegisterHotkeys>
#Include <Reload>
#Include <ReloadScript>
#Include <Run>
#Include <RunInSciTE>
#Include <SaveSelection>
#Include <Show ToolTip>
#Include <showTTtoggle>
#Include <SplitPath>
#Include <TasksWindow>
#Include <TrayMenu>
#Include <tt>
#Include <Win Activate>
#Include <Win AlwaysOnTop>
#Include <Win Close>
#Include <Win GetClass>
#Include <Win GetInfo>
#Include <Win GetList>
#Include <Win GetTitle>
#Include <Win GetTitleAndClass>
#Include <Win Last>
#Include <Win Maximize>
#Include <Win Minimize>
#Include <WinMover>
#Include <WinSplit>