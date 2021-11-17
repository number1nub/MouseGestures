showTTtoggle() {
	showTT := !showTT
	RegWrite, REG_SZ, %RegPath%, showTT, %showTT%
	Menu, Tray, ToggleCheck, Show Tooltips
}