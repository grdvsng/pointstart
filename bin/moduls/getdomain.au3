Const    $dom = 0, _ ; ����� ������ _GetDomain ��� ����������� ������ �� �����.
		 $usnam = 1 ; ����� ������ _GetDomain ��� ����������� �����.

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