GetConfig(fName:="Commands.ini") {
	RegPath := "HKCU\Software\WSNHapps\MouseGestures"
	Version := A_IsCompiled ? GetVersion() : ";auto_version"
	
	;*** Get & Return Config File Path from Registry ***
	RegRead, cfgDir, %RegPath%, ConfigDir
	if (!ErrorLevel && FileExist(cfgDir))
		return (RegExReplace(cfgDir, "\\$") "\" fName)
	
	try {
		;*** Path Not In Registry - Initial Setup ***
		tt("Setting up for first time use...", "time:1", "ico:i", "tray")
		RegWrite, REG_SZ, %RegPath%, ConfigDir, % (cfgDir:=A_AppData "\WSNHapps\MouseGestures")
		if (FileExist(cfgPath:=cfgDir "\" fName))
			return cfgPath
		
		;*** Create File in User Config Dir ***f
		if (!FileExist(cfgDir))
			FileCreateDir, %cfgDir%
		if (A_IsCompiled)
			FileInstall, res\ConfigTemplate.ini, %cfgPath%
		else
			FileAppend, % ConfigTemplate(), %cfgPath%
		return cfgPath
	}
	catch e {
		m("Error while creating new config file... ", e.extra,"", e.what, "!")
		ExitApp
	}
}