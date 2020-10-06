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

var $cible; $ObjectName; $t : Text
var $background; $droppable; $highlight; $vInsertion : Boolean
var $x : Blob
var $dropped : Object
var $types : Collection

// ----------------------------------------------------
// Initialisations
$0:=-1  // Deny

$ObjectName:=This:C1470.preview.name

If (This:C1470.$.vInsert#Null:C1517)
	
	SVG SET ATTRIBUTE:C1055(*; $ObjectName; This:C1470.$.vInsert; \
		"fill-opacity"; "0.01")
	
End if 

This:C1470.$.current:=SVG Find element ID by coordinates:C1054(*; "preview"; MOUSEX; MOUSEY)

GET PASTEBOARD DATA:C401("com.4d.private.ios.field"; $x)

If (Bool:C1537(OK))
	
	BLOB TO VARIABLE:C533($x; $dropped)
	SET BLOB SIZE:C606($x; 0)
	
End if 

// ----------------------------------------------------
If (Length:C16(This:C1470.$.current)>0)
	
	$cible:=This:C1470.$.current
	
	If (FEATURE.with("newViewUI"))\
		 & (Num:C11(Form:C1466.$dialog.VIEWS.template.manifest.renderer)>=2)
		
		// Accept insertion
		$vInsertion:=($cible="@.vInsert")
		
		If (FEATURE.with("droppingNext"))
			
			$vInsertion:=$vInsertion | ($cible="@.hInsertBefore") | ($cible="@.hInsertAfter")
			
		End if 
		
		If ($vInsertion)
			
			If ($dropped.fromIndex#Null:C1517)  // Internal D&D
				
				// Not on me ;-)
				$vInsertion:=($dropped.fromIndex#(Num:C11(Replace string:C233($cible; "e"; ""))-1))
				
			End if 
		End if 
		
		If (Not:C34($vInsertion))\
			 & (This:C1470.$.template.type="detail")  // Not for list
			
			// Accept dropping on the background
			SVG GET ATTRIBUTE:C1056(*; $ObjectName; $cible; "4D-isOfClass-background"; $t)
			$background:=JSON Parse:C1218($t; Is boolean:K8:9)
			
		End if 
	End if 
	
	$highlight:=$vInsertion
	
	If (Not:C34($background))
		
		// Accept drag if the object is dropable
		SVG GET ATTRIBUTE:C1056(*; $ObjectName; $cible; "4D-isOfClass-droppable"; $t)
		$droppable:=JSON Parse:C1218($t; Is boolean:K8:9)
		
		If ($droppable)
			
			$vInsertion:=($dropped.fromIndex#(Num:C11(Replace string:C233($cible; "e"; ""))-1))
			
			If (Not:C34($vInsertion))
				
				// But does not accept drag-and-drop of a 1 to N relation on a static field into a detailed form
				
				
				
			End if 
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
					
					This:C1470.$.vInsert:=$cible
					
					If ($highlight)
						
						SVG SET ATTRIBUTE:C1055(*; $ObjectName; $cible; \
							"fill-opacity"; 1)
						
					Else 
						
						SVG SET ATTRIBUTE:C1055(*; $ObjectName; $cible; \
							"fill-opacity"; 0.3)
						
					End if 
				End if 
				
				$0:=0
				
			Else 
				
				If (FEATURE.with("moreRelations"))  // Accept 1-N relation
					
					// Accept drag if the type match with the source
					SVG GET ATTRIBUTE:C1056(*; $ObjectName; $cible; "ios:type"; $t)
					
					If ($t="all")
						
						//If ($o.fieldType<8858)  // Not relation
						$0:=0
						
						// End if
						
					Else 
						
						$types:=Split string:C1554($t; ","; sk trim spaces:K86:2).map("col_formula"; Formula:C1597($1.result:=Num:C11($1.value)))
						
						If (tmpl_compatibleType($types; $dropped.fieldType))
							
							$0:=0
							
						End if 
					End if 
					
				Else 
					
					If ($dropped.fieldType#8859)  // Not 1-N relation
						
						// Accept drag if the type match with the source
						SVG GET ATTRIBUTE:C1056(*; $ObjectName; $cible; "ios:type"; $t)
						
						If ($t="all")
							
							$0:=0
							
						Else 
							
							$types:=Split string:C1554($t; ","; sk trim spaces:K86:2).map("col_formula"; Formula:C1597($1.result:=Num:C11($1.value)))
							
							If (tmpl_compatibleType($types; $dropped.fieldType))
								
								$0:=0
								
							End if 
						End if 
						
					Else 
						
						// Accept only on multi-valued fields
						SVG GET ATTRIBUTE:C1056(*; $ObjectName; $cible; "4D-isOfClass-multivalued"; $t)
						
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
		: (FEATURE.with("withWidgetActions"))  // Action area (WIP)
			
			// Accept drag if a widget action is drag over
			GET PASTEBOARD DATA:C401("com.4d.private.ios.action"; $x)
			
			If (Bool:C1537(OK))
				
				BLOB TO VARIABLE:C533($x; $dropped)
				SET BLOB SIZE:C606($x; 0)
				
				// #MARK_TODO - Il doit y avoir des widget action qui ne sont pas compatible avec tous les types
				
				If (_or(\
					Formula:C1597($dropped.target=Null:C1517); \
					Formula:C1597(String:C10($dropped.target)="widget")))
					
					$0:=0
					
				End if 
			End if 
			
			//————————————————————————————————————
	End case 
End if 

// ----------------------------------------------------
// End