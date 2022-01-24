//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : str_equal
// ID[DCF30A469D5E4218B85F194A77D16EFA]
// Created 12-5-2015 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Tests if two strings are strictly identical
// ----------------------------------------------------
// #THREAD-SAFE
// ----------------------------------------------------
// Declarations
#DECLARE($text1 : Text; $text2 : Text)->$equal : Boolean

If (False:C215)
	C_TEXT:C284(str_equal; $1)
	C_TEXT:C284(str_equal; $2)
	C_BOOLEAN:C305(str_equal; $0)
End if 

$equal:=(Length:C16($text1)=Length:C16($text2)) && ((Length:C16($text1)=0) | (Position:C15($text1; $text2; 1; *)=1))