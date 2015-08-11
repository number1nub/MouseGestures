showTTtoggle() {
	showTT := !showTT
	RegWrite, REG_SZ, HKCU, %RegPath%, showTT, %showTT%
	Menu, Tray, ToggleCheck, Show Tooltips
}