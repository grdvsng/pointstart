#cs ----------------------------------------------------------------------------
   Данный модуль проверяет подленость ранее созданого ярлыка
   и если файлы не подменены вызывает метод Тест запускаюзий файл.
#ce ----------------------------------------------------------------------------

Func _LNK($reg)
   $regpath = $reg_path & '\'
   $regpath &= $reg


   RegRead($regpath, '0')
   If @error <> 0 Then _close(3)

   $fsecret = encoding(RegRead($regpath, '0'))
   $username = encoding(RegRead($regpath, '1'), $fsecret)
   $file = encoding(RegRead($regpath, '2'), $fsecret)
   $liesecret = FileGetSize($file) & FileGetEncoding($file)
   $pass = encoding(RegRead($regpath, '3'), $fsecret)

   If $liesecret <> $fsecret Then
	  _close(3)
	  Exit
   EndIf

   _Test(0)

EndFunc
