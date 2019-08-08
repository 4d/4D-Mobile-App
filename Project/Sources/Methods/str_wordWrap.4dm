//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : str_wordWrap
  // Database: 4D Mobile App
  // ID[D741AFED7862440FB86FEB940D250D33]
  // Created 8-6-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // #THREAD_SAFE
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_LONGINT:C283($2)

C_BOOLEAN:C305($Boo_matched)
C_LONGINT:C283($Lon_length;$Lon_maxColumns;$Lon_parameters;$Lon_position)
C_TEXT:C284($Txt_pattern;$Txt_toWrap;$Txt_wrappedText)

If (False:C215)
	C_TEXT:C284(str_wordWrap ;$0)
	C_TEXT:C284(str_wordWrap ;$1)
	C_LONGINT:C283(str_wordWrap ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_toWrap:=$1
	
	  // Default values
	$Lon_maxColumns:=79
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		$Lon_maxColumns:=$2
		
	End if 
	
	$Txt_pattern:="^(.{1,COL}|\\S{COL,})(?:\\s[^\\S\\r\\n]*|\\Z)"
	$Txt_pattern:=Replace string:C233($Txt_pattern;"COL";String:C10($Lon_maxColumns);1;*)
	$Txt_pattern:=Replace string:C233($Txt_pattern;"COL";String:C10($Lon_maxColumns+1);1;*)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Repeat 
	
	$Boo_matched:=Match regex:C1019($Txt_pattern;$Txt_toWrap;1;$Lon_position;$Lon_length;*)
	
	If ($Boo_matched)
		
		$Txt_wrappedText:=$Txt_wrappedText+Substring:C12($Txt_toWrap;1;$Lon_length)+"\r"
		$Txt_toWrap:=Delete string:C232($Txt_toWrap;1;$Lon_length)
		
	Else 
		
		If (Length:C16($Txt_toWrap)>0)
			
			$Txt_wrappedText:=$Txt_wrappedText+$Txt_toWrap
			
		Else 
			
			  // Remove the last carriage return
			$Txt_wrappedText:=Delete string:C232($Txt_wrappedText;Length:C16($Txt_wrappedText);1)
			
		End if 
	End if 
Until (Not:C34($Boo_matched))

  // ----------------------------------------------------
  // Return
$0:=$Txt_wrappedText

  // ----------------------------------------------------
  // End