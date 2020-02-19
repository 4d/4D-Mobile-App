//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : logger
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

C_LONGINT:C283($l)
C_TEXT:C284($t;$tProcess)
C_OBJECT:C1216($file;$o)

If (False:C215)
	C_OBJECT:C1216(logger ;$0)
	C_VARIANT:C1683(logger ;$1)
	C_OBJECT:C1216(logger ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)  // Constructor
	
	$o:=New object:C1471(\
		"";"logger";\
		"destination";Into 4D debug message:K38:5;\
		"header";Null:C1517;\
		"success";False:C215;\
		"verbose";False:C215;\
		"info";Formula:C1597(logger ("log";New object:C1471("level";Information message:K38:1;"message";$1)));\
		"warning";Formula:C1597(logger ("log";New object:C1471("level";Warning message:K38:2;"message";$1)));\
		"error";Formula:C1597(logger ("log";New object:C1471("level";Error message:K38:3;"message";$1)));\
		"line";Formula:C1597(logger ("line";New object:C1471("line";$1;"count";$2)));\
		"log";Formula:C1597(logger (Choose:C955($2=Null:C1517;"line";"log");Choose:C955($2=Null:C1517;New object:C1471("line";$1);New object:C1471("level";$2;"message";$1))));\
		"open";Formula:C1597(OPEN URL:C673(String:C10(This:C1470.destination.platformPath)));\
		"reset";Formula:C1597(logger ("reset"));\
		"setDestination";Formula:C1597(logger ("setDestination";New object:C1471("destination";$1)));\
		"start";Formula:C1597(logger ("start"));\
		"stop";Formula:C1597(logger ("stop"));\
		"trace";Formula:C1597(logger ("trace"))\
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
					
					PROCESS PROPERTIES:C336(Current process:C322;$t;$l;$l;$l)
					
					Case of 
							
							  //……………………………………………………………………………………………………
						: ($o.destination=Into 4D commands log:K38:7)
							
							If (Not:C34($l ?? 1))
								
								  //%T-
								SET DATABASE PARAMETER:C642(Debug log recording:K37:34;Num:C11($o.logStatus))
								
								  //%T+
								
							End if 
							
							  //……………………………………………………………………………………………………
						: ($o.destination=Into 4D diagnostic log:K38:8)
							
							If (Not:C34($l ?? 1))
								
								  //%T-
								SET DATABASE PARAMETER:C642(Diagnostic log recording:K37:69;Num:C11($o.logStatus))
								
								  //%T+
								
							End if 
							
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
				
				PROCESS PROPERTIES:C336(Current process:C322;$t;$l;$l;$l)
				
				Case of 
						
						  //……………………………………………………………………………………………………
					: ($o.destination=Into 4D commands log:K38:7)
						
						If (Not:C34($l ?? 1))
							
							  //%T-
							$o.logStatus:=Get database parameter:C643(Debug log recording:K37:34)
							SET DATABASE PARAMETER:C642(Debug log recording:K37:34;1)
							
							  //%T+
							
						End if 
						
						  //……………………………………………………………………………………………………
					: ($o.destination=Into 4D diagnostic log:K38:8)
						
						If (Not:C34($l ?? 1))
							
							  //%T-
							$o.logStatus:=Get database parameter:C643(Diagnostic log recording:K37:69)
							SET DATABASE PARAMETER:C642(Diagnostic log recording:K37:69;1)
							
							  //%T+
							
						End if 
						
						  //……………………………………………………………………………………………………
				End case 
			End if 
			
			  //______________________________________________________
		: ($1="stop")
			
			If (Value type:C1509($o.destination)=Is real:K8:4)
				
				PROCESS PROPERTIES:C336(Current process:C322;$t;$l;$l;$l)
				
				Case of 
						
						  //……………………………………………………………………………………………………
					: ($o.destination=Into 4D commands log:K38:7)
						
						If (Not:C34($l ?? 1))
							
							  //%T-
							SET DATABASE PARAMETER:C642(Debug log recording:K37:34;Num:C11($o.logStatus))
							
							  //%T+
							
						End if 
						
						  //……………………………………………………………………………………………………
					: ($o.destination=Into 4D diagnostic log:K38:8)
						
						If (Not:C34($l ?? 1))
							
							  //%T-
							SET DATABASE PARAMETER:C642(Diagnostic log recording:K37:69;Num:C11($o.logStatus))
							
							  //%T+
							
						End if 
						
						  //……………………………………………………………………………………………………
				End case 
				
				$o.logStatus:=0
				
			End if 
			
			  //______________________________________________________
		: ($1="log")
			
			If ($2.level#Information message:K38:1)\
				 | ($o.verbose)
				
				PROCESS PROPERTIES:C336(Current process:C322;$tProcess;$l;$l;$l)
				
				Case of 
						
						  //……………………………………………………………………………………
					: (Value type:C1509($2.message)=Is object:K8:27) | (Value type:C1509($2.message)=Is collection:K8:32)
						
						$2.message:=JSON Stringify:C1217($2.message;*)
						
						  //……………………………………………………………………………………
					: (Value type:C1509($2.message)=Is boolean:K8:9)
						
						$2.message:=Choose:C955($2.message;"TRUE";"FALSE")
						
						  //……………………………………………………………………………………
					Else 
						
						$2.message:=String:C10($2.message)
						
						  //……………………………………………………………………………………
				End case 
				
				If (Value type:C1509($o.destination)=Is real:K8:4)
					
					If (($o.destination=6))
						
						Case of 
								
								  //……………………………………………………………………………………………………
							: ($2.level=Error message:K38:3)
								
								$t:=$t+" error: "
								
								  //……………………………………………………………………………………………………
							: ($2.level=Warning message:K38:2)
								
								$t:=$t+" warning: "
								
								  //……………………………………………………………………………………………………
							: ($2.level=Information message:K38:1)
								
								$t:=$t+Choose:C955(Is Windows:C1573;" ";" note: ")
								
								  //……………………………………………………………………………………………………
						End case 
						
						$t:=$t+String:C10($2.message)
						
					Else 
						
						$t:="("+Folder:C1567(fk database folder:K87:14).name+") "+$tProcess+" - "+$t+String:C10($2.message)
						
					End if 
					
					LOG EVENT:C667(Num:C11($o.destination);$t;Num:C11($2.level))
					
				Else 
					
					$t:=Replace string:C233(String:C10(Current date:C33;ISO date:K1:8;Current time:C178);"T";" ")+"\t"\
						+$tProcess+" - "\
						+Choose:C955(Num:C11($2.level);"info";"warning";"error")+": "
					
					$o.destination.setText($o.destination.getText()+$t+String:C10($2.message)+"\n")
					
				End if 
			End if 
			
			  //______________________________________________________
		: ($1="line")
			
			If ($2.line=Null:C1517)
				
				$t:="-"*80
				
			Else 
				
				$t:=String:C10($2.line)
				
				If ($2.count#Null:C1517)
					
					$t:=$t*Num:C11($2.count)
					
				End if 
			End if 
			
			If (Value type:C1509($o.destination)=Is real:K8:4)
				
				LOG EVENT:C667(Num:C11($o.destination);$t;Num:C11($2.level))
				
			Else 
				
				$o.destination.setText($o.destination.getText()+$t+"\n")
				
			End if 
			
			  //______________________________________________________
		: ($1="trace")
			
			$o.log(Get call chain:C1662.query("name!=:1";Current method name:C684);8858)
			
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