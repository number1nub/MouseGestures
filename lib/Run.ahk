Run(Path, args*) {
	for c, v in args
		params .= (params ? " " : "") """" v """"
	Run, "%Path%" %params%,, UseErrorLevel
	If ErrorLevel
		MsgBox, 262160, Run :, Error with this command!`n%Path%, 1
}