//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : ob deepMerge
  // ID[882D2F9691D34C5F9D90B4ADD34FCE27]
  // Created 23-5-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Copy object properties from source to target
  // ----------------------------------------------------
  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  // !!!!!!!!!!!!!!!!!! NOT FINALIZED !!!!!!!!!!!!!!!!!!!
  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($i)
C_TEXT:C284($t)

If (False:C215)
	C_OBJECT:C1216(ob deepMerge ;$0)
	C_OBJECT:C1216(ob deepMerge ;$1)
	C_OBJECT:C1216(ob deepMerge ;$2)
End if 

  // ----------------------------------------------------
If (Asserted:C1132(Count parameters:C259>=2;"Missing parameter"))
	
	If ($1=Null:C1517)
		
		$1:=New object:C1471
		
	End if 
	
	For each ($t;$2)
		
		Case of 
				
				  //……………………………………………………………………………………………………………………………
			: (Value type:C1509($2[$t])=Is object:K8:27)
				
				If ($1[$t]=Null:C1517)
					
					$1[$t]:=OB Copy:C1225($2[$t])
					
				Else 
					
					If (Value type:C1509($1[$t])#Is object:K8:27)
						
						$1[$t]:=New object:C1471
						
					End if 
					
					$1[$t]:=ob deepMerge ($1[$t];OB Copy:C1225($2[$t]))  // <- RECURSIVE
					
				End if 
				
				  //……………………………………………………………………………………………………………………………
			: (Value type:C1509($2[$t])=Is collection:K8:32)
				
				If ($1[$t]=Null:C1517)
					
					$1[$t]:=$2[$t].copy()
					
				Else 
					
					$1[$t]:=New collection:C1472.resize($2[$t].length)
					
					For ($i;0;$2[$t].length-1;1)
						
						Case of 
								
								  //_________________________________
							: (Value type:C1509($2[$t][$i])=Is object:K8:27)
								
								Case of 
										
										  //..........................
									: ($1[$t][$i]=Null:C1517)
										
										$1[$t][$i]:=OB Copy:C1225($2[$t][$i])
										
										  //..........................
									: (Value type:C1509($1[$t][$i])=Is object:K8:27)
										
										$1[$t][$i]:=ob deepMerge ($1[$t][$i];OB Copy:C1225($2[$t][$i]))  // <- RECURSIVE
										
										  //..........................
									: (Value type:C1509($1[$t][$i])=Is collection:K8:32)
										
										If (Not:C34($1[$t][$i].equal($1[$t][$i];ck diacritical:K85:3)))
											
											TRACE:C157  //#TO_DO
											
										End if 
										
										  //..........................
									Else 
										
										$1[$t][$i]:=$2[$t][$i]
										
										  //..........................
								End case 
								
								  //_________________________________
							: (Value type:C1509($2[$t][$i])=Is collection:K8:32)
								
								TRACE:C157  //#TO_DO
								
								  //_________________________________
							Else 
								
								$1[$t]:=$2[$t]
								
								  //_________________________________
						End case 
					End for 
				End if 
				
				  //……………………………………………………………………………………………………………………………
			Else 
				
				$1[$t]:=$2[$t]
				
				  //……………………………………………………………………………………………………………………………
		End case 
	End for each 
End if 