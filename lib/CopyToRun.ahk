CopyToRun() {
	try Selection := GetSelection()
	catch
		return
	TTM := A_TitleMatchMode
	SetTitleMatchMode, 3
	Send, {Blind}#r
	WinWait, Run,,1.5
	If !(ErrorLevel)
		Send, {Blind}^v
	SetTitleMatchMode, %TTM%
}