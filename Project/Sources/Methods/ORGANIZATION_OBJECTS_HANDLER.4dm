//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : ORGANIZATION_OBJECTS_HANDLER
  // ID[3F53FF6AE66446689950ED7A076890EA]
  // Created 1-9-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_formEvent;$Lon_parameters)
C_POINTER:C301($Ptr_me)
C_TEXT:C284($Txt_me)
C_OBJECT:C1216($Obj_form)

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
	$Lon_formEvent:=Form event code:C388
	$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
	$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)
	
	$Obj_form:=ORGANIZATION_Handler (New object:C1471(\
		"action";"init"))
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //==================================================
	: ($Txt_me=($Obj_form.name+".help"))
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Clicked:K2:4)
				
				OPEN URL:C673(Get localized string:C991("doc_orgName");*)
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($Txt_me=($Obj_form.identifier+".help"))
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Clicked:K2:4)
				
				OPEN URL:C673(Get localized string:C991("doc_orgIdentifier");*)
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	Else 
		
		ASSERT:C1129(False:C215;"Unknown object: \""+$Txt_me+"\"")
		
		  //==================================================
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End