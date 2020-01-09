//%attributes = {"invisible":true}
C_TEXT:C284($Txt_widget)

$Txt_widget:=OBJECT Get name:C1087(Object current:K67:2)

Case of 
		  //______________________________________________________
	: ($Txt_widget="return")
		
		CALL SUBFORM CONTAINER:C1086(-1)
		
		  //______________________________________________________
	: (False:C215)
		
		  //______________________________________________________
	Else 
		
		  // A "Case of" statement should never omit "Else"
		
		  //______________________________________________________
End case 