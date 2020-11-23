//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : tmpl_TIPS
// ID[0DDE6FCC7CBA406BB7A1D3ED14E73E97]
// Created 6-9-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Show tips based on the overflowed object
// ----------------------------------------------------
// Declarations
C_BOOLEAN:C305($b)
C_LONGINT:C283($Lon_type)
C_TEXT:C284($t; $Txt_bind; $Txt_templateTips; $Txt_tips)
C_OBJECT:C1216($o; $Obj_field; $Obj_target)
C_COLLECTION:C1488($c)

// ----------------------------------------------------

// Tips added for truncated names (cf.views_preview)
SVG GET ATTRIBUTE:C1056(*; This:C1470.preview.name; This:C1470.$.current+".label"; "tips"; $Txt_tips)

If (Length:C16($Txt_tips)#0)
	
	//$Txt_tips:="\""+$Txt_tips+"\""
	
Else 
	
	SVG GET ATTRIBUTE:C1056(*; This:C1470.preview.name; This:C1470.$.current; "ios:bind"; $Txt_bind)
	
	
	$Obj_target:=Form:C1466[This:C1470.$.typeForm()][This:C1470.$.tableNumber]
	
	$o:=Rgx_match(New object:C1471(\
		"pattern"; "(?mi-s)(\\w+)\\[(\\d+)]"; \
		"target"; $Txt_bind))
	
	If ($o.success)  // List of fields
		
		$b:=(Num:C11($o.match[2].data)>=$Obj_target[$o.match[1].data].length)
		
		If (Not:C34($b))
			
			$b:=($Obj_target[$o.match[1].data][Num:C11($o.match[2].data)]=Null:C1517)
			
		End if 
		
	Else   // Single value field (Not aaaaa[000]) ie 'searchableField' or 'sectionField'
		
		$b:=($Obj_target[$Txt_bind]=Null:C1517)
		
	End if 
	
	If ($b)
		
		// Get a tips value into the template
		SVG GET ATTRIBUTE:C1056(*; This:C1470.preview.name; This:C1470.$.current+".label"; "ios:tips"; $Txt_templateTips)
		
		// Tips adds according to template informations
		SVG GET ATTRIBUTE:C1056(*; This:C1470.preview.name; This:C1470.$.current; "ios:type"; $t)
		
		If ($t="all")
			
			$Txt_tips:=Get localized string:C991("dropHereAFieldOfAnyType")
			
		Else 
			
			// Get the accepted types
			$c:=Split string:C1554($t; ","; sk trim spaces:K86:2).map("col_formula"; Formula:C1597($1.result:=Num:C11($1.value)))
			
			If ($c.every("col_formula"; Formula:C1597($1.result:=($1.value>=0))))
				
				If ($c.indexOf(Is integer:K8:5)#-1)\
					 & ($c.indexOf(Is longint:K8:6)#-1)\
					 & ($c.indexOf(Is integer 64 bits:K8:25)#-1)\
					 & ($c.indexOf(Is real:K8:4)#-1)\
					 & ($c.indexOf(_o_Is float:K8:26)#-1)
					
					If (Length:C16($Txt_tips)=0)
						
						$Txt_tips:=cs:C1710.str.new(Choose:C955(Length:C16($Txt_templateTips)=0; "dropHereAFieldThatMustBe_"; "theFieldTypeMustBe_")).localized("number")
						
					Else 
						
						// Concat
						$Txt_tips:=$Txt_tips+Get localized string:C991("_or_")+Get localized string:C991("number")
						
					End if 
					
					$c.remove($c.indexOf(Is integer:K8:5))
					$c.remove($c.indexOf(Is longint:K8:6))
					$c.remove($c.indexOf(Is integer 64 bits:K8:25))
					$c.remove($c.indexOf(Is real:K8:4))
					$c.remove($c.indexOf(_o_Is float:K8:26))
					
				End if 
				
				If ($c.indexOf(Is alpha field:K8:1)#-1)\
					 & ($c.indexOf(Is text:K8:3)#-1)
					
					If (Length:C16($Txt_tips)=0)
						
						$Txt_tips:=cs:C1710.str.new(Choose:C955(Length:C16($Txt_templateTips)=0; "dropHereAFieldThatMustBe_"; "theFieldTypeMustBe_")).localized("text")
						
					Else 
						
						// Concat
						$Txt_tips:=$Txt_tips+Get localized string:C991("_or_")+Get localized string:C991("text")
						
					End if 
					
					$c.remove($c.indexOf(Is alpha field:K8:1))
					$c.remove($c.indexOf(Is text:K8:3))
					
				End if 
				
				// One of them
				For each ($Lon_type; $c)
					
					If (Length:C16($Txt_tips)=0)
						
						$Txt_tips:=cs:C1710.str.new(Choose:C955(Length:C16($Txt_templateTips)=0; "dropHereAFieldThatMustBe_"; "theFieldTypeMustBe_")).localized(UI.typeNames[$Lon_type])
						
					Else 
						
						// Concat
						$Txt_tips:=$Txt_tips+Get localized string:C991("_or_")+UI.typeNames[$Lon_type]
						
					End if 
				End for each 
				
			Else 
				
				// None of them
				For each ($Lon_type; $c)
					
					$Lon_type:=Abs:C99($Lon_type)
					
					If (Length:C16($Txt_tips)=0)
						
						$Txt_tips:=cs:C1710.str.new(Choose:C955(Length:C16($Txt_templateTips)=0; "dropHereAFieldWhoseTypeMustNotBe_"; "theFieldTypeMustNotBe_")).localized(UI.typeNames[$Lon_type])
						
					Else 
						
						// Concat
						$Txt_tips:=$Txt_tips+Get localized string:C991("_or_")+UI.typeNames[$Lon_type]
						
					End if 
				End for each 
			End if 
		End if 
		
		If (Length:C16($Txt_templateTips)>0)
			
			$Txt_tips:=$Txt_templateTips+"\r"+$Txt_tips
			
		End if 
		
	Else 
		
		SVG GET ATTRIBUTE:C1056(*; This:C1470.preview.name; This:C1470.$.current; "4D-isOfClass-multi-criteria"; $t)
		
		If (JSON Parse:C1218($t; Is boolean:K8:9))  // Search on several fields - append to the field list if any
			
			If (Value type:C1509($Obj_target[$Txt_bind])=Is collection:K8:32)
				
				For each ($Obj_field; $Obj_target[$Txt_bind])
					
					If ($Obj_field#Null:C1517)
						
						If (Length:C16($Txt_tips)=0)
							
							$Txt_tips:="\""+$Obj_field.name+"\""
							
						Else 
							
							// Add operator
							$Txt_tips:=$Txt_tips+Get localized string:C991("_or_")+"\""+$Obj_field.name+"\""
							
						End if 
					End if 
				End for each 
			End if 
		End if 
	End if 
	
	If ($b)
		
		If (Length:C16($Txt_tips)>0)
			
			SVG GET ATTRIBUTE:C1056(*; This:C1470.preview.name; This:C1470.$.current; "class"; $t)
			
			If (Position:C15("optional"; $t; *)>0)
				
				$Txt_tips:=$Txt_tips+"\r • "+Get localized string:C991("thisFieldIsOptional")
				
			End if 
			
			If (Position:C15("multi-criteria"; $t; *)>0)
				
				$Txt_tips:=$Txt_tips+"\r • "+Get localized string:C991("thisFieldAcceptsSeveralValues")
				
			End if 
		End if 
		
	Else 
		
		
		
	End if 
End if 

If (Length:C16($Txt_tips)=0)
	
	// Get the fields definition
	SVG GET ATTRIBUTE:C1056(*; This:C1470.preview.name; This:C1470.$.current; "ios:data"; $t)
	
	If (Length:C16($t)>0)
		
		$o:=JSON Parse:C1218($t)
		
		Case of 
				
				//______________________________________________________
			: (Num:C11($o.fieldType)=8859)  // 1-N relation
				
				If (Form:C1466.dataModel[String:C10($o.relatedTableNumber)]=Null:C1517)
					
					$Txt_tips:=UI.alert+cs:C1710.str.new("theLinkedTableIsNotPublished").localized($o.relatedEntities)
					
				Else 
					
					$Txt_tips:=cs:C1710.str.new("thisFieldWillAllowYouToNavigateToListOf").localized($o.relatedEntities)
					
				End if 
				
				//______________________________________________________
			Else 
				
				//$Txt_tips:=$o.label
				
				//______________________________________________________
		End case 
	End if 
End if 

OBJECT SET HELP TIP:C1181(*; This:C1470.preview.name; $Txt_tips)

// ----------------------------------------------------
// End