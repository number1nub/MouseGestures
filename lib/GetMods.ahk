GetMods() {
	mods .= GetKeyState("Ctrl", "P") ? "^" : ""
	mods .= GetKeyState("Alt",	"P") ? "!" : ""
	mods .= GetKeyState("Shift", "P") ? "+" : ""
	mods .= GetKeyState("LWin",	"P") ? "#" : ""
	return mods
}