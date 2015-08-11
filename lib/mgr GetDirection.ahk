mgr_GetDirection(X_Offset, Y_Offset) {
	static dirList := ["R", "UR", "U", "UL", "L", "DL", "D", "DR", "R"]
	
	Module    := Sqrt((X_Offset**2)+(Y_Offset**2))		; Distance between the center and the mouse cursor
	Argument  := ACos(X_Offset/Module)*(45/ATan(1))		; Angle between the mouse and the X-axis from the center
	Argument  := Y_Offset<0 ? Argument : 360-Argument	; (Screen Y-axis is inverted)
	Direction := Ceil((Argument-22.5)/45)				; Converts the argument into a slice number
	;~ Direction := Direction=0 ? "R" : Direction=1 ? "UR" : Direction=2 ? "U" : Direction=3 ? "UL" : Direction=4 ? "L" : Direction=5 ? "DL" : Direction=6 ? "D" : Direction=7 ? "DR" : Direction=8 ? "R" : ""
	return dirList[Direction+1]
}