//%attributes = {"invisible":true}
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
C_OBJECT:C1216($2)

C_BOOLEAN:C305($b)
C_LONGINT:C283($l)
C_TEXT:C284($t)
C_OBJECT:C1216($o;$Obj_context;$Obj_form;$Obj_params)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(ACTIONS_PARAMS_UI ;$0)
	C_TEXT:C284(ACTIONS_PARAMS_UI ;$1)
	C_OBJECT:C1216(ACTIONS_PARAMS_UI ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Obj_params:=Form:C1466.$dialog.ACTIONS_PARAMS

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($1="min")\
		 | ($1="max")  // Return the min or max rule value as string
		
		$o:=$Obj_params.parameter
		
		If ($o.rules#Null:C1517)
			
			$c:=$o.rules.extract($1)
			
			If ($c.length>0)
				
				$t:=String:C10($c[0])
				
			End if 
		End if 
		
		$o:=New object:C1471(\
			"value";$t)
		
		  //______________________________________________________
	: ($1="mandatory")  // Return the mandatory rule value as boolean
		
		$o:=$Obj_params.parameter
		
		If ($o.rules#Null:C1517)
			
			$b:=($o.rules.countValues("mandatory")>0)
			
		End if 
		
		$o:=New object:C1471(\
			"value";$b)
		
		  //______________________________________________________
	: ($1="comment")  // Comment associated with the parameter linked to a field
		
		$o:=$Obj_params
		
		If (Num:C11($o.parameter.fieldNumber)#0)  // One parameter slected
			
			If (Num:C11($o.action.tableNumber)#0)
				
				$o:=New object:C1471(\
					"value";Replace string:C233(Get localized string:C991("thisParameterIsLinkedToTheField");\
					"{field}";\
					String:C10(Form:C1466.dataModel[String:C10($o.action.tableNumber)][String:C10($o.parameter.fieldNumber)].name))\
					)
				
			End if 
			
		Else 
			
			$o:=New object:C1471(\
				"value";"")
			
		End if 
		
		  //______________________________________________________
	: ($1="formatLabel")  // display format according to format or type
		
		$o:=$Obj_params.parameter
		
		If (Length:C16(String:C10($o.format))=0)
			
			  // Take type
			$t:=Choose:C955($o.type="string";"text";String:C10($o.type))
			
		Else 
			
			  // Prefer format
			$t:=Choose:C955($o.format#$o.type;"f_"+String:C10($o.format);String:C10($o.type))
			
		End if 
		
		$o:=New object:C1471(\
			"value";Get localized string:C991($t))
		
		  //______________________________________________________
	: ($1="listUI")  // Colors UI according to focus
		
		$Obj_form:=ACTIONS_PARAMS_Handler (New object:C1471(\
			"action";"init"))
		
		If ($Obj_form.form.focusedWidget=$Obj_form.parameters.name)\
			 & (Form event:C388=On Getting Focus:K2:7)
			
			OBJECT SET RGB COLORS:C628(*;$Obj_form.form.focusedWidget;Foreground color:K23:1;ui.highlightColor;ui.highlightColor)
			OBJECT SET RGB COLORS:C628(*;$Obj_form.form.focusedWidget+".border";ui.selectedColor;Background color none:K23:10)
			
		Else 
			
			OBJECT SET RGB COLORS:C628(*;$Obj_form.form.focusedWidget;Foreground color:K23:1;0x00FFFFFF;0x00FFFFFF)
			OBJECT SET RGB COLORS:C628(*;$Obj_form.form.focusedWidget+".border";ui.backgroundUnselectedColor;Background color none:K23:10)
			
		End if 
		
		  //______________________________________________________
	: ($1="backgroundColor")  // <Background Color Expression>
		
		$o:=New object:C1471(\
			"color";0x00FFFFFF)  // Default is white
		
		If (Num:C11($Obj_params.index)#0)
			
			$Obj_form:=ACTIONS_PARAMS_Handler (New object:C1471(\
				"action";"init"))
			
			$b:=($Obj_form.form.focusedWidget=$Obj_form.parameters.name)
			
			If (ob_equal ($Obj_params.parameter;$2))  // Selected row
				
				$o.color:=Choose:C955($b;ui.backgroundSelectedColor;ui.alternateSelectedColor)
				
			Else 
				
				$l:=Choose:C955($b;ui.highlightColor;ui.highlightColorNoFocus)
				$o.color:=Choose:C955($b;$l;0x00FFFFFF)
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($1="metaInfo")  // <Meta info expression>
		
		  // Default values
		$o:=New object:C1471(\
			"stroke";"black";\
			"fontWeight";"normal")
		
		  // Mark duplicate names
		ob_createPath ($o;"cell.names")
		$o.cell.names.stroke:=Choose:C955($Obj_params.action.parameters.indices("name = :1";$2.name).length>1;ui.errorRGB;"black")
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
		
		  // Return the context object
		$o:=$Obj_context
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End