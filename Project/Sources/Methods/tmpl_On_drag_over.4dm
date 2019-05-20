//%attributes = {"invisible":true}
/*
Long Integer := ***tmpl_On_drag_over***
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : tmpl_On_drag_over
  // Database: 4D Mobile App
  // ID[F8470C01095D4B8AAE2190A7941AABDF]
  // Created #6-9-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($0)

C_BLOB:C604($x)
C_TEXT:C284($t;$Txt_isOfClass)
C_OBJECT:C1216($o)
C_COLLECTION:C1488($c)

If (False:C215)
	C_LONGINT:C283(tmpl_On_drag_over ;$0)
End if 

  // ----------------------------------------------------
  // Initialisations
$0:=-1

  // ----------------------------------------------------
If (Length:C16(This:C1470.$.current)>0)
	
	  // Accept drag if the object is dropable
	SVG GET ATTRIBUTE:C1056(*;This:C1470.preview.name;This:C1470.$.current;"4D-isOfClass-droppable";$Txt_isOfClass)
	
	If (_bool ($Txt_isOfClass))  // Template
		
		  // Accept drag if a field is drag over
		GET PASTEBOARD DATA:C401("com.4d.private.ios.field";$x)
		
		If (Bool:C1537(OK))
			
			BLOB TO VARIABLE:C533($x;$o)
			SET BLOB SIZE:C606($x;0)
			
			  // Accept drag if the type match with the source
			SVG GET ATTRIBUTE:C1056(*;This:C1470.preview.name;This:C1470.$.current;"ios:type";$t)
			
			$c:=Split string:C1554($t;",";sk trim spaces:K86:2).map("col_formula";"$1.result:=Num:C11($1.value)")
			
			If (Bool:C1537(featuresFlags.withNewFieldProperties))
				
				If (_or (\
					New formula:C1597($t="all");\
					New formula:C1597(tmpl_compatibleType ($c;$o.fieldType))))
					
					$0:=0
					
				End if 
				
			Else 
				
				  //#MARK_TO_OPTIMIZE
				If (_or (\
					New formula:C1597($t="all");\
					New formula:C1597(tmpl_compatibleType ($c;structure (New object:C1471(\
					"action";"tmplType";\
					"value";Num:C11($o.type))).value))))
					
					$0:=0
					
				End if 
			End if 
			
		Else   // Action area
			
			If (Bool:C1537(featuresFlags.withWidgetActions))
				
				  // Accept drag if a widget action is drag over
				GET PASTEBOARD DATA:C401("com.4d.private.ios.action";$x)
				
				If (Bool:C1537(OK))
					
					BLOB TO VARIABLE:C533($x;$o)
					SET BLOB SIZE:C606($x;0)
					
					  //#MARK_TODO - Il doit y avoir des widget action qui ne sont pas compatible avec tous les types
					
					If (_or (\
						New formula:C1597($o.target=Null:C1517);\
						New formula:C1597(String:C10($o.target)="widget")))
						
						$0:=0
						
					End if 
				End if 
			End if 
		End if 
	End if 
End if 

  // ----------------------------------------------------
  // End