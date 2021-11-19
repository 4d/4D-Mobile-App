//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : checkQueryFilter
// ID[D5FB3A273A28435891119B6D8C1BB97C]
// Created 04-10-2018 by Eric Marchand
// ----------------------------------------------------
// Description:
// Check query filter
// ----------------------------------------------------
// #THREAD-SAFE
// ----------------------------------------------------
// Declarations
var $0 : Object
var $1 : Object

If (False:C215)
	C_OBJECT:C1216(checkQueryFilter; $0)
	C_OBJECT:C1216(checkQueryFilter; $1)
End if 

var $o; $oIN; $oOUT : Object
var $error : cs:C1710.error

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	// Required parameters
	$oIN:=$1
	
	// Optional parameters
	If (Count parameters:C259>=2)
		
		// <NONE>
		
	End if 
	
	$oOUT:=New object:C1471(\
		"success"; False:C215)
	
	ASSERT:C1129($oIN.table#Null:C1517)  // XXX check not empty string
	ASSERT:C1129($oIN.filter#Null:C1517)  // XXX check not empty string or change to object and change code to filter.string
	
	$oOUT.filter:=$oIN.filter
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
// Detect a query with parameters
If (Match regex:C1019("(?m-si)(?:=|==|===|IS|!=|#|!==|IS NOT|>|<|>=|<=|%)\\s*(:)"; $oOUT.filter.string; 1))
	
	$oOUT.filter.parameters:=True:C214
	
Else 
	
	OB REMOVE:C1226($oOUT.filter; "parameters")
	
End if 

If (Bool:C1537($oIN.rest))
	
	If (Bool:C1537($oIN.selection))
		
		$oOUT:=Rest(New object:C1471(\
			"action"; "records"; \
			"table"; $oIN.table; \
			"url"; $oIN.url; \
			"handler"; $oIN.handler; \
			"queryEncode"; True:C214; \
			"query"; New object:C1471(\
			"$filter"; $oIN.filter.string)))
		
	Else 
		
		// Limit to one - just check
		$oOUT:=Rest(New object:C1471(\
			"action"; "records"; \
			"table"; $oIN.table; \
			"url"; $oIN.url; \
			"handler"; $oIN.handler; \
			"queryEncode"; True:C214; \
			"query"; New object:C1471(\
			"$filter"; $oIN.filter.string; \
			"$limit"; "1")))
		
	End if 
	
Else 
	
	//============================================================
	//  TEMPO - We should have a testQuery method
	//============================================================
	
/* START TRAPPING ERRORS */$error:=cs:C1710.error.new("capture")
	
	If (Bool:C1537($oIN.selection))
		
		$oOUT.selection:=ds:C1482[$oIN.table].query($oIN.filter.string)
		
	Else 
		
		ds:C1482[$oIN.table].query($oIN.filter.string)
		
	End if 
	
/* STOP TRAPPING ERRORS */$error.release()
	
	$oOUT.success:=Bool:C1537(Num:C11($error.lastError().error)=0)
	
	//============================================================
	
	OB REMOVE:C1226($oOUT.filter; "error")
	OB REMOVE:C1226($oOUT.filter; "errors")
	
	If (Not:C34($oOUT.success))
		
		$oOUT.success:=Bool:C1537($oOUT.filter.parameters)
		
		$oOUT.errors:=$error.lastError().stack
		
		// Build the error message
		$oOUT.filter.error:=""
		
		For each ($o; $oOUT.errors.query("component='dbmg'").reverse())
			
			If (Position:C15($o.desc; $oOUT.filter.error)=0)
				
				$oOUT.filter.error:=$oOUT.filter.error+$o.desc+"\r"
				
			End if 
		End for each 
		
		// Remove last carriage return
		$oOUT.filter.error:=Delete string:C232($oOUT.filter.error; Length:C16($oOUT.filter.error); 1)
		
	End if 
End if 

// End if

$oOUT.filter.validated:=$oOUT.success

// ----------------------------------------------------
// Return
$0:=$oOUT

// ----------------------------------------------------
// End