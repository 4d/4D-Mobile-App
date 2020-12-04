/*===============================================
VIEWS pannel Class
===============================================*/
Class extends form

//________________________________________________________________
Class constructor
	var $1 : Object
	
	Super:C1705("editor_CALLBACK")
	
	This:C1470.context:=editor_INIT
	
	If (OB Is empty:C1297(This:C1470.context)) | Shift down:C543
		
		This:C1470.tableWidget:=cs:C1710.picture.new("tables")
		
		This:C1470.tableButtonNext:=cs:C1710.button.new("next")
		This:C1470.tableButtonPrevious:=cs:C1710.button.new("previous")
		
		This:C1470.tableNext:=cs:C1710.static.new("next@")
		This:C1470.tablePrevious:=cs:C1710.static.new("previous@")
		
		This:C1470.tablist:=cs:C1710.button.new("tab.list")
		This:C1470.tabdetail:=cs:C1710.button.new("tab.detail")
		This:C1470.tabSelector:=cs:C1710.widget.new("tab.selector")
		
		This:C1470.noPublishedTable:=cs:C1710.widget.new("noPublishedTable")
		
		This:C1470.fieldList:=cs:C1710.listbox.new("01_fields")
		
		// Constraints definition
		This:C1470.context.constraints:=New object:C1471("rules"; New collection:C1472)
		This:C1470.context.constraints.push(New object:C1471(\
			"formula"; Formula:C1597(VIEWS_Handler(New object:C1471(\
			"action"; "geometry")))))
		
		If (FEATURE.with("newViewUI"))
			
			This:C1470.context.constraints.push(New object:C1471(\
				"object"; New collection:C1472("preview"; "preview.label"; "preview.back"; "Preview.border"); \
				"reference"; "viewport.preview"; \
				"type"; "horizontal alignment"; \
				"value"; "center"))
			
			This:C1470.context.constraints.push(New object:C1471(\
				"object"; "preview.scrollBar"; \
				"reference"; "preview"; \
				"type"; "margin-left"; \
				"value"; 20))
			
		End if 
	End if 
	
	This:C1470._update()
	
	If (Count parameters:C259>=1)
		
		This:C1470.form:=$1  //#TEMPO
		
	End if 
	
	//============================================================================
Function _update
	var $t : Text
	
	$t:=Current form name:C1298  // #TEMPORARY_COMPATIBILITY
	This:C1470.template:=Form:C1466.$dialog[$t].template
	This:C1470.manifest:=This:C1470.template.manifest
	
	//============================================================================
	// Redraw the preview
Function draw
	
	tmpl_DRAW(This:C1470.form)
	
	//============================================================================
	// Define a field in the form
