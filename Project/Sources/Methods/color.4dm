//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : color_
  // ID[830BCBA0AA804B61AD2FEE71815E4B63]
  // Created 31-7-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // WIP
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_TEXT:C284($t)
C_OBJECT:C1216($o)

If (False:C215)
	C_OBJECT:C1216(color ;$0)
	C_TEXT:C284(color ;$1)
	C_OBJECT:C1216(color ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470.$_is=Null:C1517)
	
	$o:=New object:C1471(\
		"$_is";"color";\
		"color";0;\
		"_rgb";Formula:C1597(color ("_rgb"));\
		"_hex";Formula:C1597(color ("_hex"))\
		)
	
	If (Count parameters:C259>=1)
		
		$o.type:=$1
		
		If (Count parameters:C259>=2)
			
			Case of 
					
					  //______________________________________________________
				: ($1="4dColor")  // 4-byte Long Integer (format 0x00rrggbb)
					
					$o.color:=Num:C11($2.value)
					
					  //______________________________________________________
				: ($1="CSS color name")  // Standard CSS2 color name.
					
					$o.name:=String:C10($2.value)
					
					  //______________________________________________________
				: ($1="CSS hex color")  // "#rrggbb
					
					  // rr = red component of the color
					  // gg = green component of the color
					  // bb = blue component of the color
					
					$o.hex:=String:C10($2.value)
					
					  //______________________________________________________
				Else 
					
					  // A "Case of" statement should never omit "Else"
					  //______________________________________________________
			End case 
		End if 
	End if 
	
	$o._rgb()
	$o._hex()
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="_rgb")
			
			If ($o.color#Null:C1517)
				
				$o.rgb:=Replace string:C233("rgb({r},{g},{b})";"{r}";String:C10(($o.color & 0x00FF0000) >> 16))
				$o.rgb:=Replace string:C233($o.rgb;"{g}";String:C10(($o.color & 0xFF00) >> 8))
				$o.rgb:=Replace string:C233($o.rgb;"{b}";String:C10(($o.color & 0x00FF)))
				
			End if 
			
			  //______________________________________________________
		: ($1="_hex")
			
			If ($o.color#Null:C1517)
				
				$o.hex:="#"+Substring:C12(String:C10($o.color+0x01000000;"&x");5)
				
			End if 
			
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