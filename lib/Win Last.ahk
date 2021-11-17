Win_Last() {
	IDs := Get_WinList()
	StringSplit, ID, IDs, `,
	WinActivate, % "ahk_id" ID3
}