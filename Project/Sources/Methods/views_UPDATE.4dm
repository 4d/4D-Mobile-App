//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : views_UPDATE
// ID[5F4AE9BB93F742A7B1446586DE2B7825]
// Created 1-2-2019 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Update all form definition according to the datamodel
// Ie. remove from forms, the fields that are no more published
// ----------------------------------------------------
// Declarations
#DECLARE ($formType : Text)

var $formType; $tableID : Text
var $field; $target : Object

// ----------------------------------------------------
If (Count parameters:C259=0)
	
	views_UPDATE("list")
	views_UPDATE("detail")
	
Else 
	
	If (Form:C1466[$formType]#Null:C1517)
		
		For each ($tableID; Form:C1466[$formType])
			
			If (PROJECT.dataModel[$tableID]#Null:C1517)
				
				$target:=Form:C1466[$formType][$tableID]
				
				If ($target.fields#Null:C1517)
					
					// FIELDS ---------------------------------------------------------------------
					For each ($field; $target.fields)
						
						If ($field#Null:C1517)
							
							If (Not:C34(PROJECT.fieldAvailable($field; $tableID)))
								
								$target.fields[$target.fields.indexOf($field)]:=Null:C1517
								
							End if 
						End if 
					End for each 
				End if 
				
				If ($formType="list")
					
					// SEARCH WIDGET --------------------------------------------------------------
					If ($target.searchableField#Null:C1517)
						
						If (Value type:C1509($target.searchableField)=Is collection:K8:32)
							
							For each ($field; $target.searchableField)
								
								If (Not:C34(PROJECT.fieldAvailable($field; $tableID)))
									
									$target.searchableField.remove($target.searchableField.indexOf($field))
									
								End if 
							End for each 
							
							Case of 
									
									//…………………………………………………………………………………………………
								: ($target.searchableField.length=0)  // There are no more
									
									OB REMOVE:C1226($target; "searchableField")
									
									//…………………………………………………………………………………………………
								: ($target.searchableField.length=1)  // Convert to object
									
									$target.searchableField:=$target.searchableField[0]
									
									//…………………………………………………………………………………………………
							End case 
							
						Else 
							
							If (Not:C34(PROJECT.fieldAvailable($target.searchableField; $tableID)))
								
								OB REMOVE:C1226($target; "searchableField")
								
							End if 
						End if 
					End if 
					
					// SECTION WIDGET -------------------------------------------------------------
					If ($target.sectionField#Null:C1517)
						
						If (Not:C34(PROJECT.fieldAvailable($target.sectionField; $tableID)))
							
							OB REMOVE:C1226($target; "sectionField")
							
						End if 
					End if 
				End if 
			End if 
		End for each 
	End if 
End if 