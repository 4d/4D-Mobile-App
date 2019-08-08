//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : macros
  // Database: 4D Mobile Express
  // ID[2FB4F4541BFC4C7F910600716696D754]
  // Created 11-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Process <macro> tags and  xliff
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_i;$Lon_i;$Lon_parameters)
C_TEXT:C284($kTxt_macro;$kTxt_xliff;$Txt_buffer;$Txt_in;$Txt_OnErrorMethod;$Txt_out)
C_TEXT:C284($Txt_replacement;$Txt_target)
C_OBJECT:C1216($Obj_path)

ARRAY TEXT:C222($tTxt_results;0)

If (False:C215)
	C_TEXT:C284(_o_macros ;$0)
	C_TEXT:C284(_o_macros ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_in:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$kTxt_macro:="(?m-si)<macro>(.*)</macro>"
	$kTxt_xliff:="(?m-si):xliff:(\\w+)"
	
	$Txt_out:=$Txt_in
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  // Xliff
If (0=Rgx_ExtractText ($kTxt_xliff;$Txt_out;"1";->$tTxt_results))
	
	For ($Lon_i;1;Size of array:C274($tTxt_results);1)
		
		CLEAR VARIABLE:C89($Txt_replacement)
		
		$Txt_buffer:=Get localized string:C991($tTxt_results{$Lon_i})
		
		If (Length:C16($Txt_buffer)#0)
			
			$Txt_out:=Replace string:C233($Txt_out;":xliff:"+$tTxt_results{$Lon_i};$Txt_buffer)
			
		End if 
	End for 
End if 


  // Macros
$Txt_OnErrorMethod:=Method called on error:C704

ON ERR CALL:C155("noError")

If (0=Rgx_ExtractText ($kTxt_macro;$Txt_out;"1";->$tTxt_results))
	
	For ($Lon_i;1;Size of array:C274($tTxt_results);1)
		
		CLEAR VARIABLE:C89($Txt_replacement)
		
		Case of 
				
				  //______________________________________________________
			: ($tTxt_results{$Lon_i}="@:C@")
				
				$Txt_buffer:=DOCUMENT
				EXECUTE FORMULA:C63("DOCUMENT:="+$tTxt_results{$Lon_i})
				$Txt_replacement:=DOCUMENT
				DOCUMENT:=$Txt_buffer
				
				  //______________________________________________________
			: ($tTxt_results{$Lon_i}="Current user")
				
				$Txt_replacement:=Current system user:C484
				
				  //______________________________________________________
			: ($tTxt_results{$Lon_i}="current year")
				
				$Txt_replacement:=String:C10(Year of:C25(Current date:C33))
				
				  //______________________________________________________
				  //: ($tTxt_results{$Lon_i}="lowerCamelCase(@)")
			: (Match regex:C1019("(?m-si)lowerCamelCase\\([^)]*\\)";$tTxt_results{$Lon_i};1))
				
				$Txt_buffer:=Delete string:C232($tTxt_results{$Lon_i};1;15)
				$Txt_buffer:=Delete string:C232($Txt_buffer;Length:C16($Txt_buffer);1)
				$Txt_replacement:=str_format ("uperCamelCase";$Txt_buffer)
				$Txt_replacement[[1]]:=Lowercase:C14($Txt_replacement[[1]])
				
				  //______________________________________________________
				  //: ($tTxt_results{$Lon_i}="uperCamelCase(@)")
			: (Match regex:C1019("(?m-si)uperCamelCase\\([^)]*\\)";$tTxt_results{$Lon_i};1))
				
				$Txt_buffer:=Delete string:C232($tTxt_results{$Lon_i};1;14)
				$Txt_buffer:=Delete string:C232($Txt_buffer;Length:C16($Txt_buffer);1)
				$Txt_replacement:=str_format ("uperCamelCase";$Txt_buffer)
				
				  //______________________________________________________
				  //: ($tTxt_results{$Lon_i}="uniqueAppName(@)")
			: (Match regex:C1019("(?m-si)uniqueAppName\\([^)]*\\)";$tTxt_results{$Lon_i};1))
				
				$Txt_buffer:=Delete string:C232($tTxt_results{$Lon_i};1;14)
				$Txt_buffer:=Delete string:C232($Txt_buffer;Length:C16($Txt_buffer);1)
				
				$Obj_path:=New object:C1471
				$Obj_path.parentFolder:=_o_Pathname ("products")
				$Obj_path.isFolder:=True:C214
				$Obj_path.name:=$Txt_buffer
				
				While (Test path name:C476(Object to path:C1548($Obj_path))=Is a folder:K24:2)
					
					$Lon_i:=$Lon_i+1
					$Obj_path.name:=$Txt_buffer+String:C10($Lon_i;" #####0")
					
				End while 
				
				$Txt_replacement:=$Obj_path.name
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Unknown entry point: \""+$tTxt_results{$Lon_i}+"\"")
				
				  //______________________________________________________
		End case 
		
		If (Length:C16($Txt_replacement)>0)
			
			$Txt_target:="<macro>"+$tTxt_results{$Lon_i}+"</macro>"
			$Txt_out:=Replace string:C233($Txt_out;$Txt_target;$Txt_replacement)
			
		End if 
	End for 
End if 

ON ERR CALL:C155($Txt_OnErrorMethod)

  // ----------------------------------------------------
  // Return
$0:=$Txt_out

  // ----------------------------------------------------
  // End