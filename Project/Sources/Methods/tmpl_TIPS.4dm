//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : tmpl_TIPS
  // Database: 4D Mobile App
  // ID[0DDE6FCC7CBA406BB7A1D3ED14E73E97]
  // Created 6-9-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Show tips based on the overflowed object
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($Boo_buildTips)
C_LONGINT:C283($Lon_type)
C_TEXT:C284($Txt_bind;$Txt_buffer;$Txt_templateTips;$Txt_tips)
C_OBJECT:C1216($Obj_field;$Obj_rgx;$Obj_target)
C_COLLECTION:C1488($Col_types)

  // ----------------------------------------------------

  // Tips added for truncated names (cf.views_preview)
SVG GET ATTRIBUTE:C1056(*;This:C1470.preview.name;This:C1470.$.current+".label";"tips";$Txt_tips)

If (Length:C16($Txt_tips)#0)
	
	$Txt_tips:="\""+$Txt_tips+"\""
	
Else 
	
	SVG GET ATTRIBUTE:C1056(*;This:C1470.preview.name;This:C1470.$.current;"ios:bind";$Txt_bind)
	
	$Obj_target:=Form:C1466[This:C1470.$.typeForm()][This:C1470.$.tableNumber]
	
	$Obj_rgx:=Rgx_match (New object:C1471(\
		"pattern";"(?mi-s)(\\w+)\\[(\\d+)]";\
		"target";$Txt_bind))
	
	If ($Obj_rgx.success)  // List of fields
		
		$Boo_buildTips:=(Num:C11($Obj_rgx.match[2].data)>=$Obj_target[$Obj_rgx.match[1].data].length)
		
		If (Not:C34($Boo_buildTips))
			
			$Boo_buildTips:=($Obj_target[$Obj_rgx.match[1].data][Num:C11($Obj_rgx.match[2].data)]=Null:C1517)
			
		End if 
		
	Else   // Single value field (Not aaaaa[000]) ie 'searchableField' or 'sectionField'
		
		$Boo_buildTips:=($Obj_target[$Txt_bind]=Null:C1517)
		
	End if 
	
	If ($Boo_buildTips)
		
		  // Get a tips value into the template
		SVG GET ATTRIBUTE:C1056(*;This:C1470.preview.name;This:C1470.$.current+".label";"ios:tips";$Txt_templateTips)
		
		  // Tips adds according to template informations
		SVG GET ATTRIBUTE:C1056(*;This:C1470.preview.name;This:C1470.$.current;"ios:type";$Txt_buffer)
		
		If ($Txt_buffer="all")
			
			$Txt_tips:=Get localized string:C991("dropHereAFieldOfAnyType")
			
		Else 
			
			$Col_types:=Split string:C1554($Txt_buffer;",";sk trim spaces:K86:2).map("col_formula";"$1.result:=Num:C11($1.value)")
			
			If ($Col_types.every("col_formula";"$1.result:=($1.value>=0)"))
				
				If ($Col_types.indexOf(Is integer:K8:5)#-1)\
					 & ($Col_types.indexOf(Is longint:K8:6)#-1)\
					 & ($Col_types.indexOf(Is integer 64 bits:K8:25)#-1)\
					 & ($Col_types.indexOf(Is real:K8:4)#-1)\
					 & ($Col_types.indexOf(Is float:K8:26)#-1)
					
					If (Length:C16($Txt_tips)=0)
						
						$Txt_tips:=Get localized string:C991(Choose:C955(Length:C16($Txt_templateTips)=0;"dropHereAFieldThatMustBe_";"theFieldTypeMustBe_"))+Get localized string:C991("number")
						
					Else 
						
						  // Concat
						$Txt_tips:=$Txt_tips+Get localized string:C991("_or_")+Get localized string:C991("number")
						
					End if 
					
					$Col_types.remove($Col_types.indexOf(Is integer:K8:5))
					$Col_types.remove($Col_types.indexOf(Is longint:K8:6))
					$Col_types.remove($Col_types.indexOf(Is integer 64 bits:K8:25))
					$Col_types.remove($Col_types.indexOf(Is real:K8:4))
					$Col_types.remove($Col_types.indexOf(Is float:K8:26))
					
				End if 
				
				If ($Col_types.indexOf(Is alpha field:K8:1)#-1)\
					 & ($Col_types.indexOf(Is text:K8:3)#-1)
					
					If (Length:C16($Txt_tips)=0)
						
						$Txt_tips:=Get localized string:C991(Choose:C955(Length:C16($Txt_templateTips)=0;"dropHereAFieldThatMustBe_";"theFieldTypeMustBe_"))+Get localized string:C991("text")
						
					Else 
						
						  // Concat
						$Txt_tips:=$Txt_tips+Get localized string:C991("_or_")+Get localized string:C991("text")
						
					End if 
					
					$Col_types.remove($Col_types.indexOf(Is alpha field:K8:1))
					$Col_types.remove($Col_types.indexOf(Is text:K8:3))
					
				End if 
				
				  // One of them
				For each ($Lon_type;$Col_types)
					
					If (Length:C16($Txt_tips)=0)
						
						$Txt_tips:=Get localized string:C991(Choose:C955(Length:C16($Txt_templateTips)=0;"dropHereAFieldThatMustBe_";"theFieldTypeMustBe_"))+ui.typeNames[$Lon_type]
						
					Else 
						
						  // Concat
						$Txt_tips:=$Txt_tips+Get localized string:C991("_or_")+ui.typeNames[$Lon_type]
						
					End if 
				End for each 
				
			Else 
				
				  // None of them
				For each ($Lon_type;$Col_types)
					
					$Lon_type:=Abs:C99($Lon_type)
					
					If (Length:C16($Txt_tips)=0)
						
						$Txt_tips:=Get localized string:C991(Choose:C955(Length:C16($Txt_templateTips)=0;"dropHereAFieldWhoseTypeMustNotBe_";"theFieldTypeMustNotBe_"))+ui.typeNames[$Lon_type]
						
					Else 
						
						  // Concat
						$Txt_tips:=$Txt_tips+Get localized string:C991("_or_")+ui.typeNames[$Lon_type]
						
					End if 
				End for each 
			End if 
		End if 
		
		If (Length:C16($Txt_templateTips)>0)
			
			$Txt_tips:=$Txt_templateTips+"\r"+$Txt_tips
			
		End if 
		
	Else 
		
		SVG GET ATTRIBUTE:C1056(*;This:C1470.preview.name;This:C1470.$.current;"4D-isOfClass-multi-criteria";$Txt_buffer)
		
		If ($Txt_buffer="true")  // Search on several fields - append to the field list if any
			
			If (Value type:C1509($Obj_target[$Txt_bind])=Is collection:K8:32)
				
				For each ($Obj_field;$Obj_target[$Txt_bind])
					
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
	
	If ($Boo_buildTips)
		
		If (Length:C16($Txt_tips)>0)
			
			SVG GET ATTRIBUTE:C1056(*;This:C1470.preview.name;This:C1470.$.current;"class";$Txt_buffer)
			
			If (Position:C15("optional";$Txt_buffer;*)>0)
				
				$Txt_tips:=$Txt_tips+"\r • "+Get localized string:C991("thisFieldIsOptional")
				
			End if 
			
			If (Position:C15("multi-criteria";$Txt_buffer;*)>0)
				
				$Txt_tips:=$Txt_tips+"\r • "+Get localized string:C991("thisFieldAcceptsSeveralValues")
				
			End if 
		End if 
	End if 
End if 

OBJECT SET HELP TIP:C1181(*;This:C1470.preview.name;$Txt_tips)

  // ----------------------------------------------------
  // End