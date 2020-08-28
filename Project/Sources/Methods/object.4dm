//%attributes = {}
var $0 : Object
var $1 : Variant

If (False:C215)
	C_OBJECT:C1216(object; $0)
	C_VARIANT:C1683(object; $1)
End if 

var $t : Text
var $l : Integer
var $c : Collection

$t:="group"

Case of 
		
		//______________________________________________________
	: ($l=Is collection:K8:32)
		
		$t:="group"
		
		//______________________________________________________
	: ($l=Is text:K8:3)
		
		$c:=Split string:C1554($1; ",")
		
		If ($c.length>1)
			
			$t:="group"
			
		Else 
			
			$l:=OBJECT Get type:C1300(*; $1)
			
			Case of 
					
					//__________________________
				: ($l=Object type static text:K79:2)\
					 | ($l=Object type static picture:K79:3)\
					 | ($l=Object type rectangle:K79:32)\
					 | ($l=Object type rounded rectangle:K79:34)\
					 | ($l=Object type line:K79:33)\
					 | ($l=Object type oval:K79:35)
					
					$t:="static"
					
					//__________________________
				: ($l=Object type push button:K79:16)\
					 | ($l=Object type checkbox:K79:26)\
					 | ($l=Object type 3D button:K79:17)\
					 | ($l=Object type 3D checkbox:K79:27)\
					 | ($l=Object type 3D radio button:K79:24)\
					 | ($l=Object type radio button field:K79:6)
					
					$t:="button"
					
					//__________________________
				: ($l=Object type unknown:K79:1)
					
					ASSERT:C1129(False:C215; "Unknown type for $1: "+String:C10($l))
					
					//__________________________
				Else 
					
					$t:="widget"
					
					//__________________________
			End case 
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Type of $1 should be Collection or Text!")
		
		//______________________________________________________
End case 

$0:=cs:C1710[$t].new($1)