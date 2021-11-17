Win_Activate(win, winClass = 0) {
	TMM := A_TitleMatchMode
	SetTitleMatchMode, 2
	if WinExist((winClass ? "ahk_class " : "") win)
		WinActivate, % (winClass ? "ahk_class " : "") win
	SetTitleMatchMode, %TMM%
}