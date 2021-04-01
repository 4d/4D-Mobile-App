/*

Common tools to have at hand

*/

//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	This:C1470.success:=False:C215
	This:C1470.lastError:=""
	This:C1470.errors:=New collection:C1472
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function first($c : Collection)->$result : Variant
	
	// Null by default
	var $o : Object
	$result:=$o
	
	If ($c#Null:C1517)
		
		If ($c.length>0)
			
			$result:=$c[0]
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function last($c : Collection)->$result : Variant
	
	// Null by default
	var $o : Object
	$result:=$o
	
	If ($c#Null:C1517)
		
		If ($c.length>0)
			
			$result:=$c[$c.length-1]
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function next($c : Collection; $current : Integer)->$result : Variant
	
	// Null by default
	var $o : Object
	$result:=$o
	
	If ($c#Null:C1517)
		
		If ($c.length>$current)
			
			$result:=$c[$current+1]
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _pushError($desription : Text)
	
	This:C1470.success:=False:C215
	This:C1470.errors.push(Get call chain:C1662[1].name+" - "+$desription)
	
	//====================================================================
	// A very simple execution of LAUNCH EXTERNAL PROCESS
Function lep
	var $0 : Object  // {success,out,error}
	var $1 : Text  // Command
	var $2 : Variant  // In
	
	var $cmd; $error; $in; $out : Text
	var $len; $pid; $pos : Integer
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259<2)
			
			// <NOTHING MORE TO DO>
			
			//______________________________________________________
		: (Value type:C1509($2)=Is text:K8:3)
			
			$in:=$2
			
			//______________________________________________________
		: (Value type:C1509($2)=Is collection:K8:32)
			
			$in:=$2.join(" ")
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "$2 must be a text or a collection")
			
			//______________________________________________________
	End case 
	
	$0:=New object:C1471(\
		"success"; False:C215)
	
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
	LAUNCH EXTERNAL PROCESS:C811($1; $in; $out; $error; $pid)
	
	$0.pid:=$pid
	
	// Remove the last line feed, if any
	If (Match regex:C1019("^.+$"; $out; 1; $pos; $len))
		
		$out:=Substring:C12($out; $pos; $len)
		
	End if 
	
	$0.out:=$out
	$0.error:=$error
	
	If (Bool:C1537(OK))
		
		$0.success:=True:C214
		
	Else 
		
		ASSERT:C1129(False:C215; "tools > lep failed: "+$cmd)
		
	End if 
	
	//====================================================================
Function escape
	var $0 : Text
	var $1 : Text
	
	var $t : Text
	
	$0:=$1
	If (Is macOS:C1572)
		
		For each ($t; Split string:C1554("\\!\"#$%&'()=~|<>?;*`[] "; ""))
			
			$0:=Replace string:C233($0; $t; "\\"+$t; *)
			
		End for each 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Compare two string version
	// -  0 if the version and the reference are equal
	// -  1 if the version is higher than the reference
	// - -1 if the version is lower than the reference
Function versionCompare($version : Text; $reference : Text; $separator : Text)->$result : Integer
	
	var $sep : Text
	var $i : Integer
	var $c1; $c2 : Collection
	
	ASSERT:C1129(Count parameters:C259>=2)
	
	$sep:="."  // Default separator
	
	If (Count parameters:C259>=3)
		
		$sep:=$separator
		
	End if 
	
	$c1:=Split string:C1554($version; $sep)
	$c2:=Split string:C1554($reference; $sep)
	
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
				
				$result:=1
				$i:=MAXLONG:K35:2-1  // Break
				
				//______________________________________________________
			: (Num:C11($c1[$i])<Num:C11($c2[$i]))
				
				$result:=-1
				$i:=MAXLONG:K35:2-1  // Break
				
				//______________________________________________________
			Else 
				
				// Go on
				
				//______________________________________________________
		End case 
	End for 
	
	//====================================================================
	// Enclose, if necessary, the string in single quotation marks
Function singleQuoted($tring : Text)->$quoted : Text
	
	$quoted:=Choose:C955(Match regex:C1019("^'.*'$"; $tring; 1); $tring; "'"+$tring+"'")  // Already done // Do it
	
	//====================================================================
	// Returns the string between quotes
Function quoted
	var $0 : Text
	var $1 : Text
	
	If (Match regex:C1019("^\".*\"$"; $1; 1))
		
		$0:=$1  // Already done
		
	Else 
		
		$0:="\""+$1+"\""  // Do it
		
	End if 
	
	//====================================================================
	// ⛔️ Returns the localized string corresponding to the $1 resname & made replacement if any
Function localized
	var $0 : Text
	var $1 : Text
	var $2 : Variant
	var ${3} : Text
	
	var $t : Text
	var $b : Boolean
	var $i; $length; $position : Integer
	
	If (Count parameters:C259>=1)
		
		$t:=$1
		
		If (Length:C16($1)>0)\
			 & (Length:C16($1)<=255)
			
			//%W-533.1
			If ($1[[1]]#Char:C90(1))
				
				$t:=Get localized string:C991($1)
				$0:=Choose:C955(Length:C16($t)>0; $t; $1)  // Revert if no localization
				
			End if 
			//%W+533.1
			
		End if 
		
		If (Count parameters:C259>=2)
			
			If (Value type:C1509($2)=Is collection:K8:32)
				
				Repeat 
					
					$b:=$i<$2.length
					
					If ($b)
						
						$b:=Match regex:C1019("(?m-si)(\\{[\\w\\s]+\\})"; $0; 1; $position; $length)
						
						If ($b)
							
							$t:=Get localized string:C991($2[$i])
							$t:=Choose:C955(Length:C16($t)>0; $t; $2[$i])
							
							If (Position:C15("</span>"; $0)>0)  // Multistyle
								
								$t:=This:C1470.multistyleCompatible($t)
								
							End if 
							
							$0:=Replace string:C233($0; Substring:C12($0; $position; $length); $t)
							$i:=$i+1
							
						End if 
					End if 
				Until (Not:C34($b))
				
			Else 
				
				For ($i; 2; Count parameters:C259; 1)
					
					If (Match regex:C1019("(?m-si)(\\{[\\w\\s]+\\})"; $0; 1; $position; $length))
						
						$t:=Get localized string:C991(String:C10($2))
						$t:=Choose:C955(Length:C16($t)>0; $t; String:C10($2))
						
						If (Position:C15("</span>"; $0)>0)  // Multistyle
							
							$t:=This:C1470.multistyleCompatible($t)
							
						End if 
						
						$0:=Replace string:C233($0; Substring:C12($0; $position; $length); $t)
						
					End if 
				End for 
			End if 
			
		Else 
			
			If (Length:C16($0)=0)
				
				$0:=$1
				
			End if 
			
			
		End if 
	End if 
	
	//====================================================================
	// Returns True if text match given pattern
Function match
	var $0 : Boolean
	var $1 : Text
	var $2 : Text
	
	$0:=Match regex:C1019($1; $2; 1)
	
	//====================================================================
	// ⛔️ Returns a coded string that can be used in multistyles texts
Function multistyleCompatible
	var $0; $1 : Text
	
	$0:=$1
	$0:=Replace string:C233($0; "&"; "&amp;")
	$0:=Replace string:C233($0; "<"; "&lt;")
	$0:=Replace string:C233($0; ">"; "&gt;")
	
	//====================================================================
	// Identical to the Choose command
	// but without error because it does not evaluate all members.
Function choose($requirement)->$choosed
	var ${2} : Object
	
	If (Value type:C1509($requirement)=Is real:K8:4)\
		 | (Value type:C1509($requirement)=Is longint:K8:6)
		
		$choosed:=${Num:C11($requirement)+2}.call()
		
	Else 
		
		$choosed:=${3-Num:C11(Bool:C1537($requirement))}.call()
		
	End if 
	
	//====================================================================
	// Returns a digest signature of the contents of a folder
Function folderDigest($folder : 4D:C1709.folder)->$digest : Text
	
	var $o : Object
	var $x : Blob
	var $onErrCallMethod : Text
	
	$onErrCallMethod:=Method called on error:C704
	//====================== [
	ON ERR CALL:C155("noError")
	
	For each ($o; $folder.files(fk recursive:K87:7+fk ignore invisible:K87:22))
		
		$x:=$o.getContent()
		$digest:=$digest+Generate digest:C1147($x; SHA1 digest:K66:2)
		
	End for each 
	
	ON ERR CALL:C155($onErrCallMethod)
	//====================== ]
	
	$digest:=Generate digest:C1147($digest; SHA1 digest:K66:2)
	
	