Show_ToolTip(_Text, _Seconds:=1.5) {
	t1 := A_TickCount
	
	While (Seconds < _Seconds) {
		Sleep, 10
		t2		:= A_TickCount
		Seconds	:= (t2-t1) // 1000
		ToolTip, % _Text
	}
	ToolTip
}