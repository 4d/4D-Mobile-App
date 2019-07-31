//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : swiftPM
  // Created #2019 by Eric Marchand
  // ----------------------------------------------------
  // Description: Call swift package manager function

  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters;$Lon_i)
C_TEXT:C284($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
C_OBJECT:C1216($Obj_in;$Obj_out)


If (False:C215)
	C_OBJECT:C1216(swiftPM ;$0)
	C_OBJECT:C1216(swiftPM ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Obj_out:=New object:C1471(\
		"success";False:C215)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Asserted:C1132($Obj_in.action#Null:C1517;"Missing the tag \"action\""))
	
	Case of 
			
			
			  //______________________________________________________
		: ($Obj_in.action="describe")
			
			If ($Obj_in.path#Null:C1517)
				Case of 
					: (Value type:C1509($Obj_in.path)=Is object:K8:27)  // suppose Folder
						$Obj_in.posix:=$Obj_in.path.path
					Else   // suppose string
						$Obj_in.posix:=Convert path system to POSIX:C1106($Obj_in.path)
						
				End case 
				
			End if 
			
			If ($Obj_in.posix#Null:C1517)
				
				$Txt_cmd:="swift package --package-path "+str_singleQuoted ($Obj_in.posix)+" describe --type json"
				
				LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
				
				If (Length:C16($Txt_error)=0)
					
					$Obj_out.package:=JSON Parse:C1218($Txt_out)
					$Obj_out.success:=True:C214
					
				Else 
					
					$Obj_out.error:=$Txt_error
					
				End if 
				
			Else 
				
				$Obj_out.errors:=New collection:C1472("path must be defined")
				
			End if 
			
			  //______________________________________________________
		: ($Obj_in.action="package")
			
			If ($Obj_in.path#Null:C1517)
				Case of 
					: (Value type:C1509($Obj_in.path)=Is object:K8:27)  // suppose Folder
						$Obj_in.posix:=$Obj_in.path.path
					Else   // suppose string
						$Obj_in.posix:=Convert path system to POSIX:C1106($Obj_in.path)
						
				End case 
				
			End if 
			
			If ($Obj_in.posix#Null:C1517)
				
				$Txt_cmd:="swift package --package-path "+str_singleQuoted ($Obj_in.posix)+" dump-package"
				
				LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
				
				If (Length:C16($Txt_error)=0)
					
					$Obj_out.package:=JSON Parse:C1218($Txt_out)
					$Obj_out.success:=True:C214
					
				Else 
					
					$Obj_out.error:=$Txt_error
					
				End if 
				
			Else 
				
				$Obj_out.errors:=New collection:C1472("path must be defined")
				
			End if 
			
			  //______________________________________________________
		: ($Obj_in.action="dependencies")
			
			If ($Obj_in.path#Null:C1517)
				Case of 
					: (Value type:C1509($Obj_in.path)=Is object:K8:27)  // suppose Folder
						$Obj_in.posix:=$Obj_in.path.path
					Else   // suppose string
						$Obj_in.posix:=Convert path system to POSIX:C1106($Obj_in.path)
						
				End case 
				
			End if 
			
			If ($Obj_in.posix#Null:C1517)
				
				$Txt_cmd:="swift package --package-path "+str_singleQuoted ($Obj_in.posix)+" show-dependencies --format json"
				
				LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
				
				If (Length:C16($Txt_error)=0)
					
					$Obj_out.dependencies:=JSON Parse:C1218($Txt_out)
					$Obj_out.success:=True:C214
					
				Else 
					
					$Obj_out.error:=$Txt_error
					
				End if 
				
			Else 
				
				$Obj_out.errors:=New collection:C1472("path must be defined")
				
			End if 
			
			  //______________________________________________________
		: ($Obj_in.action="toolsVersion")
			
			$Txt_cmd:="swift package tools-version"
			
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
			
			If (Length:C16($Txt_error)=0)
				
				$Obj_out.version:=$Txt_out
				$Obj_out.success:=True:C214
				
			Else 
				
				$Obj_out.error:=$Txt_error
				
			End if 
			
			  //________________________________________
		Else 
			
			ob_warning_add ($Obj_out;"Unknown type of file '"+String:C10($Obj_in.extension)+"'. Could not be added to final project")
			ASSERT:C1129(dev_Matrix ;"Unknown type of file "+String:C10($Obj_in.extension))
			$Obj_out.success:=False:C215
			
			  //________________________________________
	End case 
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End