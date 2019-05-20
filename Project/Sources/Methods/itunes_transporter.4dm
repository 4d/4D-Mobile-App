//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : itunes_transporter
  // Database: 4D Mobile Express
  // ID[97B746353E7C46B5ACE896B1RD9C0058]
  // Created #20-12-2017 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // Method to upload to itunes store
  // mode: verify, upload, provider, diagnostic, lookupMetadata,lookupArtist, status, statusAll,
  //       createMetadataTicket,queryTickets, generateSchema, transferTest,downloadMetadataGuides, 
  //       iTunesExtraQCDownload, iTunesLPQCDownload, listReports, requestReport


  // ----------------------------------------------------
  // Declarations

C_OBJECT:C1216($Obj_in;$Obj_out)
C_TEXT:C284($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
C_TEXT:C284($Txt_xcodePath)

C_LONGINT:C283($Lon_parameters)

If (False:C215)
	C_OBJECT:C1216(itunes_transporter ;$0)
	C_OBJECT:C1216(itunes_transporter ;$1)
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

$Obj_in.mode:="verify"

  // see https://github.com/fastlane/fastlane/blob/4d129bdb23aa73472a68d71124662a19c7c00eaf/fastlane_core/lib/fastlane_core/itunes_transporter.rb

  // ----------------------------------------------------

$Txt_cmd:=str_singleQuoted ($Txt_xcodePath+"/Contents/Applications/Application Loader.app/Contents/itms/bin/iTMSTransporter")

$Txt_cmd:=$Txt_cmd+" -m "+$Obj_in.mode


LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)


  // ERROR_REGEX = />\s*ERROR:\s+(.+)/
  // WARNING_REGEX=/>\s*WARN:\s+(.+)/
  // OUTPUT_REGEX=/>\s+(.+)/
  // RETURN_VALUE_REGEX = />\sDBG-X:\sReturning\s+(\d+)/

$Obj_out.success:=Length:C16($Txt_error)=0

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End