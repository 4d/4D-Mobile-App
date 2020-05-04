Class extends widget

Class constructor
	
	C_VARIANT:C1683($1)
	
	Super:C1705($1)
	
/*===============================================*/
Function forceBoolean
	
	EXECUTE FORMULA:C63("C_BOOLEAN:C305((OBJECT Get pointer:C1124(Object named:K67:5;$o.name))->)")
	
/*===============================================*/
Function getValue
	
	C_LONGINT:C283($0)
	
	$0:=This:C1470.value
	
/*===============================================*/
Function setValue
	
	C_VARIANT:C1683($1)
	
	This:C1470.value:=Bool:C1537($1)
	
/*===============================================*/
Function highlightShortcut
	
	C_OBJECT:C1216($0)
	
	C_LONGINT:C283($index;$lModifier)
	C_TEXT:C284($key;$t)
	
	OBJECT GET SHORTCUT:C1186(*;This:C1470.name;$key;$lModifier)
	
	If (Length:C16($key)>0)
		
		$t:=This:C1470.getTitle()
		
		$index:=Position:C15(Uppercase:C13($key);$t;*)
		
		If ($index=0)
			
			$index:=Position:C15($key;$t)
			
		End if 
		
		If ($index>0)
			
			This:C1470.setTitle(Substring:C12($t;1;$index)+Char:C90(0x0332)+Substring:C12($t;$index+1))
			
		End if 
	End if 
	
	$0:=This:C1470