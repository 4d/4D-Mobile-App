//%attributes = {"invisible":true}
/*
out := ***ACTIONS_PARAMS_UI*** ( action )
 -> action (Text)
 <- out (Object)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : ACTIONS_PARAMS_UI
  // Database: 4D Mobile App
  // ID[43429814D9324358882F88A14298D45D]
  // Created #11-4-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)

C_BOOLEAN:C305($Boo_withFocus)
C_LONGINT:C283($Lon_backgroundColor;$Lon_parameters)
C_TEXT:C284($Txt_action)
C_OBJECT:C1216($Obj_context;$Obj_form;$Obj_out)

If (False:C215)
	C_OBJECT:C1216(ACTIONS_PARAMS_UI ;$0)
	C_TEXT:C284(ACTIONS_PARAMS_UI ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Txt_action:=$1
		
	End if 
	
	$Obj_form:=ACTIONS_PARAMS_Handler (New object:C1471(\
		"action";"init"))
	
	$Obj_context:=$Obj_form.$
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Txt_action="listUI")  // Colors UI according to focus
		
		If ($Obj_form.form.focusedWidget=$Obj_form.parameters.name)\
			 & (Form event:C388=On Getting Focus:K2:7)
			
			OBJECT SET RGB COLORS:C628(*;$Obj_form.form.focusedWidget;Foreground color:K23:1;ui.highlightColor;ui.highlightColor)
			OBJECT SET RGB COLORS:C628(*;$Obj_form.form.focusedWidget+".border";ui.selectedColor;Background color none:K23:10)
			
		Else 
			
			OBJECT SET RGB COLORS:C628(*;$Obj_form.form.focusedWidget;Foreground color:K23:1;0x00FFFFFF;0x00FFFFFF)
			OBJECT SET RGB COLORS:C628(*;$Obj_form.form.focusedWidget+".border";ui.backgroundUnselectedColor;Background color none:K23:10)
			
		End if 
		
		  //______________________________________________________
	: ($Txt_action="background")  // <Background Color Expression>
		
		$Obj_out:=New object:C1471(\
			"color";0x00FFFFFF)  // Default is white
		
		If ($Obj_context.parameter#Null:C1517)
			
			If (ob_equal ($Obj_context.parameter;This:C1470))  // Selected
				
				If ($Obj_form.form.focusedWidget=$Obj_form.parameters.name)
					
					  // Focused
					$Obj_out.color:=ui.backgroundSelectedColor
					
				Else 
					
					$Obj_out.color:=ui.alternateSelectedColor
					
				End if 
			End if 
		End if 
		
		  //______________________________________________________
	: ($Txt_action="meta")  // <Meta info expression>
		
		  // Default values
		$Obj_out:=New object:C1471(\
			"stroke";"black";\
			"fontWeight";"normal")
		
		  // Mark duplicate names
		ob_createPath ($Obj_out;"cell.names")
		$Obj_out.cell.names.stroke:=Choose:C955($Obj_context.action.parameters.indices("name = :1";This:C1470.name).length>1;ui.errorRGB;"black")
		
		  //______________________________________________________
	Else 
		
		  // Return the context object
		$Obj_out:=$Obj_context
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End