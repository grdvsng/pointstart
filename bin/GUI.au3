#cs ----------------------------------------------------------------------------

Модуль основного окна приложения.
1) Создание GUI окна и элементов.
2) Загрузка и установка надстроек.
3) Основной цикл приложения.
;) Вызов методов связанных с элементами управления GUI.

#ce ----------------------------------------------------------------------------

#include ".\moduls\getdomain.au3"
#include ".\moduls\coding.au3"
#include ".\moduls\Fbuttons.au3"
#include <MsgBoxConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <WinAPISys.au3>
#include <WinAPIvkeysConstants.au3>

Func _Checking()
   #cs
   Метод проверяет ключевые файлы отвечающее за работоспособность прогнаммы.
   #ce

   Global $reg_path = 'HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\PointStart'

   $val = RegRead($reg_path & '\Default', 'ini')
   if $val == '' Then
	  if not IsAdmin() then _close(1)
	  RegWrite($reg_path)
	  RegWrite($reg_path & '\Default')
	  RegWrite($reg_path & '\Default', 'ini', 'REG_SZ', @ScriptDir & "\bin\constant\config.ini")
	  RegWrite($reg_path & '\Default', 'path', 'REG_SZ', @ScriptFullPath)
   EndIf

   $val = IniRead(RegRead($reg_path & '\Default', 'ini'), 'GUI', 'BadCBut', '')
   If $val = '' Then _close(0)

EndFunc

Func _ConsOpt()
    #cs
   Метод устанавливает основные константы и глобальные переменные,
   большинство констант прописаны в ini файле программы.
   #ce

   Global Const _
   $scriptpath = RegRead($reg_path & '\Default', 'path'), _
   $const_path = RegRead($reg_path & '\Default', 'ini'), _
   $weight = @DesktopWidth * 0.15, _
   $height = @DesktopHeight * 0.4, _
   $bweight = $weight * 0.8, _
   $bheight = $height * 0.2, _
   $fontsize = Round(@DesktopWidth / 106), _
   $left = $weight * 0.1, _
   $iTop = $height * 0.09, _
   $top = $bheight * 1.05, _
   $shaders = IniRead($const_path, 'GUI', 'shaders', ''), _
   $title = 'PointStart', _
   $style = $WS_POPUP, _
   $icon = IniRead($const_path, 'GUI', 'icon', ''), _ ; Иконка приложения.
   $currentcollor = IniRead($const_path, 'GUI', 'backgroun', ''), _ ; Переменная с основным цветом
   $butscolor = IniRead($const_path, 'GUI', 'butscolor', ''), _ ; Цвет кнопок.
   $CokBut = IniRead($const_path, 'GUI', 'CokBut', ''), _ ; Цвет кнопок в активном состоянии.
   $BadCBut = IniRead($const_path, 'GUI', 'BadCBut', ''), _
   $fontset = IniRead($const_path, 'GUI', 'fontset', ''), _; Настройки шрифта.
   $event =  Opt('GUIOnEventMode', IniRead($const_path, 'GUI', 'event', '')), _
   $bord = $fontsize * 0.6

   GUICtrlSetDefBkColor($butscolor) ; установка Цвета всех кнопок.
   Global $GUI, $bLoad, $InpName, $ButName, $ButPass, $InpPass, $bCompile, $bLableFile, $what, $cansel, $gwr, $gwl, $ghu, $ghd
   Global $pass, $truepass, $username, $file, $fsecret, $DataStatus

EndFunc

