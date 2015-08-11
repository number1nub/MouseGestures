GetMods() {
	static keys:=["Ctrl", "Alt", "Shift", "LWin"]
		 , syms:={Ctrl:"^", Alt:"!", Shift:"+", LWin:"#"}
	Loop, % keys.MaxIndex()
		mods .= GetKeyState(syms[keys[A_Index]], "P") ? syms[keys[A_Index]] : ""
	return mods
}