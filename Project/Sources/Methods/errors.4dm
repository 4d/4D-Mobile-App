//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : errors
  // ID[113B9039655C4E06B194A25A54380846]
  // Created 7-10-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_TEXT:C284($t)
C_OBJECT:C1216($o)

If (False:C215)
	C_OBJECT:C1216(errors ;$0)
	C_TEXT:C284(errors ;$1)
	C_OBJECT:C1216(errors ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470._is=Null:C1517)  // Constructor
	
	$o:=New object:C1471(\
		"_is";"errors";\
		"stack";New collection:C1472;\
		"current";"";\
		"install";Formula:C1597(errors ("install";New object:C1471("method";String:C10($1))));\
		"deinstall";Formula:C1597(errors ("deinstall"));\
		"stopCatch";Formula:C1597(errors ("stopCatch"))\
		)
	
	If (Count parameters:C259>=1)
		
		$o.install($1)
		
	End if 
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="install")  // Installs an error-handling method
			
			  // Record the current method called on error
			$o.stack.unshift(Method called on error:C704)
			
			$t:=String:C10($2.method)
			
			If ($t#$o.current)
				
				  // Install the method
				ON ERR CALL:C155($t)
				
			End if 
			
			$o.current:=$t
			
			  //______________________________________________________
		: ($1="deinstall")  // Deinstalls the last error-handling method and restore the previous one
			
			If ($o.stack.length>0)
				
				  // Get the previous method if any
				$t:=String:C10($o.stack.shift())
				$o.current:=$t
				
				ON ERR CALL:C155($t)
				
			End if 
			
			  //______________________________________________________
		: ($1="stopCatch")  // Stop the trapping of errors
			
			$o.stack:=New collection:C1472
			$o.current:=""
			
			ON ERR CALL:C155("")
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
			
			  //______________________________________________________
	End case 
End if 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End