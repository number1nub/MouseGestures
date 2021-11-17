Explore(path) {
	WinGetClass, wClass, % "ahk_id " (wId:=WinExist("A"))
	try {
		if (wClass = "CabinetWClass") {
			cbb := Clipboard
			Clipboard := path
			WinActivate, ahk_id %wId%
			WinWaitActive
			SendInput, ^l
			Sleep 50
			SendInput, ^a
			sleep 50
			SendInput, ^v{Enter}
			sleep 50
			clipboard := cbb
			return
		}
		Run, explore %path%
	}
	catch e 
		throw Exception("Failed to open the path in Explorer.", A_ThisFunc, "Path: """ path """")
}