OpenConfig() {
	try Run, *edit "%fCommands%"
	catch e 
		m("ico:!", "title:ERROR IN " e.what, e.message, "", e.extra)
}