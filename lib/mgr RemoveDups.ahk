mgr_RemoveDups(list1, separator="") { ; Remove duplicate followed values
	Loop, Parse, list1, % separator
	{
		if (A_LoopField != Last_LoopField)
			list2 .= separator A_LoopField
		Last_LoopField := A_LoopField
	}
	return % mgr_Trim(list2, separator)
}