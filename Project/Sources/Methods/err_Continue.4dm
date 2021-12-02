//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : Continue
// ID[059593008F9741E1A807F101AD2FCD26]
// Created 18-5-2017 by Vincent de Lachaux
// ----------------------------------------------------
C_BOOLEAN:C305($0)

C_BOOLEAN:C305($Boo_noError)

If (False:C215)
	C_BOOLEAN:C305(err_Continue; $0)
End if 

// ----------------------------------------------------
$Boo_noError:=(ERROR=0)

// ----------------------------------------------------
$0:=$Boo_noError