struct translitWrapper (
	currentPath = getFileNamePath (getThisScriptFileName()),
	regexClass = dotNetClass "System.Text.RegularExpressions.Regex",
	regexOptions = dotNetClass "System.Text.RegularExpressions.RegexOptions",
	ini = currentPath + "translit.ini",
	-- Pattern for good symbols	
	pattern = "[^A-Za-z\-_@!#$=%&(){}[\]0-9+~`'., ]",
	sec = "DICTIONARY",
	table = (for i in (getINISetting ini sec) collect #(i , getINISetting ini sec i)),	
	fn conv s = (
		for i in table do (
			s = regexClass.Replace s i[1] i[2] (regexOptions.IgnoreCase)
		)
		
		-- Remove bad symbols
		return regexClass.Replace s pattern "-"
	)	
)

global translitManager = translitWrapper()


fn translitFileName f = (
	try (setFileAttribute f #readOnly false) catch()
	local n = getFilenameFile f
	local p = getFilenamePath f
	local ext = getFilenameType f
	local nn = translitManager.conv n
	local ff = p + nn + ext
	renameFile f ff
)


translitFileName @"C:\Users\MM\Downloads\TestAutomation\????? ???????.txt"