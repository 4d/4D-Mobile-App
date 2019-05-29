//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : str_URLDecode
  // Database: 4D Mobile App
  // ID[4B76CDB37A7D433F8391D2CCB6C5627F]
  // Created #4-10-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Returns a URL decoded string
  // ----------------------------------------------------
  // #THREAD_SAFE
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)

C_BLOB:C604($Blb_buffer)
C_LONGINT:C283($Lon_byte;$Lon_i;$Lon_length;$Lon_offset;$Lon_parameters)
C_TEXT:C284($Txt_in;$Txt_out)

If (False:C215)
	C_TEXT:C284(str_URLDecode ;$0)
	C_TEXT:C284(str_URLDecode ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_in:=$1  // String to decode
	
	  // Default values
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Lon_length:=Length:C16($Txt_in)
	
	SET BLOB SIZE:C606($Blb_buffer;$Lon_length+1;0)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
For ($Lon_i;1;$Lon_length;1)
	
	Case of 
			
			  //________________________________________
		: ($Txt_in[[$Lon_i]]="%")
			
			$Lon_byte:=Position:C15(Substring:C12($Txt_in;$Lon_i+1;1);"123456789ABCDEF")*16
			$Lon_byte:=$Lon_byte+Position:C15(Substring:C12($Txt_in;$Lon_i+2;1);"123456789ABCDEF")
			
			$Blb_buffer{$Lon_offset}:=$Lon_byte
			
			$Lon_i:=$Lon_i+2
			
			  //________________________________________
		Else 
			
			$Blb_buffer{$Lon_offset}:=Character code:C91($Txt_in[[$Lon_i]])
			
			  //________________________________________
	End case 
	
	$Lon_offset:=$Lon_offset+1
	
End for 

  // Convert from UTF-8
SET BLOB SIZE:C606($Blb_buffer;$Lon_offset)

$Txt_out:=Convert to text:C1012($Blb_buffer;"utf-8")

  // ----------------------------------------------------
  // Return
$0:=$Txt_out  // Decoded string

  // ----------------------------------------------------
  // End