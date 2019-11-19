//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : ui_SET_ENABLED
  // ID[D060CD6A3D444F4FA21E790326938909]
  // Created 20-11-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Some objects, like 3D buttons, are not graphically enabled/disabled correctly.
  // So, we do it.
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)
C_BOOLEAN:C305($2)

C_BOOLEAN:C305($Boo_enabled)
C_LONGINT:C283($Lon_parameters;$Lon_type)
C_TEXT:C284($Txt_widget)

If (False:C215)
	C_TEXT:C284(ui_SET_ENABLED ;$1)
	C_BOOLEAN:C305(ui_SET_ENABLED ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_widget:=$1
	
	  // Default values
	$Boo_enabled:=True:C214
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		$Boo_enabled:=$2
		
	End if 
	
	$Lon_type:=OBJECT Get type:C1300(*;$Txt_widget)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
OBJECT SET ENABLED:C1123(*;$Txt_widget;$Boo_enabled)

If ($Boo_enabled)
	
	Case of 
			
			  //______________________________________________________
		: ($Lon_type=Object type 3D button:K79:17) | ($Lon_type=Object type push button:K79:16)
			
			OBJECT SET COLOR:C271(*;$Txt_widget;-(Black:K11:16+(256*Black:K11:16)))
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Not managed object type: \""+$Txt_widget+"\"")
			
			  //______________________________________________________
	End case 
	
Else 
	
	Case of 
			
			  //______________________________________________________
		: ($Lon_type=Object type 3D button:K79:17) | ($Lon_type=Object type push button:K79:16)
			
			OBJECT SET COLOR:C271(*;$Txt_widget;-(Dark grey:K11:12+(256*Dark grey:K11:12)))
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Not managed object type: \""+$Txt_widget+"\"")
			
			  //______________________________________________________
	End case 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End