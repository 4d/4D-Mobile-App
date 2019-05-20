//%attributes = {"invisible":true}
/*
Text := ***turn_field_name*** ( Param_1 )
 -> Param_1 (Pointer)
________________________________________________________

*/
C_TEXT:C284($0)
C_POINTER:C301($1)

C_LONGINT:C283($Lon_field;$Lon_table)
C_TEXT:C284($Txt_var)

If (False:C215)
	C_TEXT:C284(TURN_AROUND_Field_name ;$0)
	C_POINTER:C301(TURN_AROUND_Field_name ;$1)
End if 

RESOLVE POINTER:C394($1;$Txt_var;$Lon_table;$Lon_field)
$0:=Field name:C257($Lon_table;$Lon_field)