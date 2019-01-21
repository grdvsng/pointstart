#cs ----------------------------------------------------------------------------

������ ��������� ���� ����������.
1) �������� GUI ���� � ���������.
2) �������� � ��������� ���������.
3) �������� ���� ����������.
;) ����� ������� ��������� � ���������� ���������� GUI.

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
   ����� ��������� �������� ����� ���������� �� ����������������� ���������.
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
   ����� ������������� �������� ��������� � ���������� ����������,
   ����������� �������� ��������� � ini ����� ���������.
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
   $icon = IniRead($const_path, 'GUI', 'icon', ''), _ ; ������ ����������.
   $currentcollor = IniRead($const_path, 'GUI', 'backgroun', ''), _ ; ���������� � �������� ������
   $butscolor = IniRead($const_path, 'GUI', 'butscolor', ''), _ ; ���� ������.
   $CokBut = IniRead($const_path, 'GUI', 'CokBut', ''), _ ; ���� ������ � �������� ���������.
   $BadCBut = IniRead($const_path, 'GUI', 'BadCBut', ''), _
   $fontset = IniRead($const_path, 'GUI', 'fontset', ''), _; ��������� ������.
   $event =  Opt('GUIOnEventMode', IniRead($const_path, 'GUI', 'event', '')), _
   $bord = $fontsize * 0.6

   GUICtrlSetDefBkColor($butscolor) ; ��������� ����� ���� ������.
   Global $GUI, $bLoad, $InpName, $ButName, $ButPass, $InpPass, $bCompile, $bLableFile, $what, $cansel, $gwr, $gwl, $ghu, $ghd
   Global $pass, $truepass, $username, $file, $fsecret, $DataStatus

EndFunc

Func _PreSetting()
   #cs
   ����� ������� �������� �������� ���������� ���������.
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

   $bLoad = GUICtrlCreateButton("�������� ����", $left, $iTop, $bweight, $bheight, 0x0001)
   $InpName = GUICtrlCreateInput("��� ������������", $left, $top+$iTop, $bweight, $bheight*0.5, $ES_AUTOHSCROLL)
   $ButName = GUICtrlCreateButton("�����������", $left, $top+($bheight*0.5)+$iTop, $bweight, $bheight*0.5, 0x0300 + 0x0001)
   $InpPass = GUICtrlCreateInput("������", $left, ($top*2)+$iTop, $bweight, $bheight*0.5, BitOR($ES_READONLY, $ES_CENTER))
   $ButPass = GUICtrlCreateButton("�����������", $left, $top*2+($bheight*0.5)+$iTop, $bweight, $bheight*0.5, 0x0300 + 0x0001)
   $bCompile = GUICtrlCreateButton("�������������", $left, ($top*3)+$iTop, $bweight, $bheight, 0x0300 + 0x0001)

   ; ����������� ���������� ��� '�������'.
   _InputColor($InpPass)
   _InputColor($InpName)
   GUICtrlSetTip($InpName, "������� ������ � �������: �����\���. ���� ������������ ��������� ������� ������ ��� ������������.", "����������")
EndFunc

Func _Render()
   #cs
   ����� ����� GUI.
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
			   $truepass = InputBox("������� ������", "������ ������������ �� �������� ������������ �����.", "", "*")

			   If $truepass <> "" Then
				  GUICtrlSetData($InpPass, "������ �������")
				  GUICtrlSetBkColor($InpPass, 0xFFFF00)
			   EndIf

		 Case $CurInfo[4] = $InpName And $CurInfo[2] = 1 And  ControlGetText('', '', $InpName) == "��� ������������"
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