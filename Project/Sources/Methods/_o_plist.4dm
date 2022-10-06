//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($Obj_in : Object)->$Obj_out : Object
// ----------------------------------------------------
// Project method : plist
// ID[B8934F6DFF59468399DDA49E6FB2173F]
// Created 29-6-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:

// ----------------------------------------------------
// Declarations

C_BOOLEAN:C305($Bool_errorInOut; $Bool_ReplaceLS)
C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($format; $Txt_cmd; $Txt_error; $Txt_in; $Txt_out)
C_OBJECT:C1216($Obj_in; $Obj_out)

If (False:C215)
	C_OBJECT:C1216(_o_plist; $0)
	C_OBJECT:C1216(_o_plist; $1)
End if 

// ----------------------------------------------------
// Initialisations


$Obj_out:=New object:C1471("success"; False:C215)


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
		
		// MARK: - convert
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
				
				ASSERT:C1129(False:C215; "format must be xml1, xml, binary1, binary, json or open step for action : \""+$Obj_in.action+"\"")
				$Txt_cmd:=""
				
			Else 
				
				$Txt_cmd:=$Txt_cmd+" -convert "+$format
				
			End if 
			
			If ($format="openstep")
				
				$Txt_cmd:=str_singleQuoted(cs:C1710.path.new().scripts().file("xprojstep").path)
				
				If (String:C10($Obj_in.project)#"")
					//$Txt_cmd:=$Txt_cmd+" --projectName "+singleQuote ($Obj_in.project)
				End if 
				
				If (String:C10($Obj_in.output)#"")
					//$Txt_cmd:=$Txt_cmd+" --output "+singleQuote ($Obj_in.project)
				End if 
				
			Else 
				
				$Txt_cmd:=Choose:C955($Obj_in.output#Null:C1517; $Txt_cmd+" -o "+str_singleQuoted($Obj_in.output); $Txt_cmd+" -o -")  // stdout
				
			End if 
			
			$Txt_cmd:=$Txt_cmd+" "+str_singleQuoted($Obj_in.domain)
			
		Else 
			
			ASSERT:C1129(False:C215; "domain and format must be defined for action : \""+$Obj_in.action+"\"")
			$Txt_cmd:=""
			
		End if 
		
		// MARK: - object: cs.simctl, cs.Storyboard, XcodeProj
	: ($Obj_in.action="object")
		
		If ($Obj_in.domain#Null:C1517)
			
			// read all as json
			$Obj_out:=_o_plist(New object:C1471("action"; "convert"; "format"; "json"; "domain"; $Obj_in.domain))
			
			//End if
			
			// then convert
			If ($Obj_out.success)
				
				$Obj_out.json:=$Obj_out.value
				
				If (Length:C16($Obj_out.value)>0)
					
					$Obj_out.value:=JSON Parse:C1218($Obj_out.value)
					
				End if 
				
			End if 
			
		Else 
			
			ASSERT:C1129(False:C215; "domain must be defined for action : \""+$Obj_in.action+"\"")
			
		End if 
		
		// MARK: - fromobject: XcodeProj, Xcode, capabilities
	: ($Obj_in.action="fromobject")
		
		If ($Obj_in.domain=Null:C1517)
			
			$Obj_in.domain:=$Obj_in.output
			
		End if 
		
		If (($Obj_in.domain#Null:C1517) & ($Obj_in.object#Null:C1517))
			
			//TEXT TO DOCUMENT(Convert path POSIX to system($Obj_in.domain); JSON Stringify($Obj_in.object; *))
			File:C1566(Convert path POSIX to system:C1107($Obj_in.domain); fk platform path:K87:2).setText(JSON Stringify:C1217($Obj_in.object; *))
			
			If ($Obj_in.format#Null:C1517)
				
				If ($Obj_in.format="openstep")
					
					$Obj_in.format:="xml1"  // convert to xml before
					$Obj_in.openstep:=True:C214
					
				End if 
				
				$Obj_in.action:="convert"
				$Obj_in.output:=$Obj_in.domain
				$Obj_out:=_o_plist($Obj_in)
				
			Else 
				
				$Obj_out.success:=True:C214  // XXX to ON ERR CALL for TEXT TO DOCUMENT to check...
				
			End if 
			
		Else 
			
			ASSERT:C1129(False:C215; "domain/output and object must be defined for action : \""+$Obj_in.action+"\"")
			
		End if 
		
		// MARK: - obsoletes
	: ($Obj_in.action="read") || ($Obj_in.action="command") || ($Obj_in.action="extract") || ($Obj_in.action="write") || ($Obj_in.action="insert") || ($Obj_in.action="replace") || ($Obj_in.action="delete") || ($Obj_in.action="remove") || ($Obj_in.action="find")
		
		ASSERT:C1129(False:C215; Current method name:C684+":"+$Obj_in.action+" obsolete")
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$Obj_in.action+"\"")
		
		//______________________________________________________
End case 

If (Length:C16($Txt_cmd)>0)
	
	LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
	
	If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
		
		$Bool_errorInOut:=(Position:C15("Error domain"; $Txt_out)>0)\
			 | (Position:C15("Permission denied"; $Txt_out)>0)\
			 | (Position:C15("invalid object in plist"; $Txt_out)>0)
		
		If (Not:C34($Bool_errorInOut))
			
			$Bool_errorInOut:=(Position:C15("error:"; $Txt_out)>0)
			
		End if 
		
		If ((Length:C16($Txt_error)=0) & Not:C34($Bool_errorInOut))
			
			$Obj_out.success:=True:C214
			$Obj_out.value:=Choose:C955($Bool_ReplaceLS; Replace string:C233($Txt_out; "\n"; ""); $Txt_out)
			
			// XXX maybe for some action remove $Obj_result.value if empty
			
		Else 
			
			$Obj_out.success:=False:C215
			$Obj_out.error:=$Txt_error
			
			If ($Bool_errorInOut)
				
				$Obj_out.error:=$Obj_out.error+$Txt_out
				
			End if 
			
			If (String:C10($Obj_in.format)="openstep")
				
				If (Position:C15("libswiftCore.dylib"; $Obj_out.error)>0)
					
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
	$Obj_out:=_o_plist($Obj_in)  // $Obj_result:= ?
	$Obj_in.openstep:=True:C214
	
End if 

// ----------------------------------------------------
// End