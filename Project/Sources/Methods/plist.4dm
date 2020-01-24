//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : plist
  // ID[B8934F6DFF59468399DDA49E6FB2173F]
  // Created 29-6-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:

  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Bool_errorInOut;$Bool_ReplaceLS)
C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($format;$Txt_cmd;$Txt_error;$Txt_in;$Txt_out)
C_OBJECT:C1216($Obj_in;$Obj_out)

If (False:C215)
	C_OBJECT:C1216(plist ;$0)
	C_OBJECT:C1216(plist ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$Obj_in:=$1
	
	  //Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Obj_out:=New object:C1471("success";False:C215)
	
Else 
	
	ABORT:C156
	
End if 

$Bool_ReplaceLS:=True:C214

If ($Obj_in.domain=Null:C1517)
	
	If ($Obj_in.posix#Null:C1517)
		
		$Obj_in.domain:=$Obj_in.posix
		
	Else 
		
		If ($Obj_in.path#Null:C1517)
			
			$Obj_in.domain:=Convert path system to POSIX:C1106($Obj_in.path)
			
		End if 
	End if 
End if 

If ($Obj_in.openstep=Null:C1517)
	
	$Obj_in.openstep:=False:C215
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Obj_in.action=Null:C1517)
		
		ASSERT:C1129(False:C215)
		
		  //______________________________________________________
	: ($Obj_in.action="read")
		
		  // with defaults
		$Txt_cmd:="defaults read"  // not working with complex plist
		
		If ($Obj_in.domain#Null:C1517)
			
			$Txt_cmd:=$Txt_cmd+" "+str_singleQuoted ($Obj_in.domain)
			
		End if 
		
		If ($Obj_in.key#Null:C1517)
			
			$Txt_cmd:=$Txt_cmd+" "+$Obj_in.key
			
		End if 
		
		  // with plistbuddy
		  //$Txt_cmd:="/usr/libexec/PlistBuddy -c \"Print"
		  //$Bool_ReplaceLS:=False
		  //If (Not(Undefined($Obj_action.domain)))
		  //If (Not(Undefined($Obj_action.key)))
		  //$Txt_cmd:=$Txt_cmd+$Obj_action.key
		  //End if
		  //$Txt_cmd:=$Txt_cmd+"\""
		
		  //$Txt_cmd:=$Txt_cmd+" "+singleQuote ($Obj_action.domain)
		
		  // with plutil
		  //$Txt_cmd:="/usr/libexec/PlistBuddy -c \"Print"
		  //plutil-extract"objects.48010EA21EEEB1CA0086ED62"json-o-/Users/emarchand/ma.pbxproj
		
		  //Else
		  //ASSERT(False;"Domain must be defined for action : \""+$Obj_action.action+"\"")
		  //$Txt_cmd:=""
		  //End if
		
		  //______________________________________________________
	: ($Obj_in.action="extract")
		
		If (($Obj_in.domain#Null:C1517) & ($Obj_in.key#Null:C1517))
			
			$Txt_cmd:="plutil -extract "
			$Txt_cmd:=$Txt_cmd+" "+$Obj_in.key
			
			$Txt_cmd:=Choose:C955($Obj_in.format#Null:C1517;$Txt_cmd+"  "+$Obj_in.format;$Txt_cmd+" json")
			
			$Txt_cmd:=Choose:C955($Obj_in.output#Null:C1517;$Txt_cmd+" -o "+str_singleQuoted ($Obj_in.output);$Txt_cmd+" -o -")  // stdout
			
			$Txt_cmd:=$Txt_cmd+" "+str_singleQuoted ($Obj_in.domain)
			
		Else 
			
			ASSERT:C1129(False:C215;"Domain and key must be defined for action : \""+$Obj_in.action+"\"")
			$Txt_cmd:=""
			
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="write")
		
		If (($Obj_in.domain#Null:C1517) & ($Obj_in.key#Null:C1517) & ($Obj_in.value#Null:C1517))
			
			$Txt_cmd:="defaults write"
			
			$Txt_cmd:=$Txt_cmd+" "+str_singleQuoted ($Obj_in.domain)
			$Txt_cmd:=$Txt_cmd+" "+$Obj_in.key
			$Txt_cmd:=$Txt_cmd+" "+$Obj_in.value  // MAYBE here if value is not texte, do use plistbuddy inserts
			
			$Bool_ReplaceLS:=False:C215
			
		Else 
			
			ASSERT:C1129(False:C215;"Domain, key and value must be defined for action : \""+$Obj_in.action+"\"")
			$Txt_cmd:=""
			
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="insert")
		
		If (($Obj_in.domain#Null:C1517) & ($Obj_in.key#Null:C1517) & ($Obj_in.value#Null:C1517) & ($Obj_in.type#Null:C1517))
			
			  // quote value if needed
			If (($Obj_in.type#"integer") & ($Obj_in.type#"float") & ($Obj_in.type#"bool"))
				
				If (Position:C15("'";$Obj_in.value)=1)
					
					If (Position:C15("'";$Obj_in.value;Length:C16($Obj_in.value))=Length:C16($Obj_in.value))
						
					Else 
						
						$Obj_in.value:=str_singleQuoted ($Obj_in.value)
						
					End if 
					
				Else 
					
					$Obj_in.value:=str_singleQuoted ($Obj_in.value)
					
				End if 
			End if 
			
			If ($Obj_in.openstep)
				
				$Obj_in.action:="convert"
				$Obj_in.format:="xml1"
				$Obj_in.openstep:=False:C215
				$Obj_in.output:=$Obj_in.domain  // inline
				$Obj_out:=plist ($Obj_in)
				$Obj_in.openstep:=True:C214
				
			End if 
			
			$Txt_cmd:="plutil -insert "
			$Txt_cmd:=$Txt_cmd+" "+$Obj_in.key
			$Txt_cmd:=$Txt_cmd+" -"+$Obj_in.type
			$Txt_cmd:=$Txt_cmd+" "+$Obj_in.value
			$Txt_cmd:=$Txt_cmd+" "+str_singleQuoted ($Obj_in.domain)
			
		Else 
			
			ASSERT:C1129(False:C215;"Domain, key, type(bool,integer,float,string,date,data,xml,json) and value must be defined for action : \""+$Obj_in.action+"\"")
			$Txt_cmd:=""
			
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="replace")
		
		If (($Obj_in.domain#Null:C1517) & ($Obj_in.key#Null:C1517) & ($Obj_in.value#Null:C1517) & ($Obj_in.type#Null:C1517))
			
			  // quote value if needed
			If (($Obj_in.type#"integer") & ($Obj_in.type#"float") & ($Obj_in.type#"bool"))
				
				If (Position:C15("'";$Obj_in.value)=1)
					
					If (Position:C15("'";$Obj_in.value;Length:C16($Obj_in.value))=Length:C16($Obj_in.value))
						
					Else 
						
						$Obj_in.value:=str_singleQuoted ($Obj_in.value)
						
					End if 
					
				Else 
					
					$Obj_in.value:=str_singleQuoted ($Obj_in.value)
					
				End if 
			End if 
			
			If ($Obj_in.openstep)
				
				$Obj_in.action:="convert"
				$Obj_in.format:="xml1"
				$Obj_in.openstep:=False:C215
				$Obj_in.output:=$Obj_in.domain  // inline
				$Obj_out:=plist ($Obj_in)
				$Obj_in.openstep:=True:C214
				
			End if 
			
			$Txt_cmd:="plutil -replace "
			$Txt_cmd:=$Txt_cmd+" "+$Obj_in.key
			$Txt_cmd:=$Txt_cmd+" -"+$Obj_in.type
			$Txt_cmd:=$Txt_cmd+" "+$Obj_in.value
			$Txt_cmd:=$Txt_cmd+" "+str_singleQuoted ($Obj_in.domain)
			
		Else 
			
			ASSERT:C1129(False:C215;"Domain, key, type(bool,integer,float,string,date,data,xml,json) and value must be defined for action : \""+$Obj_in.action+"\"")
			$Txt_cmd:=""
			
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="delete")
		
		$Txt_cmd:="defaults delete"
		
		If ($Obj_in.domain#Null:C1517)
			
			$Txt_cmd:=$Txt_cmd+" "+str_singleQuoted ($Obj_in.domain)
			
			If ($Obj_in.key#Null:C1517)
				
				$Txt_cmd:=$Txt_cmd+" "+$Obj_in.key
				
			End if 
			
		Else 
			
			ASSERT:C1129(False:C215;"domain must be defined for action : \""+$Obj_in.action+"\"")
			$Txt_cmd:=""
			
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="remove")
		
		$Txt_cmd:="plutil -remove"
		
		If (($Obj_in.domain#Null:C1517) & ($Obj_in.key#Null:C1517))
			
			If ($Obj_in.openstep)
				
				$Obj_in.action:="convert"
				$Obj_in.format:="xml1"
				$Obj_in.openstep:=False:C215
				$Obj_in.output:=$Obj_in.domain  // inline
				$Obj_out:=plist ($Obj_in)
				$Obj_in.openstep:=True:C214
				
			End if 
			
			$Txt_cmd:=$Txt_cmd+" "+$Obj_in.key
			$Txt_cmd:=$Txt_cmd+" "+str_singleQuoted ($Obj_in.domain)
			
		Else 
			
			ASSERT:C1129(False:C215;"domain, key must be defined for action : \""+$Obj_in.action+"\"")
			$Txt_cmd:=""
			
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="find")
		
		$Txt_cmd:="defaults find"
		
		If ($Obj_in.word#Null:C1517)
			
			$Txt_cmd:=$Txt_cmd+" "+str_singleQuoted ($Obj_in.word)
			
		Else 
			
			ASSERT:C1129(False:C215;"word must be defined for action : \""+$Obj_in.action+"\"")
			$Txt_cmd:=""
			
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="lint")
		
		$Txt_cmd:="plutil -lint "
		
		If ($Obj_in.domain#Null:C1517)
			
			$Txt_cmd:=$Txt_cmd+" "+str_singleQuoted ($Obj_in.domain)
			
		Else 
			
			ASSERT:C1129(False:C215;"domain must be defined for action : \""+$Obj_in.action+"\"")
			$Txt_cmd:=""
			
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="convert")
		
		$Txt_cmd:="plutil"
		
		If (($Obj_in.domain#Null:C1517) & ($Obj_in.format#Null:C1517))
			
			$format:=$Obj_in.format
			
			If ($format="xml")
				
				$format:="xml1"
				
			End if 
			
			If ($format="binary")
				
				$format:="binary1"
				
			End if 
			
			If (($format#"binary1") & ($format#"json") & ($format#"xml1") & ($format#"openstep"))
				
				ASSERT:C1129(False:C215;"format must be xml1, xml, binary1, binary, json or open step for action : \""+$Obj_in.action+"\"")
				$Txt_cmd:=""
				
			Else 
				
				$Txt_cmd:=$Txt_cmd+" -convert "+$format
				
			End if 
			
			If ($format="openstep")
				
				$Txt_cmd:=str_singleQuoted (path .scripts().file("xprojstep").path)
				
				If (String:C10($Obj_in.project)#"")
					  //$Txt_cmd:=$Txt_cmd+" --projectName "+singleQuote ($Obj_in.project)
				End if 
				
				If (String:C10($Obj_in.output)#"")
					  //$Txt_cmd:=$Txt_cmd+" --output "+singleQuote ($Obj_in.project)
				End if 
				
			Else 
				
				$Txt_cmd:=Choose:C955($Obj_in.output#Null:C1517;$Txt_cmd+" -o "+str_singleQuoted ($Obj_in.output);$Txt_cmd+" -o -")  // stdout
				
			End if 
			
			$Txt_cmd:=$Txt_cmd+" "+str_singleQuoted ($Obj_in.domain)
			
		Else 
			
			ASSERT:C1129(False:C215;"domain and format must be defined for action : \""+$Obj_in.action+"\"")
			$Txt_cmd:=""
			
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="object")
		
		If ($Obj_in.domain#Null:C1517)
			
			  // read all as json
			$Obj_out:=plist (New object:C1471("action";"convert";"format";"json";"domain";$Obj_in.domain))
			
			  //End if
			
			  // then convert
			If ($Obj_out.success)
				
				$Obj_out.json:=$Obj_out.value
				
				If (Length:C16($Obj_out.value)>0)
					
					$Obj_out.value:=JSON Parse:C1218($Obj_out.value)
					
				End if 
				
			End if 
			
		Else 
			
			ASSERT:C1129(False:C215;"domain must be defined for action : \""+$Obj_in.action+"\"")
			
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="fromobject")
		
		If ($Obj_in.domain=Null:C1517)
			
			$Obj_in.domain:=$Obj_in.output
			
		End if 
		
		If (($Obj_in.domain#Null:C1517) & ($Obj_in.object#Null:C1517))
			
			TEXT TO DOCUMENT:C1237(Convert path POSIX to system:C1107($Obj_in.domain);JSON Stringify:C1217($Obj_in.object;*))
			
			If ($Obj_in.format#Null:C1517)
				
				If ($Obj_in.format="openstep")
					
					$Obj_in.format:="xml1"  // convert to xml before
					$Obj_in.openstep:=True:C214
					
				End if 
				
				$Obj_in.action:="convert"
				$Obj_in.output:=$Obj_in.domain
				$Obj_out:=plist ($Obj_in)
				
			Else 
				
				$Obj_out.success:=True:C214  // XXX to ON ERR CALL for TEXT TO DOCUMENT to check...
				
			End if 
			
		Else 
			
			ASSERT:C1129(False:C215;"domain/output and object must be defined for action : \""+$Obj_in.action+"\"")
			
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="command")
		
		If (($Obj_in.domain#Null:C1517) & ($Obj_in.command#Null:C1517))
			
			$Txt_cmd:="/usr/libexec/PlistBuddy -c \""+$Obj_in.command+"\" "+str_singleQuoted ($Obj_in.output)
			
		Else 
			
			ASSERT:C1129(False:C215;"domain and command must be defined for action : \""+$Obj_in.action+"\"")
			
		End if 
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Obj_in.action+"\"")
		
		  //______________________________________________________
End case 

If (Length:C16($Txt_cmd)>0)
	
	LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
	
	If (Asserted:C1132(OK=1;"LEP failed: "+$Txt_cmd))
		
		$Bool_errorInOut:=(Position:C15("Error domain";$Txt_out)>0)
		
		If (Not:C34($Bool_errorInOut))
			
			$Bool_errorInOut:=(Position:C15("error:";$Txt_out)>0)
			
		End if 
		
		If ((Length:C16($Txt_error)=0) & Not:C34($Bool_errorInOut))
			
			$Obj_out.success:=True:C214
			$Obj_out.value:=Choose:C955($Bool_ReplaceLS;Replace string:C233($Txt_out;"\n";"");$Txt_out)
			
			  // XXX maybe for some action remove $Obj_result.value if empty
			
		Else 
			
			$Obj_out.success:=False:C215
			$Obj_out.error:=$Txt_error
			
			If ($Bool_errorInOut)
				
				$Obj_out.error:=$Obj_out.error+$Txt_out
				
			End if 
			
			If (String:C10($Obj_in.format)="openstep")
				
				If (Position:C15("libswiftCore.dylib";$Obj_out.error)>0)
					
					$Obj_out.error:="Please update your OS or download the swift 5 runtime: \nhttps://support.apple.com/kb/DL1998?locale=en_US\n\n\nCause:\n"+$Obj_out.error
					
				End if 
			End if 
			
		End if 
	End if 
End if 

If (($Obj_in.openstep) & ($Obj_out.success))
	
	$Obj_in.action:="convert"
	$Obj_in.format:="openstep"
	$Obj_in.openstep:=False:C215
	$Obj_out:=plist ($Obj_in)  // $Obj_result:= ?
	$Obj_in.openstep:=True:C214
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End