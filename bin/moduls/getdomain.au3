Const    $dom = 0, _ ; Опция метода _GetDomain для возвращение домена от имени.
		 $usnam = 1 ; Опция метода _GetDomain для возвращение имени.

Func _GetDomain($val, $format)
   $temp = StringSplit($val, '', 2)

   For $i in $temp
	  if $i == '\' Then
		 $var = StringSplit($val, '\', 2)
		 Return $var[$format]
	  EndIf
   Next

   if $format = $dom Then Return @ComputerName
   Return $val

EndFunc