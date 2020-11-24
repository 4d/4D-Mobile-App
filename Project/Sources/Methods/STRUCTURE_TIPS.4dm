//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : STRUCTURE_TIPS
// ID[1ACA778192DD48D4898BC23D5CF6FAFC]
// Created 31-1-2019 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $1 : Object

If (False:C215)
	C_OBJECT:C1216(STRUCTURE_TIPS; $1)
End if 

var $tips : Text
var $l : Integer
var $dataModel; $e; $field; $o; $str; $table : Object
var $c; $catalog; $unsynchronizedTableFields : Collection

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	// Required parameters
	ASSERT:C1129($1.form#Null:C1517)  //On pourra s'en passer quand le dialogue sera géré avec une class
	
	$e:=FORM Event:C1606
	
	$str:=cs:C1710.str.new()  // init class
	
	$catalog:=This:C1470.catalog()
	
	//ASSERT(Not(Shift down))
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If (Num:C11($e.row)>0)
	
	If ($e.objectName=$1.form.tableList)
		
		//%W-533.3
		$c:=$catalog.query("name=:1"; (OBJECT Get pointer:C1124(Object named:K67:5; "tables"))->{$e.row})
		//%W+533.3
		
	Else 
		
		// Get current table
		$c:=$catalog.query("name=:1"; $1.form.form.currentTable.name)
		
	End if 
	
	If ($c.length>0)
		
		$table:=$c[0]
		
		$unsynchronizedTableFields:=Form:C1466.$dialog.unsynchronizedTableFields
		
		If ($unsynchronizedTableFields.length>$table.tableNumber)
			
			// Restrict to the table
			$unsynchronizedTableFields:=$unsynchronizedTableFields[$table.tableNumber]
			
			If ($unsynchronizedTableFields=Null:C1517)
				
				// TABLE IS OK
				
			Else 
				
				If ($unsynchronizedTableFields.length=0)  // Not found into the current catalog
					
					$tips:=UI.alert+" "+$str.setText("theTableIsNoLongerAvailable").localized($table.name)  //
					
				Else 
					
					Case of 
							
							//______________________________________________________
						: ($e.objectName=$1.form.tableList) & ($e.row<=Size of array:C274((UI.pointer($1.form.tableList))->))  // TABLE LIST
							
							If ($unsynchronizedTableFields.length=1)
								
								//$o:=$unsynchronizedTableFields[0]
								//If ($o.fields#Null)
								//Case of
								////_______________________________________
								//: ($o.fields.length=0)
								//$tips:=UI.alert+$str.setText("theRelationIsNoLongerAvailable").localized($o.name)
								////_______________________________________
								//: ($o.fields.length=1)
								//$tips:=UI.alert+$str.setText("theRelatedFieldIsMissingOrHasBeenModified").localized($o.fields[0].name)
								////_______________________________________
								//Else
								//$tips:=UI.alert+$str.setText("theRelatedFieldsAreMissingOrWasModified").localized($o.fields.extract("name").join("\", \""))
								////_______________________________________
								//End case
								//Else
								//Case of
								////______________________________________________________
								//: ($o.relatedEntities#Null)
								//$tips:=UI.alert+$str.setText("theRelationIsNoLongerAvailable").localized($o.name)
								////______________________________________________________
								//: ($o.relatedTableNumber#Null)
								//$tips:=UI.alert+$str.setText("theN1RelationIsNoMoreAvailable").localized($o.name)
								////______________________________________________________
								//Else
								//$tips:=UI.alert+$str.setText("theFieldIsMissingOrWasModified").localized($o.name)
								////______________________________________________________
								//End case
								//End if
								
								//#WIP better tips
								$tips:=UI.alert+" - "+$unsynchronizedTableFields.extract("tableTips").distinct().join("\r       - ")
								
							Else 
								
								$tips:=UI.alert+" "+$str.setText("someFieldsOrRelationsAreNoLongerAvailableOrWasModified").localized($unsynchronizedTableFields.extract("name").join("\", \""))
								$tips:=$tips+"\r       - "+$unsynchronizedTableFields.extract("tableTips").distinct().join("\r       - ")
								
							End if 
							
							//$tips:=" - "+$unsynchronizedTableFields.extract("tableTips").distinct().join("\r - ")
							
							//______________________________________________________
						: ($e.objectName=$1.form.fieldList) & ($e.row<=Size of array:C274((UI.pointer($1.form.fields))->))  // FIELD LIST
							
							//$o:=$unsynchronizedTableFields.query("name = :1"; (UI.pointer($1.form.fields))->{$Lon_row}).pop()
							//Case of
							////………………………………………………………………………………………………………………
							//: ($o.relatedEntities#Null)  // 1 -> N relation
							//If ($o.missing)
							//If ($o.missingRelatedDataclass)
							//$Txt_tips:=UI.alert+$str.setText("theRelatedTableIsNoLongerAvailable").localized($o.relatedEntities)
							//Else
							//$Txt_tips:=UI.alert+$str.setText("the1NRelationIsNoMoreAvailable").localized($o.name)
							//End if
							//End if
							////………………………………………………………………………………………………………………
							//: ($o.relatedDataClass#Null)  // N -> 1 relation
							//If ($o.missing)
							//If ($o.missingRelatedDataclass)
							//$Txt_tips:=UI.alert+$str.setText("theRelatedTableIsNoLongerAvailable").localized($o.relatedDataClass)
							//Else
							//$Txt_tips:=UI.alert+$str.setText("theN1RelationIsNoMoreAvailable").localized($o.name)
							//End if
							//Else
							//// Missing fields
							//If ($o.unsynchronizedFields.length=1)
							//$Txt_tips:=UI.alert+$str.setText("theRelatedFieldIsMissingOrHasBeenModified").localized($o.unsynchronizedFields[0].name)
							//Else
							//$Txt_tips:=UI.alert+$str.setText("theRelatedFieldsAreMissingOrWasModified").localized($o.unsynchronizedFields.extract("name").join("\", \""))
							//End if
							//End if
							////………………………………………………………………………………………………………………
							//: (Bool($o.missing))
							//$Txt_tips:=UI.alert+$str.setText("theFieldIsMissing").localized()
							////………………………………………………………………………………………………………………
							//: (Bool($o.nameMismatch))
							//$Txt_tips:=UI.alert+$str.setText("theFieldWasRenamed").localized($o.current.name)
							////………………………………………………………………………………………………………………
							//: (Bool($o.typeMismatch))
							//$Txt_tips:=UI.alert+$str.setText("theFieldTypeWasModified").localized()
							////………………………………………………………………………………………………………………
							//Else
							//$Txt_tips:=UI.alert+$str.setText("theFieldIsMissingOrWasModified").localized($o.name)
							////………………………………………………………………………………………………………………
							//End case
							
							// Get the desynchronized item, if applicable
							//%W-533.3
							$o:=$unsynchronizedTableFields.query("name = :1"; (UI.pointer($1.form.fields))->{$e.row}).pop()
							//%W+533.3
							
							If ($o#Null:C1517)
								
								$tips:=UI.alert+" "+$o.fieldTips
								
							End if 
							
							//______________________________________________________
					End case 
				End if 
			End if 
			
		Else 
			
			// TABLE IS OK
			
		End if 
		
		If (Length:C16($tips)=0)
			
			// NO ERROR - DISPLAY USEFUL INFORMATIONS, IF ANY
			
			$dataModel:=Form:C1466.dataModel
			
			Case of 
					
					//______________________________________________________
				: ($e.objectName=$1.form.tableList) & ($e.row<=Size of array:C274((UI.pointer($1.form.tableList))->))
					
					//
					
					//______________________________________________________
				: ($e.objectName=$1.form.fieldList) & ($e.row<=Size of array:C274((UI.pointer($1.form.fields))->))
					
					//%W-533.3
					$l:=$table.field.extract("name").indexOf((UI.pointer($1.form.fields))->{$e.row})
					//%W+533.3
					
					If ($l#-1)
						
						$field:=$table.field[$l]
						
						Case of 
								
								//…………………………………………………………………………………………………
							: ($field.type=-1)  // N -> 1 relation
								
								// Related dataclass name
								$tips:=$str.setText("nTo1Relation").localized($field.relatedDataClass)
								
								If ($field.relatedDataClass=$table.name)  // Recursive link
									
									// Recursive link
									$tips:=$tips+" ("+Get localized string:C991("recursive")+")"
									
								End if 
								
								//%W-533.3
								$tips:=$tips+"\r- "+Choose:C955($e.column=1; \
									$str.setText("youCanEnableDisableThePublishOfAllRelatedFieldsByClickingHere").localized(Choose:C955($1.form.publishedPtr->{$e.row}#0; "disable"; "enable")); \
									Get localized string:C991("clickHereToSelectThePublishedFields"))
								//%W+533.3
								
								//…………………………………………………………………………………………………
							: ($field.type=-2)  // 1 -> N relation
								
								If ($dataModel[String:C10($field.relatedTableNumber)]=Null:C1517)
									
									//%W-533.3
									If (Bool:C1537((UI.pointer($1.form.published))->{$e.row}))
										//%W+533.3
										
										// Error
										$tips:=UI.alert+" "+$str.setText("theLinkedTableIsNotPublished").localized($field.relatedDataClass)
										
									Else 
										
										$tips:=$str.setText("1toNRelation").localized($field.relatedDataClass)
										
										If ($field.relatedDataClass=$table.name)
											
											// Recursive link
											$tips:=$tips+" ("+Get localized string:C991("recursive")+")"
											
										Else 
											
											// Unpublished related dataclass
											$tips:=$tips+" ("+Get localized string:C991("unpublished")+")"
											
										End if 
									End if 
									
								Else 
									
									// Related dataclass name
									$tips:=$str.setText("1toNRelation").localized($field.relatedDataClass)
									
									If ($field.relatedDataClass=$table.name)  // Recursive link
										
										// Recursive link
										$tips:=$tips+" ("+Get localized string:C991("recursive")+")"
										
									End if 
								End if 
								
								//…………………………………………………………………………………………………
							Else 
								
								If ($field.name=$table.primaryKey)
									
									$tips:=Get localized string:C991("primaryKey")
									
								End if 
								
								//…………………………………………………………………………………………………
						End case 
						
					Else 
						
						// SHOULD NOT, BUT COULD
						
					End if 
					
					//______________________________________________________
			End case 
		End if 
		
	Else 
		
		// TABLE NOT IN CATALOG
		If ($e.row<=Size of array:C274((UI.pointer($1.form.tableList))->))
			
			//%W-533.3
			$tips:=UI.alert+$str.setText("theTableIsNoLongerAvailable").localized((OBJECT Get pointer:C1124(Object named:K67:5; "tables"))->{$e.row})
			//%W+533.3
			
		End if 
	End if 
	
	If (Position:C15("\r"; $tips)=0)
		
		$tips:=$str.setText($tips).wordWrap(60)
		
	End if 
	
Else 
	
	// NO ITEM HOVERED
	
End if 

OBJECT SET HELP TIP:C1181(*; $e.objectName; $tips)

// ----------------------------------------------------
// Return
// <NONE>
// ----------------------------------------------------
// End