//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : Process_tags_on_file
  // Database: 4D Mobile Express
  // ID[961E38E50FBD4D6E8E23747083687D5C]
  // Created #2-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)
C_TEXT:C284($2)
C_OBJECT:C1216($3)
C_COLLECTION:C1488($4)

C_BLOB:C604($Blb_)
C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($File_src;$File_tgt;$Txt_content)
C_OBJECT:C1216($Obj_tags)
C_COLLECTION:C1488($Col_types)

If (False:C215)
	C_TEXT:C284(Process_tags_on_file ;$1)
	C_TEXT:C284(Process_tags_on_file ;$2)
	C_OBJECT:C1216(Process_tags_on_file ;$3)
	C_COLLECTION:C1488(Process_tags_on_file ;$4)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=4;"Missing parameters: file, tags, types"))
	
	  // Required parameters
	$File_src:=$1
	$File_tgt:=$2
	$Obj_tags:=$3
	$Col_types:=$4
	
	  // Optional parameters
	If ($Lon_parameters>=4)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Length:C16(String:C10($File_tgt))=0)
	$File_tgt:=$File_src  // edit in place
End if 

If (Test path name:C476($File_src)=Is a document:K24:1)
	
	  // Replace variable into contents
	  // ! without BOM
	DOCUMENT TO BLOB:C525($File_src;$Blb_)
	
	$Txt_content:=Process_tags (BLOB to text:C555($Blb_;UTF8 text without length:K22:17);$Obj_tags;$Col_types)
	
	CLEAR VARIABLE:C89($Blb_)
	
	TEXT TO BLOB:C554($Txt_content;$Blb_;UTF8 text without length:K22:17)
	
	CREATE FOLDER:C475($File_tgt;*)
	
	BLOB TO DOCUMENT:C526($File_tgt;$Blb_)
	
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End