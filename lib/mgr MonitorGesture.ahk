mgr_MonitorGesture() { ; Monitor the mouse directions to get the gesture
	While GetKeyState(mainHotkey, "P") {
		MouseGetPos, x1, y1
		While GetKeyState(mainHotkey, "P") {
			Sleep, 10
			MouseGetPos, x2, y2
			if (Sqrt((x2-x1)**2+(y2-y1)**2)>=15)							; if the module is greater or equal than 35,
			{
				Direction := mgr_GetDirection(x2-x1, y2-y1)					;	Get hotkey modifiers & the mouse movement direction
				x1 := x2 , y1 := y2											;	Update the origin point
				if (Direction && LastDirection && Direction<>LastDirection)	;	if the direction has changed,
					Break														;		get the next direction
				Gesture	:= GetMods() mgr_RemoveDups(Directions "-" Direction, "-")	; Set the gesture with the different directions
				Command	:= mgr_GetCommand(Gesture, 1)							;	if there is a description, get the description instead of the command
				if (Gesture && Gesture<>LastGesture) 							;	if the gesture has changed,
					if (showTT) {
						ToolTip, % Command ? Command : Gesture						;		display the command else display the gesture
						LastGesture := Gesture											;	Usefull to know if the gesture has changed
						SetTimer, RemoveTips_tmr, 1000									;	Remove tooltips (+ traytips) after 1.5 seconds
					}
			}
			LastDirection := Direction	; Usefull to know if the direction has changed
		}
		Directions .= "-" LastDirection
		LastDirection := Direction	:= ""
	}
	;~ traytip, % Command ? Command : Gesture
	;~ SetTimer, RemoveTips_tmr, 1000
	return, Gesture
}