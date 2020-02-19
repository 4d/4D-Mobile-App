//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : publishedTableList
  // ID[892090D3E24D425C9269C91077BE4BCD]
  // Created 21-3-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($i)
C_PICTURE:C286($p)
C_TEXT:C284($Dir_hostRoot;$Dir_root;$tTableNumber)
C_OBJECT:C1216($fileIcon;$o;$oDataModel;$oIN;$oOUT;$oTable)

If (False:C215)
	C_OBJECT:C1216(publishedTableList ;$0)
	C_OBJECT:C1216(publishedTableList ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations

  // <NO PARAMETERS REQUIRED>

  // Optional parameters
If (Count parameters:C259>=1)
	
	$oIN:=$1
	
End if 

$oOUT:=New object:C1471(\
"success";$oIN.dataModel#Null:C1517)

  // ----------------------------------------------------
If ($oOUT.success)
	
	$oDataModel:=$oIN.dataModel
	
	$Dir_root:=COMPONENT_Pathname ("tableIcons").platformPath
	$Dir_hostRoot:=COMPONENT_Pathname ("host_tableIcons").platformPath
	
	If (Bool:C1537($oIN.asCollection))  // List to use with a collection listbox
		
		$oOUT.tables:=New collection:C1472
		
		If (feature.with("newDataModel"))
			
			For each ($tTableNumber;$oDataModel)
				
				$o:=$oDataModel[$tTableNumber][""]  // Table properties
				
				$oTable:=New object:C1471(\
					"tableNumber";Num:C11($tTableNumber);\
					"name";$o.name)
				
				If ($o.label=Null:C1517)
					
					$o.label:=formatString ("label";$o.name)
					
				End if 
				
				$oTable.label:=$o.label
				
				If ($o.shortLabel=Null:C1517)
					
					$o.shortLabel:=$o.label
					
				End if 
				
				$oTable.shortLabel:=$o.shortLabel
				
				If ($o.filter#Null:C1517)
					
					$oTable.filter:=Choose:C955(Value type:C1509($o.filter)=Is text:K8:3;New object:C1471(\
						"string";$o.filter);\
						$o.filter)
					
				End if 
				
				$oTable.embedded:=Bool:C1537($o.embedded)
				
				$oTable.iconPath:=String:C10($o.icon)
				
				If (Length:C16($oTable.iconPath)=0)
					
					$fileIcon:=ui.noIcon
					
				Else 
					
					If (Position:C15("/";String:C10($o.icon))=1)  // User resource
						
						$fileIcon:=$Dir_hostRoot+Replace string:C233(String:C10($o.icon);"/";Folder separator:K24:12)
						
						If (Test path name:C476($fileIcon)#Is a document:K24:1)
							
							$fileIcon:=ui.errorIcon
							
						End if 
						
					Else 
						
						$fileIcon:=$Dir_root+Replace string:C233(String:C10($o.icon);"/";Folder separator:K24:12)
						
						If (Test path name:C476($fileIcon)#Is a document:K24:1)
							
							$fileIcon:=ui.noIcon
							
						End if 
					End if 
				End if 
				
				READ PICTURE FILE:C678($fileIcon;$p)
				
				CREATE THUMBNAIL:C679($p;$p;24;24;Scaled to fit:K6:2)
				$oTable.icon:=$p
				
				$oOUT.tables.push($oTable)
				
			End for each 
			
		Else 
			
			For each ($tTableNumber;$oDataModel)
				
				$oTable:=New object:C1471(\
					"tableNumber";Num:C11($tTableNumber);\
					"name";$oDataModel[$tTableNumber].name)
				
				If ($oDataModel[$tTableNumber].label=Null:C1517)
					
					$oDataModel[$tTableNumber].label:=formatString ("label";$oDataModel[$tTableNumber].name)
					
				End if 
				
				$oTable.label:=$oDataModel[$tTableNumber].label
				
				If ($oDataModel[$tTableNumber].shortLabel=Null:C1517)
					
					$oDataModel[$tTableNumber].shortLabel:=$oDataModel[$tTableNumber].label
					
				End if 
				
				$oTable.shortLabel:=$oDataModel[$tTableNumber].shortLabel
				
				If ($oDataModel[$tTableNumber].filter#Null:C1517)
					
					$oTable.filter:=Choose:C955(Value type:C1509($oDataModel[$tTableNumber].filter)=Is text:K8:3;New object:C1471(\
						"string";$oDataModel[$tTableNumber].filter);\
						$oDataModel[$tTableNumber].filter)
					
				End if 
				
				$oTable.embedded:=Bool:C1537($oDataModel[$tTableNumber].embedded)
				
				$oTable.iconPath:=String:C10($oDataModel[$tTableNumber].icon)
				
				If (Length:C16($oTable.iconPath)=0)
					
					$fileIcon:=ui.noIcon
					
				Else 
					
					If (Position:C15("/";String:C10($oDataModel[$tTableNumber].icon))=1)  // User resource
						
						$fileIcon:=$Dir_hostRoot+Replace string:C233(String:C10($oDataModel[$tTableNumber].icon);"/";Folder separator:K24:12)
						
						If (Test path name:C476($fileIcon)#Is a document:K24:1)
							
							$fileIcon:=ui.errorIcon
							
						End if 
						
					Else 
						
						$fileIcon:=$Dir_root+Replace string:C233(String:C10($oDataModel[$tTableNumber].icon);"/";Folder separator:K24:12)
						
						If (Test path name:C476($fileIcon)#Is a document:K24:1)
							
							$fileIcon:=ui.noIcon
							
						End if 
					End if 
				End if 
				
				READ PICTURE FILE:C678($fileIcon;$p)
				
				CREATE THUMBNAIL:C679($p;$p;24;24;Scaled to fit:K6:2)
				$oTable.icon:=$p
				
				$oOUT.tables.push($oTable)
				
			End for each 
			
		End if 
		
	Else   // Old mechanism
		
		$oOUT.ids:=New collection:C1472
		$oOUT.names:=New collection:C1472
		$oOUT.labels:=New collection:C1472
		$oOUT.shortLabels:=New collection:C1472
		$oOUT.iconPaths:=New collection:C1472
		$oOUT.icons:=New collection:C1472
		
		If (feature.with("newDataModel"))
			
			For each ($tTableNumber;$oDataModel)
				
				$o:=$oDataModel[$tTableNumber][""]  // Table properties
				
				$oOUT.ids[$i]:=Num:C11($tTableNumber)
				$oOUT.names[$i]:=$o.name
				
				If ($o.label=Null:C1517)
					
					$o.label:=formatString ("label";$o.name)
					
				End if 
				
				$oOUT.labels[$i]:=$o.label
				
				If ($o.shortLabel=Null:C1517)
					
					$o.shortLabel:=$o.label
					
				End if 
				
				$oOUT.shortLabels[$i]:=$o.shortLabel
				
				$oOUT.iconPaths[$i]:=String:C10($o.icon)
				
				If (Length:C16($oOUT.iconPaths[$i])=0)
					
					$fileIcon:=ui.noIcon
					
				Else 
					
					If (Position:C15("/";String:C10($o.icon))=1)  // User resource
						
						$fileIcon:=$Dir_hostRoot+Replace string:C233(String:C10(Delete string:C232($o.icon;1;1));"/";Folder separator:K24:12)
						
						If (Test path name:C476($fileIcon)#Is a document:K24:1)
							
							$fileIcon:=ui.errorIcon
							
						End if 
						
					Else 
						
						$fileIcon:=$Dir_root+Replace string:C233(String:C10($o.icon);"/";Folder separator:K24:12)
						
						If (Test path name:C476($fileIcon)#Is a document:K24:1)
							
							$fileIcon:=ui.noIcon
							
						End if 
					End if 
				End if 
				
				READ PICTURE FILE:C678($fileIcon;$p)
				
				CREATE THUMBNAIL:C679($p;$p;24;24;Scaled to fit:K6:2)
				$oOUT.icons[$i]:=$p
				
				$i:=$i+1
				
			End for each 
			
		Else 
			
			For each ($tTableNumber;$oDataModel)
				
				$oTable:=$oDataModel[$tTableNumber]
				
				$oOUT.ids[$i]:=Num:C11($tTableNumber)
				$oOUT.names[$i]:=$oTable.name
				
				If ($oTable.label=Null:C1517)
					
					$oTable.label:=formatString ("label";$oTable.name)
					
				End if 
				
				$oOUT.labels[$i]:=$oTable.label
				
				If ($oTable.shortLabel=Null:C1517)
					
					$oTable.shortLabel:=$oTable.label
					
				End if 
				
				$oOUT.shortLabels[$i]:=$oTable.shortLabel
				
				$oOUT.iconPaths[$i]:=String:C10($oTable.icon)
				
				If (Length:C16($oOUT.iconPaths[$i])=0)
					
					$fileIcon:=ui.noIcon
					
				Else 
					
					If (Position:C15("/";String:C10($oTable.icon))=1)  // User resource
						
						  //$File_:=$Dir_hostRoot+Replace string(String($Obj_table.icon);"/";Folder separator)
						$fileIcon:=$Dir_hostRoot+Replace string:C233(String:C10(Delete string:C232($oTable.icon;1;1));"/";Folder separator:K24:12)
						
						If (Test path name:C476($fileIcon)#Is a document:K24:1)
							
							$fileIcon:=ui.errorIcon
							
						End if 
						
					Else 
						
						$fileIcon:=$Dir_root+Replace string:C233(String:C10($oTable.icon);"/";Folder separator:K24:12)
						
						If (Test path name:C476($fileIcon)#Is a document:K24:1)
							
							$fileIcon:=ui.noIcon
							
						End if 
					End if 
				End if 
				
				READ PICTURE FILE:C678($fileIcon;$p)
				
				CREATE THUMBNAIL:C679($p;$p;24;24;Scaled to fit:K6:2)
				$oOUT.icons[$i]:=$p
				
				$i:=$i+1
				
			End for each 
			
		End if 
		
		$oOUT.count:=$i
		
	End if 
	
Else 
	
	  // ASSERT(dev_Matrix ;"No data model")  // XXX maybe add this error too?
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$oOUT

  // ----------------------------------------------------
  // End