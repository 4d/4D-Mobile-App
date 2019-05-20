//%attributes = {"invisible":true}
/*
Object := ***ui_menu*** ( action ; params )
 -> action (Text)
 -> params (Object)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : ui_menu
  // Database: 4D Mobile App
  // ID[AAAFAEA6A90C4323ABAF6133EC593187]
  // Created #18-4-2019 by Vincent de Lachaux
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
	C_OBJECT:C1216(ui_menu ;$0)
	C_TEXT:C284(ui_menu ;$1)
	C_OBJECT:C1216(ui_menu ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_action:=$1
	
	If ($Lon_parameters>=2)
		
		$Obj_params:=$2
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: (This:C1470=Null:C1517)
		
		ASSERT:C1129(False:C215;"This method must be called from an member method")
		
		  //______________________________________________________
	: ($Txt_action="append")
		
		APPEND MENU ITEM:C411(This:C1470.ref;String:C10($Obj_params.item))
		SET MENU ITEM PARAMETER:C1004(This:C1470.ref;-1;String:C10($Obj_params.param))
		SET MENU ITEM MARK:C208(This:C1470.ref;-1;Char:C90(18)*Num:C11($Obj_params.mark))
		
		  //______________________________________________________
	: ($Txt_action="popup")
		
		If ($Obj_params.x#Null:C1517)
			
			This:C1470.choice:=Dynamic pop up menu:C1006(This:C1470.ref;String:C10($Obj_params.default);Num:C11($Obj_params.x);Num:C11($Obj_params.y))
			
		Else 
			
			This:C1470.choice:=Dynamic pop up menu:C1006(This:C1470.ref;String:C10($Obj_params.default))
			
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