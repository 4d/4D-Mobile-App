//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : logs
  // ID[82E16D65903F4A2EB0CD458A79ECD474]
  // Created 28-1-2020 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_VARIANT:C1683($1)
C_OBJECT:C1216($2)

C_TEXT:C284($t)
C_OBJECT:C1216($file;$o)

If (False:C215)
	C_OBJECT:C1216(logs ;$0)
	C_VARIANT:C1683(logs ;$1)
	C_OBJECT:C1216(logs ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)  // Constructor
	
	$o:=New object:C1471(\
		"";"logs";\
		"destination";Into 4D debug message:K38:5;\
		"header";Null:C1517;\
		"success";False:C215;\
		"verbose";False:C215;\
		"infos";Formula:C1597(logs ("log";New object:C1471("importance";Information message:K38:1;"message";$1)));\
		"warning";Formula:C1597(logs ("log";New object:C1471("importance";Warning message:K38:2;"message";$1)));\
		"error";Formula:C1597(logs ("log";New object:C1471("importance";Error message:K38:3;"message";$1)));\
		"line";Formula:C1597(logs ("line"));\
		"open";Formula:C1597(OPEN URL:C673(String:C10(This:C1470.destination.platformPath)));\
		"reset";Formula:C1597(logs ("reset"));\
		"setDestination";Formula:C1597(logs ("setDestination";New object:C1471("destination";$1)));\
		"start";Formula:C1597(logs ("start"));\
		"stop";Formula:C1597(logs ("stop"))\
		)
	
	If (Count parameters:C259>=1)
		
		$o.setDestination($1)
		
	End if 
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="reset")
			
			If (Value type:C1509($o.destination)=Is object:K8:27)
				
				If ($o.destination.exists)
					
					$o.destination.setText("")
					$o.success:=(Length:C16($o.destination.getText())=0)
					
				Else 
					
					$o.success:=$o.destination.create()
					
				End if 
			End if 
			
			  //______________________________________________________
		: ($1="setDestination")
			
			If (Value type:C1509($2.destination)=Is real:K8:4)
				
				  // Restore the previous status, if any
				If (Value type:C1509($o.destination)=Is real:K8:4)
					
					Case of 
							
							  //……………………………………………………………………………………………………
						: ($o.destination=Into 4D commands log:K38:7)
							
							SET DATABASE PARAMETER:C642(Debug log recording:K37:34;Num:C11($o.logStatus))
							
							  //……………………………………………………………………………………………………
						: ($o.destination=Into 4D diagnostic log:K38:8)
							
							SET DATABASE PARAMETER:C642(Diagnostic log recording:K37:69;Num:C11($o.logStatus))
							
							  //……………………………………………………………………………………………………
					End case 
				End if 
				
				$o.destination:=$2.destination
				$o.success:=True:C214
				
			Else 
				
				If (Value type:C1509($2.destination)=Is text:K8:3)
					
					If (Position:C15("/";$2.destination)=0)
						
						$file:=Folder:C1567(fk logs folder:K87:17;*).file($2.destination)
						
					Else 
						
						$file:=File:C1566(Replace string:C233($2.destination;"~";Folder:C1567(fk documents folder:K87:21).parent.path))
						
					End if 
					
					$o.success:=$file.exists
					
					If (Not:C34($o.success))
						
						$o.success:=$file.create()
						
					End if 
					
					If ($o.success)
						
						$o.destination:=$file
						
					End if 
					
				Else 
					
					  // ? Object
					
				End if 
			End if 
			
			  //______________________________________________________
		: ($1="start")
			
			If (Value type:C1509($o.destination)=Is real:K8:4)
				
				Case of 
						
						  //……………………………………………………………………………………………………
					: ($o.destination=Into 4D commands log:K38:7)
						
						$o.logStatus:=Get database parameter:C643(Debug log recording:K37:34)
						SET DATABASE PARAMETER:C642(Debug log recording:K37:34;1)
						
						  //……………………………………………………………………………………………………
					: ($o.destination=Into 4D diagnostic log:K38:8)
						
						$o.logStatus:=Get database parameter:C643(Diagnostic log recording:K37:69)
						SET DATABASE PARAMETER:C642(Diagnostic log recording:K37:69;1)
						
						  //……………………………………………………………………………………………………
				End case 
			End if 
			
			  //______________________________________________________
		: ($1="stop")
			
			If (Value type:C1509($o.destination)=Is real:K8:4)
				
				Case of 
						
						  //……………………………………………………………………………………………………
					: ($o.destination=Into 4D commands log:K38:7)
						
						SET DATABASE PARAMETER:C642(Debug log recording:K37:34;Num:C11($o.logStatus))
						
						  //……………………………………………………………………………………………………
					: ($o.destination=Into 4D diagnostic log:K38:8)
						
						SET DATABASE PARAMETER:C642(Diagnostic log recording:K37:69;Num:C11($o.logStatus))
						
						  //……………………………………………………………………………………………………
				End case 
				
				$o.logStatus:=0
				
			End if 
			
			  //______________________________________________________
		: ($1="log")
			
			If ($2.importance#Information message:K38:1)\
				 | ($o.verbose)
				
				If (Value type:C1509($o.destination)=Is real:K8:4)
					
					If (($o.destination=6))
						
						Case of 
								
								  //……………………………………………………………………………………………………
							: ($2.importance=Error message:K38:3)
								
								$t:=$t+" error: "
								
								  //……………………………………………………………………………………………………
							: ($2.importance=Warning message:K38:2)
								
								$t:=$t+" warning: "
								
								  //……………………………………………………………………………………………………
							: ($2.importance=Information message:K38:1)
								
								$t:=$t+Choose:C955(Is Windows:C1573;" ";" note: ")
								
								  //……………………………………………………………………………………………………
						End case 
						
						$t:=$t+String:C10($2.message)
						
					Else 
						
						$t:="("+Folder:C1567(fk database folder:K87:14).name+") "+$t+String:C10($2.message)
						
					End if 
					
					LOG EVENT:C667(Num:C11($o.destination);$t;Num:C11($2.importance))
					
				Else 
					
					$t:=Replace string:C233(String:C10(Current date:C33;ISO date:K1:8;Current time:C178);"T";" ")+"\t("+Folder:C1567(fk database folder:K87:14).name+")\t"
					
					Case of 
							
							  //……………………………………………………………………………………………………
						: ($2.importance=Error message:K38:3)
							
							$t:=$t+"error: "
							
							  //……………………………………………………………………………………………………
						: ($2.importance=Warning message:K38:2)
							
							$t:=$t+"warning: "
							
							  //……………………………………………………………………………………………………
						: ($2.importance=Information message:K38:1)
							
							$t:=$t+"info: "
							
							  //……………………………………………………………………………………………………
					End case 
					
					$o.destination.setText($o.destination.getText()+$t+String:C10($2.message)+"\n")
					
				End if 
			End if 
			
			  //______________________________________________________
		: ($1="line")
			
			$t:="*"*100
			
			If (Value type:C1509($o.destination)=Is real:K8:4)
				
				LOG EVENT:C667(Num:C11($o.destination);$t;Num:C11($2.importance))
				
			Else 
				
				$t:=Replace string:C233(String:C10(Current date:C33;ISO date:K1:8;Current time:C178);"T";" ")+"\t("+Folder:C1567(fk database folder:K87:14).name+")\t"+$t
				$o.destination.setText($o.destination.getText()+$t+"\n")
				
			End if 
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
			
			  //______________________________________________________
	End case 
End if 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End