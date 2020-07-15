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
C_LONGINT:C283($0)

C_BLOB:C604($x)
C_BOOLEAN:C305($b_background; $b_droppable; $b_vInsertion; $bHighlight)
C_TEXT:C284($t)
C_OBJECT:C1216($o)
C_COLLECTION:C1488($c)

If (False:C215)
	C_LONGINT:C283(tmpl_On_drag_over; $0)
End if 

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
		$b_vInsertion:=($t="@.vInsert")
		
		If (feature.with("droppingNext"))
			
			$b_vInsertion:=$b_vInsertion | ($t="@.hInsertBefore") | ($t="@.hInsertAfter")
			
		End if 
		
		If ($b_vInsertion)
			
			If ($o.fromIndex#Null:C1517)  // Internal D&D
				
				// Not if it's me
				$b_vInsertion:=($o.fromIndex#(Num:C11(Replace string:C233(This:C1470.$.current; "e"; ""))-1))
				
			End if 
		End if 
		
		If (Not:C34($b_vInsertion))
			
			// Accept dropping on the background
			SVG GET ATTRIBUTE:C1056(*; This:C1470.preview.name; This:C1470.$.current; "4D-isOfClass-background"; $t)
			$b_background:=($t="true")
			
		End if 
	End if 
	
	$bHighlight:=$b_vInsertion
	
	If (Not:C34($b_background))
		
		// Accept drag if the object is dropable
		SVG GET ATTRIBUTE:C1056(*; This:C1470.preview.name; This:C1470.$.current; "4D-isOfClass-droppable"; $t)
		$b_droppable:=($t="true")
		
		If ($b_droppable)
			
			$b_vInsertion:=($o.fromIndex#(Num:C11(Replace string:C233(This:C1470.$.current; "e"; ""))-1))
			
		End if 
	End if 
	
	Case of 
			
			//————————————————————————————————————
		: ($b_droppable\
			 | $b_background\
			 | $b_vInsertion)
			
			If ($b_background\
				 | $b_vInsertion)
				
				If ($b_vInsertion)
					
					This:C1470.$.vInsert:=This:C1470.$.current
					
					If ($bHighlight)
						
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
						
						$0:=0
						
					Else 
						
						//$c:=Split string($t; ","; sk trim spaces).map("col_formula"; "$1.result:=Num:C11($1.value)")
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
							
							//$c:=Split string($t; ","; sk trim spaces).map("col_formula"; "$1.result:=Num:C11($1.value)")
							$c:=Split string:C1554($t; ","; sk trim spaces:K86:2).map("col_formula"; Formula:C1597($1.result:=Num:C11($1.value)))
							
							If (tmpl_compatibleType($c; $o.fieldType))
								
								$0:=0
								
							End if 
						End if 
						
					Else 
						
						// Accept only on multi-valued fields
						SVG GET ATTRIBUTE:C1056(*; This:C1470.preview.name; This:C1470.$.current; "4D-isOfClass-multivalued"; $t)
						
						If ($t="true")
							
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