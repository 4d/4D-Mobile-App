//%attributes = {"invisible":true,"preemptive":"capable"}
/*
out := ***str_URLEncode*** ( in )
 -> in (Text) -  String to encode
 <- out (Text) -  Encoded string
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : str_URLEncode
  // Database: 4D Mobile App
  // ID[1E29AECDCAA045C9A3194F772CEA4500]
  // Created #4-10-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Returns a URL encoded string
  // ----------------------------------------------------
  // #THREAD_SAFE
  // ----------------------------------------------------
  // Modified #4-10-2018 by Vincent de Lachaux
  // Remove "=" and space to get the same result as:
  // https:// Www.urlencoder.org
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)

C_BLOB:C604($Blb_buffer)
C_LONGINT:C283($Lon_i;$Lon_parameters)
C_TEXT:C284($Txt_char;$Txt_in;$Txt_out;$Txt_safeCharacters)

If (False:C215)
	C_TEXT:C284(str_URLEncode ;$0)
	C_TEXT:C284(str_URLEncode ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_in:=$1  // String to encode
	
	  // Default values
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	  // List of safe characters
	$Txt_safeCharacters:="1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz:/.?_-$(){}~&"
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Length:C16($Txt_in)>0)
	
	  // Use the UTF-8 character set for encoding
	CONVERT FROM TEXT:C1011($Txt_in;"utf-8";$Blb_buffer)
	
	  // Convert the characters
	For ($Lon_i;0;BLOB size:C605($Blb_buffer)-1;1)
		
		$Txt_char:=Char:C90($Blb_buffer{$Lon_i})
		
		Case of 
				
				  //______________________________________________________
			: (Position:C15($Txt_char;$Txt_safeCharacters;*)>0)
				
				  // It's a safe character, append unaltered
				$Txt_out:=$Txt_out+$Txt_char
				
				  //______________________________________________________
			Else 
				
				  // It's an unsafe character, append as a hex string
				$Txt_out:=$Txt_out+"%"+Substring:C12(String:C10($Blb_buffer{$Lon_i};"&x");5)
				
				  //______________________________________________________
		End case 
	End for 
End if 

  // ----------------------------------------------------
  // Return
$0:=$Txt_out  // Encoded string

  // ----------------------------------------------------
  // End