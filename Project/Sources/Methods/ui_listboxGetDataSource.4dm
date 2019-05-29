//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : ui_listboxGetDataSource
  // Database: 4D Mobile App
  // ID[A9B24113E3C34C84BD611DB55AD70FF2]
  // Created #11-3-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Return the data source type of the listbox nammed $1
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_dataSource;$Txt_name)
C_OBJECT:C1216($o)

If (False:C215)
	C_TEXT:C284(ui_listboxGetDataSource ;$0)
	C_TEXT:C284(ui_listboxGetDataSource ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_name:=$1  // listbox widget name
	
	  // Default values
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
For each ($o;FORM Convert to dynamic:C1570(Current form name:C1298).pages) Until (Length:C16($Txt_dataSource)#0)
	
	If ($o.objects[$Txt_name]#Null:C1517)
		
		$Txt_dataSource:=Choose:C955($o.objects[$Txt_name].listboxType=Null:C1517;"arrays";String:C10($o.objects[$Txt_name].listboxType))
		
	End if 
End for each 

  // ----------------------------------------------------
  // Return
$0:=$Txt_dataSource  // "arrays" | "currentSelection" | "nammedSelection" | "collection" | blank (widget not found)

  // ----------------------------------------------------
  // End