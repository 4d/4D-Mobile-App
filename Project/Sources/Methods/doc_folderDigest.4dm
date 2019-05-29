//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : doc_folderDigest
  // Database: 4D Mobile Express
  // ID[4A08879383544E8DB4F07174D19035A1]
  // Created #5-10-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)

C_BLOB:C604($Blb_)
C_LONGINT:C283($Lon_i;$Lon_parameters)
C_TEXT:C284($Dir_tgt;$Txt_digest)

ARRAY TEXT:C222($tTxt_documents;0)
ARRAY TEXT:C222($tTxt_folders;0)

If (False:C215)
	C_TEXT:C284(doc_folderDigest ;$0)
	C_TEXT:C284(doc_folderDigest ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Dir_tgt:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
DOCUMENT LIST:C474($Dir_tgt;$tTxt_documents)

For ($Lon_i;1;Size of array:C274($tTxt_documents);1)
	
	DOCUMENT TO BLOB:C525($Dir_tgt+$tTxt_documents{$Lon_i};$Blb_)
	
	$Txt_digest:=$Txt_digest+Generate digest:C1147($Blb_;SHA1 digest:K66:2)
	
End for 

FOLDER LIST:C473($Dir_tgt;$tTxt_folders)

For ($Lon_i;1;Size of array:C274($tTxt_folders);1)
	
	$Txt_digest:=$Txt_digest+doc_folderDigest ($Dir_tgt+$tTxt_folders{$Lon_i}+Folder separator:K24:12)
	
End for 

$Txt_digest:=Generate digest:C1147($Txt_digest;SHA1 digest:K66:2)

  // ----------------------------------------------------
  // Return
$0:=$Txt_digest

  // ----------------------------------------------------
  // End