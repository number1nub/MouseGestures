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
#Include 
#Include 
#Include 
#Include 
#Include 
#Include 
#Include 
#Include 
#Include lib\MGR_UDF.ahk
#Include 
#Include lib\Reload.ahk
#Include 
#Include lib\TrayMenu.ahk
#Include lib\tt.ahk