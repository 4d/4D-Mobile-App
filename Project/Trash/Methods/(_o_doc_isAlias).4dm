//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Method : doc_isAlias
  // Created 26/07/18 by Eric Marchand
  // ----------------------------------------------------
  // #THREAD_SAFE
  // ----------------------------------------------------
  // Description
  // Return True if path is an alias
  // ----------------------------------------------------
  // Declarations

C_BOOLEAN:C305($0)
C_TEXT:C284($1)


If (False:C215)
	C_BOOLEAN:C305(_o_doc_isAlias ;$0)
	C_TEXT:C284(_o_doc_isAlias ;$1)
End if 

C_TEXT:C284($Txt_alias;$Txt_target;$Txt_methodOnErrorCall)
C_BOOLEAN:C305($Boo_alias)
C_LONGINT:C283($Lon_parameters)

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259
$Boo_alias:=False:C215

  // ----------------------------------------------------

If ($Lon_parameters>0)
	
	$Txt_alias:=$1
	
	$Txt_methodOnErrorCall:=Method called on error:C704
	
	ON ERR CALL:C155(Current method name:C684)
	
	RESOLVE ALIAS:C695($Txt_alias;$Txt_target)
	
	$Boo_alias:=$Txt_target#$Txt_alias
	
	ON ERR CALL:C155($Txt_methodOnErrorCall)
	
Else 
	
	  //No error
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Boo_alias

  // ----------------------------------------------------
  //End