  // ----------------------------------------------------
  // Object method : EDITOR.Subform - (4D Mobile App)
  // ID[B259C0E7CB8C44798B0168C4A59E531B]
  // Created #2-3-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_formEvent)
C_POINTER:C301($Ptr_me)
C_TEXT:C284($Txt_me)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event:C388
$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)

  // ----------------------------------------------------
Case of 
		
		  //________________________________________
	: ($Lon_formEvent<0)  // <SUBFORM EVENTS>
		
		Case of 
				
				  //…………………………………………………………………………………………………
			: ($Lon_formEvent=-1)
				
				editor_HANDLER (New object:C1471(\
					"action";"open"))
				
				FORM GOTO PAGE:C247(1)
				
				  //…………………………………………………………………………………………………
			: (False:C215)
				
				  //…………………………………………………………………………………………………
			Else 
				
				ASSERT:C1129(False:C215;"Unknown call from subform ("+String:C10($Lon_formEvent)+")")
				
				  //…………………………………………………………………………………………………
		End case 
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 