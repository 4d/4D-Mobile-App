//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : unzip
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_OBJECT:C1216($Obj_param; $Obj_result; $file; $archive; $target; $memberFile; $cache)

If (False:C215)
	C_OBJECT:C1216(unzip; $0)
	C_OBJECT:C1216(unzip; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	// Required parameters
	$Obj_param:=$1
	
	// Optional parameters
	If ($Lon_parameters>=2)
		
		// <NONE>
		
	End if 
	
	$Obj_result:=New object:C1471(\
		"success"; False:C215)
	
Else 
	
	ABORT:C156
	
End if 

// get file from parameters
Case of 
	: (Value type:C1509($Obj_param.file)=Is object:K8:27)
		
		If (OB Instance of:C1731($Obj_param.file; 4D:C1709.File))
			$file:=$Obj_param.file
		End if 
		
	: (Value type:C1509($Obj_param.file)=Is text:K8:3)
		$file:=File:C1566($Obj_param.file; fk platform path:K87:2)
	Else 
		
End case 

// unzip the archive
If (Asserted:C1132($file#Null:C1517; "Missing tag file"))
	If (Asserted:C1132($file.exists; "file to unzip not found"))
		
		
		$archive:=ZIP Read archive:C1637($file)
		
		Case of 
				
				//________________________________________
			: ($Obj_param.target#Null:C1517)
				
				// get target as file
				$target:=Null:C1517
				Case of 
					: (Value type:C1509($Obj_param.target)=Is object:K8:27)
						If (OB Instance of:C1731($Obj_param.target; 4D:C1709.Folder))
							$target:=$Obj_param.target
						End if 
					: (Value type:C1509($Obj_param.target)=Is text:K8:3)
						$target:=Folder:C1567($Obj_param.target; fk platform path:K87:2)
					Else 
						// null
				End case 
				
				$cache:=Null:C1517
				Case of 
					: (Value type:C1509($Obj_param.cache)=Is object:K8:27)
						If (OB Instance of:C1731($Obj_param.cache; 4D:C1709.Folder))
							$cache:=$Obj_param.cache
						End if 
					: (Value type:C1509($Obj_param.cache)=Is text:K8:3)
						
						If (Length:C16($Obj_param.cache)>0)
							$cache:=Folder:C1567($Obj_param.cache; fk platform path:K87:2)
						End if 
					Else 
						// null
				End case 
				
				
				If ($cache#Null:C1517)
					
					If (Not:C34($cache.exists))
						
						$cache.create()
						
						// Create the cache
						$archive.root.copyTo($cache)
						$Obj_result.success:=True:C214
						
					Else 
						
						$Obj_result.success:=True:C214  // do the copy
						
					End if 
					
					If ($Obj_result.success)
						
						$cache.copyTo($target)
						
					End if 
					
				Else 
					
					$archive.root.copyTo($target)
					
				End if 
				
				//________________________________________
			: ($Obj_param.members#Null:C1517)  // ie read file content
				
				$memberFile:=$archive.root.file($Obj_param.members)
				If ($memberFile.exists)
					$Obj_result.success:=True:C214
					$Obj_result.out:=$memberFile.getText()
				Else 
					$Obj_result.success:=False:C215
					$Obj_result.error:="member "+String:C10($Obj_param.members)+" do not exists in archive"
				End if 
				//________________________________________
		End case 
		
	End if 
End if 

// ----------------------------------------------------
// Return
$0:=$Obj_result

// ----------------------------------------------------
// End