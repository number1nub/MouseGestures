ManageScript(Command = "Edit") {
	If (Command="Edit" && !A_IsCompiled)
		Edit
	Else If (Command="Suspend")
		Suspend
	Else If (Command="Reload")
		Reload
	Else If (Command="Exit")
		ExitApp
}