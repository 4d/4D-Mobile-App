//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : publishedTableList
  // Database: 4D Mobile App
  // ID[892090D3E24D425C9269C91077BE4BCD]
  // Created #21-3-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($i;$Lon_parameters)
C_PICTURE:C286($Pic_buffer)
C_TEXT:C284($Dir_hostRoot;$Dir_root;$File_;$Txt_tableNumber)
C_OBJECT:C1216($Obj_dataModel;$Obj_in;$Obj_out;$Obj_table)

If (False:C215)
	C_OBJECT:C1216(publishedTableList ;$0)
	C_OBJECT:C1216(publishedTableList ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // <NO PARAMETERS REQUIRED>
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Obj_in:=$1
		
	End if 
	
	$Obj_out:=New object:C1471(\
		"success";$Obj_in.dataModel#Null:C1517)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($Obj_out.success)
	
	$Obj_dataModel:=$Obj_in.dataModel
	
	$Dir_root:=COMPONENT_Pathname ("tableIcons").platformPath
	$Dir_hostRoot:=COMPONENT_Pathname ("host_tableIcons").platformPath
	
	If (Bool:C1537($Obj_in.asCollection))  // List to use with a collection listbox
		
		$Obj_out.tables:=New collection:C1472
		
		For each ($Txt_tableNumber;$Obj_dataModel)
			
			$Obj_table:=New object:C1471(\
				"tableNumber";Num:C11($Txt_tableNumber);\
				"name";$Obj_dataModel[$Txt_tableNumber].name)
			
			If ($Obj_dataModel[$Txt_tableNumber].label=Null:C1517)
				
				$Obj_dataModel[$Txt_tableNumber].label:=formatString ("label";$Obj_dataModel[$Txt_tableNumber].name)
				
			End if 
			
			$Obj_table.label:=$Obj_dataModel[$Txt_tableNumber].label
			
			If ($Obj_dataModel[$Txt_tableNumber].shortLabel=Null:C1517)
				
				$Obj_dataModel[$Txt_tableNumber].shortLabel:=$Obj_dataModel[$Txt_tableNumber].label
				
			End if 
			
			$Obj_table.shortLabel:=$Obj_dataModel[$Txt_tableNumber].shortLabel
			
			If ($Obj_dataModel[$Txt_tableNumber].filter#Null:C1517)
				
				$Obj_table.filter:=Choose:C955(Value type:C1509($Obj_dataModel[$Txt_tableNumber].filter)=Is text:K8:3;New object:C1471(\
					"string";$Obj_dataModel[$Txt_tableNumber].filter);\
					$Obj_dataModel[$Txt_tableNumber].filter)
				
			End if 
			
			$Obj_table.embedded:=Bool:C1537($Obj_dataModel[$Txt_tableNumber].embedded)
			
			$Obj_table.iconPath:=String:C10($Obj_dataModel[$Txt_tableNumber].icon)
			
			If (Length:C16($Obj_table.iconPath)=0)
				
				$File_:=ui.noIcon
				
			Else 
				
				If (Position:C15("/";String:C10($Obj_dataModel[$Txt_tableNumber].icon))=1)  // User resource
					
					$File_:=$Dir_hostRoot+Replace string:C233(String:C10($Obj_dataModel[$Txt_tableNumber].icon);"/";Folder separator:K24:12)
					
					If (Test path name:C476($File_)#Is a document:K24:1)
						
						$File_:=ui.errorIcon
						
					End if 
					
				Else 
					
					$File_:=$Dir_root+Replace string:C233(String:C10($Obj_dataModel[$Txt_tableNumber].icon);"/";Folder separator:K24:12)
					
					If (Test path name:C476($File_)#Is a document:K24:1)
						
						$File_:=ui.noIcon
						
					End if 
				End if 
			End if 
			
			READ PICTURE FILE:C678($File_;$Pic_buffer)
			
			CREATE THUMBNAIL:C679($Pic_buffer;$Pic_buffer;24;24;Scaled to fit:K6:2)
			$Obj_table.icon:=$Pic_buffer
			
			$Obj_out.tables.push($Obj_table)
			
		End for each 
		
	Else   // Old mechanism
		
		$Obj_out.ids:=New collection:C1472
		$Obj_out.names:=New collection:C1472
		$Obj_out.labels:=New collection:C1472
		$Obj_out.shortLabels:=New collection:C1472
		$Obj_out.iconPaths:=New collection:C1472
		$Obj_out.icons:=New collection:C1472
		
		For each ($Txt_tableNumber;$Obj_dataModel)
			
			$Obj_table:=$Obj_dataModel[$Txt_tableNumber]
			
			$Obj_out.ids[$i]:=Num:C11($Txt_tableNumber)
			$Obj_out.names[$i]:=$Obj_table.name
			
			If ($Obj_table.label=Null:C1517)
				
				$Obj_table.label:=formatString ("label";$Obj_table.name)
				
			End if 
			
			$Obj_out.labels[$i]:=$Obj_table.label
			
			If ($Obj_table.shortLabel=Null:C1517)
				
				$Obj_table.shortLabel:=$Obj_table.label
				
			End if 
			
			$Obj_out.shortLabels[$i]:=$Obj_table.shortLabel
			
			$Obj_out.iconPaths[$i]:=String:C10($Obj_table.icon)
			
			If (Length:C16($Obj_out.iconPaths[$i])=0)
				
				$File_:=ui.noIcon
				
			Else 
				
				If (Position:C15("/";String:C10($Obj_table.icon))=1)  // User resource
					
					  //$File_:=$Dir_hostRoot+Replace string(String($Obj_table.icon);"/";Folder separator)
					$File_:=$Dir_hostRoot+Replace string:C233(String:C10(Delete string:C232($Obj_table.icon;1;1));"/";Folder separator:K24:12)
					
					If (Test path name:C476($File_)#Is a document:K24:1)
						
						$File_:=ui.errorIcon
						
					End if 
					
				Else 
					
					$File_:=$Dir_root+Replace string:C233(String:C10($Obj_table.icon);"/";Folder separator:K24:12)
					
					If (Test path name:C476($File_)#Is a document:K24:1)
						
						$File_:=ui.noIcon
						
					End if 
				End if 
			End if 
			
			READ PICTURE FILE:C678($File_;$Pic_buffer)
			
			CREATE THUMBNAIL:C679($Pic_buffer;$Pic_buffer;24;24;Scaled to fit:K6:2)
			$Obj_out.icons[$i]:=$Pic_buffer
			
			$i:=$i+1
			
		End for each 
		
		$Obj_out.count:=$i
		
	End if 
	
Else 
	
	  // ASSERT(dev_Matrix ;"No data model")  // XXX maybe add this error too?
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End