Function addField($field : Object; $fields : Collection)
	var $index : Integer
	var $ok : Boolean
	var $o : Object
	
	$field:=PROJECT.cleanup($field)
	
	$ok:=True:C214
	
	If ($field.fieldType=8859)
		
		// 1-N relation with published related data class
		$ok:=(Form:C1466.dataModel[String:C10($field.relatedTableNumber)]#Null:C1517)
		
	End if 
	
	If ($ok)
		
		If ($field.fieldType#8859)  // Not 1-N relation
			
			$index:=$fields.indexOf(Null:C1517)
			
			If (($index#-1))
				
				// Set
				$fields[$index]:=$field
				
			Else 
				
				// Append
				$fields.push($field)
				
			End if 
			
		Else 
			
			// Append
			$fields.push($field)
			
		End if 
	End if 
	
	//============================================================================
	// Construct the table's field list
Function fieldList($table : Variant)->$result : Object
	var $attribute; $key; $tableID : Text
	var $field; $o; $subfield; $tableModel : Object
	var $c : Collection
	var $subLevel : Integer
	var $linkPrefix : Text
	
	$linkPrefix:=Choose:C955(Is macOS:C1572; "└ "; "└ ")  //"├ " //" ┊"
	
	ASSERT:C1129(Count parameters:C259>=1; "Missing parameter")
	
	$tableID:=Choose:C955(Value type:C1509($table)=Is text:K8:3; $table; String:C10($table))
	
	$result:=New object:C1471(\
		"success"; Form:C1466.dataModel#Null:C1517)
	
	If ($result.success)
		
		$tableModel:=Form:C1466.dataModel[$tableID]
		
		$result.success:=($tableModel#Null:C1517)
		
		If ($result.success)
			
			$result.fields:=New collection:C1472
			
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
						$field.$label:=$field.path
						$field.$level:=0
						
						$result.fields.push($field)
						
						//……………………………………………………………………………………………………………
					: (PROJECT.isRelationToOne($tableModel[$key]))
						
						If (FEATURE.with("moreRelations"))
							
							$field:=New object:C1471(\
								"name"; $key; \
								"path"; $key; \
								"fieldType"; 8858; \
								"relatedDataClass"; $tableModel[$key].relatedDataclass; \
								"inverseName"; $tableModel[$key].inverseName; \
								"label"; PROJECT.label($key); \
								"shortLabel"; PROJECT.shortLabel($key); \
								"relatedTableNumber"; $tableModel[$key].relatedTableNumber; \
								"$added"; True:C214)
							
							// #TEMPO [
							$field.id:=0
							//]
							
							//******* Il faut vérifier que la relation existe toujours *******
							
							
							$subLevel:=$subLevel+10
							
							$field.$label:=$field.path
							$field.$level:=$subLevel
							
							$result.fields.push($field)
							
						End if 
						
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
									
									$field.$label:=$linkPrefix+$field.name
									$field.path:=$key+"."+$field.name
									$field.$level:=$subLevel+1
									
									$result.fields.push($field)
									
									//______________________________________________________
								: (Not:C34(FEATURE.with("moreRelations")))
									
									// <NOT DELIVERED>
									
									//______________________________________________________
								Else 
									
									$field:=OB Copy:C1225($tableModel[$key][$attribute])
									
									$c:=New collection:C1472
									
									If ($field.relatedTableNumber#Null:C1517)
										
										For each ($subfield; OB Entries:C1720($field).filter("col_formula"; Formula:C1597($1.result:=Match regex:C1019("^\\d+$"; $1.value.key; 1))))
											
											$o:=OB Copy:C1225($subfield.value)
											$o.$label:=$linkPrefix+$o.path
											$o.path:=$key+"."+$o.path
											$o.id:=Num:C11($subfield.key)
											$o.$level:=$subLevel+2
											
											$c.push($o)
											
										End for each 
										
									End if 
									
									If ($c.length>0)
										
										$result.fields.combine($c)
										
									Else 
										
										$field.id:=0
										$field.name:=$attribute
										$field.$label:=$linkPrefix+$attribute
										$field.path:=$key+"."+$attribute
										$field.fieldType:=Choose:C955(Bool:C1537($field.isToMany); 8859; 8858)
										$result.fields.push($field)
										$field.$level:=$subLevel+2
										
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
							$field.$label:=$field.path
							
							$result.fields.push($field)
							
						Else 
							
							If (FEATURE.with("moreRelations"))
								
								$field:=New object:C1471(\
									"name"; $key; \
									"path"; $key; \
									"fieldType"; 8859; \
									"relatedDataClass"; $tableModel[$key].relatedDataclass; \
									"relatedTableNumber"; $tableModel[$key].relatedTableNumber; \
									"inverseName"; $tableModel[$key].inverseName; \
									"label"; PROJECT.label($tableModel[$key].label); \
									"shortLabel"; PROJECT.label($tableModel[$key].shortLabel); \
									"isToMany"; True:C214)
								
								// #TEMPO [
								$field.id:=0
								//]
								
								$field.$label:=$field.path
								
								$result.fields.push($field)
								
							End if 
						End if 
						
						$field.$level:=0
						
						//……………………………………………………………………………………………………………
				End case 
			End for each 
			
			If (FEATURE.with("moreRelations"))
				
				$result.fields:=$result.fields.orderBy("$level, path")
				
			Else 
				
				$result.fields:=$result.fields.orderBy("path")
				
			End if 
		End if 
	End if 
	
	//============================================================================
	// Attach a form (Call back from widget)
Function setTemplate($browser : Object)
	var $currentTemplate; $newTemplate; $selector; $tableID : Text
	var $update : Boolean
	var $browser; $context; $o; $target : Object
	var $c : Collection
	var $template : cs:C1710.tmpl
	
	$context:=This:C1470.form.$
	
	This:C1470.form.fieldGroup.show()
	This:C1470.form.previewGroup.show()
	This:C1470.form.scrollBar.hide()
	
	If ($browser.form#Null:C1517)  // Browser auto close
		
		$newTemplate:=$browser.form
		$update:=True:C214
		
	Else 
		
		If ($browser.item>0)\
			 & ($browser.item<=$browser.pathnames.length)
			
			If ($browser.pathnames[$browser.item-1]#Null:C1517)
				
				// The selected form
				$newTemplate:=$browser.pathnames[$browser.item-1]
				$update:=True:C214
				
			Else 
				
				// Show browser
				$o:=New object:C1471(\
					"url"; Get localized string:C991("res_"+$context.typeForm()+"Forms"))
				
				This:C1470.form.form.call(New collection:C1472("initBrowser"; $o))
				
			End if 
		End if 
	End if 
	
	If ($update)
		
		// Table number as string
		$tableID:=$context.tableNum()
		
		// Current selector (list | detail)
		$selector:=$browser.selector
		
		// The current table form
		$currentTemplate:=String:C10(Form:C1466[$selector][$tableID].form)
		
		If ($newTemplate#$currentTemplate)
			
			$template:=cs:C1710.tmpl.new($newTemplate; $selector).update()
			
			$target:=Form:C1466[$selector][$tableID]
			
			$browser.target:=OB Copy:C1225($target)
			OB REMOVE:C1226($browser.target; "form")
			
			If (Length:C16($currentTemplate)#0)
				
				// Save a snapshot of the current form definition
				Case of 
						
						//______________________________________________________
					: ($context[$tableID]=Null:C1517)
						
						$context[$tableID]:=New object:C1471(\
							$selector; New object:C1471($currentTemplate; \
							$browser.target))
						
						//______________________________________________________
					: ($context[$tableID][$selector]=Null:C1517)
						
						$context[$tableID][$selector]:=New object:C1471(\
							$currentTemplate; $browser.target)
						
						//______________________________________________________
					Else 
						
						$context[$tableID][$selector][$currentTemplate]:=$browser.target
						
						//______________________________________________________
				End case 
			End if 
			
			// Update project & save
			$target.form:=$newTemplate
			
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
					This:C1470.form.form.call("projectAudit")
					
				End if 
			End if 
			
			If ($context[$tableID][$selector][$newTemplate]=Null:C1517)
				
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
				$c:=$context[$tableID][$selector][$newTemplate].fields
				$template.enrich($c; $context[$tableID][$selector]; $newTemplate)
				
			End if 
			
			$browser.form:=$newTemplate
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
		This:C1470.form.form.refresh()
		
	End if 
	
	//============================================================================
	// Open the template selector
Function templatePicker($formType : Text)
	
	views_LAYOUT_PICKER($formType)