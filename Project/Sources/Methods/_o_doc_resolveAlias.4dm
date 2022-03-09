//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Method : doc_resolveAlias
// Created 02/06/10 by Vincent de Lachaux
// ----------------------------------------------------
// #THREAD-SAFE
// ----------------------------------------------------
// Description
// Give a file path, return the full path if it's an alias
// ----------------------------------------------------
// Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)

C_TEXT:C284($t; $Txt_onError)

If (False:C215)
	C_TEXT:C284(_o_doc_resolveAlias; $0)
	C_TEXT:C284(_o_doc_resolveAlias; $1)
End if 

// ----------------------------------------------------
// Initialisations

// ----------------------------------------------------
If (Count parameters:C259>0)
	
	If (Test path name:C476($1)=Is a document:K24:1)
		
		$Txt_onError:=Method called on error:C704
		ON ERR CALL:C155(Current method name:C684)
		
		RESOLVE ALIAS:C695($1; $t)
		
		If (Bool:C1537(OK))
			
			$0:=$t
			
		Else 
			
			// UNABLE TO RESOLVE THE ALIAS
			
		End if 
		
		ON ERR CALL:C155($Txt_onError)
		
	Else 
		
		// NOT A DOCUMENT PATHNAME
		
	End if 
	
Else 
	
	// No error
	
End if 

// ----------------------------------------------------
// End