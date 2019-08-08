//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : checkQueryFilter
  // Database: 4D Mobile For iOS
  // ID[D5FB3A273A28435891119B6D8C1BB97C]
  // Created 04-10-2018 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // Check query filter
  // ----------------------------------------------------
  // #THREAD-SAFE
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_methodOnErrCall)
C_OBJECT:C1216($Obj_;$Obj_in;$Obj_out)

If (False:C215)
	C_OBJECT:C1216(checkQueryFilter ;$0)
	C_OBJECT:C1216(checkQueryFilter ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Obj_out:=New object:C1471(\
		"success";False:C215)
	
	ASSERT:C1129($Obj_in.table#Null:C1517)  // XXX check not empty string
	ASSERT:C1129($Obj_in.filter#Null:C1517)  // XXX check not empty string or change to object and change code to filter.string
	
	$Obj_out.filter:=$Obj_in.filter
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  // Detect a query with parameters
If (Match regex:C1019("(?m-si)(?:=|==|===|IS|!=|#|!==|IS NOT|>|<|>=|<=|%)\\s*(:)";$Obj_out.filter.string;1))
	
	$Obj_out.filter.parameters:=True:C214
	
Else 
	
	OB REMOVE:C1226($Obj_out.filter;"parameters")
	
End if 

If (Bool:C1537($Obj_in.rest))
	
	If (Bool:C1537($Obj_in.selection))
		
		$Obj_out:=Rest (New object:C1471(\
			"action";"records";\
			"table";$Obj_in.table;\
			"url";$Obj_in.url;\
			"handler";$Obj_in.handler;\
			"queryEncode";True:C214;\
			"query";New object:C1471("$filter";$Obj_in.filter.string)\
			))
		
	Else 
		
		$Obj_out:=Rest (New object:C1471(\
			"action";"records";\
			"table";$Obj_in.table;\
			"url";$Obj_in.url;\
			"handler";$Obj_in.handler;\
			"queryEncode";True:C214;\
			"query";New object:C1471("$filter";$Obj_in.filter.string;"$limit";"1")\
			))
		
	End if 
	
Else 
	
	$Txt_methodOnErrCall:=Method called on error:C704
	
	  //============================================================
	  //  TEMPO
	  //============================================================
	ERROR:=0
	ON ERR CALL:C155("noError")
	
	If (Bool:C1537($Obj_in.selection))
		
		$Obj_out.selection:=ds:C1482[$Obj_in.table].query($Obj_in.filter.string)
		
	Else 
		
		ds:C1482[$Obj_in.table].query($Obj_in.filter.string)
		
	End if 
	
	ON ERR CALL:C155($Txt_methodOnErrCall)  // restore
	
	$Obj_out.success:=Bool:C1537(ERROR=0)
	  //============================================================
	
	OB REMOVE:C1226($Obj_out.filter;"error")
	OB REMOVE:C1226($Obj_out.filter;"errors")
	
	If (Not:C34($Obj_out.success))
		
		$Obj_out.success:=Bool:C1537($Obj_out.filter.parameters)
		
		  // Get error stack
		ARRAY LONGINT:C221($tLon_codes;0x0000)
		ARRAY TEXT:C222($tTxt_components;0x0000)
		ARRAY TEXT:C222($tTxt_labels;0x0000)
		GET LAST ERROR STACK:C1015($tLon_codes;$tTxt_components;$tTxt_labels)
		
		  // Put all stack for test purposes
		$Obj_out.errors:=New collection:C1472
		ARRAY TO COLLECTION:C1563($Obj_out.errors;$tLon_codes;"code";$tTxt_components;"component";$tTxt_labels;"desc")
		
		  // Build the error message
		$Obj_out.filter.error:=""
		
		For each ($Obj_;$Obj_out.errors.query("component='dbmg'").reverse())
			
			If (Position:C15($Obj_.desc;$Obj_out.filter.error)=0)
				
				$Obj_out.filter.error:=$Obj_out.filter.error+$Obj_.desc+"\r"
				
			End if 
		End for each 
		
		  // Remove last carriage return
		$Obj_out.filter.error:=Delete string:C232($Obj_out.filter.error;Length:C16($Obj_out.filter.error);1)
		
	End if 
End if 

  // End if

$Obj_out.filter.validated:=$Obj_out.success

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End