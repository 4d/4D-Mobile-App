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
		
	Else   // Old mechanism
		
		RECORD.info("#Old mechanism for publishedTableList").trace()
		
		$oOUT.ids:=New collection:C1472
		$oOUT.names:=New collection:C1472
		$oOUT.labels:=New collection:C1472
		$oOUT.shortLabels:=New collection:C1472
		$oOUT.iconPaths:=New collection:C1472
		$oOUT.icons:=New collection:C1472
		
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