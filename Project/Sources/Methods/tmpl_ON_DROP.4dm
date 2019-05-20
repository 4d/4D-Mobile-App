//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : tmpl_ON_DROP
  // Database: 4D Mobile App
  // ID[FC685A0A360B4F518FF6B8E40D4BA148]
  // Created #6-9-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_BLOB:C604($x)
C_BOOLEAN:C305($b)
C_TEXT:C284($t;$Txt_isOfClass)
C_OBJECT:C1216($o;$Obj_field;$Obj_target)
C_COLLECTION:C1488($c)

ARRAY TEXT:C222($tTxt_results;0)

  // ----------------------------------------------------
  // Initialisations

$Obj_target:=Form:C1466[Choose:C955(Num:C11(This:C1470.$.selector)=2;"detail";"list")][This:C1470.$.tableNumber]

  // ----------------------------------------------------
If (Length:C16(This:C1470.$.current)>0)
	
	  // Get the pastboard
	GET PASTEBOARD DATA:C401("com.4d.private.ios.field";$x)
	
	If (Bool:C1537(OK))
		
		BLOB TO VARIABLE:C533($x;$o)
		SET BLOB SIZE:C606($x;0)
		
		  // Check the match of the type with the source
		SVG GET ATTRIBUTE:C1056(*;This:C1470.preview.name;This:C1470.$.current;"ios:type";$t)
		
		$c:=Split string:C1554($t;",";sk trim spaces:K86:2).map("col_formula";"$1.result:=Num:C11($1.value)")
		
		If ($t="all")
			
			$b:=True:C214
			
		Else 
			
			If (Bool:C1537(featuresFlags.withNewFieldProperties))
				
				$b:=tmpl_compatibleType ($c;$o.fieldType)
				
			Else 
				
				  //#MARK_TO_OPTIMIZE
				$b:=tmpl_compatibleType ($c;structure (New object:C1471(\
					"action";"tmplType";\
					"value";Num:C11($o.type))).value)
				
			End if 
		End if 
		
		If ($b)
			
			If (Bool:C1537(featuresFlags.withNewFieldProperties))
				
				$Obj_field:=New object:C1471(\
					"name";$o.path;\
					"id";$o.fieldNumber)
				
			Else 
				
				$Obj_field:=New object:C1471(\
					"name";$o.path;\
					"id";$o.id)
				
			End if 
			
			SVG GET ATTRIBUTE:C1056(*;This:C1470.preview.name;This:C1470.$.current;"ios:bind";$t)
			Rgx_MatchText ("(?m-si)^([^\\[]+)\\[(\\d+)]\\s*$";$t;->$tTxt_results)
			
			If (Size of array:C274($tTxt_results)=2)  // List of fields
				
				  // Belt and braces
				If ($Obj_target[$tTxt_results{1}]=Null:C1517)
					
					$Obj_target[$tTxt_results{1}]:=New collection:C1472
					
				End if 
				
				$Obj_target[$tTxt_results{1}][Num:C11($tTxt_results{2})]:=$Obj_field  //$o
				
			Else   // Single value field (Not aaaaa[000]) ie 'searchableField' or 'sectionField'
				
				  //#98105 - Multi-criteria Search
				  //If (Bool(featuresFlags._98105))
				
				SVG GET ATTRIBUTE:C1056(*;This:C1470.preview.name;This:C1470.$.current;"4D-isOfClass-multi-criteria";$Txt_isOfClass)
				
				  //End if
				
				If ($Txt_isOfClass="true")  // Search on several fields - append to the field list if any
					
					If (Value type:C1509($Obj_target[$t])#Is collection:K8:32)
						
						If ($Obj_target[$t]#Null:C1517)
							
							  // Convert
							$Obj_target[$t]:=New collection:C1472($Obj_target[$t])
							
						Else 
							
							$Obj_target[$t]:=$Obj_field
							
						End if 
					End if 
					
					If (Value type:C1509($Obj_target[$t])=Is collection:K8:32)
						
						  //#104976 - [BUG] Add related field in searchBar for Multi-criteria search
						  //If ($Obj_target[$t].extract("id").indexOf($o.id)=-1)
						If ($Obj_target[$t].extract("name").indexOf($o.path)=-1)
							
							  // Append field
							$Obj_target[$t].push($Obj_field)
							
						End if 
					End if 
					
				Else 
					
					$Obj_target[$t]:=$Obj_field
				End if 
			End if 
			
			  // Update preview
			views_preview ("draw";This:C1470)
			
			  // Save project
			project.save()
			
		End if 
		
	Else 
		
		  //If (Bool(featuresFlags._103505))
		  //SVG GET ATTRIBUTE(*;This.preview;This.$.current;"4D-isOfClass-action";$Txt_isOfClass)
		  //If ($Txt_isOfClass="true")
		  //SVG GET ATTRIBUTE(*;This.preview.name;This.$.current;"ios:bind";$t)
		  //Rgx_MatchText ("(?m-si)^([^\\[]+)\\[(\\d+)]\\s*$";$t;->$tTxt_results)
		  //If (Size of array($tTxt_results)=2)  // List of fields
		  //GET PASTEBOARD DATA("com.4d.private.ios.action";$x)
		  //If (Bool(OK))
		  //BLOB TO VARIABLE($x;$o)
		  //SET BLOB SIZE($x;0)
		  //OB REMOVE($o;"target")
		  //For each ($t;$o)
		  //If ($t[[1]]="$")
		  //OB REMOVE($o;$t)
		  //End if
		  //End for each
		  //ob_createPath ($Obj_target;"fieldsActions";Is collection)
		  //$Obj_target.fieldsActions[Num($tTxt_results{2})]:=$o
		  //End if
		  //End if
		  //End if
		  //End if
		
	End if 
End if 

  // ----------------------------------------------------
  // End