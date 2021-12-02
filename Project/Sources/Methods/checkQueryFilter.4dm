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
#DECLARE($in : Object)->$out : Object

If (False:C215)
	C_OBJECT:C1216(checkQueryFilter; $1)
	C_OBJECT:C1216(checkQueryFilter; $0)
End if 

var $o : Object
var $es : 4D:C1709.EntitySelection
var $error : cs:C1710.error

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	ASSERT:C1129(Length:C16(String:C10($in.table))>0)
	ASSERT:C1129(Length:C16(String:C10($in.filter.string))>0)
	
	OB REMOVE:C1226($in.filter; "error")
	OB REMOVE:C1226($in.filter; "errors")
	OB REMOVE:C1226($in.filter; "parameters")
	
	$out:=New object:C1471(\
		"success"; False:C215; \
		"filter"; $in.filter)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
// Detect a query with parameters
$out.filter.parameters:=(Match regex:C1019("(?m-si)(?:=|==|===|IS|!=|#|!==|IS NOT|>|<|>=|<=|%)\\s*(:)"; $out.filter.string; 1))

If ($out.filter.parameters)
	
	// Perform a syntax verification with a generic placeholder 
	
	//mark: - START TRAPPING ERRORS 
	$error:=cs:C1710.error.new("capture")
	
	ds:C1482[$in.table].query($in.filter.string)  //; "@")
	
	$error.release()
	//mark: - STOP TRAPPING ERRORS 
	
	$out.success:=Bool:C1537(Num:C11($error.lastError().error)=0)
	
Else 
	
	If (Bool:C1537($in.rest))
		
		// Mark: - OBSOLETE ?
		If (Bool:C1537($in.selection))
			
			$out:=Rest(New object:C1471(\
				"action"; "records"; \
				"table"; $in.table; \
				"url"; $in.url; \
				"handler"; $in.handler; \
				"queryEncode"; True:C214; \
				"query"; New object:C1471(\
				"$filter"; $in.filter.string)))
			
		Else 
			
			// Limit to one - just check
			$out:=Rest(New object:C1471(\
				"action"; "records"; \
				"table"; $in.table; \
				"url"; $in.url; \
				"handler"; $in.handler; \
				"queryEncode"; True:C214; \
				"query"; New object:C1471(\
				"$filter"; $in.filter.string; \
				"$limit"; "1")))
			
		End if 
		
		// Mark: -
		
	Else 
		
		//mark: - START TRAPPING ERRORS 
		$error:=cs:C1710.error.new("capture")
		
		If (Bool:C1537($in.selection))
			
			$out.selection:=ds:C1482[$in.table].query($in.filter.string)
			
		Else 
			
			If (FEATURE.with("cancelableDatasetGeneration"))
				
				$es:=ds:C1482[$in.table].query($in.filter.string)
				
				If ($es#Null:C1517)
					
					$out.count:=Num:C11($es.length)
					
				End if 
				
			Else 
				
				ds:C1482[$in.table].query($in.filter.string)
				
			End if 
		End if 
		
		$error.release()
		//mark: - STOP TRAPPING ERRORS 
		
		$out.success:=Bool:C1537(Num:C11($error.lastError().error)=0)
		
	End if 
End if 

If (Not:C34($out.success))
	
	$out.errors:=$error.lastError().stack
	
	// Build the error message
	$out.filter.error:=""
	
	For each ($o; $out.errors.query("component='dbmg'").reverse())
		
		If (Position:C15($o.desc; $out.filter.error)=0)
			
			$out.filter.error:=$out.filter.error+$o.desc+"\r"
			
		End if 
	End for each 
	
	// Remove last carriage return
	$out.filter.error:=Split string:C1554($out.filter.error; "\r"; sk ignore empty strings:K86:1).join("\r")
	
End if 

$out.filter.validated:=Bool:C1537($out.success)