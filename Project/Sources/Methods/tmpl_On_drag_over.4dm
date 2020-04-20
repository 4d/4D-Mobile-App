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
C_BOOLEAN:C305($bBackground;$bDroppable;$bInsert)
C_TEXT:C284($t)
C_OBJECT:C1216($o)
C_COLLECTION:C1488($c)

If (False:C215)
	C_LONGINT:C283(tmpl_On_drag_over ;$0)
End if 

  // ----------------------------------------------------
  // Initialisations
$0:=-1

If (This:C1470.$.vInsert#Null:C1517)
	
	SVG SET ATTRIBUTE:C1055(*;This:C1470.preview.name;This:C1470.$.vInsert;\
		"fill-opacity";"0.01")
	
End if 

This:C1470.$.current:=SVG Find element ID by coordinates:C1054(*;"preview";MOUSEX;MOUSEY)

ASSERT:C1129(Not:C34(Shift down:C543))

  // ----------------------------------------------------
If (Length:C16(This:C1470.$.current)>0)
	
	If (feature.with("newViewUI"))\
		 & (Num:C11(Form:C1466.$dialog.VIEWS.template.manifest.version)>=2)
		
		  // Accept insertion
		$bInsert:=(This:C1470.$.current="@.insert")
		
		  // Accept dropping on the background
		SVG GET ATTRIBUTE:C1056(*;This:C1470.preview.name;This:C1470.$.current;"4D-isOfClass-background";$t)
		$bBackground:=($t="true")
		
	End if 
	
	If (Not:C34($bBackground))
		
		  // Accept drag if the object is dropable
		SVG GET ATTRIBUTE:C1056(*;This:C1470.preview.name;This:C1470.$.current;"4D-isOfClass-droppable";$t)
		$bDroppable:=($t="true")
		
	End if 
	
	Case of 
			
			  //————————————————————————————————————
		: ($bDroppable\
			 | $bBackground\
			 | $bInsert)
			
			  // Accept drag if a field is drag over
			GET PASTEBOARD DATA:C401("com.4d.private.ios.field";$x)
			
			If (Bool:C1537(OK))
				
				BLOB TO VARIABLE:C533($x;$o)
				SET BLOB SIZE:C606($x;0)
				
				If ($bBackground\
					 | $bInsert)
					
					If ($bInsert)
						
						This:C1470.$.vInsert:=This:C1470.$.current
						SVG SET ATTRIBUTE:C1055(*;This:C1470.preview.name;This:C1470.$.current;\
							"fill-opacity";"1")
						
					End if 
					
					$0:=0
					
				Else 
					
					If ($o.fieldType#8859)  // Not 1-N relation
						
						  // Accept drag if the type match with the source
						SVG GET ATTRIBUTE:C1056(*;This:C1470.preview.name;This:C1470.$.current;"ios:type";$t)
						
						If ($t="all")
							
							$0:=0
							
						Else 
							
							$c:=Split string:C1554($t;",";sk trim spaces:K86:2).map("col_formula";"$1.result:=Num:C11($1.value)")
							
							If (tmpl_compatibleType ($c;$o.fieldType))
								
								$0:=0
								
							End if 
						End if 
						
					Else 
						
						  // Accept only on multi-valued fields
						SVG GET ATTRIBUTE:C1056(*;This:C1470.preview.name;This:C1470.$.current;"4D-isOfClass-multivalued";$t)
						
						If ($t="true")
							
							$0:=0
							
						End if 
					End if 
				End if 
			End if 
			
			  //————————————————————————————————————
		: (feature.with("withWidgetActions"))  // Action area (WIP)
			
			  // Accept drag if a widget action is drag over
			GET PASTEBOARD DATA:C401("com.4d.private.ios.action";$x)
			
			If (Bool:C1537(OK))
				
				BLOB TO VARIABLE:C533($x;$o)
				SET BLOB SIZE:C606($x;0)
				
				  //#MARK_TODO - Il doit y avoir des widget action qui ne sont pas compatible avec tous les types
				
				If (_or (\
					Formula:C1597($o.target=Null:C1517);\
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