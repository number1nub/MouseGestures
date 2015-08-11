mgr_Trim(str, omitchars=" `t") {
	if (!StrLen(omitchars))
		return str
	str := RegExReplace(str, "^[" omitchars "]+")
	str := RegExReplace(str, "[" omitchars "]+$")
	return, str
}