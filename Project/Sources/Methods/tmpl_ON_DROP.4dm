//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : tmpl_ON_DROP
  // ID[FC685A0A360B4F518FF6B8E40D4BA148]
  // Created 6-9-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_BLOB:C604($x)
C_BOOLEAN:C305($b)
C_LONGINT:C283($countFixed;$indx)
C_TEXT:C284($t;$t_isOfClass)
C_OBJECT:C1216($o;$oTarget)
C_COLLECTION:C1488($c)

ARRAY TEXT:C222($tMatches;0)

  // ----------------------------------------------------
  // Initialisations

$oTarget:=Form:C1466[Choose:C955(Num:C11(This:C1470.$.selector)=2;"detail";"list")][This:C1470.$.tableNumber]

  // ----------------------------------------------------
If (Length:C16(This:C1470.$.current)>0)
	
	  // Get the pastboard
	GET PASTEBOARD DATA:C401("com.4d.private.ios.field";$x)
	
	If (Bool:C1537(OK))
		
		BLOB TO VARIABLE:C533($x;$o)
		SET BLOB SIZE:C606($x;0)
		
		  // Check the match of the type with the source
		SVG GET ATTRIBUTE:C1056(*;This:C1470.preview.name;This:C1470.$.current;"ios:type";$t)
		
		If ($t="all")
			
			$b:=True:C214
			
		Else 
			
			  // Check the type compatibility
			$c:=Split string:C1554($t;",";sk trim spaces:K86:2).map("col_formula";"$1.result:=Num:C11($1.value)")
			$b:=tmpl_compatibleType ($c;$o.fieldType)
			
		End if 
		
		If ($b)
			
			$o.name:=$o.path
			
			SVG GET ATTRIBUTE:C1056(*;This:C1470.preview.name;This:C1470.$.current;"ios:bind";$t)
			Rgx_MatchText ("(?m-si)^([^\\[]+)\\[(\\d+)]\\s*$";$t;->$tMatches)
			
			If (Size of array:C274($tMatches)=2)  // List of fields
				
				  // Belt and braces
				If ($oTarget[$tMatches{1}]=Null:C1517)
					
					$oTarget[$tMatches{1}]:=New collection:C1472
					
				End if 
				
				$oTarget[$tMatches{1}][Num:C11($tMatches{2})]:=$o
				
			Else   // Single value field (Not aaaaa[000]) ie 'searchableField' or 'sectionField'
				
				SVG GET ATTRIBUTE:C1056(*;This:C1470.preview.name;This:C1470.$.current;"4D-isOfClass-multi-criteria";$t_isOfClass)
				
				If ($t_isOfClass="true")  // Search on several fields - append to the field list if any
					
					If (Value type:C1509($oTarget[$t])#Is collection:K8:32)
						
						If ($oTarget[$t]#Null:C1517)
							
							  // Convert
							$oTarget[$t]:=New collection:C1472($oTarget[$t])
							
						Else 
							
							$oTarget[$t]:=$o
							
						End if 
					End if 
					
					If (Value type:C1509($oTarget[$t])=Is collection:K8:32)
						
						If ($oTarget[$t].extract("name").indexOf($o.path)=-1)
							
							  // Append field
							$oTarget[$t].push($o)
							
						End if 
					End if 
					
				Else 
					
					Case of 
							  //______________________________________________________
						: (This:C1470.$.current="background")
							
							If ($o.fromIndex#Null:C1517)
								
								$oTarget.fields.remove($o.fromIndex)
								
							End if 
							
							$countFixed:=Form:C1466.$dialog.VIEWS.template.manifest.fields.count
							$indx:=$oTarget.fields.indexOf(Null:C1517;$countFixed)
							
							If ($indx=-1)
								
								If ($oTarget.fields.length<$countFixed)
									
									$oTarget.fields[$countFixed]:=$o
									
								Else 
									
									$oTarget.fields.push($o)
									
								End if 
								
							Else 
								
								$oTarget.fields[$indx]:=$o
								
							End if 
							
							  //______________________________________________________
						: (This:C1470.$.current="@.vInsert")
							
							$indx:=Num:C11(Replace string:C233(This:C1470.$.current;"e";""))
							
							If ($o.fromIndex#Null:C1517)
								
								$oTarget.fields.remove($o.fromIndex)
								$indx:=$indx-1-Num:C11($o.fromIndex<$indx)
								
							Else 
								
								$indx:=$indx-1
								
							End if 
							
							$oTarget.fields.insert($indx;$o)
							
							  //______________________________________________________
						Else 
							
							$oTarget[$t]:=$o
							
							  //______________________________________________________
					End case 
				End if 
			End if 
			
			If (feature.with("newViewUI"))
				
				OB REMOVE:C1226(Form:C1466.$dialog.VIEWS;"scroll")
				
			End if 
			
			  // Update preview
			views_preview ("draw";This:C1470)
			
			  // Save project
			project.save()
			
		End if 
		
	Else 
		
		  // If (Bool(featuresFlags._103505))
		  //SVG GET ATTRIBUTE(*;This.preview;This.$.current;"4D-isOfClass-action";$Txt_isOfClass)
		  //If ($Txt_isOfClass="true")
		  //SVG GET ATTRIBUTE(*;This.preview.name;This.$.current;"ios:bind";$t)
		  //Rgx_MatchText ("(?m-si)^([^\\[]+)\\[(\\d+)]\\s*$";$t;->$tTxt_results)
		  //If (Size of array($tTxt_results)=2)  // List of fields
		  //GET PASTEBOARD DATA("com.4d.private.ios.action";$x)
		  // If (Bool(OK))
		  //BLOB TO VARIABLE($x;$o)
		  //SET BLOB SIZE($x;0)
		  //OB REMOVE($o;"target")
		  //For each ($t;$o)
		  //If ($t[[1]]="$")
		  //OB REMOVE($o;$t)
		  // End if
		  // End for each
		  //ob_createPath ($Obj_target;"fieldsActions";Is collection)
		  //$Obj_target.fieldsActions[Num($tTxt_results{2})]:=$o
		  // End if
		  // End if
		  // End if
		  // End if
		
	End if 
End if 

  // ----------------------------------------------------
  // End