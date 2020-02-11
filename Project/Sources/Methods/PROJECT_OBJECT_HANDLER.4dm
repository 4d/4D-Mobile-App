//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : PROJECT_OBJECT_HANDLER
  // ID[8142AD53194D44F8B7DCDA882982F3EE]
  // Created 18-10-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($indx)
C_POINTER:C301($ptr)
C_OBJECT:C1216($event)
C_COLLECTION:C1488($c)


  // ----------------------------------------------------
  // Initialisations

  // NO PARAMETERS REQUIRED

  // Optional parameters
If (Count parameters:C259>=1)
	
	  // <NONE>
	
End if 

$event:=FORM Event:C1606

  // ----------------------------------------------------
Case of 
		
		  //==================================================
	: ($event.objectName="help.@")
		
		$c:=Split string:C1554($event.objectName;".")
		
		ARRAY TEXT:C222($tTxt_objects;0x0000)
		FORM GET OBJECTS:C898($tTxt_objects)
		
		$indx:=Find in array:C230($tTxt_objects;"panel."+String:C10($c[$c.length-1]))
		
		If ($indx>0)
			
			OBJECT GET SUBFORM:C1139(*;$tTxt_objects{$indx};$ptr;$event.objectName)
			
			If (Form:C1466.$dialog[$event.objectName].help#Null:C1517)
				
				OPEN URL:C673(String:C10(Form:C1466.$dialog[$event.objectName].help);*)
				
			Else 
				
				ASSERT:C1129(False:C215;"help button without url!")
				
			End if 
		End if 
		
		  //==================================================
	: ($event.objectName="panel.@")
		
		Case of 
				
				  //______________________________________________________
			: ($event.code=On Losing Focus:K2:8)
				
				CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"onLosingFocus";New object:C1471(\
					"panel";$event.objectName))
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$event.description+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($event.objectName="picker")
		
		Case of 
				
				  // ----------------------------------------
			: ($event.code<0)  // <SUBFORM EVENTS>
				
				Case of 
						
						  //…………………………………………………………………………………………………
					: ($event.code=-1)  // Close
						
						  // Send result to the caller
						CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"pickerResume";Self:C308->)
						
						
						  //…………………………………………………………………………………………………
					: ($event.code=-2)  // update
						
						CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"pickerResume";Self:C308->)
						  //views_LAYOUT_PICKER (Form.$dialog.VIEWS.typeForm())
						
						  //…………………………………………………………………………………………………
					Else 
						
						ASSERT:C1129(False:C215;"Unknown call from subform ("+String:C10($event.code)+")")
						
						  //…………………………………………………………………………………………………
				End case 
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$event.description+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($event.objectName="picker.close")
		
		CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"pickerHide";(OBJECT Get pointer:C1124(Object named:K67:5;"picker"))->)
		
		  //==================================================
	Else 
		
		ASSERT:C1129(False:C215;"Unknown object: \""+$event.objectName+"\"")
		
		  //==================================================
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End