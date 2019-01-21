#Region Надстройки для компиляции.
; Прописываем основную информацию, иконку, метод сжатия.

#pragma compile(Out, uninstall.exe)
#pragma compile(Icon, .\bin\shaders\unst.ico)
#pragma compile(ExecLevel, none)
#pragma compile(Compatibility, win7)
#pragma compile(UPX, False)
#pragma compile(FileDescription, PointStart - безопасный запуск от имени администратора)
#pragma compile(ProductName, PointStart)
#pragma compile(ProductVersion, 1.0)
#pragma compile(FileVersion, 1.1, 1.1.1.1)
#pragma compile(LegalCopyright, Тришкин Сергей)
#pragma compile(LegalTrademarks, 'C&S')
#pragma compile(Compression, 9)

#EndRegion

#RequireAdmin

Func uninstall()
   $reg_path = 'HKLM\SOFTWARE\Wow6432Node\PointStart'
   $path = @ScriptDir

   DirRemove($path & '\bin', 1)
   RegDelete($reg_path)
   FileDelete($path & '\PointStart.exe')
   FileDelete('C:\Users\Public\Desktop\PointStart.lnk')

   Run('cmd.exe', "C:\Windows\System32\", @SW_SHOW)

   BlockInput(1)
   WinWaitActive('C:\Windows\System32\cmd.exe', '', 1)
   Send('timeout /t 4 /nobreak &' & ' rmdir /s /q ' & '"' & $path & '"' & ' & exit ' & '{ENTER}')
   BlockInput(0)

   MsgBox(0, 'Удаление PointStart', 'Программа была полностью удалена с Вашего компьютера.', 2)
   Exit
EndFunc

Func Start()
   $request=MsgBox(4, 'Удаление PointStart', 'Программа будет полностью удалена с Вашего пк, хотите продолжить?')
   if $request=6 Then uninstall()

   Exit

EndFunc

if FileExists('.\PointStart.au3')=0 Then Start()