//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : Xcode
  // ID[97EABBBAC0374F59B13F13F2CFDC4D1D]
  // Created 25-10-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_TEXT:C284($Txt_cmd;$Txt_error;$Txt_in;$Txt_out)
C_OBJECT:C1216($o)

If (False:C215)
	C_OBJECT:C1216(_iw_Xcode ;$0)
	C_TEXT:C284(_iw_Xcode ;$1)
	C_OBJECT:C1216(_iw_Xcode ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)  // Constructor
	
	$o:=New object:C1471(\
		"";"Xcode";\
		"success";True:C214;\
		"openAppStore";Formula:C1597(OPEN URL:C673(Get localized string:C991("appstore_xcode");*));\
		"defaultPath";Formula:C1597(_iw_Xcode ("defaultPath").value);\
		"path";Formula:C1597(_iw_Xcode ("path").value);\
		"toolsPath";Formula:C1597(_iw_Xcode ("toolsPath").value);\
		"isDefaultPath";Formula:C1597(_iw_Xcode ("isDefaultPath").value)\
		)
	
Else 
	
	$o:=This:C1470
	$o.success:=False:C215
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="defaultPath")
			
			$o.value:=File:C1566("/Applications/Xcode.app")
			$o.success:=True:C214
			
			  //______________________________________________________
		: ($1="toolsPath")
			
			$Txt_cmd:="xcode-select --print-path"
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
			
			If (Asserted:C1132(OK=1;"LEP failed: "+$Txt_cmd))
				
				If (Length:C16($Txt_out)>0)
					
					$o.success:=True:C214
					$o.value:=Folder:C1567(Replace string:C233($Txt_out;"\n";""))
					
				Else 
					
					$o.error:=$Txt_error
					
				End if 
			End if 
			
			  //______________________________________________________
		: ($1="path")
			
			  // return by default the default path,
			  // and if not exist the tool path,
			  // and if not exist one of the path found by spotlight. The last version.
			
			$o:=$o.defaultPath()
			
			If ($o.exists)
				
			Else 
				
				  // A "If" statement should never omit "Else"
				
			End if 
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
			
			  //______________________________________________________
	End case 
End if 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End