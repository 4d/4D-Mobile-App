//%attributes = {"invisible":true}
//#DECLARE ($svg : cs.svg; $context : Object)
var $1 : cs:C1710.svg
var $2 : Object

If (False:C215)
	C_OBJECT:C1216(VIEW_RENDERER_v1; $1)
	C_OBJECT:C1216(VIEW_RENDERER_v1; $2)
End if 

var $container; $domField; $domTemplate; $domUse; $index; $name; $new; $node; $t; $widgetField : Text
var $first; $multivalued : Boolean
var $dy; $i; $indx; $width; $y : Integer
var $context; $o; $target : Object
var $c : Collection
var $svg : cs:C1710.svg

$svg:=$1
$context:=$2

// Update values if any
$t:=$svg.findById("cookery")

If (Asserted:C1132($svg.success; "Missing cookery element"))
	
	$o:=xml_attributes($t)
	
	// Get the bindind definition
	If (Asserted:C1132($o["ios:values"]#Null:C1517))
		
		$c:=Split string:C1554(String:C10($o["ios:values"]); ","; sk trim spaces:K86:2)
		
	End if 
	
	// Get the template for multivalued fields reference, if exist
	$domTemplate:=$svg.findById("f")
	$multivalued:=($svg.success)
	
	If ($multivalued)
		
		// Get the main group reference
		$container:=$svg.findById("multivalued")
		
		// Get the vertical offset
		$o:=xml_attributes($domTemplate)
		
		If ($o["ios:dy"]#Null:C1517)
			
			$dy:=Num:C11($o["ios:dy"])
			DOM REMOVE XML ATTRIBUTE:C1084($domTemplate; "ios:dy")
			
		End if 
		
		For each ($widgetField; $c)
			
			$t:=$svg.findById($widgetField)
			
			If ($svg.success)
				
				If (FEATURE.with("newViewUI"))
					
					$node:=$svg.findById($widgetField+".label")
					
					If ($svg.success)
						
						$svg.setValue(Get localized string:C991("dropAFieldHere"); $node)
						
					End if 
				End if 
				
				// Get position
				$node:=$svg.parent($t)
				
				If (Asserted:C1132(OK=1))
					
					DOM GET XML ATTRIBUTE BY NAME:C728($node; "transform"; $t)
					$y:=Num:C11(Replace string:C233($t; "translate(0,"; ""))
					
				End if 
				
			Else 
				
				// Create an object from the template
				$y:=$y+$dy
				$index:=String:C10(Num:C11($widgetField))
				
				$domUse:=DOM Create XML Ref:C861("root")
				
				If (Asserted:C1132(OK=1))
					
					$new:=DOM Append XML element:C1082($domUse; $domTemplate)
					
					// Remove id
					DOM REMOVE XML ATTRIBUTE:C1084($new; "id")
					
					// Set position
					DOM SET XML ATTRIBUTE:C866($new; \
						"transform"; "translate(0,"+String:C10($y)+")")
					
					// Set label
					$node:=DOM Find XML element by ID:C1010($new; "f.label")
					DOM SET XML ATTRIBUTE:C866($node; \
						"id"; $widgetField+".label")
					
					If (FEATURE.with("newViewUI"))
						
						DOM SET XML ELEMENT VALUE:C868($node; Get localized string:C991("dropAFieldHere"))
						
					Else 
						
						DOM GET XML ELEMENT VALUE:C731($node; $t)
						DOM SET XML ELEMENT VALUE:C868($node; Get localized string:C991($t)+$index)
						
					End if 
					
					// Set id, bind & default label
					$node:=DOM Find XML element by ID:C1010($new; "f")
					
					DOM SET XML ATTRIBUTE:C866($node; \
						"id"; $widgetField; \
						"ios:bind"; "fields["+String:C10(Num:C11($widgetField)-1)+"]"; \
						"ios:label"; Get localized string:C991("field[n]")+" "+$index)
					
					// Set cancel id
					$node:=DOM Find XML element by ID:C1010($new; "f.cancel")
					DOM SET XML ATTRIBUTE:C866($node; \
						"id"; $widgetField+".cancel")
					
					// Append object to the preview
					$new:=DOM Append XML element:C1082($container; $new)
					
					DOM CLOSE XML:C722($domUse)
					
				End if 
			End if 
		End for each 
	End if 
	
	// Valorize the fields
	For each ($t; $c)
		
		CLEAR VARIABLE:C89($name)
		
		// Find the binded element
		$domField:=$svg.findById($t)
		
		// Get the field bind
		$o:=xml_attributes($domField)
		
		If (Asserted:C1132($o["ios:bind"]#Null:C1517))
			
			If (Rgx_MatchText("(?m-si)^([^\\[]+)\\[(\\d+)]\\s*$"; $o["ios:bind"])=-1)
				
				// Single value field (Not aaaaa[000]) ie 'searchableField' or 'sectionField'
				If ($target[$o["ios:bind"]]#Null:C1517)
					
					If (Value type:C1509($target[$o["ios:bind"]])=Is collection:K8:32)
						
						If ($target[$o["ios:bind"]].length=1)
							
							$name:=$target[$o["ios:bind"]][0].name
							
						Else 
							
							// Multi-criteria Search
							$name:=Get localized string:C991("multiCriteriaSearch")
							
						End if 
						
					Else 
						
						$name:=String:C10($target[$o["ios:bind"]].name)
						
					End if 
				End if 
				
				$indx:=$indx-1
				
			Else 
				
				If ($indx<$target.fields.length)
					
					$o:=$target.fields[$indx]
					
					If ($o#Null:C1517)
						
						// Keep the field  description for the needs of UI
						$svg.setAttribute("ios:data"; JSON Stringify:C1217($o); $domField)
						
						$name:=$o.name
						
						If (Num:C11($o.fieldType)=8859)  // 1-N relation
							
							$node:=$svg.findById($t+".label")
							$svg.setAttribute("font-style"; "italic"; $node)
							
							If (PROJECT.dataModel[String:C10($o.relatedTableNumber)]=Null:C1517)  // Error
								
								$svg.setAttribute("class"; String:C10(xml_attributes($node).class)+" error"; $node)
								
							End if 
						End if 
						
						// Keep the nex available index
						$context.lastMultivaluedField:=$indx+1
						
					End if 
				End if 
			End if 
		End if 
		
		If (Length:C16($name)>0)
			
			If (Asserted:C1132(OK=1))
				
				$svg.setAttribute("stroke-dasharray"; "none"; $domField)
				
				If ($multivalued)
					
					// Make it visible & mark as affected
					$svg.setAttributes(New object:C1471("visibility"; "visible"; "class"; "affected"); DOM Get parent XML element:C923($domField))
					
				End if 
				
				$node:=$svg.findById($t+".label")
				
				If (Asserted:C1132($svg.success))
					
					// Truncate & set tips if necessary
					$width:=Num:C11(xml_attributes($node).width)
					
					If ($width>0)
						
						$width:=$width/10
						
						If (Length:C16($name)>($width))
							
							$svg.setAttribute("tips"; $name; $node)
							$name:=Substring:C12($name; 1; $width)+"…"
							
						End if 
					End if 
					
					DOM SET XML ELEMENT VALUE:C868($node; $name)
					
				End if 
				
				$node:=$svg.findById($t+".cancel")
				
				If ($svg.success)
					
					$svg.visible(True:C214; $node)
					
				End if 
			End if 
		End if 
		
		$indx:=$indx+1
		
	End for each 
	
	If ($multivalued)
		
		// Hide unassigned multivalued fields (except the first)
		ARRAY TEXT:C222($tDom_; 0x0000)
		$tDom_{0}:=DOM Find XML element:C864($container; "g"; $tDom_)
		
		For ($i; 1; Size of array:C274($tDom_); 1)
			
			If (String:C10(xml_attributes($tDom_{$i}).class)="")  // Not affected
				
				If (Not:C34($first))
					
					// We have found the first non affected field
					$first:=True:C214
					
					// Make it visible to allow drag and drop
					$svg.visible(True:C214; $tDom_{$i})
					
				Else 
					
					// Hide the other ones
					$svg.visible(False:C215; $tDom_{$i})
					
				End if 
			End if 
		End for 
	End if 
	
	// Tabs
	$t:=$svg.findById("tabs")
	
	If ($svg.success)
		
		CLEAR VARIABLE:C89($indx)
		
		Repeat 
			
			$node:=$svg.findById("tab-"+String:C10($indx))
			
			If ($svg.success)
				
				$svg.visible(Num:C11($context.tabIndex)=$indx; $node)
				
			End if 
			
			$indx:=$indx+1
			
		Until (OK=0)
	End if 
End if 

$context.previewHeight:=440