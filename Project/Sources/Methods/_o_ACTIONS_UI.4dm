//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : ACTIONS_UI
// ID[F5B35B27DE504EA3BF5697976B967FB5]
// Created 13-3-2019 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
#DECLARE($entryPoint : Text; $params : Object)->$result : Object

var $icon : Picture
var $isFocused : Boolean
var $color : Integer
var $formData; $action : Object
var $file : 4D:C1709.File
var $path : cs:C1710.path

If (False:C215)
	C_OBJECT:C1216(_o_ACTIONS_UI; $0)
	C_TEXT:C284(_o_ACTIONS_UI; $1)
	C_OBJECT:C1216(_o_ACTIONS_UI; $2)
End if 

// ----------------------------------------------------
// Initialisations

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($entryPoint="load")  // Load project actions
		
		If (Form:C1466.actions#Null:C1517)
			
			// Compute icons
			$path:=cs:C1710.path.new()
			
			For each ($action; Form:C1466.actions)
				
				If (Length:C16(String:C10($action.icon))=0)
					
					READ PICTURE FILE:C678(EDITOR.noIcon; $icon)
					
				Else 
					
					$file:=$path.icon(String:C10($action.icon))
					
					If ($file.exists)
						
						READ PICTURE FILE:C678($file.platformPath; $icon)
						
					Else 
						
						READ PICTURE FILE:C678(EDITOR.errorIcon; $icon)
						
					End if 
				End if 
				
				CREATE THUMBNAIL:C679($icon; $icon; 24; 24; Scaled to fit:K6:2)
				$action.$icon:=$icon
				
			End for each 
		End if 
		
		//______________________________________________________
	: ($entryPoint="tableName")  // Populate the table names' column
		
		If (Num:C11($params.tableNumber)#0)
			
			$result:=New object:C1471("value"; Table name:C256($params.tableNumber))
			
		Else 
			
			// Invite
			$result:=New object:C1471("value"; Get localized string:C991("choose..."))
			
		End if 
		
		//______________________________________________________
	: ($entryPoint="scopeLabel")  // Populate the scope labels' column
		
		$result:=New object:C1471("value"; Get localized string:C991(String:C10($params.scope)))
		
		//______________________________________________________
	: ($entryPoint="listUI")  // Colors UI according to focus
		
		$formData:=_o_ACTIONS_Handler(New object:C1471("action"; "init"))
		
		If ($formData.form.focusedWidget=$formData.actions.name) & (Form event code:C388=On Getting Focus:K2:7)
			
			OBJECT SET RGB COLORS:C628(*; $formData.form.focusedWidget; Foreground color:K23:1)
			OBJECT SET RGB COLORS:C628(*; $formData.form.focusedWidget+".border"; EDITOR.selectedColor)
			
		Else 
			
			OBJECT SET RGB COLORS:C628(*; $formData.form.focusedWidget; Foreground color:K23:1)
			OBJECT SET RGB COLORS:C628(*; $formData.form.focusedWidget+".border"; EDITOR.backgroundUnselectedColor)
			
		End if 
		
		//______________________________________________________
	: ($entryPoint="backgroundColor")  // <Background Color Expression>
		
		$result:=New object:C1471("color"; "transparent")
		
		If (Num:C11(This:C1470.index)#0)
			
			$formData:=_o_ACTIONS_Handler(New object:C1471("action"; "init"))
			
			$isFocused:=($formData.form.focusedWidget=$formData.actions.name)
			
			If (ob_equal(This:C1470.current; $params))  // Selected row
				
				$result.color:=Choose:C955($isFocused; EDITOR.backgroundSelectedColor; EDITOR.alternateSelectedColor)
				
			Else 
				
				$color:=Choose:C955($isFocused; EDITOR.highlightColor; EDITOR.highlightColorNoFocus)
				$result.color:=Choose:C955($isFocused; $color; "transparent")
				
			End if 
		End if 
		
		//______________________________________________________
	: ($entryPoint="metaInfo")  // <Meta info expression>
		
		// Default values
		$result:=New object:C1471(\
			"stroke"; Choose:C955(EDITOR.isDark; "white"; "black"); \
			"fontWeight"; "normal"; \
			"cell"; New object:C1471(\
			"tables"; New object:C1471; \
			"names"; New object:C1471))
		
		// Mark not or missing assigned table
		//ob_createPath($result; "cell.tables")
		
		If (Form:C1466.dataModel[String:C10($params.tableNumber)]=Null:C1517)
			
			// Not published table
			$result.cell.tables.stroke:=EDITOR.errorRGB
			
		Else 
			
			// Not assigned table
			$result.cell.tables.stroke:=Choose:C955(Num:C11($params.tableNumber)=0; EDITOR.errorRGB; Choose:C955(EDITOR.isDark; "white"; "black"))
			
		End if 
		
		// Mark duplicate names
		//ob_createPath($result; "cell.names")
		$result.cell.names.stroke:=Choose:C955(Form:C1466.actions.indices("name = :1"; $params.name).length>1; EDITOR.errorRGB; Choose:C955(EDITOR.isDark; "white"; "black"))
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$entryPoint+"\"")
		
		//______________________________________________________
End case 
