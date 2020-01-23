//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Description:
  // Find recursively property in object
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)
C_TEXT:C284($2)
C_OBJECT:C1216($3)

C_LONGINT:C283($i)
C_TEXT:C284($t;$tProperty)

If (False:C215)
	C_OBJECT:C1216(ob findPropertyValues ;$0)
	C_OBJECT:C1216(ob findPropertyValues ;$1)
	C_TEXT:C284(ob findPropertyValues ;$2)
	C_OBJECT:C1216(ob findPropertyValues ;$3)
End if 

  // ----------------------------------------------------
If (Asserted:C1132(Count parameters:C259>=2;"Missing parameter"))
	
	$tProperty:=$2
	
	If (Count parameters:C259>=3)
		
		$0:=$3
		
	Else 
		
		$0:=New object:C1471(\
			"success";False:C215;\
			"value";New collection:C1472())
		
	End if 
	
	For each ($t;$1)  //Until ($0.success)
		
		Case of 
				
				  //……………………………………………………………………………………………………………………………
			: ($t=$tProperty)  // We found an instance
				
				$0.value.push($1[$t])
				
				  //……………………………………………………………………………………………………………………………
			: (Value type:C1509($1[$t])=Is collection:K8:32)
				
				For ($i;0;$1[$t].length-1;1)
					
					If (Value type:C1509($1[$t][$i])=Is object:K8:27)
						
						ob findPropertyValues ($1[$t][$i];$tProperty;$0)  // <- RECURSIVE
						
					End if 
				End for 
				
				  //……………………………………………………………………………………………………………………………
			: (Value type:C1509($1[$t])=Is object:K8:27)
				
				If ($1[$t].isFile#Null:C1517)
					
					  // Exclude special object with cycle: File
					  //
					  // XXX other object
					
				Else   // Normal object
					
					ob findPropertyValues ($1[$t];$tProperty;$0)  // <- RECURSIVE
					
				End if 
				
				  //……………………………………………………………………………………………………………………………
			Else 
				
				  // Ignore
				
				  //……………………………………………………………………………………………………………………………
		End case 
	End for each 
	
	$0.success:=$0.value.length>0
	
End if 