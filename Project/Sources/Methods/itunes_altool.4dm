//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : itunes_altool
  // Database: 4D Mobile Express
  // ID[97B746353E7C46B5ACE496B1RD9C0051]
  // Created 20-12-2017 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // https://help.apple.com/itc/apploader/#/apdATD1E53-D1E1A1303-D1E53A1126
  // ----------------------------------------------------
  // Declarations

C_OBJECT:C1216($Obj_in;$Obj_out)
C_TEXT:C284($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
C_TEXT:C284($Txt_xcodePath)

C_LONGINT:C283($Lon_parameters)

If (False:C215)
	C_OBJECT:C1216(itunes_altool ;$0)
	C_OBJECT:C1216(itunes_altool ;$1)
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
	
	$Obj_out:=New object:C1471("success";False:C215)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  // TEMP/TEST
$Txt_xcodePath:="/Applications/Xcode.app"  // TODO Get from config


  // ----------------------------------------------------

$Txt_cmd:=str_singleQuoted ($Txt_xcodePath+"/Contents/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Support/altool")

  // --validate-app or --upload-app
If (Bool:C1537($Obj_in.validate))
	$Txt_cmd:=$Txt_cmd+" --validate-app"
Else 
	$Txt_cmd:=$Txt_cmd+" --upload-app"
End if 

  // -f file 
$Txt_cmd:=$Txt_cmd+" -f "+str_singleQuoted ($Obj_in.path)  // TODO assert if not defined

  // -u username -p password

$Txt_cmd:=$Txt_cmd+" --output-format xml"  // xml or normal


LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)

  // TODO READ XML

$Obj_out.success:=Length:C16($Txt_error)=0

$Obj_out.output:=$Txt_out

If (Length:C16($Txt_error)=0)
	
	$Obj_out.errors:=$Txt_error
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End