#Region ���������� ��� ����������.
; ����������� �������� ����������, ������, ����� ������.

#pragma compile(Out, PointStart.exe)
#pragma compile(Icon, .\bin\shaders\logo.ico)
#pragma compile(ExecLevel, none)
#pragma compile(Compatibility, win7)
#pragma compile(UPX, False)
#pragma compile(FileDescription, PointStart - ���������� ������ �� ����� ��������������)
#pragma compile(ProductName, PointStart)
#pragma compile(ProductVersion, 1.0)
#pragma compile(FileVersion, 1.2, 1.2.1.1)
#pragma compile(LegalCopyright, ������� ������)
#pragma compile(LegalTrademarks, 'C&S')
#pragma compile(Compression, 9)

#EndRegion

#Region ������������ ������ � ����� �������.

#comments-start

 ���� ����� ��������� ��������� ������� ���������,
 ������ ��������� ������ ������ ������� �� ������ ���������.

#comments-end

#NoTrayIcon
#include ".\bin\GUI.au3"
#include ".\bin\moduls\runas.au3"

$bin = 'PointStart' ; ������ ��� ���������.
$main = StringSplit(@ScriptName,'.', 2)[0] ; ��� ���������� ���������� ������

#EndRegion

Func _Run()
#comments-start

	������ ����� ����������:
	1) ������� �� �������� ��� ������ ���������;

	  I ���� user �������������
		 * E��� �������� ������� �������, ���������:
			   * ��������� ������ �������;
			   * �������� ���� �����������;
			   * ��������� ���������;
			   * ������ ����� ��������� ����������������� ����� � ��������������� ����������� ����.
		 * E��� �������� �� �������, ���������:
			* �������� ���� �����������;
			* ��������� ���������
			* ������ ������������;
			* �������� ����� ����������� ����������.

	  II ���� user ���������������
		 * �����������

#comments-end

   if $CmdLine[0] <> 0 Then
	  _Checking()
	  _ConsOpt()
	  _LNK($CmdLine[1])

   Else
	  if IsAdmin() Then
		 _Checking()
		 _ConsOpt()
		 _PreSetting()
		 _Render()

	  Else
		 _close(4)
	  EndIf
   EndIf
EndFunc

If $bin = $main Then _Run() ; ���� ��������� ����������� �� � ������� ������ ��� �������� ���������.