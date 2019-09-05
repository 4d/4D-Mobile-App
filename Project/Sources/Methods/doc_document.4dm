//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : doc_document
  // ID[85FB47FDA8B1405BBFC3A8A374445BAF]
  // Created 23-10-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_invisible;$Boo_locked)
C_DATE:C307($Dat_created;$Dat_creation;$Dat_modified)
C_LONGINT:C283($Lon_i;$Lon_parameters)
C_TIME:C306($Gmt_created;$Gmt_creation;$Gmt_modified)
C_PICTURE:C286($Pic_icon)
C_TEXT:C284($Txt_buffer)
C_OBJECT:C1216($Obj_document;$Obj_file)

If (False:C215)
	C_OBJECT:C1216(doc_document ;$0)
	C_OBJECT:C1216(doc_document ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_document:=$1
	
	  // Default values
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Obj_document.success:=False:C215
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Obj_document.action=Null:C1517)
		
		TRACE:C157
		
		  //______________________________________________________
	: ($Obj_document.path=Null:C1517)
		
		TRACE:C157
		
		  //______________________________________________________
	: ($Obj_document.action="properties")
		
		GET DOCUMENT PROPERTIES:C477($Obj_document.path;$Boo_locked;$Boo_invisible;$Dat_creation;$Gmt_creation;$Dat_modified;$Gmt_modified)
		$Obj_document.creationDate:=String:C10($Dat_creation;ISO date GMT:K1:10;$Gmt_creation)
		$Obj_document.lastModification:=String:C10($Dat_modified;ISO date GMT:K1:10;$Gmt_modified)
		$Obj_document.locked:=$Boo_locked
		$Obj_document.invisible:=$Boo_invisible
		
		$Obj_document.size:=Get document size:C479($Obj_document.path)
		
		GET DOCUMENT ICON:C700($Obj_document.path;$Pic_icon)
		$Obj_file.icon:=$Pic_icon
		
		  //RESOLVE ALIAS($Obj_document.path;$Txt_buffer)
		  //$Obj_document.isAlias:=Bool(OK)
		$Obj_document.isAlias:=(Length:C16(doc_resolveAlias ($Obj_document.path))>0)
		
		  //______________________________________________________
	: ($Obj_document.action="isAlias")
		
		$Obj_document.success:=(Test path name:C476($Obj_document.path)=Is a document:K24:1)
		
		If ($Obj_document.success)
			
			  //RESOLVE ALIAS($Obj_document.path;$Txt_buffer)
			  //$Obj_document.isAlias:=Bool(OK)
			$Obj_document.isAlias:=(Length:C16(doc_resolveAlias ($Obj_document.path))>0)
			$Obj_document.targetPath:=$Txt_buffer
			
		Else 
			
			$Obj_document.isAlias:=False:C215
			$Obj_document.error:="File not found: \""+$Obj_document.path+"\""
			
		End if 
		
		  //______________________________________________________
	: ($Obj_document.action="volume")
		
		ARRAY LONGINT:C221($tLon_lengths;0x0000)
		ARRAY LONGINT:C221($tLon_positions;0x0000)
		
		If (Match regex:C1019("(?mi-s)^\\W*(?:([^:]{1,}:)\\\\[^\\n]*)|(?:\\\\{2}([^\\\\]*)\\\\)|(?:([^:]*):){1}[^\\$]*$";$Obj_document.path;1;$tLon_positions;$tLon_lengths))
			
			For ($Lon_i;1;Size of array:C274($tLon_lengths);1)
				
				If ($tLon_positions{$Lon_i}>0)
					
					$Obj_document.volume:=Substring:C12($Obj_document.path;$tLon_positions{$Lon_i};$tLon_lengths{$Lon_i})
					$Obj_document.success:=True:C214
					
					$Lon_i:=MAXLONG:K35:2-1
					
				End if 
			End for 
		End if 
		
		  //______________________________________________________
	: ($Obj_document.action="copy")
		
		ASSERT:C1129($Obj_document.src#Null:C1517)
		
		$Obj_document.action:="delete"
		$Obj_document.success:=doc_document ($Obj_document).success
		
		If ($Obj_document.success)
			
			COPY DOCUMENT:C541($Obj_document.src;$Obj_document.path;*)
			
		End if 
		
		  //______________________________________________________
	: ($Obj_document.action="delete")
		
		$Obj_document.success:=(Test path name:C476($Obj_document.path)#Is a document:K24:1)
		
		If (Not:C34($Obj_document.success))
			
			$Obj_document.action:="unlock"
			$Obj_document.success:=doc_document ($Obj_document).success
			
			If ($Obj_document.success)
				
				DELETE DOCUMENT:C159($Obj_document.path)
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($Obj_document.action="unlock")
		
		GET DOCUMENT PROPERTIES:C477($Obj_document.path;$Boo_locked;$Boo_invisible;$Dat_created;$Gmt_created;$Dat_modified;$Gmt_modified)
		
		If ($Boo_locked)
			
			SET DOCUMENT PROPERTIES:C478($Obj_document.path;False:C215;$Boo_invisible;$Dat_created;$Gmt_created;$Dat_modified;$Gmt_modified)
			
		End if 
		
		GET DOCUMENT PROPERTIES:C477($Obj_document.path;$Boo_locked;$Boo_invisible;$Dat_created;$Gmt_created;$Dat_modified;$Gmt_modified)
		
		$Obj_document.success:=Not:C34($Boo_locked)
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Obj_document.action+"\"")
		
		  //______________________________________________________
End case 

OB REMOVE:C1226($Obj_document;"action")

  // ----------------------------------------------------
  // Return
$0:=$Obj_document

  // ----------------------------------------------------
  // End