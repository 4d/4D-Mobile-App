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
#DECLARE($data : Object)

If (False:C215)
	C_OBJECT:C1216(STRUCTURE_TIPS; $1)
End if 

var $tips : Text
var $ptr : Pointer
var $e; $ƒ; $o : Object
var $unsynchronized : Collection
var $field : cs:C1710.field
var $table : cs:C1710.table

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	// Required parameters
	ASSERT:C1129($data.form#Null:C1517)  // On pourra s'en passer quand le dialogue sera géré avec une class
	
	$ƒ:=$data.form
	
	$e:=FORM Event:C1606
	
	$ptr:=$e.objectName=$ƒ.tableList ? OBJECT Get pointer:C1124(Object named:K67:5; $ƒ.tableList) : OBJECT Get pointer:C1124(Object named:K67:5; $ƒ.fields)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If (Num:C11($e.row)>0)
	
	If ($e.objectName=$ƒ.tableList)
		
		If (Length:C16(String:C10($e.columnName))>0)
			
			//%W-533.3
			$table:=PROJECT.getCatalog().query("name=:1"; (OBJECT Get pointer:C1124(Object named:K67:5; $e.columnName))->{$e.row}).pop()
			
			//%W+533.3
			
		End if 
		
	Else 
		
		// Get current table
		If ($ƒ.form.currentTable.name#Null:C1517)
			
			$table:=PROJECT.getCatalog().query("name=:1"; $ƒ.form.currentTable.name).pop()
			
		End if 
	End if 
	
	If ($table#Null:C1517)
		
		$unsynchronized:=Form:C1466.$dialog.unsynchronizedTables
		
		If ($unsynchronized.length>$table.tableNumber)
			
			// Restrict to the table
			$unsynchronized:=$unsynchronized[$table.tableNumber]
			
			If ($unsynchronized=Null:C1517)
				
				// TABLE IS OK
				
			Else 
				
				If ($unsynchronized.length=0)  // Not found into the current catalog
					
					$tips:=EDITOR.alert+" "+EDITOR.str.localize("theTableIsNoLongerAvailable"; $table.name)
					
				Else 
					
					Case of 
							
							//______________________________________________________
						: ($e.objectName=$ƒ.tableList)\
							 & ($e.row<=Size of array:C274($ptr->))  // TABLE LIST
							
							If ($unsynchronized.length=1)
								
								$tips:=EDITOR.alert+" "+$unsynchronized.extract("tableTips").distinct().join("\r       - ")
								
							Else 
								
								$tips:=EDITOR.alert+" "+EDITOR.str.localize("someFieldsOrRelationsAreNoLongerAvailableOrWasModified"; $unsynchronized.extract("name").distinct().join("\", \""))
								$tips+="\r       - "+$unsynchronized.extract("tableTips").distinct().join("\r       - ")
								
							End if 
							
							//______________________________________________________
						: ($e.objectName=$ƒ.fieldList)\
							 & ($e.row<=Size of array:C274($ptr->))  // FIELD LIST
							
							// Get the desynchronized item, if applicable
							//%W-533.3
							$o:=$unsynchronized.query("name = :1 OR parent = :1"; $ptr->{$e.row}).pop()
							
							//%W+533.3
							
							If (Length:C16(String:C10($o.fieldTips))#0)
								
								$tips:=EDITOR.alert+" "+$o.fieldTips
								
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
			
			Case of 
					
					//______________________________________________________
				: ($e.objectName=$ƒ.tableList)\
					 & ($e.row<=Size of array:C274($ptr->))
					
					//$tips:=".published fields:\r"+$table.field.extract("name").join("\", \"")
					
					//______________________________________________________
				: ($e.objectName=$ƒ.fieldList)\
					 & ($e.row<=Size of array:C274($ptr->))
					
					//%W-533.3
					$field:=$table.field.query("name = :1"; $ptr->{$e.row}).pop()
					
					//%W+533.3
					
					If ($field#Null:C1517)
						
						Case of 
								
								//…………………………………………………………………………………………………
							: ($field.kind="relatedEntity")\
								 | (($field.kind="alias") && (Bool:C1537($field.isToOne)))
								
								// Related dataclass name
								$tips:=EDITOR.str.localize("nTo1Relation"; $field.relatedDataClass)
								
								If ($field.relatedDataClass=$table.name)  // Recursive link
									
									// Recursive link
									$tips+=" ("+Get localized string:C991("recursive")+")"
									
								End if 
								
								//%W-533.3
								$tips+="\r- "+($e.column=1 ? \
									EDITOR.str.localize("youCanEnableDisableThePublishOfAllRelatedFieldsByClickingHere"; $ƒ.publishedPtr->{$e.row}#0 ? "disable" : "enable")\
									 : Get localized string:C991("clickHereToSelectThePublishedFields"))
								
								//%W+533.3
								
								//…………………………………………………………………………………………………
							: ($field.kind="relatedEntities")\
								 | (($field.kind="alias") && (Bool:C1537($field.isToMany)))
								
								If (Form:C1466.dataModel[String:C10($field.relatedTableNumber)]=Null:C1517)
									
									//%W-533.3
									If (Bool:C1537((OBJECT Get pointer:C1124(Object named:K67:5; $ƒ.published))->{$e.row}))
										//%W+533.3
										
										// Error
										$tips:=EDITOR.alert+" "+EDITOR.str.localize("theLinkedTableIsNotPublished"; $field.relatedDataClass)
										
									Else 
										
										$tips:=EDITOR.str.localize("1toNRelation"; $field.relatedDataClass)
										
										If ($field.relatedDataClass=$table.name)
											
											// Recursive link
											$tips+=" ("+Get localized string:C991("recursive")+")"
											
										Else 
											
											// Unpublished related dataclass
											$tips+=" ("+Get localized string:C991("unpublished")+")"
											
										End if 
									End if 
									
								Else 
									
									// Related dataclass name
									$tips:=EDITOR.str.localize("1toNRelation"; $field.relatedDataClass)
									
									If ($field.relatedDataClass=$table.name)  // Recursive link
										
										// Recursive link
										$tips+=" ("+Get localized string:C991("recursive")+")"
										
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
		If ($e.row<=Size of array:C274($ptr->))
			
			//%W-533.3
			$tips:=EDITOR.alert+" "+EDITOR.str.localize("theTableIsNoLongerAvailable"; (OBJECT Get pointer:C1124(Object named:K67:5; $ƒ.tableList))->{$e.row})
			
			//%W+533.3
			
		End if 
	End if 
	
	If (Position:C15("\r"; $tips)=0)
		
		$tips:=EDITOR.str.setText($tips).wordWrap(60)
		
	End if 
	
Else 
	
	// NO ITEM HOVERED
	
End if 

OBJECT SET HELP TIP:C1181(*; $e.objectName; $tips)