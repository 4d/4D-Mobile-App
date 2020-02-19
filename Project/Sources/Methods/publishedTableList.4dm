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
C_TEXT:C284($tTableNumber)
C_OBJECT:C1216($o;$oDataModel;$oIN;$oOUT;$oTable)

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
				$oTable.icon:=getIcon ($oTable.iconPath)
				
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
				$oTable.icon:=getIcon ($oTable.iconPath)
				
				$oOUT.tables.push($oTable)
				
			End for each 
		End if 
		
	Else   // Old mechanism
		
		RECORD.info("#Old mechanism for publishedTableList").trace()
		
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
				$oOUT.icons[$i]:=getIcon ($oOUT.iconPaths[$i])
				
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
				$oOUT.icons[$i]:=getIcon ($oOUT.iconPaths[$i])
				
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