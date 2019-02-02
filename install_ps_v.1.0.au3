#Region Надстройки для компиляции.
; Прописываем основную информацию, иконку, метод сжатия.

#pragma compile(Out, install_ps_v_1.0.exe)
#pragma compile(Icon, .\bin\shaders\inst.ico)
#pragma compile(ExecLevel, none)
#pragma compile(Compatibility, win7)
#pragma compile(UPX, False)
#pragma compile(FileDescription, PointStart - secure run as administrator)
#pragma compile(ProductName, PointStart)
#pragma compile(ProductVersion, 1.0)
#pragma compile(FileVersion, 1.1, 1.1.1.1)
#pragma compile(LegalCopyright, Trishkin Sergey)
#pragma compile(LegalTrademarks, 'C&S')
#pragma compile(Compression, 9)

#EndRegion

#Region Подключаемые модули.

#RequireAdmin
#include <GUIConstantsEx.au3>
#include <GUIConstantsEx.au3>
#include <.\bin\moduls\desctoper.au3>
#include <.\bin\moduls\beep.au3>

#EndRegion

#Region  и преднастройки.

Global Const _
			$w = @DesktopWidth / 3, _
			$h = @DesktopWidth * 0.2, _
			$GUI = GUICreate("PointStart", $w, $h, -1, -1, 0x00080000), _
			$wbut = $w*0.25, _
			$whight = $h*0.15, _
			$reg_path = 'HKLM\SOFTWARE\Wow6432Node\PointStart', _
			$myvers = 12, _
			$fPath = RegRead($reg_path & '\Default', 'path'), _
			$fontsize = @DesktopHeight * 0.018

Global $next, $folider, $foldstr, $progress, $dir, $txt
$txt = "«PointStart v 1.0»"
$txt &= @CR
$txt &= @CR & 'Welcome to install'
$txt &= @CR & '«PointStart».'
$txt &= @CR & @CR & 'Program author: grdvsng@gmail.com'

SetGui()

#EndRegion

Func Final($exe, $ico='')

   $request=MsgBox(4, 'The program is installed!', 'Add shortcut to desktop?')
   If $request=6 Then dirtorion($exe, $ico)
   BP()
   MsgBox(0, "Attention!", "Installation completed successfully.")
   Exit

EndFunc

Func SetGui()
   Local  $version = StringSplit(FileGetVersion($fPath), ".", 2), _
		  $last = Execute($version[0] & $version[1]), _
		  $info = GUICtrlCreateLabel($txt, $wbut*0.1, $wbut*0.2, $w, $h*0.6, 0x0C, 2), _
	      $folider = GUICtrlCreateButton("Overview", $w-($wbut*1.1), $h-($wbut*0.9), $wbut, $whight), _
	      $foldstr = GUICtrlCreateLabel("", $wbut*0.1, $h-($wbut*0.85), $wbut*2.8, $whight*0.7, 0x0200+0x01)

   Opt('GUIOnEventMode', 0)
   GUISetBkColor(0xC4E4E1)
   GUISetFont($fontsize)
   GUICtrlSetFont($info, $fontsize, 'Time Roman', 2)
   GUICtrlSetBkColor($foldstr, 0xFFFFFF)

   If $last <> '' Then
	  Select
	  Case $myvers > $last
		 MsgBox(4, 'Attention!', 'An older version of the file is found, do you want to update and continue?')

	  Case $myvers = $last
		 $iBox = MsgBox(4, 'Attention!', 'You have already installed the current version of the machine, want to continue?')

      Case Else
		 $iBox  MsgBox(4, 'Attention!', 'The machine has already installed an updated version, you want to continue the installation (the existing application will be deleted)?')
	  EndSelect

	  if $iBox = 6 Then uninstall()
	  if $iBox <> 6 Then Exit
   EndIf

   GUISetState(@SW_SHOW, $GUI)

   While 1
	  $msg = GUIGetMsg($GUI)

	  Switch $msg
	  Case $GUI_EVENT_CLOSE
		 Exit

	  Case $folider
		 $dir = FileSelectFolder('Choose a directory to install', @ProgramFilesDir)
		 GUICtrlSetData($foldstr, $dir)
		 if FileExists($dir) Then IfExist()
	  EndSwitch
   WEnd

