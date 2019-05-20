//%attributes = {"invisible":true}
/*
out := ***ACTIONS_UI*** ( action )
 -> action (Text)
 <- out (Object)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : ACTIONS_UI
  // Database: 4D Mobile App
  // ID[F5B35B27DE504EA3BF5697976B967FB5]
  // Created #13-3-2019 by Vincent de Lachaux
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
	C_OBJECT:C1216(ACTIONS_UI ;$0)
	C_TEXT:C284(ACTIONS_UI ;$1)
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
	
	$Obj_form:=ACTIONS_Handler (New object:C1471(\
		"action";"init"))
	
	$Obj_context:=$Obj_form.$
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Txt_action="tableName")  // Populate the table names' column
		
		$Obj_out:=New object:C1471
		
		If (Num:C11(This:C1470.tableNumber)#0)
			
			$Obj_out.value:=Table name:C256(This:C1470.tableNumber)
			
		Else 
			
			  // Invite
			$Obj_out.value:=Get localized string:C991("choose...")
			
		End if 
		
		  //______________________________________________________
	: ($Txt_action="scopeLabel")  // Populate the scope labels' column
		
		$Obj_out:=New object:C1471(\
			"value";Get localized string:C991(String:C10(This:C1470.scope)))
		
		  //______________________________________________________
	: ($Txt_action="listUI")  // Colors UI according to focus
		
		If ($Obj_form.form.focusedWidget=$Obj_form.actions.name)\
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
			"color";0x00FFFFFF)
		
		If (Num:C11($Obj_context.index)#0)
			
			$Boo_withFocus:=($Obj_form.form.focusedWidget=$Obj_form.actions.name)
			
			If (ob_equal ($Obj_context.current;This:C1470))
				
				$Obj_out.color:=Choose:C955($Boo_withFocus;ui.backgroundSelectedColor;ui.alternateSelectedColor)
				
			Else 
				
				$Lon_backgroundColor:=Choose:C955($Boo_withFocus;ui.highlightColor;ui.highlightColorNoFocus)
				$Obj_out.color:=Choose:C955($Boo_withFocus;$Lon_backgroundColor;0x00FFFFFF)
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($Txt_action="meta")  // <Meta info expression>
		
		  // Default values
		$Obj_out:=New object:C1471(\
			"stroke";"black";\
			"fontWeight";"normal")
		
		  // Mark not or missing assigned table
		ob_createPath ($Obj_out;"cell.tables")
		
		If (Form:C1466.dataModel[String:C10(This:C1470.tableNumber)]=Null:C1517)
			
			  // Not published table
			$Obj_out.cell.tables.stroke:=ui.errorRGB
			
		Else 
			
			  // Not assigned table
			$Obj_out.cell.tables.stroke:=Choose:C955(Num:C11(This:C1470.tableNumber)=0;ui.errorRGB;"black")
			
		End if 
		
		  // Mark duplicate names
		ob_createPath ($Obj_out;"cell.names")
		$Obj_out.cell.names.stroke:=Choose:C955(Form:C1466.actions.indices("name = :1";This:C1470.name).length>1;ui.errorRGB;"black")
		
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