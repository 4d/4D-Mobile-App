//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : FIELDS_Handler
  // ID[BF3981E8AF72452DB0171AEDA52AF625]
  // Created 26-10-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_LONGINT:C283($l;$Lon_formEvent)
C_PICTURE:C286($p)
C_OBJECT:C1216($ƒ;$Obj_form;$Obj_in)

If (False:C215)
	C_OBJECT:C1216(FIELDS_HANDLER ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations

  // NO PARAMETERS REQUIRED

  // Optional parameters
If (Count parameters:C259>=1)
	
	$Obj_in:=$1
	
End if 

$Obj_form:=FIELDS_class ("editor_CALLBACK")  // Form definition

$ƒ:=$Obj_form.$  // Current context

$ƒ.tableNumber:=Num:C11(Form:C1466.$dialog.TABLES.currentTableNumber)

  // ----------------------------------------------------
Case of 
		
		  //=========================================================
	: ($Obj_in=Null:C1517)  // Form method
		
		$Lon_formEvent:=panel_Form_common (On Load:K2:1;On Timer:K2:25)
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Load:K2:1)
				
				  // This trick remove the horizontal gap
				$Obj_form.fieldList.setScrollbar(0;2)
				
				  // Place the tabs according to the localization
				$l:=$Obj_form.selectorFields.bestSize(Align left:K42:2).coordinates.right+10
				$Obj_form.selectorRelations.bestSize(Align left:K42:2).setCoordinates($l;Null:C1517;Null:C1517;Null:C1517)
				
				  // Place the download button
				$Obj_form.resources.setTitle(str ("seeFreeCommunityResources").localized(Lowercase:C14(Get localized string:C991("formatters"))))
				$Obj_form.resources.bestSize(Align right:K42:4)
				
				$ƒ.setTab()
				
				  // Preload the icons
				CALL FORM:C1391($Obj_form.window;"editor_CALLBACK";"fieldIcons")
				
				  //______________________________________________________
			: ($Lon_formEvent=On Timer:K2:25)
				
				$ƒ.update()
				
				  //______________________________________________________
		End case 
		
		  //=========================================================
	: ($Obj_in.action=Null:C1517)  // Error
		
		ASSERT:C1129(False:C215;"Missing parameter \"action\"")
		
		  //=========================================================
	: ($Obj_in.action="update")  // Display published tables according to data model
		
		$ƒ.update()
		
		  //=========================================================
	: ($Obj_in.action="fieldIcons")  // Call back from picker
		
		If ($Obj_in.item>0)\
			 & ($Obj_in.item<=$Obj_in.pathnames.length)
			
			  // Update data model
			$ƒ.field($Obj_in.row).icon:=$Obj_in.pathnames[$Obj_in.item-1]
			
			  // Update UI
			If ($Obj_in.pictures[$Obj_in.item-1]#Null:C1517)
				
				$p:=$Obj_in.pictures[$Obj_in.item-1]
				CREATE THUMBNAIL:C679($p;$p;24;24;Scaled to fit:K6:2)
				
				  //%W-533.3
				($Obj_form.icons.pointer())->{$Obj_in.row}:=$p
				  //%W+533.3
				
			Else 
				
				  //%W-533.3
				CLEAR VARIABLE:C89(($Obj_form.icons.pointer())->{$Obj_in.row})
				  //%W+533.3
				
			End if 
			
			project.save()
			
		End if 
		
		  //=========================================================
	: ($Obj_in.action="icons")  // Preload the icons
		
		$Obj_in.target:="fieldIcons"
		($Obj_form.picker.pointer())->:=editor_LoadIcons ($Obj_in)
		
		  //=========================================================
	: ($Obj_in.action="select")  // Set the selected field
		
		$ƒ.currentFieldNumber:=Num:C11($Obj_in.fieldNumber)
		
		  //=========================================================
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Obj_in.action+"\"")
		
		  //=========================================================
End case 

  // ----------------------------------------------------
  // End