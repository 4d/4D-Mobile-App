//%attributes = {"invisible":true}
#DECLARE($File_src : Variant; $File_tgt : Variant; $Obj_tags : Object; $Col_types : Collection)
// ----------------------------------------------------
// Project method : Process_tags_on_file
// ID[961E38E50FBD4D6E8E23747083687D5C]
// Created 2-8-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations

C_BLOB:C604($x)
C_TEXT:C284($Txt_content)
C_OBJECT:C1216($Obj_tags)
C_COLLECTION:C1488($Col_types)

If (False:C215)
	C_VARIANT:C1683(Process_tags_on_file; $1)
	C_VARIANT:C1683(Process_tags_on_file; $2)
	C_OBJECT:C1216(Process_tags_on_file; $3)
	C_COLLECTION:C1488(Process_tags_on_file; $4)
End if 

// ----------------------------------------------------
// Initialisations

$File_src:=FileFrom($File_src)

If (($File_tgt=Null:C1517) || ((Value type:C1509($File_tgt)=Is text:K8:3) && (Length:C16($File_tgt)=0)))  // XXX is it necessary?
	
	$File_tgt:=$File_src  // edit in place
	
Else 
	
	$File_tgt:=FileFrom($File_tgt)
	
End if 


// ----------------------------------------------------
If (TestPathName($File_src.platformPath)=Is a document:K24:1)  // Just in case of folder with same name?
	
	If (Feature.with("buildWithCmd"))
		
		$x:=$File_src.getContent()
		
		$Txt_content:=Process_tags(BLOB to text:C555($x; UTF8 text without length:K22:17); $Obj_tags; $Col_types)
		
		CLEAR VARIABLE:C89($x)
		
		TEXT TO BLOB:C554($Txt_content; $x; UTF8 text without length:K22:17)
		
		$File_tgt.parent.create()
		
		$File_tgt.setContent($x)
		
	Else 
		// Replace variable into contents
		// ! without BOM
		DOCUMENT TO BLOB:C525($File_src.platformPath; $x)
		
		$Txt_content:=Process_tags(BLOB to text:C555($x; UTF8 text without length:K22:17); $Obj_tags; $Col_types)
		
		CLEAR VARIABLE:C89($x)
		
		TEXT TO BLOB:C554($Txt_content; $x; UTF8 text without length:K22:17)
		
		CREATE FOLDER:C475($File_tgt.platformPath; *)
		
		BLOB TO DOCUMENT:C526($File_tgt.platformPath; $x)
		
	End if 
	
End if 