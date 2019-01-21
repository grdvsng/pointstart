Func UserName()
   Local $Text, $Wpath =  @WorkingDir & '.\bin\moduls\'

   $Pid=Run($Wpath & 'name.bat', "", @SW_HIDE, 0x1+0x2)
   if $Pid = 0 Then Return

   Do
	  $Text &= StdoutRead($Pid)
   Until @error

   Return StringReplace($Text, @CRLF, "")

EndFunc