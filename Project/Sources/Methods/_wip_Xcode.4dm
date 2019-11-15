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

C_LONGINT:C283($l)
C_TEXT:C284($Txt_cmd;$Txt_error;$Txt_in;$Txt_out)
C_OBJECT:C1216($folder;$o;$Obj_result)

If (False:C215)
	C_OBJECT:C1216(_wip_Xcode ;$0)
	C_TEXT:C284(_wip_Xcode ;$1)
	C_OBJECT:C1216(_wip_Xcode ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)  // Constructor
	
	$o:=New object:C1471(\
		"";"Xcode";\
		"success";True:C214;\
		"openAppStore";Formula:C1597(OPEN URL:C673(Get localized string:C991("appstore_xcode");*));\
		"defaultPath";Formula:C1597(_wip_Xcode ("defaultPath").value);\
		"path";Formula:C1597(_wip_Xcode ("path").value);\
		"toolsPath";Formula:C1597(_wip_Xcode ("toolsPath").value);\
		"isDefaultPath";Formula:C1597(_wip_Xcode ("isDefaultPath").value);\
		"paths";Formula:C1597(_wip_Xcode ("paths").value);\
		"lastpath";Formula:C1597(_wip_Xcode ("lastpath").value)\
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
			
			$o.value:=Folder:C1567("/Applications/Xcode.app")
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
			
			  // Return by default the default path,
			  // and if not exist the tool path,
			  // and if not exist one of the path found by spotlight. The last version.
			
			$folder:=$o.defaultPath()
			
			If (Not:C34($folder.exists))
				
				$folder:=$o.toolsPath()
				
				If ($folder.exists)
					
					$o.value:=$folder.value.parent.parent
					
				Else 
					
					$folder:=$o.lastpath()
					
				End if 
			End if 
			
			  //______________________________________________________
		: ($1="paths")
			
			  // Get all installed xcode using spotlight
			
			$Txt_cmd:="mdfind \"kMDItemCFBundleIdentifier == 'com.apple.dt.Xcode'\""
			
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
			
			If (Asserted:C1132(OK=1;"Get paths failed: "+$Txt_cmd))
				
				If ((Length:C16($Txt_error)=0)\
					 & (Length:C16($Txt_out)#0))
					
					$o.value:=New collection:C1472
					
					Repeat 
						
						$l:=Position:C15("\n";$Txt_out)
						
						If ($l#0)
							
							$o.value.push(Folder:C1567(Substring:C12($Txt_out;1;$l-1)))
							$Txt_out:=Substring:C12($Txt_out;$l+1)
							
						End if 
					Until ($l=0)
					
					$o.success:=True:C214
					
				Else 
					
					$o.error:=Choose:C955(Length:C16($Txt_error)=0;"No Xcode installed";$Txt_error)
					
				End if 
			End if 
			
			  //______________________________________________________
		: ($1="lastpath")
			
			$o:=$o.paths()
			
			If ($o.success)
				
				  //For each ($folder;$o.value)
				
				  //$Obj_result:=Xcode (New object(\
										"action";"version";\
										"posix";$folder.path))
				
				  //If ($Obj_result.success)
				
				  //If (str_cmpVersion (String($Obj_result.version);$Txt_buffer)>=0)  // Equal or higher
				
				  //$o.value:=new object(\
										"version";String($Obj_result.version);\
										"";;;\
										"";;;\
										"";;\
										)
				  //$Obj_result.version:=$Txt_buffer
				  //$Obj_result.posix:=$t
				  //$Obj_result.path:=Convert path POSIX to system($Obj_result.posix)
				  //$Obj_result.success:=True
				
				  //End if
				  //End if
				  //End for each
				
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