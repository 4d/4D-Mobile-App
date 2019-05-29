//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : ui_form
  // Database: 4D Mobile App
  // ID[C3D3F74CB1554257A2F5466A1220206E]
  // Created #15-4-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_action)
C_OBJECT:C1216($Obj_params)

If (False:C215)
	C_OBJECT:C1216(ui_form ;$0)
	C_TEXT:C284(ui_form ;$1)
	C_OBJECT:C1216(ui_form ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

  // NO PARAMETERS REQUIRED

  // Optional parameters
If ($Lon_parameters>=1)
	
	$Txt_action:=$1
	
	If ($Lon_parameters>=2)
		
		$Obj_params:=$2
		
	End if 
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: (This:C1470=Null:C1517)
		
		ASSERT:C1129(False:C215;"This method must be called from an member method")
		
		  //______________________________________________________
	: (Length:C16($Txt_action)=0)
		
		This:C1470.getEvent()
		This:C1470.getCurrentWidget()
		This:C1470.getFocusedWidget()
		
		  // MOUSEX & MOUSEY are not updated during D&D events
		If (This:C1470.event=On Drag Over:K2:13)\
			 | (This:C1470.event=On Drop:K2:12)
			
			MOUSEX:=Drop position:C608(MOUSEY)
			
		End if 
		
		  //______________________________________________________
	: ($Txt_action="event")
		
		This:C1470.event:=Form event:C388
		
		  //______________________________________________________
	: ($Txt_action="current")
		
		This:C1470.currentWidget:=OBJECT Get name:C1087(Object current:K67:2)
		
		  //______________________________________________________
	: ($Txt_action="focused")
		
		This:C1470.focusedWidget:=OBJECT Get name:C1087(Object with focus:K67:3)
		
		  //______________________________________________________
	: ($Txt_action="call")
		
		If (Value type:C1509($Obj_params.parameters)=Is collection:K8:32)
			
			If ($Obj_params.parameters.length=2)
				
				CALL FORM:C1391(This:C1470.window;This:C1470.callback;$Obj_params.parameters[0];$Obj_params.parameters[1])
				
			Else 
				
				CALL FORM:C1391(This:C1470.window;This:C1470.callback;$Obj_params.parameters[0])
				
			End if 
			
		Else 
			
			CALL FORM:C1391(This:C1470.window;This:C1470.callback;$Obj_params.parameters)
			
		End if 
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Txt_action+"\"")
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=This:C1470

  // ----------------------------------------------------
  // End