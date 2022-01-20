//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : colors
// Created 13-11-2017 by Eric Marchand
// ----------------------------------------------------

// Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Bool_errorInOut)
C_LONGINT:C283($Lon_parameters)
C_OBJECT:C1216($Obj_in; $Obj_out)
C_TEXT:C284($Txt_cmd; $Txt_in; $Txt_out; $Txt_error; $Txt_buffer)

If (False:C215)
	C_OBJECT:C1216(colors; $0)
	C_OBJECT:C1216(colors; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	// Required parameters
	$Obj_in:=$1
	
	// Optional parameters
	If ($Lon_parameters>=2)
		
		// <NONE>
		
	End if 
	
	$Obj_out:=New object:C1471(\
		"success"; False:C215)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Obj_in.action=Null:C1517)
		
		ASSERT:C1129(False:C215)
		
		// MARK:- juicer
	: ($Obj_in.action="juicer")
		
		$Txt_cmd:=str_singleQuoted(cs:C1710.path.new().scripts().file("colorjuicer").path)
		
		If ($Obj_in.posix=Null:C1517)
			
			If ($Obj_in.path#Null:C1517)
				
				$Obj_in.posix:=Convert path system to POSIX:C1106($Obj_in.path)
				
			End if 
		End if 
		
		If ($Obj_in.posix#Null:C1517)
			
			$Txt_cmd:=$Txt_cmd+" -i "+str_singleQuoted($Obj_in.posix)
			
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
			
			If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
				
				$Bool_errorInOut:=(Position:C15("error:"; $Txt_out)>0)
				If (Not:C34($Bool_errorInOut))
					
					Case of 
							
						: (Position:C15("{"; $Txt_out)=1)  // Check JSON (not really safe but better than nothing)
							
							$Obj_out.value:=JSON Parse:C1218($Txt_out).main
							
							If ($Obj_out.value#Null:C1517)
								
								$Obj_out.success:=True:C214
								$Obj_out.value.space:="srgb"
								
							Else 
								
								$Obj_out.errors:=New collection:C1472("No color")
								
							End if 
							
						Else 
							
							$Obj_out.success:=False:C215
							$Obj_out.errors:=New collection:C1472("No color")  // maybe white or black
							$Obj_out.out:=$Txt_out
							
					End case 
					
				Else 
					// out return an error message
					$Obj_out.success:=False:C215
					ob_error_add($Obj_out; $Txt_out)
					
				End if 
				
				If ((Length:C16($Txt_error)>0))  // add always error from command output if any, but do not presume if success or not
					ob_error_add($Obj_out; $Txt_error)
				End if 
				
			End if 
			
		Else 
			
			$Obj_out.errors:=New collection:C1472("path or posix must be defined")
			
		End if 
		
		// MARK:- contrast
	: ($Obj_in.action="contrast")
		
		If (Value type:C1509($Obj_in.color)=Is object:K8:27)
			
			// luminance
			$Obj_out.luma:=1-(((0.299*$Obj_in.color.red)+(0.587*$Obj_in.color.green)+(0.114*$Obj_in.color.blue))/255)
			
			If ($Obj_out.luma<0.5)
				
				$Obj_out.value:=New object:C1471(\
					"space"; "gray"; \
					"white"; 0)  // bright colors - black font
				
				$Obj_out.name:="black"
				
			Else 
				
				$Obj_out.value:=New object:C1471(\
					"space"; "gray"; \
					"white"; 255)  // dark colors - white font
				
				$Obj_out.name:="white"
				
			End if 
			
			$Obj_out.success:=True:C214
			
		Else 
			
			$Obj_out.errors:=New collection:C1472("color must be defined")
			
		End if 
		
		// MARK:- rgbtohex
	: ($Obj_in.action="rgbtohex")
		
		Case of 
				
				// ----------------------------------------
			: (Value type:C1509($Obj_in.color)=Is object:K8:27)
				
				Case of 
						
						//________________________________________
					: (Value type:C1509($Obj_in.color.white)=Is longint:K8:6)\
						 | (Value type:C1509($Obj_in.color.white)=Is real:K8:4)
						
						$Txt_buffer:=Replace string:C233(String:C10($Obj_in.color.white; "&x"); "0x00"; "")
						$Obj_out.value:="#"+$Txt_buffer+$Txt_buffer+$Txt_buffer
						$Obj_out.success:=True:C214
						
						//________________________________________
					: ((Value type:C1509($Obj_in.color.red)=Is real:K8:4)\
						 & (Value type:C1509($Obj_in.color.green)=Is real:K8:4)\
						 & (Value type:C1509($Obj_in.color.blue)=Is real:K8:4))\
						 | ((Value type:C1509($Obj_in.color.red)=Is integer:K8:5)\
						 & (Value type:C1509($Obj_in.color.green)=Is integer:K8:5)\
						 & (Value type:C1509($Obj_in.color.blue)=Is integer:K8:5))
						
						$Obj_out.value:="#"+Replace string:C233(String:C10($Obj_in.color.red; "&x"); "0x00"; "")+Replace string:C233(String:C10($Obj_in.color.green; "&x"); "0x00"; "")+Replace string:C233(String:C10($Obj_in.color.blue; "&x"); "0x00"; "")
						
						$Obj_out.success:=True:C214
						
						//________________________________________
					Else 
						
						$Obj_out.errors:=New collection:C1472("No red,blue,green or white defined")
						
						//________________________________________
				End case 
				
				// : (Value type($Obj_in.color)=Is string var) > parse rgb format
				
			Else 
				
				$Obj_out.errors:=New collection:C1472("No color in parameters")
				
				// ----------------------------------------
				
				//________________________________________
		End case 
		
		//________________________________________
End case 

// ----------------------------------------------------
// Return
$0:=$Obj_out

// ----------------------------------------------------
// End