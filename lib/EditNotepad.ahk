EditNotepad() {
	fObj := {}
	try {
		if (FileExist(sel:=GetSelectedFile(fObj, 1))) {
			;--- SINGLE FILE ---
			try EditRunner(fObj)
			catch e
			m("ico:!", e.message, "", "File: """ e.extra """")
		}
		else {
			;--- MULTIPLE FILES ---
			tmpObj:={}, tmpObj:=fObj, errCount:=0, errMsg:="", fObj:={}
			for i, fObj in tmpObj {
				EditRunner(fObj, 1)
				if (ErrorLevel)
					errCount++, errMsg.=(errMsg ? "`n":"Error List:`n`n") ErrorLevel
			}
			if (errCount)
				m("ico:!", "Error launching " errCount " files...", "", errMsg)
		}
	}
	catch e {
		return m("ico:!", "title: " e.what, e.message, "", e.extra)
	}
}

EditRunner(fObj, UseErrorLvl:="") {
	ErrorLevel := ""
	config := GetEditRunnerConfig()
	fType  := ""
	fExt   := fObj.ext
	fCmd   := config.default.cmd
	for type, typeCfg in config {
		extensions := typeCfg.extensions
		if fExt in %extensions%
		{
			fType := type
			fCmd  := typeCfg.cmd
			Break
		}
	}
	for c, v in {PATH:fObj.path, DIR:fObj.dir, EXT:fObj.ext, NAME:fObj.name}
		fCmd := StrReplace(fCmd, "[" c "]", fObj[c])
	try Run, %fCmd%
	catch e {
		ErrorLevel := """" fObj.path """"
		if (!UseErrorLvl)
			throw Exception("Failed to launch """ fType """ editor program.", A_ThisFunc, fObj.path)
	}
}


GetEditRunnerConfig() {
	oExt := {}
	Loop, Reg, HKCU\SOFTWARE\WSNHapps\EditRunner\Extensions, V
	{
		RegRead, extList
		if (ErrorLevel || !extList || !A_LoopRegName || RegExMatch(extList, "m)^--"))
			Continue
		RegRead, cmd, HKCU\SOFTWARE\WSNHapps\EditRunner\Extensions\Commands, %A_LoopRegName%
		if (ErrorLevel || !cmd)
			Continue
		oExt[A_LoopRegName] := {extensions:extList, cmd:cmd}
	}
	RegRead, defCmd, HKCU\SOFTWARE\WSNHapps\EditRunner\Extensions\Commands
	oExt.default := {extensions:"", cmd:((ErrorLevel || !defCmd) ? "notepad.exe ""[PATH]""" : defCmd)}
	return oExt
}