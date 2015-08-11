#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%
DetectHiddenWindows, On
SetTitleMatchMode, 2

global fCommands, mainHotkey, showTT, RegPath:="Software\WSNHapps\MouseGestures"

fCommands := GetConfig()
RegisterHotkeys()
TrayMenu()
;~ CheckUpdate()
return



#Include lib\CheckUpdate.ahk
#Include lib\Exit.ahk
#Include lib\GetConfig.ahk
#Include lib\GetMods.ahk
#Include lib\m.ahk
#Include lib\mgr Execute.ahk
#Include lib\mgr GetCommand.ahk
#Include lib\mgr GetDirection.ahk
#Include lib\mgr MonitorGesture.ahk
#Include lib\mgr MonitorRButton.ahk
#Include lib\mgr RemoveDups.ahk
#Include lib\mgr RemoveTips tmr.ahk
#Include lib\mgr Trim.ahk
#Include lib\MGR_UDF.ahk
#Include lib\RegisterHotkeys.ahk
#Include lib\Reload.ahk
#Include lib\showTTtoggle.ahk
#Include lib\TrayMenu.ahk
#Include lib\tt.ahk