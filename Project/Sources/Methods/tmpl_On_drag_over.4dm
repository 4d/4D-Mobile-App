//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : tmpl_On_drag_over
// ID[F8470C01095D4B8AAE2190A7941AABDF]
// Created 6-9-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $0 : Integer

var $t : Text
var $background; $droppable; $highlight; $vInsertion : Boolean
var $x : Blob
var $o : Object
var $c : Collection

// ----------------------------------------------------
// Initialisations
$0:=-1

If (This:C1470.$.vInsert#Null:C1517)
	
	SVG SET ATTRIBUTE:C1055(*; This:C1470.preview.name; This:C1470.$.vInsert; \
		"fill-opacity"; "0.01")
	
End if 

This:C1470.$.current:=SVG Find element ID by coordinates:C1054(*; "preview"; MOUSEX; MOUSEY)

GET PASTEBOARD DATA:C401("com.4d.private.ios.field"; $x)

If (Bool:C1537(OK))
	
	BLOB TO VARIABLE:C533($x; $o)
	SET BLOB SIZE:C606($x; 0)
	
End if 

// ----------------------------------------------------
If (Length:C16(This:C1470.$.current)>0)
	
	If (feature.with("newViewUI"))\
		 & (Num:C11(Form:C1466.$dialog.VIEWS.template.manifest.renderer)>=2)
		
		// Accept insertion
		$t:=This:C1470.$.current
		$vInsertion:=($t="@.vInsert")
		
		If (feature.with("droppingNext"))
			
			$vInsertion:=$vInsertion | ($t="@.hInsertBefore") | ($t="@.hInsertAfter")
			
		End if 
		
		If ($vInsertion)
			
			If ($o.fromIndex#Null:C1517)  // Internal D&D
				
				// Not if it's me
				$vInsertion:=($o.fromIndex#(Num:C11(Replace string:C233(This:C1470.$.current; "e"; ""))-1))
				
			End if 
		End if 
		
		If (Not:C34($vInsertion))
			
			// Accept dropping on the background
			SVG GET ATTRIBUTE:C1056(*; This:C1470.preview.name; This:C1470.$.current; "4D-isOfClass-background"; $t)
			$background:=JSON Parse:C1218($t; Is boolean:K8:9)
			
		End if 
	End if 
	
	$highlight:=$vInsertion
	
	If (Not:C34($background))
		
		// Accept drag if the object is dropable
		SVG GET ATTRIBUTE:C1056(*; This:C1470.preview.name; This:C1470.$.current; "4D-isOfClass-droppable"; $t)
		$droppable:=JSON Parse:C1218($t; Is boolean:K8:9)
		
		If ($droppable)
			
			$vInsertion:=($o.fromIndex#(Num:C11(Replace string:C233(This:C1470.$.current; "e"; ""))-1))
			
		End if 
	End if 
	
	Case of 
			
			//————————————————————————————————————
		: ($droppable\
			 | $background\
			 | $vInsertion)
			
			If ($background\
				 | $vInsertion)
				
				If ($vInsertion)
					
					This:C1470.$.vInsert:=This:C1470.$.current
					
					If ($highlight)
						
						SVG SET ATTRIBUTE:C1055(*; This:C1470.preview.name; This:C1470.$.current; \
							"fill-opacity"; 1)
						
					Else 
						
						SVG SET ATTRIBUTE:C1055(*; This:C1470.preview.name; This:C1470.$.current; \
							"fill-opacity"; 0.3)
						
					End if 
				End if 
				
				$0:=0
				
			Else 
				
				If (feature.with("moreRelations"))  // Accept 1-N relation
					
					// Accept drag if the type match with the source
					SVG GET ATTRIBUTE:C1056(*; This:C1470.preview.name; This:C1470.$.current; "ios:type"; $t)
					
					If ($t="all")
						
						//If ($o.fieldType<8858)  // Not relation
						
						$0:=0
						
						//End if
						
					Else 
						
						$c:=Split string:C1554($t; ","; sk trim spaces:K86:2).map("col_formula"; Formula:C1597($1.result:=Num:C11($1.value)))
						
						If (tmpl_compatibleType($c; $o.fieldType))
							
							$0:=0
							
						End if 
					End if 
					
				Else 
					
					If ($o.fieldType#8859)  // Not 1-N relation
						
						// Accept drag if the type match with the source
						SVG GET ATTRIBUTE:C1056(*; This:C1470.preview.name; This:C1470.$.current; "ios:type"; $t)
						
						If ($t="all")
							
							$0:=0
							
						Else 
							
							$c:=Split string:C1554($t; ","; sk trim spaces:K86:2).map("col_formula"; Formula:C1597($1.result:=Num:C11($1.value)))
							
							If (tmpl_compatibleType($c; $o.fieldType))
								
								$0:=0
								
							End if 
						End if 
						
					Else 
						
						// Accept only on multi-valued fields
						SVG GET ATTRIBUTE:C1056(*; This:C1470.preview.name; This:C1470.$.current; "4D-isOfClass-multivalued"; $t)
						
						If (JSON Parse:C1218($t; Is boolean:K8:9))
							
							$0:=0
							
						End if 
					End if 
				End if 
			End if 
			
			If ($0=-1)
				
				SET CURSOR:C469(9019)
				
			End if 
			
			//————————————————————————————————————
		: (feature.with("withWidgetActions"))  // Action area (WIP)
			
			// Accept drag if a widget action is drag over
			GET PASTEBOARD DATA:C401("com.4d.private.ios.action"; $x)
			
			If (Bool:C1537(OK))
				
				BLOB TO VARIABLE:C533($x; $o)
				SET BLOB SIZE:C606($x; 0)
				
				//#MARK_TODO - Il doit y avoir des widget action qui ne sont pas compatible avec tous les types
				
				If (_or(\
					Formula:C1597($o.target=Null:C1517); \
					Formula:C1597(String:C10($o.target)="widget")))
					
					$0:=0
					
				End if 
			End if 
			
			//————————————————————————————————————
		Else 
			
			// A "Case of" statement should never omit "Else"
			//————————————————————————————————————
	End case 
	
Else 
	
	ASSERT:C1129(Not:C34(Shift down:C543))
	
End if 

// ----------------------------------------------------
// End