EndFunc

Func IfExist()
   $request=MsgBox(4, 'Attention', 'Path assigned, want to continue?')

   if $request=6 Then
	  ; Удаляем элеменns управления для создания новых.
	  GUICtrlDelete($folider)
	  GUICtrlDelete($foldstr)
	  $folider = Default ; Необходимо для блокирования получений сообщений GUI от нового элемента.
	  ; Создание новых элементиов GUI.
	  $next = GUICtrlCreateLabel("Installation", $w-($wbut*0.97), $h-($wbut*0.8), $wbut, $whight, 0x0B)
	  GUICtrlSetFont($next, $fontsize)
	  $progress = GUICtrlCreateProgress($wbut*0.1, $h-($wbut*0.85), $wbut*2.8, $whight*0.7, 0x10)
	  GUICtrlSetColor($progress, 0xfffff)
	  Install()
   EndIf
EndFunc

Func Install()
   #cs
   Метод отвечает за цикл установки и изменение линии прогресса.

   #ce

   Local $path[5], $reg[2], $n=0, $curdir = @WorkingDir

   $path[0] = $dir & '\PointStart'
   $path[1] = '.\bin\'
   $path[2] = '.\bin\shaders\'
   $path[3] = '.\bin\constant\'
   $path[4] = '.\bin\moduls\'

   DirCreate($path[0])
   FileChangeDir($path[0])

   For $str in $path
	  if $str <> $path[0] Then DirCreate($str)

	  Select
	  Case $str = $path[0]
		 FileInstall(".\PointStart.exe", '.\')
		 FileInstall(".\uninstall.exe", '.\')

	  Case $str == $path[1]
		 FileInstall(".\bin\help.html", $str)

	  Case $str == $path[2]
		 FileInstall(".\bin\shaders\cansel.bmp", $str)
		 FileInstall(".\bin\shaders\what.bmp",  $str)
		 FileInstall(".\bin\shaders\logo.ico",  $str)

	  Case $str == $path[3]
		 FileInstall(".\bin\constant\config.ini", $str)

	  Case $str == $path[4]
		 FileInstall(".\bin\moduls\name.bat", $str)
	  EndSelect

	  if @error <> 0 Then Error($str)

	  $n += 20
	  GUICtrlSetData($progress, $n)
   Next

   RegWrite($reg_path)
   RegWrite($reg_path & '\Default')
   RegWrite($reg_path & '\Default', 'ini', 'REG_SZ', @WorkingDir & "\bin\constant\config.ini")
   RegWrite($reg_path & '\Default', 'path', 'REG_SZ', @WorkingDir & '\PointStart.exe')
   RegWrite($reg_path & '\Default', 'fold', 'REG_SZ', @WorkingDir)

   $n += 20
   GUICtrlSetData($progress, $n)

   Final($path[0] & '\PointStart.exe', @WorkingDir & '\bin\shaders\logo.ico')

EndFunc

Func Error($rise, $box=5)
   #cs
   Метод вызывает при ошибках возникающих при установке.

   #ce

   $resolution = MsgBox($box, 'Attention!','An error occurred: ' & $rise)

   Select
   Case $resolution = 4
	  Install()

   Case $resolution = 6
	  Return

   Case Else
	  Exit
   EndSelect
EndFunc

Func uninstall()
   #cs
   Метод удаляет старую версию программы, если она была установлена.

   #ce
   Local $t = StringSplit($fPath, "\", 2), _
		 $iN = 0, _
		 $val = '', _
		 $ers = 0

   Do
	  $val &= $t[$iN] & '\'
	  $iN += 1
   Until $iN = UBound($t) - 1

   dirtorion(0, 0, 1)
   erros_catcher('DirRemove("' & $val & '", 1)')
   erros_catcher('RegDelete("' & $reg_path & '"& "\Default")')
EndFunc

Func erros_catcher($func)
   Execute($func)
   if @error <> 0 Then Error('failed to delete ' & $func & @CRLF & 'Continue?', 4)
EndFunc

