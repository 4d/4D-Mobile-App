//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : xloc
// Created 2018 by Eric Marchand
// ----------------------------------------------------
// Description: All about Xcode localization file
//
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_buffer; $File_target; $Txt_ouput; $Txt_value)
C_OBJECT:C1216($Obj_; $Obj_comment; $Obj_in; $Obj_out)

If (False:C215)
	C_OBJECT:C1216(xloc; $0)
	C_OBJECT:C1216(xloc; $1)
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

// Default values
If (Length:C16(String:C10($Obj_in.ld))=0)
	
	$Obj_in.ld:="\n"  // default line delimiter
	
End if 

If (Length:C16(String:C10($Obj_in.file))=0)
	
	$Obj_in.file:="Localizable"  // default file name
	
End if 

If (Length:C16(String:C10($Obj_in.lang))=0)
	
	$Obj_in.lang:="en"  // default lang
	
End if 


// ----------------------------------------------------
If (Asserted:C1132($Obj_in.action#Null:C1517; "Missing the tag \"action\""))
	
	Case of 
		// MARK:- dataModel
		: ($Obj_in.action="dataModel")
			Case of 
					
					//----------------------------------------
				: (Value type:C1509($Obj_in.dataModel)#Is object:K8:27)
					
					$Obj_out.errors:=New collection:C1472("No dataModel defined to create an xcode localization file")
					
					//----------------------------------------
				: (Value type:C1509($Obj_in.output)#Is object:K8:27)
					
					$Obj_out.errors:=New collection:C1472("No output file defined to create an xcode localization file")
					
				Else 
					
					$Txt_ouput:=$Obj_in.ld
					var $table; $field : Object
					var $tableId; $fieldId : Text
					var $tableName; $fieldName : Text
					
					For each ($tableId; $Obj_in.dataModel)
						$table:=$Obj_in.dataModel[$tableId]
						
						$tableName:=formatString("table-name"; $table[""].name)
						
						If (Length:C16(String:C10($table[""].label))>0)
							$Txt_ouput:=$Txt_ouput+"\"Entity/"+$tableName+"\" = \""+$table[""].label+"\";"+$Obj_in.ld
						End if 
						If (Length:C16(String:C10($table[""].shortLabel))>0)
							$Txt_ouput:=$Txt_ouput+"\"Entity/"+$tableName+"@short \" = \""+$table[""].shortLabel+"\";"+$Obj_in.ld
						End if 
						
						For each ($fieldId; $table)
							If ($fieldId#"")
								If (Value type:C1509($table[$fieldId])=Is object:K8:27)
									$field:=$table[$fieldId]
									
									$fieldName:=formatString("field-name"; $field.name)
									
									If (Length:C16(String:C10($field.shortLabel))>0)
										$Txt_ouput:=$Txt_ouput+"\"Property/"+$fieldName+"/Entity/"+$tableName+"\" = \""+$field.label+"\";"+$Obj_in.ld
									End if 
									If (Length:C16(String:C10($field.shortLabel))>0)
										$Txt_ouput:=$Txt_ouput+"\"Property/"+$fieldName+"/Entity/"+$tableName+"@short\" = \""+$field.shortLabel+"\";"+$Obj_in.ld
									End if 
								End if 
							End if 
						End for each 
						
					End for each 
					
					$Obj_in.output.setText($Txt_ouput; "UTF-8"; Document with LF:K24:22)
					
					// to inject in project file
					$Obj_out.children:=New collection:C1472(New object:C1471("target"; $Obj_in.output.platformPath; "types"; New collection:C1472("strings")))
					
					$Obj_out.success:=True:C214
					
			End case 
			
		// MARK:- create
		: (($Obj_in.action="create") | ($Obj_in.action="formatter"))
			
			Case of 
					
					//----------------------------------------
				: (Value type:C1509($Obj_in.formatter)#Is object:K8:27)
					
					$Obj_out.errors:=New collection:C1472("No formatter defined to create an xcode files")
					
					//----------------------------------------
				: (Test path name:C476(String:C10($Obj_in.target))#Is a folder:K24:2)
					
					$Obj_out.errors:=New collection:C1472("Target is not a folder: "+String:C10($Obj_in.target))
					
					//----------------------------------------
				: (Length:C16(String:C10($Obj_in.formatter.name))=0)
					
					$Obj_out.errors:=New collection:C1472("No formatter name defined."+JSON Stringify:C1217($Obj_in.formatter))
					
					
					//----------------------------------------
				Else 
					
					// Get choice list in object format
					
					var $choiceList : Variant
					$choiceList:=$Obj_in.formatter.choiceList
					If (Value type:C1509($choiceList)=Is object:K8:27)
						
						// special case for boolean defined by false/true string
						var $isBooleanType : Boolean
						$isBooleanType:=False:C215
						Case of 
							: (Value type:C1509($Obj_in.formatter.type)=Is text:K8:3)
								$isBooleanType:=$Obj_in.formatter.type="boolean"
							: (Value type:C1509($Obj_in.formatter.type)=Is collection:K8:32)
								If ($Obj_in.formatter.type.length=1)
									$isBooleanType:=$Obj_in.formatter.type[0]="boolean"
								End if 
								// Else false
						End case 
						If ($isBooleanType)
							If ($choiceList["0"]=Null:C1517)
								$choiceList["0"]:=$choiceList["false"]
							End if 
							If ($choiceList["1"]=Null:C1517)
								$choiceList["1"]:=$choiceList["true"]
							End if 
						End if 
						
						$Obj_:=$choiceList
						
					Else 
						$Obj_:=formatters(New object:C1471("action"; "objectify"; "value"; $choiceList)).value
					End if 
					
					$Obj_comment:=formatters(New object:C1471("action"; "objectify"; "value"; $Obj_in.formatter.choiceListComment))
					
					// Create localizable file data
					
					// if format == "strings" (think about android, xliff, xloc package)
					
					$Txt_ouput:=""
					
					For each ($Txt_buffer; $Obj_)
						
						If ($Obj_comment.success)  // here comment from formatter, maybe add from context?
							$Txt_value:=Replace string:C233(String:C10($Obj_comment.value[$Txt_buffer]); "*/"; "*-/")
							$Txt_ouput:=$Txt_ouput+$Obj_in.ld+"/* "+String:C10($Obj_comment.value[$Txt_buffer])+" */"
						End if 
						
						$Txt_value:=Replace string:C233(String:C10($Obj_[$Txt_buffer]); "\""; "\\\"")  // XXX maybe add some other encoding (must be tested)
						$Txt_ouput:=$Txt_ouput+$Obj_in.ld+"\""+$Obj_in.formatter.name+"_"+$Txt_buffer+"\" = \""+$Txt_value+"\";"
						
					End for each 
					
					// Write to a localizable file
					
					//If (Position(".lproj";$Obj_in.target;Length($Obj_in.target)-6)>0)
					
					$File_target:=$Obj_in.target+$Obj_in.file+".strings"  // already a lang folder
					
					//Else 
					
					//$File_target:=$Obj_in.target+$Obj_in.lang+".lproj"+Folder separator+$Obj_in.file+".strings"
					//CREATE FOLDER($File_target;*)
					
					//End if 
					
					/// append mode
					If (Bool:C1537($Obj_in.append)\
						 & (Test path name:C476($File_target)=Is a document:K24:1))
						
						$Txt_ouput:=Document to text:C1236($File_target)+$Obj_in.ld+$Txt_ouput
						
					End if 
					
					TEXT TO DOCUMENT:C1237($File_target; $Txt_ouput)
					
					$Obj_out.target:=$File_target
					$Obj_out.ouput:=$Txt_ouput
					$Obj_out.success:=True:C214
					
					//----------------------------------------
			End case 
			
			
			//________________________________________
		Else 
			
			$Obj_out.errors:=New collection:C1472("Unknown action "+$Obj_in.action)
			
			//________________________________________
	End case 
End if 

// ----------------------------------------------------
// Return
$0:=$Obj_out

// ----------------------------------------------------
// End