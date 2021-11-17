GetSciTEpath() {
	ahkDir := Trim(RegExReplace(Trim(A_AhkPath), "i)\\AutoHotkey.exe$"))
	SciTEdir := ""
	Loop, %ahkDir%\*, 1
	{
		if instr(A_LoopFileName, "SciTE") {
			FileGetAttrib, attribs, %A_LoopFileFullPath%
			if instr(attribs, "D") {
				SciTEdir := A_LoopFileFullPath
				break
			}
		}
	}
	if !(SciTEdir)
		return
	loop, %SciTEdir%\*
		if (instr(A_LoopFileName, "SciTE") && (A_LoopFileExt = "exe"))
			return A_LoopFileFullPath
	return
}