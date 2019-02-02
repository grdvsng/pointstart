#cs ----------------------------------------------------------------------------

Модуль c основными методами программы.

#ce ----------------------------------------------------------------------------

#include <MsgBoxConstants.au3>
#include <GuiEdit.au3>
#include ".\clientname.au3"

Global $val, $pass, $progName, $domain, _
	   $UserProfileDir  = 'C:\Users\' & UserName() & '\Desktop\'

Func _GetShortName($str)
   ; Метод позваляет сгенерировать короткое имя файла без пути и расширения.
   $L = StringSplit($str, '\')
   $val = StringSplit($L[$L[0]], '.')

   return $val[1]
EndFunc

Func _Test($run=1)
   #cs
   Метод проверяет возможность запуска программы с пользовательскими данными.
   В противном случае вызывает ошибку.
   Если прогрмаа запущена с аргументами командной строки, метод не только проверяет,
   но и запускает файл записанный в ярлыке.
   #ce

   $progName = _GetShortName($file) ; Вызов метода для генирации короткого имени.
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
   Метод создает сгенерированную ссылку
   для дальнейшего вызова программы с атрибутом запуска.
   #ce

   RunAs($username, '', $pass, 2, $file)
   WinActivate($progName & '.exe')

   $lnk = FileSelectFolder('Выберите директорию для сохранения',  $UserProfileDir) & '\'

   if @error <> 0 Then
	  $DataStatus=1
	  Return
   EndIf

   $lDir = $lnk
   $lnk &= $progName & ' PS.lnk'
   FileCreateShortcut($scriptpath, $lnk, '', $progName, 'Запуск программы при помощи PointStart', $file)

   FileExists($lnk)
   If @error = 0 Then
	  MsgBox(0, 'Успешно', 'Ярлык был сгенерирован в ' & $lDir & '.', 3)

   Else
	  MsgBox(0, 'Неудача', 'При генерации возникла ошибка.', 10)
	  $DataStatus=1
	  Return
   EndIf

EndFunc

Func _Refresh()
   #cs
   Метод очищает GUI и связанные с ним переменные от
   пользовательской информации.
   #ce
   $pass = ''
   $username = ''
   $file = ''

   ; Скидываем вид всех кнопок по умолчанию.
   _load(1)
   _form($ButName, $InpName, 1)
   _form($ButPass, $InpPass, 1)
EndFunc

Func _RegAppend()
   #cs
   Метод добавляет в реестр закодированные значения
   пользовательских данных для запуска файлов клиента в бущем
   через программу.
   #ce

   $fsecret = FileGetSize($file) & FileGetEncoding($file) ; Переменная с данными файла, для избежания подмены
   $regpath = $reg_path & '\' & $progName

   RegRead ($regpath, 'pass')

   if @error = 0 Then ; Проверка на случай если указанная программа уже была добавлена.
	  $BoxReturn = MsgBox(4, 'Внимание!', 'Данные о программе уже существуют, желаете перезаписать?')
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
   Метод проверяет данные введенные пользователем
   в формы GUI и меняет их в соответствии с их состоянием
   (заполненые/пустые, применить/отмена).
   #ce

   $Data = ControlGetText('', '', $but)
   $text = ControlGetText('', '', $inp)
   $txtName = ControlGetText('', '', $inp)

   If $opt = 0 Then
	  Select
	  Case $inp = $InpName
		 Switch $text
		 Case ''
			MsgBox(0, 'Внимание!', 'Имя пользователя введено не корректно.')
			Return

		 Case 'Имя Пользователя'
			MsgBox(0, 'Внимание!', 'Возможно имя пользователя введено некорректно.')
		 EndSwitch

	  Case $inp = $InpPass and $truepass == ""
		 MsgBox(0, 'Внимание!', 'Пароль не назначен, введите пароль иначе ярлык не будет сгенерирован.')
		 Return

	  EndSelect

	  $BoxReturn = MsgBox(4, 'Внимание!', 'Вы уверены, что хотите продолжить? ')

   Else
	  $BoxReturn = 6
   EndIf

   If $Data == 'Confirm' Then
	  If $BoxReturn = 6 Then
			GUICtrlSetBkColor($inp, 0xD7FED7)
			GUICtrlSetData($but, 'Cancel')
			GUICtrlSetBkColor($but, $BadCBut)
			GUICtrlSetStyle($inp, 0x0800)
			$val = $txtName
			If $inp = $InpPass Then
			   _GUICtrlEdit_SetText($inp, '********')
			   Return $truepass
			   EndIf
			Return $val
		 EndIf

   ElseIf $Data == 'Cancel'  Then
	  If $BoxReturn = 6 Then
			if $inp = $InpName Then
			   GUICtrlSetData($inp, 'Username')
			Else
			   GUICtrlSetStyle($inp, $ES_READONLY)
			   GUICtrlSetData($inp, 'Password')
			   $truepass = ""
			EndIf

			GUICtrlSetBkColor($inp, 0xFFFFFF)
			GUICtrlSetBkColor($but, $butscolor)
			GUICtrlSetData($but, 'Confirm')
			GUICtrlSetStyle($inp, $ES_AUTOHSCROLL)
			$val = ''
			Return $val
		 EndIf
   EndIf
EndFunc

Func _Load($opt=0)
   #cs
   Функция открывает директорию для выбора файла пользователем,
   после чего назначает путь к файлу как имя специальной переменной.
   #ce

   If $opt = 0 Then $val = FileOpenDialog("Change file", @ProgramFilesDir, "Aplication(*.exe)", 2)
   If $opt = 1 Then $val=''

   If $val <> '' Then
	  GUICtrlSetBkColor($bLoad, $CokBut)
	  GUICtrlSetTip($bLoad, $val)

   ElseIf $val == '' or $opt = 1 Then
	  GUICtrlSetBkColor($bLoad, $butscolor)
	  GUICtrlSetTip($bLoad, 'Файл не установлен')
   EndIf

   Return $val
EndFunc

Func _close($e=777)
   #cs
   При вызове функция уничтожает окно и процесс.
   Если параметр ошибки задан, будут выведены сведенья о ошибке
   #ce
   Dim $errors[10]
   $errors[0] = '#0 The file with add-ons was not found.'
   $errors[1] = '#1 Registry files are corrupted or not found, try restarting the program as an administrator.'
   $errors[2] = '#2 Ошибка при обращении к программе. '
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