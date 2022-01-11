//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : tmpl_On_drag_over
// ID[F8470C01095D4B8AAE2190A7941AABDF]
// Created 6-9-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Accept or not the drop
// ----------------------------------------------------
// Declarations
var $0 : Integer  // -1 = deny; 0 = accept

If (False:C215)
	C_LONGINT:C283(tmpl_On_drag_over; $0)  // -1 = deny; 0 = accept
End if 

var $bind; $cible; $currentForm; $preview; $t : Text
var $highlightsTheTarget; $isBackground; $isDroppable; $isInsertion : Boolean
var $x : Blob
var $dropped : Object
var $tmpl : cs:C1710.tmpl

// ----------------------------------------------------
// Initialisations
$0:=-1  // Deny

$preview:=This:C1470.preview.name  //current preview widget

If (This:C1470.$.vInsert#Null:C1517)
	
	SVG SET ATTRIBUTE:C1055(*; $preview; This:C1470.$.vInsert; \
		"fill-opacity"; "0.01")
	
End if 

This:C1470.$.current:=SVG Find element ID by coordinates:C1054(*; "preview"; MOUSEX; MOUSEY)
$cible:=This:C1470.$.current

// ----------------------------------------------------
If (Length:C16($cible)>0)
	
	GET PASTEBOARD DATA:C401("com.4d.private.4dmobile.field"; $x)
	
	If (Bool:C1537(OK))
		
		BLOB TO VARIABLE:C533($x; $dropped)
		SET BLOB SIZE:C606($x; 0)
		
		// Check the match of the type with the source
		SVG GET ATTRIBUTE:C1056(*; $preview; $cible; "ios:type"; $bind)
		
		$currentForm:=Current form name:C1298  //
		$tmpl:=Form:C1466.$dialog[$currentForm].template
		
		If ($tmpl.isTypeAccepted($bind; $dropped.fieldType))
			
			If (Num:C11(Form:C1466.$dialog.VIEWS.template.manifest.renderer)>=2)
				
				// Accept insertion
				$isInsertion:=($cible="@.vInsert")
				
				If (FEATURE.with("droppingNext"))
					
					$isInsertion:=$isInsertion | ($cible="@.hInsertBefore") | ($cible="@.hInsertAfter")
					
				End if 
				
				If ($isInsertion)
					
					If ($dropped.fromIndex#Null:C1517)  // Internal D&D
						
						// Not on me ;-)
						$isInsertion:=($dropped.fromIndex#(Num:C11(Replace string:C233($cible; "e"; ""))-1))
						
					End if 
				End if 
				
				If (Not:C34($isInsertion))\
					 & (This:C1470.$.template.type="detail")  // Not for list
					
					// Accept dropping on the background
					SVG GET ATTRIBUTE:C1056(*; $preview; $cible; "4D-isOfClass-background"; $t)
					$isBackground:=JSON Parse:C1218($t; Is boolean:K8:9)
					
				End if 
			End if 
			
			$highlightsTheTarget:=$isInsertion
			
			If (Not:C34($isBackground))
				
				// Accept drag if the object is dropable
				SVG GET ATTRIBUTE:C1056(*; $preview; $cible; "4D-isOfClass-droppable"; $t)
				$isDroppable:=JSON Parse:C1218($t; Is boolean:K8:9)
				
				// Reject object fields for search and sections 
				If ($isDroppable)
					
					SVG GET ATTRIBUTE:C1056(*; $preview; $cible; "ios:bind"; $t)
					
					If ($t="sectionField")\
						 | ($t="searchableField")
						
						$isDroppable:=$dropped.fieldType#Is object:K8:27
						
					End if 
				End if 
				
				If ($isDroppable)
					
					$isInsertion:=($dropped.fromIndex#(Num:C11(Replace string:C233($cible; "e"; ""))-1))
					
					If (Not:C34($isInsertion))
						
						// Does not accept drag-and-drop of a 1 to N relation on a static field into a detailed form
						If ($dropped.fieldType=8859)\
							 & (This:C1470.$.template.type="detail")
							
							SVG GET ATTRIBUTE:C1056(*; $preview; $cible; "4D-isOfClass-static"; $t)
							$isDroppable:=Not:C34(JSON Parse:C1218($t; Is boolean:K8:9))
							
						End if 
					End if 
				End if 
			End if 
			
			Case of 
					
					//————————————————————————————————————
				: ($isDroppable\
					 | $isBackground\
					 | $isInsertion)
					
					If ($isDroppable | $isInsertion)
						
						This:C1470.$.vInsert:=$cible
						
						SVG SET ATTRIBUTE:C1055(*; $preview; $cible; \
							"fill-opacity"; Choose:C955($isDroppable; 0.7; 1))
						
					End if 
					
					If ($isBackground\
						 | $isInsertion)
						
						If ($highlightsTheTarget)
							
							SVG SET ATTRIBUTE:C1055(*; $preview; $cible; \
								"fill-opacity"; 1)
							
						Else 
							
							If ($isInsertion)
								
								SVG SET ATTRIBUTE:C1055(*; $preview; $cible; \
									"fill-opacity"; 0.3)
								
							End if 
						End if 
						
						$0:=0
						
					Else 
						
						$0:=0
						
					End if 
					
					//————————————————————————————————————
				: (FEATURE.with("withWidgetActions"))  // Action area (WIP)
					
					// Accept drag if a widget action is drag over
					GET PASTEBOARD DATA:C401("com.4d.private.4dmobile.action"; $x)
					
					If (Bool:C1537(OK))
						
						BLOB TO VARIABLE:C533($x; $dropped)
						SET BLOB SIZE:C606($x; 0)
						
						// #MARK_TODO - Il doit y avoir des widget action qui ne sont pas compatible avec tous les types
						
						If (($dropped.target=Null:C1517) || (String:C10($dropped.target)="widget"))
							
							$0:=0
							
						End if 
					End if 
					
					//————————————————————————————————————
			End case 
			
		Else 
			
			// INCOMPATIBLE TYPE
			
		End if 
		
	Else 
		
		// NOT AUTHORIZED DROP
		
	End if 
	
Else 
	
	// <NOTHING MORE TO DO>
	
End if 

If ($0=-1)
	
	SET CURSOR:C469(9019)
	
End if 

// ----------------------------------------------------
// End