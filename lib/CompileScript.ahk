CompileScript(outFile:="", inFile:="", IconFile:="") {
	if !(inFile) {	;Get input file from clipboard
		inFile := getSelectedFile() ? getSelectedFile() : ""
		IfEqual, inFile,,return
	}
	else if !(SubStr(inFile,(StrLen(inFile)-2))="ahk")
		return
	if ((instr(infile, "quickCWI.ahk")) || (instr(infile, "CWI search LITE.ahk")) || (instr(inFile, "cwiLoad.ahk"))) {
		SplitPath, inFile,,,,fName
		outFile := "C:\Dropbox\Public\WD RTA Manager sheet\" fName ".exe"
		iconFile := "C:\Dropbox\AHK\icons\cwi.ico"
		run, cmd /c ahk2exe /in `"%inFile%`" /out `"%outFile% /icon `"%iconFile%
	}
	if (outFIle = "C")
		FileSelectFile, outFile,,, Select compile location, Application (*.exe)
	if !((outFile) || (InStr(outFile, ".exe")))
		outFile := StrReplace(inFile, ".ahk", ".exe")
	if !(IconFile)
		FileSelectFile, IconFile, , %A_Desktop%\AHK\Icons, Select an Icon, Icons (*.ico; *.png)
	iconParam := iconFile ? " /icon """ IconFile """" : ""
	run, cmd /c ahk2exe /in `"%inFile%`" /out `"%outFile%`"%iconParam%
}