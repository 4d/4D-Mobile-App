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
var $e; $field; $o; $str; $table : Object
var $unsynchronizedTableFields : Collection

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	// Required parameters
	ASSERT:C1129($1.form#Null:C1517)  //On pourra s'en passer quand le dialogue sera géré avec une class
	
	$e:=FORM Event:C1606
	$str:=cs:C1710.str.new()  // init class
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If (Num:C11($e.row)>0)
	
	If ($e.objectName=$1.form.tableList)
		
		If (Length:C16(String:C10($e.columnName))>0)
			
			//%W-533.3
			$table:=PROJECT.getCatalog().query("name=:1"; (OBJECT Get pointer:C1124(Object named:K67:5; $e.columnName))->{$e.row}).pop()
			//%W+533.3
			
		End if 
		
	Else 
		
		// Get current table
		If ($1.form.form.currentTable.name#Null:C1517)
			
			$table:=PROJECT.getCatalog().query("name=:1"; $1.form.form.currentTable.name).pop()
			
		End if 
	End if 
	
	If ($table#Null:C1517)
		
		$unsynchronizedTableFields:=Form:C1466.$dialog.unsynchronizedTables
		
		If ($unsynchronizedTableFields.length>$table.tableNumber)
			
			// Restrict to the table
			$unsynchronizedTableFields:=$unsynchronizedTableFields[$table.tableNumber]
			
			If ($unsynchronizedTableFields=Null:C1517)
				
				// TABLE IS OK
				
			Else 
				
				If ($unsynchronizedTableFields.length=0)  // Not found into the current catalog
					
					$tips:=EDITOR.alert+" "+$str.setText("theTableIsNoLongerAvailable").localized($table.name)
					
				Else 
					
					Case of 
							
							//______________________________________________________
						: ($e.objectName=$1.form.tableList) & ($e.row<=Size of array:C274((OBJECT Get pointer:C1124(Object named:K67:5; $1.form.tableList))->))  // TABLE LIST
							
							If ($unsynchronizedTableFields.length=1)
								
								$tips:=EDITOR.alert+" "+$unsynchronizedTableFields.extract("tableTips").distinct().join("\r       - ")
								
							Else 
								
								$tips:=EDITOR.alert+" "+$str.setText("someFieldsOrRelationsAreNoLongerAvailableOrWasModified").localized($unsynchronizedTableFields.extract("name").distinct().join("\", \""))
								$tips:=$tips+"\r       - "+$unsynchronizedTableFields.extract("tableTips").distinct().join("\r       - ")
								
							End if 
							
							//______________________________________________________
						: ($e.objectName=$1.form.fieldList) & ($e.row<=Size of array:C274((OBJECT Get pointer:C1124(Object named:K67:5; $1.form.fields))->))  // FIELD LIST
							
							// Get the desynchronized item, if applicable
							//%W-533.3
							$o:=$unsynchronizedTableFields.query("name = :1 OR parent = :1"; (OBJECT Get pointer:C1124(Object named:K67:5; $1.form.fields))->{$e.row}).pop()
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
				: ($e.objectName=$1.form.tableList) & ($e.row<=Size of array:C274((OBJECT Get pointer:C1124(Object named:K67:5; $1.form.tableList))->))
					
					//$tips:=".published fields:\r"+$table.field.extract("name").join("\", \"")
					
					//______________________________________________________
				: ($e.objectName=$1.form.fieldList) & ($e.row<=Size of array:C274((OBJECT Get pointer:C1124(Object named:K67:5; $1.form.fields))->))
					
					//%W-533.3
					$field:=$table.field.query("name = :1"; (OBJECT Get pointer:C1124(Object named:K67:5; $1.form.fields))->{$e.row}).pop()
					
					//%W+533.3
					
					
					If ($field#Null:C1517)
						
						Case of 
								
								//…………………………………………………………………………………………………
							: ($field.kind="relatedEntity")  // N -> 1 relation
								
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
							: ($field.kind="relatedEntities")\
								 | (($field.kind="alias") && (Bool:C1537($field.isToMany)))  // 1 -> N relation
								
								If (Form:C1466.dataModel[String:C10($field.relatedTableNumber)]=Null:C1517)
									
									//%W-533.3
									If (Bool:C1537((OBJECT Get pointer:C1124(Object named:K67:5; $1.form.published))->{$e.row}))
										//%W+533.3
										// Error
										
										If ($field.kind="alias")
											
											
											//ASSERT(Not(Shift down))
											
											$tips:=EDITOR.alert+" "+$str.setText("theTargetTableIsNotPublished").localized()
											
										Else 
											
											$tips:=EDITOR.alert+" "+$str.setText("theLinkedTableIsNotPublished").localized($field.relatedDataClass)
											
										End if 
										
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
		If ($e.row<=Size of array:C274((OBJECT Get pointer:C1124(Object named:K67:5; $1.form.tableList))->))
			
			//%W-533.3
			$tips:=EDITOR.alert+" "+$str.setText("theTableIsNoLongerAvailable").localized((OBJECT Get pointer:C1124(Object named:K67:5; "tables"))->{$e.row})
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