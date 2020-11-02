// VIEWS pannel Class
Class constructor
	
	
	//============================================================================
	// Construct the table field list
Function fieldList
	var $0 : Object
	var $1 : Variant
	
	var $attribute; $key; $tableID : Text
	var $field; $tableModel : Object
	
	ASSERT:C1129(Count parameters:C259>=1; "Missing parameter")
	
	If (Value type:C1509($1)=Is text:K8:3)
		
		$tableID:=$1
		
	Else 
		
		$tableID:=String:C10($1)
		
	End if 
	
	$0:=New object:C1471(\
		"success"; Form:C1466.dataModel#Null:C1517)
	
	If ($0.success)
		
		$tableModel:=Form:C1466.dataModel[$tableID]
		
		$0.success:=($tableModel#Null:C1517)
		
		If ($0.success)
			
			$0.fields:=New collection:C1472
			
			For each ($key; $tableModel)
				
				Case of 
						
						//……………………………………………………………………………………………………………
					: (Length:C16($key)=0)
						
						// table meta-data
						
						//……………………………………………………………………………………………………………
					: (Value type:C1509($tableModel[$key])#Is object:K8:27)
						
						// <NOTHING MORE TO DO>
						
						//……………………………………………………………………………………………………………
					: (PROJECT.isField($key))
						
						$field:=OB Copy:C1225($tableModel[$key])
						
						// #TEMPO [
						$field.id:=Num:C11($key)
						$field.fieldNumber:=Num:C11($key)
						//]
						
						$field.path:=$field.name
						
						$0.fields.push($field)
						
						//……………………………………………………………………………………………………………
					: (PROJECT.isRelationToOne($tableModel[$key]))
						
						If (FEATURE.with("moreRelations"))
							
							If (Form:C1466.dataModel[String:C10($tableModel[$key].relatedTableNumber)]#Null:C1517)
								
								$field:=New object:C1471(\
									"name"; $key; \
									"path"; $key; \
									"fieldType"; 8858; \
									"relatedDataClass"; $tableModel[$key].relatedDataclass; \
									"inverseName"; $tableModel[$key].inverseName; \
									"label"; $tableModel[$key].label; \
									"shortlabel"; $tableModel[$key].$t.shortLabel; \
									"relatedTableNumber"; $tableModel[$key].relatedTableNumber; \
									"$added"; True:C214)
								
								// #TEMPO [
								$field.id:=0
								//]
								
								$0.fields.push($field)
								
							End if 
						End if 
						
						
						ASSERT:C1129(Not:C34(Shift down:C543))
						
						For each ($attribute; $tableModel[$key])
							
							Case of 
									
									//______________________________________________________
								: (Value type:C1509($tableModel[$key][$attribute])#Is object:K8:27)
									
									// <NOTHING MORE TO DO>
									
									//______________________________________________________
								: (PROJECT.isField($attribute))
									
									$field:=OB Copy:C1225($tableModel[$key][$attribute])
									
									// #TEMPO [
									$field.id:=Num:C11($attribute)
									$field.fieldNumber:=Num:C11($attribute)
									//]
									
									$field.path:=$key+"."+$field.name
									
									//$o.path:="┊"+$o.path
									
									$0.fields.push($field)
									
									//______________________________________________________
								: (Not:C34(FEATURE.with("moreRelations")))
									
									// <NOT DELIVERED>
									
									//______________________________________________________
								Else 
									
									If ($0.fields.query("path = :1"; $attribute).pop()=Null:C1517)
										
										$field:=OB Copy:C1225($tableModel[$key][$attribute])
										$field.id:=0
										$field.name:=$attribute
										
										If (Bool:C1537($field.isToMany))
											
											
											$field.path:=$key+"."+$attribute
											$field.fieldType:=8859
											
										Else 
											
											$field.path:=$key+"."+$attribute
											$field.fieldType:=8858
											
										End if 
										
										$field.$added:=True:C214
										
										$0.fields.push($field)
										
									End if 
									
									//______________________________________________________
							End case 
							
						End for each 
						
						//……………………………………………………………………………………………………………
					: (PROJECT.isRelationToMany($tableModel[$key]))
						
						If (Form:C1466.$dialog.VIEWS.template.detailform)
							
							$field:=OB Copy:C1225($tableModel[$key])
							
							$field.name:=$key
							$field.fieldType:=8859
							
							// #TEMPO [
							$field.id:=0
							$field.fieldNumber:=0
							//]
							
							$field.path:=$key
							
							$0.fields.push($field)
							
						Else 
							
							If (FEATURE.with("moreRelations"))
								
								$field:=New object:C1471(\
									"name"; $key; \
									"path"; $key; \
									"fieldType"; 8859; \
									"relatedDataClass"; $tableModel[$key].relatedDataclass; \
									"inverseName"; $tableModel[$key].inverseName; \
									"label"; PROJECT.label($tableModel[$key].label); \
									"shortlabel"; PROJECT.label($tableModel[$key].$t.shortLabel); \
									"isToMany"; True:C214; \
									"relatedTableNumber"; $tableModel[$key].relatedTableNumber)
								
								// #TEMPO [
								$field.id:=0
								//]
								
								$0.fields.push($field)
								
							End if 
						End if 
						
						//……………………………………………………………………………………………………………
				End case 
			End for each 
			
			$0.fields:=$0.fields.orderBy("path")
			
		End if 
	End if 
	
	//============================================================================
	// Attach a form (Call back from widget)
Function setTemplate($browser : Object; $form : Object)
	var $currentForm; $formName; $selector; $tableID : Text
	var $update : Boolean
	var $context; $o; $target : Object
	var $c : Collection
	var $template : cs:C1710.tmpl
	
	$context:=$form.$
	
	$form.fieldGroup.show()
	$form.previewGroup.show()
	$form.scrollBar.hide()
	
	If ($browser.form#Null:C1517)  // Browser auto close
		
		$formName:=$browser.form
		$update:=True:C214
		
	Else 
		
		If ($browser.item>0)\
			 & ($browser.item<=$browser.pathnames.length)
			
			If ($browser.pathnames[$browser.item-1]#Null:C1517)
				
				// The selected form
				$formName:=$browser.pathnames[$browser.item-1]
				$update:=True:C214
				
			Else 
				
				// Show browser
				$o:=New object:C1471(\
					"url"; Get localized string:C991("res_"+$context.typeForm()+"Forms"))
				
				$form.form.call(New collection:C1472("initBrowser"; $o))
				
			End if 
		End if 
	End if 
	
	If ($update)
		
		// Table number as string
		$tableID:=$context.tableNum()
		
		// Current selector (list | detail)
		$selector:=$browser.selector
		
		// The current table form
		$currentForm:=String:C10(Form:C1466[$selector][$tableID].form)
		
		If ($formName#$currentForm)
			
			$template:=cs:C1710.tmpl.new($formName; $selector).update()
			
			$target:=Form:C1466[$selector][$tableID]
			
			$browser.target:=OB Copy:C1225($target)
			OB REMOVE:C1226($browser.target; "form")
			
			If (Length:C16($currentForm)#0)
				
				// Save a snapshot of the current form definition
				Case of 
						
						//______________________________________________________
					: ($context[$tableID]=Null:C1517)
						
						$context[$tableID]:=New object:C1471(\
							$selector; New object:C1471($currentForm; \
							$browser.target))
						
						//______________________________________________________
					: ($context[$tableID][$selector]=Null:C1517)
						
						$context[$tableID][$selector]:=New object:C1471(\
							$currentForm; $browser.target)
						
						//______________________________________________________
					Else 
						
						$context[$tableID][$selector][$currentForm]:=$browser.target
						
						//______________________________________________________
				End case 
			End if 
			
			// Update project & save
			$target.form:=$formName
			
			If ($target.fields=Null:C1517)
				
				$target.fields:=New collection:C1472
				
				If (Num:C11($template.manifest.fields.count)>0)
					
					$target.fields.resize($template.manifest.fields.count)
					
				End if 
			End if 
			
			//OB REMOVE($context; "manifest")
			PROJECT.save()
			
			If (ob_testPath(Form:C1466.$project; "status"; "project"))
				
				If (Not:C34(Form:C1466.$project.status.project))
					
					// Launch project verifications
					$form.form.call("projectAudit")
					
				End if 
			End if 
			
			If ($context[$tableID][$selector][$formName]=Null:C1517)
				
				// Create a new binding
				If ($target.fields=Null:C1517)
					
					$c:=New collection:C1472
					
				Else 
					
					// Use current
					$c:=$target.fields.copy()
					
				End if 
				
				If ($context[$tableID]#Null:C1517)
					
					If ($context[$tableID][$selector]#Null:C1517)
						
						$template.enrich($c; $context[$tableID][$selector])
						
					End if 
				End if 
				
			Else 
				
				// Reuse the last snapshot
				$c:=$context[$tableID][$selector][$formName].fields
				$template.enrich($c; $context[$tableID][$selector]; $formName)
				
			End if 
			
			$browser.form:=$formName
			$browser.tableNumber:=$tableID
			
			If (FEATURE.with("newViewUI"))
				
				$browser.manifest:=$template.manifest
				
			End if 
			
			If (False:C215)  //#WIP
				
				$template.reorder($tableID)
				
			Else 
				
				$browser.template:=$template
				tmpl_REORDER($browser)
				
			End if 
		End if 
		
		// Redraw
		$context.draw:=True:C214
		$form.form.refresh()
		
	End if 
	