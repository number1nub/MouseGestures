EditCode(fPath:="", editor:="") {
	static fPaths := {MGR:A_ScriptFullPath, MGR_UDF:A_ScriptDir "\lib\MGR_UDF.ahk"}
	try {
		fPath := fPath ? (FileExist(fPaths[fPath]) ? fPaths[fPath] : fPath) : getSelectedFile()
		Run, % (editor ? RegExReplace(editor, "^\s*""(.+)""\s*$", "$1") : "*edit") " """ RegExReplace(fPath, "^\s*""(.+)""\s*$", "$1") """"
	}
	catch e {
		m("ico:!", "Something went wrong while trying to edit the script """ fPath """", "`n" e.message, "`n" e.extra)
	}
}