Func _PreSetting()
   #cs
   Метод создает основные элементы управления прогрымма.
   #ce

   $GUI = GUICreate($title, $weight, $height, -1, -1, $style)
   GUISetIcon(Execute($icon))
   GUISetFont($fontsize, Default, Default, $fontset)
   GUISetBkColor($currentcollor)
   GUICtrlSetDefBkColor($butscolor)
   GUICtrlSetDefColor($currentcollor)

   $gwr=GUICtrlCreateGraphic(0, 0, $bord, $height)
   $gwl=GUICtrlCreateGraphic($weight-$bord, 0, $bord, $height)
   $ghu=GUICtrlCreateGraphic(0, 0, $weight, $bord)
   $ghd=GUICtrlCreateGraphic(0, $height-$bord, $weight, $bord)
   $cansel = GUICtrlCreatePic(".\bin\shaders\cansel.bmp", $weight - ($bweight * 0.1)-$bord, $bord, $bweight * 0.1, $bweight * 0.1)
   $what = GUICtrlCreatePic(".\bin\shaders\what.bmp", $weight - ($bweight * 0.105)*2-$bord, $bord, $bweight * 0.1, $bweight * 0.1)
   GUISetHelp('hh.exe ' & @WorkingDir & "\bin\help.html")

   $bLoad = GUICtrlCreateButton("Выберите файл", $left, $iTop, $bweight, $bheight, 0x0001)
   $InpName = GUICtrlCreateInput("Имя Пользователя", $left, $top+$iTop, $bweight, $bheight*0.5, $ES_AUTOHSCROLL)
   $ButName = GUICtrlCreateButton("Подтвердить", $left, $top+($bheight*0.5)+$iTop, $bweight, $bheight*0.5, 0x0300 + 0x0001)
   $InpPass = GUICtrlCreateInput("Пароль", $left, ($top*2)+$iTop, $bweight, $bheight*0.5, BitOR($ES_READONLY, $ES_CENTER))
   $ButPass = GUICtrlCreateButton("Подтвердить", $left, $top*2+($bheight*0.5)+$iTop, $bweight, $bheight*0.5, 0x0300 + 0x0001)
   $bCompile = GUICtrlCreateButton("Сгенерировать", $left, ($top*3)+$iTop, $bweight, $bheight, 0x0300 + 0x0001)

   ; Специальные надстройки для 'инпутов'.
   _InputColor($InpPass)
   _InputColor($InpName)
   GUICtrlSetTip($InpName, "Введите данные в формате: домен\имя. Если пользователь локальный введите только имя пользователя.", "Информация")
EndFunc

Func _Render()
   #cs
   Метод цикла GUI.
   #ce
   Local $CurInfo[5]

   GUISetState(@SW_SHOW, $GUI)
   GUISwitch($GUI)

   Local $iMsg
   While 0 < 1
	  $iMsg = GUIGetMsg()

	  $CurInfo = GUIGetCursorInfo()
	  If @error = 0 Then
		 Select
		 Case $CurInfo[4] = $InpPass And $CurInfo[2] = 1 And $truepass == ""
			   $truepass = InputBox("Введите данные", "Пароль пользователя на каторого генерируется ярлык.", "", "*")

			   If $truepass <> "" Then
				  GUICtrlSetData($InpPass, "Данные введены")
				  GUICtrlSetBkColor($InpPass, 0xFFFF00)
			   EndIf

		 Case $CurInfo[4] = $InpName And $CurInfo[2] = 1 And  ControlGetText('', '', $InpName) == "Имя Пользователя"
			GUICtrlSetData($InpName, "")
		 EndSelect
	  EndIf

	  Switch $iMsg
		 Case $cansel
            _close()

		 Case $bLoad
			$file = _load()

		 Case $ButName
			$username = _form($ButName, $InpName)

		 Case $ButPass
			$pass = _form($ButPass, $InpPass)

		 Case $what
			Run('hh.exe ' & @WorkingDir & "\bin\help.html", 'c:\windows\system32')

		 Case $bCompile
			_Test()
			If $DataStatus = 0 Then _RegAppend()
			If $DataStatus = 0 Then _Link()
			If $DataStatus = 0 Then _Refresh()

		 Case $gwr
			_move()

		 Case $gwl
			_move()

		 Case $ghu
			_move()

		 Case $ghd
			_move()
	  EndSwitch
   WEnd

EndFunc