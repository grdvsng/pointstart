Func dirtorion($exe, $ico='', $iOpt=0)
	  $iLnk = 'C:\Users\Public\Desktop\PointStart.lnk'

	  Switch $iOpt
	  Case 0
		 if FileExists($iLnk) = 0 Then FileCreateShortcut($exe, $iLnk, @WorkingDir, '', 'PointStart', $ico)

	  Case 1
		 if FileExists($iLnk) = 1 Then FileDelete($iLnk)
	  EndSwitch

EndFunc