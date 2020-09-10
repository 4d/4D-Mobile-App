/*

Common tools to have at hand

*/

Class constructor
	
	This:C1470.success:=False:C215
	This:C1470.lastError:=""
	This:C1470.errors:=New collection:C1472
	
	//====================================================================
	// Simple execution of LAUNCH EXTERNAL PROCESS
Function lep
	var $0 : Object  // {success,out,error}
	var $1 : Text  // Command
	var $2 : Text  // In
	
	var $cmd; $error; $in; $out : Text
	
	If (Count parameters:C259>=2)
		
		$in:=$2
		
	End if 
	
	$0:=New object:C1471(\
		"success"; False:C215)
	
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
	LAUNCH EXTERNAL PROCESS:C811($1; $in; $out; $error)
	
	$0.out:=$out
	$0.error:=$error
	
	If (Bool:C1537(OK))
		
		$0.success:=True:C214
		
	Else 
		
		ASSERT:C1129(False:C215; "tools > lep failed: "+$cmd)
		
	End if 
	
	//====================================================================
	// Compare two string version
	// -  0 if the version and the reference are equal
	// -  1 if the version is higher than the reference
	// - -1 if the version is lower than the reference
Function versionCompare
	var $0 : Integer  //0, 1 or -1
	var $1 : Text  // Version to test
	var $2 : Text  // Reference
	var $3 : Text  // Separator (optional - "." if omitted)
	
	var $separator : Text
	var $i : Integer
	var $c1; $c2 : Collection
	
	$separator:="."
	
	If (Count parameters:C259>=3)
		
		$separator:=$3
		
	End if 
	
	$c1:=Split string:C1554($1; $separator)
	$c2:=Split string:C1554($2; $separator)
	
	Case of 
			
			//______________________________________________________
		: ($c1.length>$c2.length)
			
			$c2.resize($c1.length; "0")
			
			//______________________________________________________
		: ($c2.length>$c1.length)
			
			$c1.resize($c2.length; "0")
			
			//______________________________________________________
	End case 
	
	For ($i; 0; $c2.length-1; 1)
		
		Case of 
				
				//______________________________________________________
			: (Num:C11($c1[$i])>Num:C11($c2[$i]))
				
				$0:=1
				$i:=MAXLONG:K35:2-1
				
				//______________________________________________________
			: (Num:C11($c1[$i])<Num:C11($c2[$i]))
				
				$0:=-1
				$i:=MAXLONG:K35:2-1
				
				//______________________________________________________
			Else 
				
				// Go on
				
				//______________________________________________________
		End case 
	End for 
	
	//====================================================================
	// Returns the string between single quote
Function singleQuoted
	var $0 : Text
	var $1 : Text
	
	If (Match regex:C1019("^'.*'$"; $1; 1))
		
		$0:=$1  // Already done
		
	Else 
		
		$0:="'"+$1+"'"  // Do it
		
	End if 
	