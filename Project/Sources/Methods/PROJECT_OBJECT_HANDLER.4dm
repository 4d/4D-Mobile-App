//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : PROJECT_OBJECT_HANDLER
  // Database: 4D Mobile Express
  // ID[8142AD53194D44F8B7DCDA882982F3EE]
  // Created #18-10-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_formEvent;$Lon_parameters;$Lon_x)
C_POINTER:C301($Ptr_;$Ptr_me)
C_TEXT:C284($Txt_me)
C_COLLECTION:C1488($Col_)

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
	$Lon_formEvent:=Form event:C388
	$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
	$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //==================================================
	: ($Txt_me="help.@")
		
		$Col_:=Split string:C1554($Txt_me;".")
		
		ARRAY TEXT:C222($tTxt_objects;0x0000)
		FORM GET OBJECTS:C898($tTxt_objects)
		
		$Lon_x:=Find in array:C230($tTxt_objects;"panel."+String:C10($Col_[$Col_.length-1]))
		
		If ($Lon_x>0)
			
			OBJECT GET SUBFORM:C1139(*;$tTxt_objects{$Lon_x};$Ptr_;$Txt_me)
			
			If (Form:C1466.$dialog[$Txt_me].help#Null:C1517)
				
				OPEN URL:C673(String:C10(Form:C1466.$dialog[$Txt_me].help);*)
				
			Else 
				
				ASSERT:C1129(False:C215;"help button without url!")
				
			End if 
		End if 
		
		  //==================================================
	: ($Txt_me="panel.@")
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Losing Focus:K2:8)
				
				CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"onLosingFocus";New object:C1471(\
					"panel";$Txt_me))
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($Txt_me="picker")
		
		Case of 
				
				  // ----------------------------------------
			: ($Lon_formEvent<0)  // <SUBFORM EVENTS>
				
				Case of 
						
						  //…………………………………………………………………………………………………
					: ($Lon_formEvent=-1)  // Close
						
						  // Send result to the caller
						CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"pickerResume";$Ptr_me->)
						
						  //…………………………………………………………………………………………………
					: (False:C215)
						
						  //…………………………………………………………………………………………………
					Else 
						
						ASSERT:C1129(False:C215;"Unknown call from subform ("+String:C10($Lon_formEvent)+")")
						
						  //…………………………………………………………………………………………………
				End case 
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	Else 
		
		ASSERT:C1129(False:C215;"Unknown object: \""+$Txt_me+"\"")
		
		  //==================================================
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End