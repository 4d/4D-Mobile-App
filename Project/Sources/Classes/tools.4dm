/*

Common tools to have at hand

*/

//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	This:C1470.success:=False:C215
	This:C1470.lastError:=""
	This:C1470.errors:=New collection:C1472
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function first($c : Collection) : Variant
	
	If ($c#Null:C1517)
		
		If ($c.length>0)
			
			return ($c[0])
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function last($c : Collection) : Variant
	
	If ($c#Null:C1517)
		
		If ($c.length>0)
			
			return ($c[$c.length-1])
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function next($c : Collection; $current : Integer) : Variant
	
	If ($c#Null:C1517)
		
		If ($c.length>$current)
			
			return ($c[$current+1])
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _pushError($desription : Text)
	
	This:C1470.success:=False:C215
	This:C1470.lastError:=Get call chain:C1662[1].name+" - "+$desription
	This:C1470.errors.push(This:C1470.lastError)
	
	//====================================================================
	// A very simple execution of LAUNCH EXTERNAL PROCESS
Function lep($command : Text; $inputStream) : Object
	
	var $error; $out : Text
	var $len; $pid; $pos : Integer
	var $o : Object
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259<2)
			
			$inputStream:=""
			
			//______________________________________________________
		: (Value type:C1509($inputStream)=Is text:K8:3)
			
			// <NOTHING MORE TO DO>
			
			//______________________________________________________
		: (Value type:C1509($inputStream)=Is collection:K8:32)
			
			$inputStream:=$inputStream.join(" ")
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "inputStream must be a text or a collection")
			$inputStream:=""
			
			//______________________________________________________
	End case 
	
	$o:=New object:C1471(\
		"success"; False:C215)
	
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
	LAUNCH EXTERNAL PROCESS:C811($command; $inputStream; $out; $error; $pid)
	
	$o.pid:=$pid
	
	// Remove the last line feed, if any
	If (Match regex:C1019("^.+$"; $out; 1; $pos; $len))
		
		$out:=Substring:C12($out; $pos; $len)
		
	End if 
	
	$o.out:=$out
	$o.error:=$error
	
	If (Bool:C1537(OK))
		
		$o.success:=True:C214
		
	Else 
		
		ASSERT:C1129(False:C215; "tools > lep failed: "+$command)
		
	End if 
	
	return ($o)
	
	//====================================================================
Function escape($tring : Text) : Text
	
	var $t : Text
	
	If (Is macOS:C1572)
		
		For each ($t; Split string:C1554("\\!\"#$%&'()=~|<>?;*`[] "; ""))
			
			$tring:=Replace string:C233($tring; $t; "\\"+$t; *)
			
		End for each 
	End if 
	
	return ($tring)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Compare two string version
	// -  0 if the version and the reference are equal
	// -  1 if the version is higher than the reference
	// - -1 if the version is lower than the reference
Function versionCompare($version : Text; $reference : Text; $separator : Text) : Integer
	
	var $i; $result : Integer
	var $splitVersion; $splitReference : Collection
	
	ASSERT:C1129(Count parameters:C259>=2)
	
	$separator:=Count parameters:C259>=3 ? $separator : "."  // Dot is default separator
	
	$splitVersion:=Split string:C1554($version; $separator)
	$splitReference:=Split string:C1554($reference; $separator)
	
	Case of 
			
			//______________________________________________________
		: ($splitVersion.length>$splitReference.length)
			
			$splitReference.resize($splitVersion.length; "0")
			
			//______________________________________________________
		: ($splitReference.length>$splitVersion.length)
			
			$splitVersion.resize($splitReference.length; "0")
			
			//______________________________________________________
	End case 
	
	For ($i; 0; $splitReference.length-1; 1)
		
		Case of 
				
				//______________________________________________________
			: (Num:C11($splitVersion[$i])>Num:C11($splitReference[$i]))
				
				$result:=1
				break
				
				//______________________________________________________
			: (Num:C11($splitVersion[$i])<Num:C11($splitReference[$i]))
				
				$result:=-1
				break
				
				//______________________________________________________
			Else 
				
				// Go on
				
				//______________________________________________________
		End case 
	End for 
	
	return ($result)
	
	//====================================================================
	// Enclose, if necessary, the string in single quotation marks
Function singleQuoted($tring : Text) : Text
	
	return (Match regex:C1019("^'.*'$"; $tring; 1) ? $tring : "'"+$tring+"'")
	
	//====================================================================
	// Returns the string between quotes
Function quoted($tring : Text) : Text
	
	return (Match regex:C1019("^\".*\"$"; $tring; 1) ? $tring : "\""+$tring+"\"")
	
	//====================================================================
	// Returns the localized string corresponding to the $resname resname & made replacement if any
Function localized($resname : Text; $replacement; $replacementN : Text)->$localizedString : Text
	
	var ${3} : Text
	
	var $t : Text
	var $continue : Boolean
	var $i; $len; $pos : Integer
	
	If (Count parameters:C259>=1)
		
		If (Length:C16($resname)>0)\
			 & (Length:C16($resname)<=255)
			
			//%W-533.1
			If ($resname[[1]]#Char:C90(1))
				
				$t:=Get localized string:C991($resname)
				$localizedString:=Length:C16($t)>0 ? $t : $resname  // Revert if no localization
				
			End if 
			//%W+533.1
			
		End if 
		
		If (Count parameters:C259>=2)
			
			If (Value type:C1509($replacement)=Is collection:K8:32)
				
				Repeat 
					
					$continue:=$i<$replacement.length
					
					If ($continue)
						
						$continue:=Match regex:C1019("(?m-si)(\\{[\\w\\s]+\\})"; $localizedString; 1; $pos; $len)
						
						If ($continue)
							
							$t:=Get localized string:C991(String:C10($replacement[$i]))
							$t:=Length:C16($t)>0 ? $t : String:C10($replacement[$i])
							
							If (Position:C15("</span>"; $localizedString)>0)  // Multistyle
								
								$t:=This:C1470.multistyleCompatible($t)
								
							End if 
							
							$localizedString:=Replace string:C233($localizedString; Substring:C12($localizedString; $pos; $len); $t)
							$i+=1
							
						End if 
					End if 
				Until (Not:C34($continue))
				
			Else 
				
				For ($i; 2; Count parameters:C259; 1)
					
					If (Match regex:C1019("(?m-si)(\\{[\\w\\s]+\\})"; $localizedString; 1; $pos; $len))
						
						$t:=Get localized string:C991(String:C10(${$i}))
						$t:=Length:C16($t)>0 ? $t : String:C10(${$i})
						
						If (Position:C15("</span>"; $localizedString)>0)  // Multistyle
							
							$t:=This:C1470.multistyleCompatible($t)
							
						End if 
						
						$localizedString:=Replace string:C233($localizedString; Substring:C12($localizedString; $pos; $len); $t)
						
					End if 
				End for 
			End if 
			
		Else 
			
			$localizedString:=Length:C16($localizedString)=0 ? $resname : $localizedString
			
		End if 
	End if 
	
	//====================================================================
	// Returns True if text match given pattern
Function match($pattern : Text; $tring : Text) : Boolean
	
	return (Match regex:C1019($pattern; $tring; 1))
	
	//====================================================================
	// Returns a string that can be used in multistyles texts
Function multistyleCompatible($tring : Text) : Text
	
	$tring:=Replace string:C233($tring; "&"; "&amp;")
	$tring:=Replace string:C233($tring; "<"; "&lt;")
	$tring:=Replace string:C233($tring; ">"; "&gt;")
	
	return ($tring)
	
	//====================================================================
	// Returns a digest signature of the contents of a folder
Function folderDigest($folder : 4D:C1709.Folder)->$digest : Text
	
	var $o : Object
	var $x : Blob
	var $onErrCallMethod : Text
	
	$onErrCallMethod:=Method called on error:C704
	ON ERR CALL:C155("noError")
	
	For each ($o; $folder.files(fk recursive:K87:7+fk ignore invisible:K87:22))
		
		$x:=$o.getContent()
		$digest:=$digest+Generate digest:C1147($x; SHA1 digest:K66:2)
		
	End for each 
	
	ON ERR CALL:C155($onErrCallMethod)
	
	$digest:=Generate digest:C1147($digest; SHA1 digest:K66:2)
	