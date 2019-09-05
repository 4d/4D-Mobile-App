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
  //C_OBJECT($0)
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_BOOLEAN:C305($b)
C_LONGINT:C283($l)
C_OBJECT:C1216($Obj_form;$o)

If (False:C215)
	C_OBJECT:C1216(ACTIONS_UI ;$0)
	C_TEXT:C284(ACTIONS_UI ;$1)
	C_OBJECT:C1216(ACTIONS_UI ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($1="tableName")  // Populate the table names' column
		
		If (Num:C11($2.tableNumber)#0)
			
			$o:=New object:C1471(\
				"value";Table name:C256($2.tableNumber))
			
		Else 
			
			  // Invite
			$o:=New object:C1471(\
				"value";Get localized string:C991("choose..."))
			
		End if 
		
		  //______________________________________________________
	: ($1="scopeLabel")  // Populate the scope labels' column
		
		$o:=New object:C1471(\
			"value";Get localized string:C991(String:C10($2.scope)))
		
		  //______________________________________________________
	: ($1="listUI")  // Colors UI according to focus
		
		$Obj_form:=ACTIONS_Handler (New object:C1471(\
			"action";"init"))
		
		If ($Obj_form.form.focusedWidget=$Obj_form.actions.name)\
			 & (Form event code:C388=On Getting Focus:K2:7)
			
			OBJECT SET RGB COLORS:C628(*;$Obj_form.form.focusedWidget;Foreground color:K23:1;ui.highlightColor;ui.highlightColor)
			OBJECT SET RGB COLORS:C628(*;$Obj_form.form.focusedWidget+".border";ui.selectedColor;Background color none:K23:10)
			
		Else 
			
			OBJECT SET RGB COLORS:C628(*;$Obj_form.form.focusedWidget;Foreground color:K23:1;0x00FFFFFF;0x00FFFFFF)
			OBJECT SET RGB COLORS:C628(*;$Obj_form.form.focusedWidget+".border";ui.backgroundUnselectedColor;Background color none:K23:10)
			
		End if 
		
		  //______________________________________________________
	: ($1="backgroundColor")  // <Background Color Expression>
		
		$o:=New object:C1471(\
			"color";0x00FFFFFF)
		
		If (Num:C11(This:C1470.index)#0)
			
			$Obj_form:=ACTIONS_Handler (New object:C1471(\
				"action";"init"))
			
			$b:=($Obj_form.form.focusedWidget=$Obj_form.actions.name)
			
			If (ob_equal (This:C1470.current;$2))  // Selected row
				
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
		
		  // Mark not or missing assigned table
		ob_createPath ($o;"cell.tables")
		
		If (Form:C1466.dataModel[String:C10($2.tableNumber)]=Null:C1517)
			
			  // Not published table
			$o.cell.tables.stroke:=ui.errorRGB
			
		Else 
			
			  // Not assigned table
			$o.cell.tables.stroke:=Choose:C955(Num:C11($2.tableNumber)=0;ui.errorRGB;"black")
			
		End if 
		
		  // Mark duplicate names
		ob_createPath ($o;"cell.names")
		$o.cell.names.stroke:=Choose:C955(Form:C1466.actions.indices("name = :1";$2.name).length>1;ui.errorRGB;"black")
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End