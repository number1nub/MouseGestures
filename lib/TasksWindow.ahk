TasksWindow(timeout = 5) {
	SendInput, ^#{Tab}
	KeyWait, LButton, T5
	Send, % ErrorLevel ? "{Esc}" : "Click"Error
}