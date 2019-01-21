#cs ----------------------------------------------------------------------------

Ìîäóëü c îñíîâíûìè ìåòîäàìè ïðîãðàììû.

#ce ----------------------------------------------------------------------------

#include <MsgBoxConstants.au3>
#include <GuiEdit.au3>
#include ".\clientname.au3"

Global $val, $pass, $progName, $domain, _
	   $UserProfileDir  = 'C:\Users\' & UserName() & '\Desktop\'

Func _GetShortName($str)
   ; Ìåòîä ïîçâàëÿåò ñãåíåðèðîâàòü êîðîòêîå èìÿ ôàéëà áåç ïóòè è ðàñøèðåíèÿ.
   $L = StringSplit($str, '\')
   $val = StringSplit($L[$L[0]], '.')

   return $val[1]
EndFunc

Func _Test($run=1)
   #cs
   Ìåòîä ïðîâåðÿåò âîçìîæíîñòü çàïóñêà ïðîãðàììû ñ ïîëüçîâàòåëüñêèìè äàííûìè.
   Â ïðîòèâíîì ñëó÷àå âûçûâàåò îøèáêó.
   Åñëè ïðîãðìàà çàïóùåíà ñ àðãóìåíòàìè êîìàíäíîé ñòðîêè, ìåòîä íå òîëüêî ïðîâåðÿåò,
   íî è çàïóñêàåò ôàéë çàïèñàííûé â ÿðëûêå.
   #ce

   $progName = _GetShortName($file) ; Âûçîâ ìåòîäà äëÿ ãåíèðàöèè êîðîòêîãî èìåíè.
   $longname = $progName & '.exe'
   $dir = StringReplace($file, $longname, '')
   $domain = _GetDomain($username, $dom)
   $username = _GetDomain($username, $usnam)

   FileChangeDir($dir)
   $pid = RunAs($username, $domain, $pass, 0, $longname)

   Select
   Case $pid=0
	  _close(2)
	  $DataStatus=1
	  Return

   Case $run=1
	  ProcessClose($pid)
	  $DataStatus=0
	  Return

   Case $run=0
	  exit

   EndSelect
EndFunc

Func _Link()
   #cs
   Ìåòîä ñîçäàåò ñãåíåðèðîâàííóþ ññûëêó
   äëÿ äàëüíåéøåãî âûçîâà ïðîãðàììû ñ àòðèáóòîì çàïóñêà.
   #ce

   RunAs($username, '', $pass, 2, $file)
   WinActivate($progName & '.exe')

   $lnk = FileSelectFolder('Âûáåðèòå äèðåêòîðèþ äëÿ ñîõðàíåíèÿ',  $UserProfileDir) & '\'

   if @error <> 0 Then
	  $DataStatus=1
	  Return
   EndIf

   $lDir = $lnk
   $lnk &= $progName & ' PS.lnk'
   FileCreateShortcut($scriptpath, $lnk, '', $progName, 'Çàïóñê ïðîãðàììû ïðè ïîìîùè PointStart', $file)

   FileExists($lnk)
   If @error = 0 Then
	  MsgBox(0, 'Óñïåøíî', 'ßðëûê áûë ñãåíåðèðîâàí â ' & $lDir & '.', 3)

   Else
	  MsgBox(0, 'Íåóäà÷à', 'Ïðè ãåíåðàöèè âîçíèêëà îøèáêà.', 10)
	  $DataStatus=1
	  Return
   EndIf

EndFunc

Func _Refresh()
   #cs
   Ìåòîä î÷èùàåò GUI è ñâÿçàííûå ñ íèì ïåðåìåííûå îò
   ïîëüçîâàòåëüñêîé èíôîðìàöèè.
   #ce
   $pass = ''
   $username = ''
   $file = ''

   ; Ñêèäûâàåì âèä âñåõ êíîïîê ïî óìîë÷àíèþ.
   _load(1)
   _form($ButName, $InpName, 1)
   _form($ButPass, $InpPass, 1)
EndFunc

Func _RegAppend()
   #cs
   Ìåòîä äîáàâëÿåò â ðååñòð çàêîäèðîâàííûå çíà÷åíèÿ
   ïîëüçîâàòåëüñêèõ äàííûõ äëÿ çàïóñêà ôàéëîâ êëèåíòà â áóùåì
   ÷åðåç ïðîãðàììó.
   #ce

   $fsecret = FileGetSize($file) & FileGetEncoding($file) ; Ïåðåìåííàÿ ñ äàííûìè ôàéëà, äëÿ èçáåæàíèÿ ïîäìåíû
   $regpath = $reg_path & '\' & $progName

   RegRead ($regpath, 'pass')

   if @error = 0 Then ; Ïðîâåðêà íà ñëó÷àé åñëè óêàçàííàÿ ïðîãðàììà óæå áûëà äîáàâëåíà.
	  $BoxReturn = MsgBox(4, 'Âíèìàíèå!', 'Äàííûå î ïðîãðàììå óæå ñóùåñòâóþò, æåëàåòå ïåðåçàïèñàòü?')
	  If $BoxReturn = 6 Then
		 RegDelete($regpath)

	  Else
		 $DataStatus=1
		 Return
	  EndIf
   EndIf

   RegWrite($regpath, '0', 'REG_SZ', coding($fsecret))
   RegWrite($regpath, '1', 'REG_SZ', coding($username, $fsecret))
   RegWrite($regpath, '2', 'REG_SZ', coding($file, $fsecret))
   RegWrite($regpath, '3', 'REG_SZ', coding($pass, $fsecret))

   RegRead($regpath, '0')
   If @error <> 0 Then
	  _close(5)
	  $DataStatus=1
	  Return

   EndIf
EndFunc

Func _InputColor($but)
   GUICtrlSetBkColor($but, 0xFFFFFF)
   GUICtrlSetColor($but, 0x808080)
   GUICtrlSetFont($but, $fontsize)
EndFunc

Func _form($but, $inp, $opt=0)
   #cs
   Ìåòîä ïðîâåðÿåò äàííûå ââåäåííûå ïîëüçîâàòåëåì
   â ôîðìû GUI è ìåíÿåò èõ â ñîîòâåòñòâèè ñ èõ ñîñòîÿíèåì
   (çàïîëíåíûå/ïóñòûå, ïðèìåíèòü/îòìåíà).
   #ce

   $Data = ControlGetText('', '', $but)
   $text = ControlGetText('', '', $inp)
   $txtName = ControlGetText('', '', $inp)

   If $opt = 0 Then
	  Select
	  Case $inp = $InpName
		 Switch $text
		 Case ''
			MsgBox(0, 'Âíèìàíèå!', 'Èìÿ ïîëüçîâàòåëÿ ââåäåíî íå êîððåêòíî.')
			Return

		 Case 'Èìÿ Ïîëüçîâàòåëÿ'
			MsgBox(0, 'Âíèìàíèå!', 'Âîçìîæíî èìÿ ïîëüçîâàòåëÿ ââåäåíî íåêîððåêòíî.')
		 EndSwitch

	  Case $inp = $InpPass and $truepass == ""
		 MsgBox(0, 'Âíèìàíèå!', 'Ïàðîëü íå íàçíà÷åí, ââåäèòå ïàðîëü èíà÷å ÿðëûê íå áóäåò ñãåíåðèðîâàí.')
		 Return

	  EndSelect

	  $BoxReturn = MsgBox(4, 'Âíèìàíèå!', 'Âû óâåðåíû, ÷òî õîòèòå ïðîäîëæèòü? ')

   Else
	  $BoxReturn = 6
   EndIf

   If $Data == 'Ïîäòâåðäèòü' Then
	  If $BoxReturn = 6 Then
			GUICtrlSetBkColor($inp, 0xD7FED7)
			GUICtrlSetData($but, 'Îòìåíà')
			GUICtrlSetBkColor($but, $BadCBut)
			GUICtrlSetStyle($inp, 0x0800)
			$val = $txtName
			If $inp = $InpPass Then
			   _GUICtrlEdit_SetText($inp, '********')
			   Return $truepass
			   EndIf
			Return $val
		 EndIf

   ElseIf $Data == 'Îòìåíà'  Then
	  If $BoxReturn = 6 Then
			if $inp = $InpName Then
			   GUICtrlSetData($inp, 'Èìÿ Ïîëüçîâàòåëÿ')
			Else
			   GUICtrlSetStyle($inp, $ES_READONLY)
			   GUICtrlSetData($inp, 'Ïàðîëü')
			   $truepass = ""
			EndIf

			GUICtrlSetBkColor($inp, 0xFFFFFF)
			GUICtrlSetBkColor($but, $butscolor)
			GUICtrlSetData($but, 'Ïîäòâåðäèòü')
			GUICtrlSetStyle($inp, $ES_AUTOHSCROLL)
			$val = ''
			Return $val
		 EndIf
   EndIf
EndFunc

Func _Load($opt=0)
   #cs
   Ôóíêöèÿ îòêðûâàåò äèðåêòîðèþ äëÿ âûáîðà ôàéëà ïîëüçîâàòåëåì,
   ïîñëå ÷åãî íàçíà÷àåò ïóòü ê ôàéëó êàê èìÿ ñïåöèàëüíîé ïåðåìåííîé.
   #ce

   If $opt = 0 Then $val = FileOpenDialog("Âûáåðèòå ôàéë", @ProgramFilesDir, "Ïðèëîæåíèå(*.exe)", 2)
   If $opt = 1 Then $val=''

   If $val <> '' Then
	  GUICtrlSetBkColor($bLoad, $CokBut)
	  GUICtrlSetTip($bLoad, $val)

   ElseIf $val == '' or $opt = 1 Then
	  GUICtrlSetBkColor($bLoad, $butscolor)
	  GUICtrlSetTip($bLoad, 'Ôàéë íå óñòàíîâëåí')
   EndIf

   Return $val
EndFunc

Func _close($e=777)
   #cs
   Ïðè âûçîâå ôóíêöèÿ óíè÷òîæàåò îêíî è ïðîöåññ.
   Åñëè ïàðàìåòð îøèáêè çàäàí, áóäóò âûâåäåíû ñâåäåíüÿ î îøèáêå
   #ce
   Dim $errors[10]
   $errors[0] = '#0 The file with add-ons was not found.'
   $errors[1] = '#1 Registry files are corrupted or not found, try restarting the program as an administrator.'
   $errors[2] = '#2 Îøèáêà ïðè îáðàùåíèè ê ïðîãðàììå. '
   $errors[2] &='The input data is probably incorrect. Try generating the link again. '
   $errors[3] = "#3 The file is changed or incompatible with the program, launch is not possible, re-generate the shortcut."
  
   $errors[5] = "#5 Error while writing data to the registrar, the continuation is impossible."
   $errors[6] = "#6 Will not find an auxiliary module name."

   if $e < 777 Then
	  $txt = 'The application was stopped due to an error: ' & @CR & $errors[$e]
	  MsgBox(0, 'Attention!', $txt)
   EndIf

   if $e=2 or $e=5 Then Return

   GUIDelete()
   Exit
EndFunc

Func _move()
   While 1
	  $pos = MouseGetPos()
	  WinMove($GUI, '', $pos[0], $pos[1])

	  If GUIGetCursorInfo()[2] = 0 Then Return
   WEnd
EndFunc
