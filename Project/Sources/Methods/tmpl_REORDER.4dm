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
#DECLARE($oIN : Object)

If (False:C215)
	C_OBJECT:C1216(tmpl_REORDER; $1)
End if 

var $dom; $Dom_field; $root; $t; $key : Text
var $isCompatible; $isMultiCriteria : Boolean
var $indx; $Lon_keyType : Integer
var $cache; $o; $oAttributes; $oField; $oIN : Object
var $c; $affected; $binding : Collection
var $template : cs:C1710.tmpl

$template:=$oIN.template

If (False:C215)  // #WORK_IN_PROGRESS
	
	$template.reorder($oIN.tableNumber)
	
Else 
	
	If ($template#Null:C1517)
		
		$t:=$template.svg
		
		If (Length:C16($t)>0)
			
			$root:=DOM Parse XML variable:C720($t)
			
			If (Asserted:C1132(OK=1; "Invalid template"))
				
				$dom:=DOM Find XML element by ID:C1010($root; "cookery")
				ASSERT:C1129(OK=1; "Missing 'cookery' element in the template")
				
				If (Bool:C1537(OK))
					
					// Get the bindind definition
					$oAttributes:=_o_xml_attributes($dom)
					OK:=Num:C11($oAttributes["ios:values"]#Null:C1517)
					ASSERT:C1129(OK=1; "Missing 'ios:values' attribute in the template")
					
					If (Bool:C1537(OK))
						
						$cache:=Form:C1466[$oIN.selector][$oIN.tableNumber]
						
						$binding:=Split string:C1554($oAttributes["ios:values"]; ","; sk trim spaces:K86:2)
						
						// Create binding collection sized according to bind attribute length
						If ($oIN.selector="detail")
							
							$binding.resize($oIN.manifest.fields.count)
							
							// No limit
							$affected:=New collection:C1472
							
						Else 
							
							$affected:=New collection:C1472.resize($binding.length)
							
						End if 
						
						// Reorganize the binded fields
						For each ($key; $binding)
							
							CLEAR VARIABLE:C89($isCompatible)
							CLEAR VARIABLE:C89($oField)
							
							// Find the binded element
							$Dom_field:=DOM Find XML element by ID:C1010($root; $key)
							
							If (Bool:C1537(OK))
								
								$oAttributes:=_o_xml_attributes($Dom_field)
								ASSERT:C1129($oAttributes["ios:bind"]#Null:C1517)
								
							Else 
								
								// The multivalued fields share the same attributes
								// As the last field defined in the template
								
							End if 
							
							If (Match regex:C1019("(?m-si)^([^\\[\\n]+)\\[(\\d+)]\\s*$"; $oAttributes["ios:bind"]; 1))
								
								// LIST OF FIELDS
								
								If ($oAttributes["ios:type"]="all")
									
									$isCompatible:=True:C214
									
								Else 
									
									// Check if the type is compatible
									$c:=Split string:C1554($oAttributes["ios:type"]; ","; sk trim spaces:K86:2).map("col_formula"; Formula:C1597($1.result:=Num:C11($1.value)))
									
									If ($oIN.target.fields#Null:C1517)
										
										For each ($oField; $oIN.target.fields.filter("col_formula"; Formula:C1597($1.result:=($1.value#Null:C1517)))) Until ($isCompatible)
											
											If ($oField#Null:C1517)
												
												$o:=Form:C1466.$project.ExposedStructure.fieldDefinition(Num:C11($oIN.tableNumber); $oField.path)
												$isCompatible:=$template.isTypeAccepted($c; $o.fieldType)
												
											End if 
										End for each 
									End if 
								End if 
								
								If ($isCompatible)\
									 & ($oField#Null:C1517)
									
									// Keep the field…
									$affected[$indx]:=$oField
									
									// …& remove it to don't use again
									$oIN.target.fields.remove($oIN.target.fields.indexOf($oField))
									
								End if 
								
								$indx:=$indx+1
								
							Else 
								
								// SINGLE VALUE FIELD (Not aaaaa[000]) ie 'searchableField' or 'sectionField'
								
								Case of 
										
										//______________________________________________________
									: ($oAttributes["ios:bind"]="searchableField")
										
										$isMultiCriteria:=(Split string:C1554($oAttributes.class; " ").indexOf("multi-criteria")#-1)
										
										$Lon_keyType:=Value type:C1509($oIN.target.searchableField)
										
										If ($Lon_keyType#Is undefined:K8:13)\
											 & ($Lon_keyType#Is null:K8:31)
											
											If ($Lon_keyType=Is collection:K8:32)
												
												// SOURCE IS MULTICRITERIA
												
												If ($oIN.target.searchableField.length>0)
													
													If ($isMultiCriteria)
														
														// Target is multi-criteria
														
														// #MARK_TODO Verify the type & remove incompatible if any
														For each ($o; $oIN.target.searchableField)
															
															// #MARK_TODO
															
														End for each 
														
														$cache.searchableField:=$oIN.target.searchableField
														
													Else 
														
														// Target is mono value -> keep the first compatible type
														$cache.searchableField:=$oIN.target.searchableField[0]
														
													End if 
												End if 
												
											Else 
												
												// SOURCE IS MONO VALUE
												
												If ($isMultiCriteria)
													
													// Target is multi-criteria -> don't modify if exist
													If ($Lon_keyType=Is null:K8:31)
														
														// #MARK_TODO Verify the type
														
														$cache.searchableField:=$oIN.target.searchableField
														
													End if 
													
												Else 
													
													// Target is mono value
													$cache.searchableField:=$oIN.target.searchableField
													
												End if 
											End if 
										End if 
										
										//______________________________________________________
									: ($oAttributes["ios:bind"]="sectionField")
										
										If ($oIN.target.sectionField#Null:C1517)
											
											$cache.sectionField:=$oIN.target.sectionField
											
										End if 
										
										//______________________________________________________
									Else 
										
										// #98417 - Remove in excess item from collection
										$affected.resize($affected.length-1)
										
										//______________________________________________________
								End case 
							End if 
						End for each 
						
						If ($oIN.manifest#Null:C1517)\
							 & ($oIN.selector="detail")\
							 & ($oIN.target.fields#Null:C1517)
							
							// Append the non affected fields
							$affected.combine($oIN.target.fields)
							
						End if 
						
						// Keep the field binding definition
						$cache.fields:=$affected
						
					End if 
					
				Else 
					
					// Not a list form
					
				End if 
				
				DOM CLOSE XML:C722($root)
				
			End if 
			
		Else 
			
			oops
			
		End if 
		
	Else 
		
		oops
		
	End if 
End if 