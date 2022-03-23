//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : xml_findByAttribute
// ----------------------------------------------------
// Description:
// Not very optimized method to replace to get element
// by attribute value
// ----------------------------------------------------
// Declarations
C_COLLECTION:C1488($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_child; $Dom_elementRef; $Txt_name; $Txt_attributeValueToFind; $Txt_attributeValue; $Txt_attributeName; $Txt_methodOnError)
C_COLLECTION:C1488($Col_result)
C_BOOLEAN:C305($Boo_noAtt; $Boo_skip)

If (False:C215)
	C_COLLECTION:C1488(_o_xml_findByAttribute; $0)
	C_TEXT:C284(_o_xml_findByAttribute; $1)
	C_OBJECT:C1216(_o_xml_findByAttribute; $2)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2; "Missing parameter"))
	
	$Dom_elementRef:=$1
	$Txt_attributeName:=$2.name
	$Txt_attributeValueToFind:=$2.value
	
	$Col_result:=New collection:C1472
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------

// Childs if any {
$Dom_child:=DOM Get first child XML element:C723($Dom_elementRef; $Txt_name)

While (OK=1)
	
	$Boo_skip:=False:C215
	If ($2.nodeName#Null:C1517)
		
		$Boo_skip:=$Txt_name#$2.nodeName
		
	Else 
		
		$Boo_skip:=False:C215
	End if 
	
	If (Not:C34($Boo_skip))
		// TRY (
		$Txt_methodOnError:=Method called on error:C704
		xml_ERROR:=0
		$Boo_noAtt:=False:C215
		ON ERR CALL:C155("_o_xml_NO_ERROR")
		//) {
		DOM GET XML ATTRIBUTE BY NAME:C728($Dom_child; $Txt_attributeName; $Txt_attributeValue)
		// } CATCH {
		If (xml_ERROR#0)
			$Boo_noAtt:=True:C214
		End if 
		ON ERR CALL:C155($Txt_methodOnError)
		// }
		
		If (Not:C34($Boo_noAtt))
			
			If ($Txt_attributeValue=$Txt_attributeValueToFind)
				
				$Col_result.push($Dom_child)
				
			End if 
		End if 
	End if 
	
	$Col_result:=$Col_result.combine(_o_xml_findByAttribute($Dom_child; $2))  // <======= RECURSIVE
	
	// Next one, if any
	$Dom_child:=DOM Get next sibling XML element:C724($Dom_child; $Txt_name)
	
End while 

// ----------------------------------------------------
// Return
$0:=$Col_result

// ----------------------------------------------------
// End