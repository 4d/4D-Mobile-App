//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : tmpl_REORDER
  // Database: 4D Mobile App
  // ID[D3DF454ABC0D4E68943727CD95C07675]
  // Created #26-4-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_accepted;$Boo_multiCriteria)
C_LONGINT:C283($Lon_indx;$Lon_keyType;$Lon_parameters)
C_TEXT:C284($Dir_root;$t;$Dom_field;$Dom_root;$File_;$Txt_bind)
C_OBJECT:C1216($o;$Obj_attributes;$Obj_cache;$Obj_field;$Obj_in)
C_COLLECTION:C1488($c;$Col_affected;$Col_bind;$Col_catalog)

If (False:C215)
	C_OBJECT:C1216(tmpl_REORDER ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	  // Load template
	If (Position:C15("/";$Obj_in.form)=1)
		
		  // Host database resources
		$Dir_root:=_o_Pathname ("host_"+$Obj_in.selector+"Forms")+Delete string:C232($Obj_in.form;1;1)
		
	Else 
		
		$Dir_root:=_o_Pathname ($Obj_in.selector+"Forms")+$Obj_in.form
		
	End if 
	
	$File_:=Object to path:C1548(New object:C1471(\
		"name";"template";\
		"extension";"svg";\
		"parentFolder";$Dir_root))
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Asserted:C1132(Test path name:C476($File_)=Is a document:K24:1))
	
	$Dom_root:=DOM Parse XML source:C719($File_)
	ASSERT:C1129(OK=1;"Invalid template")
	
	If (Bool:C1537(OK))
		
		$t:=DOM Find XML element by ID:C1010($Dom_root;"cookery")
		ASSERT:C1129(OK=1;"Missing 'cookery' element in the template")
		
		If (Bool:C1537(OK))
			
			  // Get the bindind definition
			$Obj_attributes:=xml_attributes ($t)
			OK:=Num:C11($Obj_attributes["ios:values"]#Null:C1517)
			ASSERT:C1129(OK=1;"Missing 'ios:values' attribute in the template")
			
			If (Bool:C1537(OK))
				
				$Obj_cache:=Form:C1466[$Obj_in.selector][$Obj_in.tableNumber]
				
				$Col_bind:=Split string:C1554($Obj_attributes["ios:values"];",";sk trim spaces:K86:2)
				
				  // Create binding collection sized according to bind attribute length
				$Col_affected:=New collection:C1472.resize($Col_bind.length)
				
				$Col_catalog:=editor_Catalog 
				
				  // Reorganize the binded fields
				For each ($Txt_bind;$Col_bind)
					
					CLEAR VARIABLE:C89($Boo_accepted)
					
					  // Find the binded element
					$Dom_field:=DOM Find XML element by ID:C1010($Dom_root;$Txt_bind)
					
					If (Bool:C1537(OK))
						
						$Obj_attributes:=xml_attributes ($Dom_field)
						ASSERT:C1129($Obj_attributes["ios:bind"]#Null:C1517)
						
					Else 
						
						  // The multivalued fields share the same attributes
						  // as the last field defined in the template
						
					End if 
					
					$o:=Rgx_match (New object:C1471(\
						"pattern";"(?m-si)^([^\\[]+)\\[(\\d+)]\\s*$";\
						"target";$Obj_attributes["ios:bind"]))
					
					If ($o.success)
						
						  // LIST OF FIELDS
						
						If ($Obj_attributes["ios:type"]="all")
							
							$Boo_accepted:=True:C214
							
						Else 
							
							  // Check if the type is compatible
							$c:=Split string:C1554($Obj_attributes["ios:type"];",";sk trim spaces:K86:2).map("col_formula";"$1.result:=Num:C11($1.value)")
							
							If ($Obj_in.target.fields#Null:C1517)
								
								For each ($Obj_field;$Obj_in.target.fields) Until ($Boo_accepted)
									
									If ($Obj_field#Null:C1517)
										
										$o:=structure (New object:C1471(\
											"action";"fieldDefinition";\
											"path";$Obj_field.name;\
											"tableNumber";Num:C11($Obj_in.tableNumber);\
											"catalog";$Col_catalog))
										
										If ($o.success)
											
											$Boo_accepted:=tmpl_compatibleType ($c;$o.fieldType)
											
										End if 
									End if 
								End for each 
							End if 
						End if 
						
						If ($Boo_accepted)\
							 & ($Obj_field#Null:C1517)
							
							  // Keep the field…
							$Col_affected[$Lon_indx]:=$Obj_field
							
							  // …& remove it to don't use again
							$Obj_in.target.fields.remove($Obj_in.target.fields.indexOf($Obj_field))
							
						End if 
						
						$Lon_indx:=$Lon_indx+1
						
					Else 
						
						  // SINGLE VALUE FIELD (Not aaaaa[000]) ie 'searchableField' or 'sectionField'
						
						Case of 
								
								  //______________________________________________________
							: ($Obj_attributes["ios:bind"]="searchableField")
								
								$Boo_multiCriteria:=(Split string:C1554($Obj_attributes.class;" ").indexOf("multi-criteria")#-1)
								
								$Lon_keyType:=Value type:C1509($Obj_in.target.searchableField)
								
								If ($Lon_keyType#Is undefined:K8:13)\
									 & ($Lon_keyType#Is null:K8:31)
									
									If ($Lon_keyType=Is collection:K8:32)
										
										  // SOURCE IS MULTICRITERIA
										
										If ($Obj_in.target.searchableField.length>0)
											
											If ($Boo_multiCriteria)
												
												  // Target is multi-criteria
												
												  //#TO_DO Verify the type & remove incompatible if any
												For each ($o;$Obj_in.target.searchableField)
													
													  // #TO_DO
													
												End for each 
												
												$Obj_cache.searchableField:=$Obj_in.target.searchableField
												
											Else 
												
												  // Target is mono value -> keep the first compatible type
												$Obj_cache.searchableField:=$Obj_in.target.searchableField[0]
												
											End if 
										End if 
										
									Else 
										
										  // SOURCE IS MONO VALUE
										
										If ($Boo_multiCriteria)
											
											  // Target is multi-criteria -> don't modify if exist
											If ($Lon_keyType=Is null:K8:31)
												
												  // #TO_DO Verify the type
												
												$Obj_cache.searchableField:=$Obj_in.target.searchableField
												
											End if 
											
										Else 
											
											  // Target is mono value
											$Obj_cache.searchableField:=$Obj_in.target.searchableField
											
										End if 
									End if 
								End if 
								
								  //______________________________________________________
							: ($Obj_attributes["ios:bind"]="sectionField")
								
								If ($Obj_in.target.sectionField#Null:C1517)
									
									$Obj_cache.sectionField:=$Obj_in.target.sectionField
									
								End if 
								
								  //______________________________________________________
							Else 
								
								  // #98417 - Remove in excess item from collection
								$Col_affected.resize($Col_affected.length-1)
								
								  //______________________________________________________
						End case 
					End if 
				End for each 
				
				  // Keep the field binding definition
				$Obj_cache.fields:=$Col_affected
				
			End if 
		End if 
		
		DOM CLOSE XML:C722($Dom_root)
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End