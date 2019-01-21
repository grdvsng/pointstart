#Region Надстройки для компиляции.
; Прописываем основную информацию, иконку, метод сжатия.

#pragma compile(Out, PointStart.exe)
#pragma compile(Icon, .\bin\shaders\logo.ico)
#pragma compile(ExecLevel, none)
#pragma compile(Compatibility, win7)
#pragma compile(UPX, False)
#pragma compile(FileDescription, PointStart - безопасный запуск от имени администратора)
#pragma compile(ProductName, PointStart)
#pragma compile(ProductVersion, 1.0)
#pragma compile(FileVersion, 1.2, 1.2.1.1)
#pragma compile(LegalCopyright, Тришкин Сергей)
#pragma compile(LegalTrademarks, 'C&S')
#pragma compile(Compression, 9)

#EndRegion

#Region Подключаемые модули и опции запуска.

#comments-start

 Сюда можно прописать параметры запуска программы,
 будьте осторожны данный модуль отвечат за работу программы.

#comments-end

#NoTrayIcon
#include ".\bin\GUI.au3"
#include ".\bin\moduls\runas.au3"

$bin = 'PointStart' ; Родное имя программы.
$main = StringSplit(@ScriptName,'.', 2)[0] ; Имя прогрмаммы вызывающий скрипт

#EndRegion

Func _Run()
#comments-start

	Даннай метод пароверяет:
	1) Указаны ли атрибуты при вызрве программы;

	  I Если user Администратор
		 * Eсли атрибуты запуска указаны, программа:
			   * считывает первый атрибут;
			   * проверят свою целостность;
			   * Загружает константы;
			   * делает вызов дометодов расшифровываающих ярлык и непосредственно запускающих файт.
		 * Eсли атрибуты не указаны, программа:
			* проверят свою целостность;
			* загружает константы
			* делает преустановки;
			* вызывает метод отображения приложения.

	  II Если user неАдминистратор
		 * Закрывается

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

If $bin = $main Then _Run() ; Если программа запускается не в основно режиме или название подменено.