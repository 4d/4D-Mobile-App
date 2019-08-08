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
C_TEXT:C284($Txt_buffer;$File_target;$Txt_ouput;$Txt_value)
C_OBJECT:C1216($Obj_;$Obj_comment;$Obj_in;$Obj_out)

If (False:C215)
	C_OBJECT:C1216(xloc ;$0)
	C_OBJECT:C1216(xloc ;$1)
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
		: ($Obj_in.action="create")
			
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
					$Obj_:=formatters (New object:C1471("action";"objectify";"value";$Obj_in.formatter.choiceList)).value
					
					
					$Obj_comment:=formatters (New object:C1471("action";"objectify";"value";$Obj_in.formatter.choiceListComment))
					
					  // Create localizable file data
					
					  // if format == "strings" (think about android, xliff, xloc package)
					
					$Txt_ouput:=""
					
					For each ($Txt_buffer;$Obj_)
						
						If ($Obj_comment.success)  // here comment from formatter, maybe add from context?
							$Txt_value:=Replace string:C233(String:C10($Obj_comment.value[$Txt_buffer]);"*/";"*-/")
							$Txt_ouput:=$Txt_ouput+$Obj_in.ld+"/* "+String:C10($Obj_comment.value[$Txt_buffer])+" */"
						End if 
						
						$Txt_value:=Replace string:C233(String:C10($Obj_[$Txt_buffer]);"\"";"\\\"")  // XXX maybe add some other encoding (must be tested)
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
					
					TEXT TO DOCUMENT:C1237($File_target;$Txt_ouput)
					
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