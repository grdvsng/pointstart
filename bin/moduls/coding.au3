#cs ----------------------------------------------------------------------------
Модуль кодируерт и декодирует для программы конфедициальные данные сохраненные
пользователем для запуска программ от имени определенного клиента.а также другие
значения связанные с безопасным использование программы.
#ce ----------------------------------------------------------------------------

Global $secret = Round(DriveSpaceTotal('C:\') * Cos(26031996))

Func coding($val, $sec=2)
   Local $N = 0, $S = ''
   $val = StringToBinary($val, 1)
   $val = StringSplit($val, '', 2)

   For $i In $val
	  If StringIsInt($i) Then
		 $val[$N] = $secret*($i + $sec)
	  EndIf

	  $S &= $val[$N] & 'O'
	  $N += 1

   Next
   return $S
EndFunc

Func encoding($val, $sec=2)
   Local $N = 0, $S = ''
   $val = StringSplit($val, 'O', 2)

   For $i In $val
	  If StringIsInt($i) and $i <> 0 Then
		 $val[$N] = ($i - ($sec*$secret)) / $secret
	  EndIf

	  if $i <> '' Then
		 $S &= $val[$N]
	  EndIf

	  $N += 1
   Next

   $S = BinaryToString($s, 1)

   return $S
EndFunc