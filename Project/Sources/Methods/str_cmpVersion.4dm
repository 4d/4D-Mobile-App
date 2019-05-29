//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : str_cmpVersion
  // Database: development
  // ID[DCF30A469D5E4218B85F193A77D16EFA]
  // Created #05-12-2017 by Eric Marchand
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (06/06/18)
  // Refactoring
  // ----------------------------------------------------
  // Description:
  // Compare two string version
  // -  0 if equal
  // -  1 if $1 is more recent than $2
  // - -1 if $1 is less recent than $2
  // ----------------------------------------------------
  // #THREAD_SAFE
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($0)
C_TEXT:C284($1)
C_TEXT:C284($2)
C_TEXT:C284($3)

C_LONGINT:C283($Lon_i;$Lon_parameters;$Lon_result)
C_TEXT:C284($Txt_reference;$Txt_separator;$Txt_target)
C_COLLECTION:C1488($Col_1;$Col_2)

If (False:C215)
	C_LONGINT:C283(str_cmpVersion ;$0)
	C_TEXT:C284(str_cmpVersion ;$1)
	C_TEXT:C284(str_cmpVersion ;$2)
	C_TEXT:C284(str_cmpVersion ;$3)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  // Required parameters
	$Txt_target:=$1  // Version to test
	$Txt_reference:=$2  // Reference version
	
	$Txt_separator:="."
	
	  // Optional parameters
	If ($Lon_parameters>=3)
		
		$Txt_separator:=$3  // optional - "." if omitted
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Col_1:=Split string:C1554($Txt_target;$Txt_separator)
$Col_2:=Split string:C1554($Txt_reference;$Txt_separator)

Case of 
		
		  //______________________________________________________
	: ($Col_1.length>$Col_2.length)
		
		$Col_2.resize($Col_1.length;"0")
		
		  //______________________________________________________
	: ($Col_2.length>$Col_1.length)
		
		$Col_1.resize($Col_2.length;"0")
		
		  //______________________________________________________
End case 

For ($Lon_i;0;$Col_2.length-1;1)
	
	Case of 
			
			  //______________________________________________________
		: (Num:C11($Col_1[$Lon_i])>Num:C11($Col_2[$Lon_i]))
			
			$Lon_result:=1
			$Lon_i:=MAXLONG:K35:2-1
			
			  //______________________________________________________
		: (Num:C11($Col_1[$Lon_i])<Num:C11($Col_2[$Lon_i]))
			
			$Lon_result:=-1
			$Lon_i:=MAXLONG:K35:2-1
			
			  //______________________________________________________
		Else 
			
			  // Go on
			
			  //______________________________________________________
	End case 
End for 

  // ----------------------------------------------------
  // Return
$0:=$Lon_result  //0 if equal, 1 if $1 is more recent than $2, -1 if $1 is less recent than $2

  // ----------------------------------------------------