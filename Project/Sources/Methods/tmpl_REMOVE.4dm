//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : tmpl_REMOVE
// ID[77787A83B9A048FCBA802902156129C9]
// Created 25-4-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Modified 4-9-2018 by Vincent de Lachaux
// #98105 - Multi-criteria Search
// ----------------------------------------------------
// Declarations
var $binding; $targetField; $testClass : Text
var $indx : Integer
var $target : Object
var $c : Collection
var $field : cs:C1710.field
var $menu : cs:C1710.menu

ARRAY TEXT:C222($tTxt_results; 0)

// ----------------------------------------------------
// Initialisations
$targetField:=Replace string:C233(This:C1470.$.current; ".cancel"; "")
SVG GET ATTRIBUTE:C1056(*; This:C1470.preview.name; $targetField; "ios:bind"; $binding)

$target:=Form:C1466[This:C1470.$.typeForm()][This:C1470.$.tableNumber]

// ----------------------------------------------------
SVG GET ATTRIBUTE:C1056(*; This:C1470.preview.name; $targetField; "4D-isOfClass-multi-criteria"; $testClass)

If ($testClass="true")\
 & (Value type:C1509($target[$binding])=Is collection:K8:32)
	
	$menu:=cs:C1710.menu.new()
	
	For each ($field; $target[$binding])
		
		If ($field=Null:C1517)
			
			continue
			
		End if 
		
		$menu.append(UI.str.localize("removeField"; $field.name); $field.name)
		
	End for each 
	
	$menu.line()
	$menu.append("removeAllFields"; "all")
	
	$menu.popup()
	
	If ($menu.selected)
		
		If ($menu.choice="all")
			
			$target[$binding]:=Null:C1517
			
		Else 
			
			// Delete one
			$c:=$target[$binding].indices("name = :1"; $menu.choice)
			
			If ($c.length>0)
				
				$target[$binding].remove($c[0])
				
				If ($target[$binding].length=1)
					
					// Convert to object
					$target[$binding]:=$target[$binding][0]
					
				End if 
				
			Else 
				
				oops
				
			End if 
		End if 
	End if 
	
Else 
	
	If (Asserted:C1132(Length:C16($binding)>0))
		
		Rgx_MatchText("(?m-si)^([^\\[]+)\\[(\\d+)]\\s*$"; $binding; ->$tTxt_results)
		
		If (Size of array:C274($tTxt_results)=2)
			
			If ($target[$tTxt_results{1}]#Null:C1517)
				
				$indx:=Num:C11($tTxt_results{2})
				
				If ($target[$tTxt_results{1}].length>$indx)
					
					SVG GET ATTRIBUTE:C1056(*; This:C1470.preview.name; $targetField; "4D-isOfClass-multivalued"; $testClass)
					
					If ($testClass="true")
						
						$target[$tTxt_results{1}].remove($indx)
						
					Else 
						
						// Empty
						$target[$tTxt_results{1}][$indx]:=Null:C1517
						
					End if 
				End if 
			End if 
			
		Else 
			
			$target[$binding]:=Null:C1517
			
		End if 
	End if 
End if 

PROJECT.save()

// Update preview
tmpl_DRAW(This:C1470)