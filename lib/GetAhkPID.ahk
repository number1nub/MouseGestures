GetAhkPID(name:="") {
	WinGet, ahk_list, List, ahk_class AutoHotkey
	WinGet, studioID, pid, AHK-Studio.exe
	fList:=[]
	Loop, %ahk_list% {
		id := ahk_list%A_Index%
		WinExist("ahk_id " id)
		WinGet, pid, PID
		WinGet, pName, ProcessName
		WinGetTitle, filename
		SplitPath, % (filename:=RegExReplace(filename, " - AutoHotkey v[\d\.]+$")), fName,, fExt, fNameOnly
		if (fName=name || fNameOnly=name)
			return PID
		if (fExt && !(pid=studioID && fName!="AHK-Studio.exe"))
			fList.Push({ID:id, pid:PID, process:pName, name:fName, path:filename})
	}
	return (name ? "" : fList)
}