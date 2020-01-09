//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : browser_HANDLER
  // ID[E97E394A05F8412382AF3E00D5EB20D1]
  // Created 9-1-2020 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_LONGINT:C283($eventCode)
C_OBJECT:C1216($Obj_in)

If (False:C215)
	C_OBJECT:C1216(browser_HANDLER ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations

  // NO PARAMETERS REQUIRED

  // Optional parameters
If (Count parameters:C259>=1)
	
	$Obj_in:=$1
	
End if 

  // ----------------------------------------------------

Case of 
		
		  //=========================================================
	: ($Obj_in=Null:C1517)  // Form method
		
		$eventCode:=Form event code:C388
		
		Case of 
				
				  //______________________________________________________
			: ($eventCode=On Load:K2:1)
				
				SET TIMER:C645(-1)
				
				  //______________________________________________________
			: ($eventCode=On Unload:K2:2)
				
				  //______________________________________________________
			: ($eventCode=On Timer:K2:25)
				
				SET TIMER:C645(0)
				
				  //______________________________________________________
			: ($eventCode=On Bound Variable Change:K2:52)
				
				WA OPEN URL:C1020(*;"webArea";Form:C1466.url)
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($eventCode)+")")
				
				  //______________________________________________________
		End case 
		
		  //=========================================================
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End