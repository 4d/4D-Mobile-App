//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : tmpl_REORDER
// ID[D3DF454ABC0D4E68943727CD95C07675]
// Created 26-4-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($1)

C_BOOLEAN:C305($bMultiCriteria; $Boo_accepted)
C_LONGINT:C283($indx; $Lon_keyType)
C_TEXT:C284($dom; $Dom_field; $root; $t; $Txt_bind)
C_OBJECT:C1216($o; $oAttributes; $oCache; $oField; $oIN; $pathTemplate)
C_COLLECTION:C1488($c; $Col_affected; $Col_bind; $Col_catalog)

If (False:C215)
	C_OBJECT:C1216(tmpl_REORDER; $1)
End if 

// ----------------------------------------------------
// Initialisations
$oIN:=$1

// Load template
$pathTemplate:=tmpl_form($oIN.form; $oIN.selector)

If ($pathTemplate.extension=SHARED.archiveExtension)  // Archive
	
	// Get from archive
	$t:=$pathTemplate.file("template.svg").getText()
	$root:=DOM Parse XML variable:C720($t)
	
Else 
	
	$root:=DOM Parse XML source:C719($pathTemplate.file("template.svg").platformPath)
	
End if 

If (Asserted:C1132(OK=1; "Invalid template"))
	
	$dom:=DOM Find XML element by ID:C1010($root; "cookery")
	ASSERT:C1129(OK=1; "Missing 'cookery' element in the template")
	
	If (Bool:C1537(OK))
		
		// Get the bindind definition
		$oAttributes:=xml_attributes($dom)
		OK:=Num:C11($oAttributes["ios:values"]#Null:C1517)
		ASSERT:C1129(OK=1; "Missing 'ios:values' attribute in the template")
		
		If (Bool:C1537(OK))
			
			$oCache:=Form:C1466[$oIN.selector][$oIN.tableNumber]
			
			$Col_bind:=Split string:C1554($oAttributes["ios:values"]; ","; sk trim spaces:K86:2)
			
			// Create binding collection sized according to bind attribute length
			If (feature.with("newViewUI"))\
				 & ($oIN.selector="detail")
				
				$Col_bind.resize($oIN.manifest.fields.count)
				
				// No limit
				$Col_affected:=New collection:C1472
				
			Else 
				
				$Col_affected:=New collection:C1472.resize($Col_bind.length)
				
			End if 
			
			$Col_catalog:=editor_Catalog
			
			// Reorganize the binded fields
			For each ($Txt_bind; $Col_bind)
				
				CLEAR VARIABLE:C89($Boo_accepted)
				CLEAR VARIABLE:C89($oField)
				
				// Find the binded element
				$Dom_field:=DOM Find XML element by ID:C1010($root; $Txt_bind)
				
				If (Bool:C1537(OK))
					
					$oAttributes:=xml_attributes($Dom_field)
					ASSERT:C1129($oAttributes["ios:bind"]#Null:C1517)
					
				Else 
					
					// The multivalued fields share the same attributes
					// as the last field defined in the template
					
				End if 
				
				$o:=Rgx_match(New object:C1471(\
					"pattern"; "(?m-si)^([^\\[]+)\\[(\\d+)]\\s*$"; \
					"target"; $oAttributes["ios:bind"]))
				
				If ($o.success)
					
					// LIST OF FIELDS
					
					If ($oAttributes["ios:type"]="all")
						
						$Boo_accepted:=True:C214
						
					Else 
						
						// Check if the type is compatible
						$c:=Split string:C1554($oAttributes["ios:type"]; ","; sk trim spaces:K86:2).map("col_formula"; Formula:C1597($1.result:=Num:C11($1.value)))
						
						If ($oIN.target.fields#Null:C1517)
							
							For each ($oField; $oIN.target.fields) Until ($Boo_accepted)
								
								If ($oField#Null:C1517)
									
									$o:=structure(New object:C1471(\
										"action"; "fieldDefinition"; \
										"path"; $oField.name; \
										"tableNumber"; Num:C11($oIN.tableNumber); \
										"catalog"; $Col_catalog))
									
									If ($o.success)
										
										If ($o.type=-2)  // 1-N relation
											
											$Boo_accepted:=Split string:C1554(String:C10($oAttributes.class); " ").indexOf("multivalued")#-1
											
										Else 
											
											$Boo_accepted:=tmpl_compatibleType($c; $o.fieldType)
											
										End if 
									End if 
								End if 
							End for each 
						End if 
					End if 
					
					If ($Boo_accepted)\
						 & ($oField#Null:C1517)
						
						// Keep the field…
						$Col_affected[$indx]:=$oField
						
						// …& remove it to don't use again
						$oIN.target.fields.remove($oIN.target.fields.indexOf($oField))
						
					End if 
					
					$indx:=$indx+1
					
				Else 
					
					// SINGLE VALUE FIELD (Not aaaaa[000]) ie 'searchableField' or 'sectionField'
					
					Case of 
							
							//______________________________________________________
						: ($oAttributes["ios:bind"]="searchableField")
							
							$bMultiCriteria:=(Split string:C1554($oAttributes.class; " ").indexOf("multi-criteria")#-1)
							
							$Lon_keyType:=Value type:C1509($oIN.target.searchableField)
							
							If ($Lon_keyType#Is undefined:K8:13)\
								 & ($Lon_keyType#Is null:K8:31)
								
								If ($Lon_keyType=Is collection:K8:32)
									
									// SOURCE IS MULTICRITERIA
									
									If ($oIN.target.searchableField.length>0)
										
										If ($bMultiCriteria)
											
											// Target is multi-criteria
											
											//#MARK_TODO Verify the type & remove incompatible if any
											For each ($o; $oIN.target.searchableField)
												
												// #MARK_TODO
												
											End for each 
											
											$oCache.searchableField:=$oIN.target.searchableField
											
										Else 
											
											// Target is mono value -> keep the first compatible type
											$oCache.searchableField:=$oIN.target.searchableField[0]
											
										End if 
									End if 
									
								Else 
									
									// SOURCE IS MONO VALUE
									
									If ($bMultiCriteria)
										
										// Target is multi-criteria -> don't modify if exist
										If ($Lon_keyType=Is null:K8:31)
											
											// #MARK_TODO Verify the type
											
											$oCache.searchableField:=$oIN.target.searchableField
											
										End if 
										
									Else 
										
										// Target is mono value
										$oCache.searchableField:=$oIN.target.searchableField
										
									End if 
								End if 
							End if 
							
							//______________________________________________________
						: ($oAttributes["ios:bind"]="sectionField")
							
							If ($oIN.target.sectionField#Null:C1517)
								
								$oCache.sectionField:=$oIN.target.sectionField
								
							End if 
							
							//______________________________________________________
						Else 
							
							// #98417 - Remove in excess item from collection
							$Col_affected.resize($Col_affected.length-1)
							
							//______________________________________________________
					End case 
				End if 
			End for each 
			
			If (feature.with("newViewUI"))\
				 & ($oIN.manifest#Null:C1517)\
				 & ($oIN.selector="detail")\
				 & ($oIN.target.fields#Null:C1517)
				
				// Append the non affected fields
				$Col_affected.combine($oIN.target.fields)
				
			End if 
			
			// Keep the field binding definition
			$oCache.fields:=$Col_affected
			
		End if 
	End if 
	
	DOM CLOSE XML:C722($root)
	
End if 

// ----------------------------------------------------
// Return
// <NONE>
// ----------------------------------------------------
// End