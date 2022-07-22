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
var $t : Text
var $index : Integer
var $ptr : Pointer
var $e; $o; $panel : Object
var $c : Collection

// ----------------------------------------------------
// Initialisations

$e:=FORM Event:C1606

// ----------------------------------------------------
Case of 
		
		//==================================================
	: ($e.objectName="help.@")
		
		$c:=Split string:C1554($e.objectName; ".")
		$t:=panel_FindByIndex(Num:C11($c[$c.length-1]))
		
		If (Length:C16($t)>0)
			
			$o:=panel($t)
			
			If ($o.help#Null:C1517)
				
				OPEN URL:C673(String:C10($o.help); *)
				
			Else 
				
				ASSERT:C1129(False:C215; "help button without url!")
				
			End if 
			
		Else 
			
			//
			
		End if 
		
		//==================================================
	: ($e.objectName="panel.@")
		
		Case of 
				
				//______________________________________________________
			: ($e.code=(-On Load:K2:1))  // Post-loading processing
				
				$c:=Form:C1466.$project.$page.panels
				
				If ($c#Null:C1517)
					
					OBJECT GET SUBFORM:C1139(*; $e.objectName; $ptr; $t)
					$index:=$c.extract("form").indexOf($t)  //+1
					
					$panel:=$c[$index]
					
					Case of 
							//______________________________________________________
						: (Bool:C1537($panel.noSeparator))  //& False
							
							EXECUTE METHOD IN SUBFORM:C1085($e.objectName; Formula:C1597(panel_LAST).source)
							
							//______________________________________________________
						: (($index+1)=$c.length)  // Last panel
							
							EXECUTE METHOD IN SUBFORM:C1085($e.objectName; Formula:C1597(panel_LAST).source)
							
							//______________________________________________________
					End case 
				End if 
				
				//______________________________________________________
			: ($e.code=On Losing Focus:K2:8)
				
				CALL FORM:C1391(Current form window:C827; Formula:C1597(editor_CALLBACK).source; "onLosingFocus"; New object:C1471(\
					"panel"; $e.objectName))
				
				//______________________________________________________
		End case 
		
		//==================================================
	: ($e.objectName="picker")
		
		Case of 
				
				//----------------------------------------
			: ($e.code<0)  // <SUBFORM EVENTS>
				
				Case of 
						
						//…………………………………………………………………………………………………
					: ($e.code=-1)  // Close
						
						// Send result to the caller
						CALL FORM:C1391(Current form window:C827; Formula:C1597(editor_CALLBACK).source; "pickerResume"; Self:C308->)
						
						//…………………………………………………………………………………………………
					: ($e.code=-2)  // Update
						
						CALL FORM:C1391(Current form window:C827; Formula:C1597(editor_CALLBACK).source; "pickerResume"; Self:C308->)
						
						//…………………………………………………………………………………………………
				End case 
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
				
				//______________________________________________________
		End case 
		
		//==================================================
	: ($e.objectName="picker.close")
		
		CALL FORM:C1391(Current form window:C827; Formula:C1597(editor_CALLBACK).source; "pickerHide"; (OBJECT Get pointer:C1124(Object named:K67:5; "picker"))->)
		
		//==================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown object: \""+$e.objectName+"\"")
		
		//==================================================
End case 