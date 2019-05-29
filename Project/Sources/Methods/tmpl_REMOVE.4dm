//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : tmpl_REMOVE
  // Database: 4D Mobile App
  // ID[77787A83B9A048FCBA802902156129C9]
  // Created #25-4-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Modified #4-9-2018 by Vincent de Lachaux
  // #98105 - Multi-criteria Search
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_indx)
C_TEXT:C284($Mnu_main;$Txt_bind;$Txt_choice;$Txt_field;$Txt_isOfClass)
C_OBJECT:C1216($Obj_field;$Obj_target)

ARRAY TEXT:C222($tTxt_results;0)

  // ----------------------------------------------------
  // Initialisations
$Txt_field:=Replace string:C233(This:C1470.$.current;".cancel";"")
SVG GET ATTRIBUTE:C1056(*;This:C1470.preview.name;$Txt_field;"ios:bind";$Txt_bind)

$Obj_target:=Form:C1466[Choose:C955(Num:C11(This:C1470.$.selector)=2;"detail";"list")][This:C1470.$.tableNumber]

  // ----------------------------------------------------
SVG GET ATTRIBUTE:C1056(*;This:C1470.preview.name;$Txt_field;"4D-isOfClass-multi-criteria";$Txt_isOfClass)

If ($Txt_isOfClass="true")\
 & (Value type:C1509($Obj_target[$Txt_bind])=Is collection:K8:32)
	
	$Mnu_main:=Create menu:C408
	
	For each ($Obj_field;$Obj_target[$Txt_bind])
		
		If ($Obj_field#Null:C1517)
			
			APPEND MENU ITEM:C411($Mnu_main;Replace string:C233(Get localized string:C991("removeField");"{field}";$Obj_field.name))
			SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;String:C10($Obj_field.id))
			
		End if 
	End for each 
	
	APPEND MENU ITEM:C411($Mnu_main;"-")
	
	APPEND MENU ITEM:C411($Mnu_main;Get localized string:C991("removeAllFields"))
	SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"all")
	
	$Txt_choice:=Dynamic pop up menu:C1006($Mnu_main)
	RELEASE MENU:C978($Mnu_main)
	
	If (Length:C16($Txt_choice)#0)
		
		If ($Txt_choice="all")
			
			$Obj_target[$Txt_bind]:=Null:C1517
			
		Else 
			
			  // Delete one
			$Lon_indx:=$Obj_target[$Txt_bind].extract("id").indexOf(Num:C11($Txt_choice))
			
			If ($Lon_indx#-1)
				
				$Obj_target[$Txt_bind].remove($Lon_indx)
				
				If ($Obj_target[$Txt_bind].length=1)
					
					  // Convert to object
					$Obj_target[$Txt_bind]:=$Obj_target[$Txt_bind][0]
					
				End if 
			End if 
		End if 
	End if 
	
Else 
	
	If (Asserted:C1132(Length:C16($Txt_bind)>0))
		
		Rgx_MatchText ("(?m-si)^([^\\[]+)\\[(\\d+)]\\s*$";$Txt_bind;->$tTxt_results)
		
		If (Size of array:C274($tTxt_results)=2)
			
			If ($Obj_target[$tTxt_results{1}]#Null:C1517)
				
				$Lon_indx:=Num:C11($tTxt_results{2})
				
				If ($Obj_target[$tTxt_results{1}].length>$Lon_indx)
					
					SVG GET ATTRIBUTE:C1056(*;This:C1470.preview.name;$Txt_field;"4D-isOfClass-multivalued";$Txt_isOfClass)
					
					If ($Txt_isOfClass="true")
						
						$Obj_target[$tTxt_results{1}].remove($Lon_indx)
						
					Else 
						
						  // Empty
						$Obj_target[$tTxt_results{1}][$Lon_indx]:=Null:C1517
						
					End if 
				End if 
			End if 
			
		Else 
			
			$Obj_target[$Txt_bind]:=Null:C1517
			
		End if 
	End if 
End if 

  // Update preview
views_preview ("draw";This:C1470)

  // Save project
project.save()

  // ----------------------------------------------------
  // End