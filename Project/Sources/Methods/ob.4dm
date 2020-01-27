//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : ob
  // ID[AD99930FCD1D4B9CBCD5226CE2272157]
  // Created 8-1-2020 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216(${2})

C_BOOLEAN:C305($b)
C_LONGINT:C283($i;$l)
C_PICTURE:C286($p)
C_POINTER:C301($ptr)
C_TEXT:C284($t;$Txt_indx)
C_OBJECT:C1216($o;$o1;$o2;$Obj_schem)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(ob ;$0)
	C_TEXT:C284(ob ;$1)
	C_OBJECT:C1216(ob ;${2})
End if 

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)  // Constructor
	
	$o:=New object:C1471(\
		"";"ob";\
		"contents";Null:C1517;\
		"errors";New collection:C1472;\
		"success";True:C214;\
		"assign";Formula:C1597(ob ("assign";$1;$2;$3;$4;$5;$6;$7;$8;$9;$10));\
		"clone";Formula:C1597(ob ("clone";$1));\
		"copy";Formula:C1597(OB Copy:C1225(This:C1470.contents));\
		"count";Formula:C1597(ob ("count").value);\
		"createPath";Formula:C1597(ob ("createPath";New object:C1471("path";String:C10($1);\
		"type";$2;\
		"content";$3)));\
		"deepMerge";Formula:C1597(ob ("deepMerge";$1;$2;$3;$4;$5;$6;$7;$8;$9;$10));\
		"equal";Formula:C1597(New collection:C1472(This:C1470.contents).equal(New collection:C1472($1)));\
		"findPropertyValues";Formula:C1597(ob ("findPropertyValues";New object:C1471("key";String:C10($1))));\
		"getByPath";Formula:C1597(ob ("getByPath";New object:C1471("path";String:C10($1))).value);\
		"isCollection";Formula:C1597(Value type:C1509(This:C1470.contents)=Is collection:K8:32);\
		"isEmpty";Formula:C1597(ob ("isEmpty").value);\
		"isObject";Formula:C1597(Value type:C1509(This:C1470.contents)=Is object:K8:27);\
		"merge";Formula:C1597(ob ("merge";$1;$2;$3;$4;$5;$6;$7;$8;$9;$10));\
		"remove";Formula:C1597(ob ("remove";New object:C1471("key";$1)));\
		"set";Formula:C1597(ob ("set";New object:C1471("value";$1)));\
		"testPath";Formula:C1597(ob ("testPath";New object:C1471("path";String:C10($1))).value))
	
	If (Count parameters:C259>=1)
		
		$t:=String:C10($1)
		
		Case of 
				
				  //______________________________________________________
			: ($t="object")
				
				$o.contents:=New object:C1471
				
				  //______________________________________________________
			: ($t="collection")
				
				$o.contents:=New collection:C1472
				
				  //______________________________________________________
			: (Match regex:C1019("(?msi)^(?:\\{.*\\})|(?:\\[.*\\])$";$t;1))
				
				$o.contents:=JSON Parse:C1218($t)
				
				  //______________________________________________________
				  //: (Match regex("(?msi)^\\[.*\\]$";$t;1))
				  //JSON PARSE ARRAY($t;$ar)
				  //$o.contents:=
				
				  //______________________________________________________
			Else 
				
				$o.contents:=New object:C1471
				
				  //______________________________________________________
		End case 
		
	Else 
		
		$o.contents:=New object:C1471
		
	End if 
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="assign")
			
			  // Copies the values ​​of all first level properties of the passed objects.
			  // The common properties are overloaded according to the order of the parameters.
			  // The Null values are ignored
			
			If ($o.isObject())
				
				For ($i;2;11;1)
					
					If (${$i}#Null:C1517)
						
						For each ($t;${$i})
							
							If (${$i}[$t]#Null:C1517)
								
								$o.contents[$t]:=${$i}[$t]
								
							End if 
						End for each 
						
					Else 
						
						$i:=MAXLONG:K35:2-1
						
					End if 
				End for 
			End if 
			
			  //______________________________________________________
		: ($1="clone")
			
			  // Clone the given object
			
			$o.contents:=New object:C1471
			
			For each ($t;$2)
				
				Case of 
						
						  //……………………………………………………………………………………………………………………………
					: (Value type:C1509($2[$t])=Is object:K8:27)
						
						$o.contents[$t]:=OB Copy:C1225($2[$t])
						
						  //……………………………………………………………………………………………………………………………
					: (Value type:C1509($2[$t])=Is collection:K8:32)
						
						$o.contents[$t]:=$2[$t].copy()
						
						  //……………………………………………………………………………………………………………………………
					Else 
						
						$o.contents[$t]:=$2[$t]
						
						  //……………………………………………………………………………………………………………………………
				End case 
			End for each 
			
			
			  //______________________________________________________
		: ($1="count")  // Returns the count of first level keys
			
			ARRAY TEXT:C222($tTxt_buffer;0x0000)
			OB GET PROPERTY NAMES:C1232($o.contents;$tTxt_buffer)
			$o.value:=Size of array:C274($tTxt_buffer)
			
			  //______________________________________________________
		: ($1="merge")
			
			  // Adds the missing properties of the passed objects.
			
			If ($o.isObject())
				
				For ($i;2;11;1)
					
					If (${$i}#Null:C1517)
						
						ob MERGE ($o.contents;${$i})
						
					End if 
				End for 
			End if 
			
			  //______________________________________________________
		: ($1="set")
			
			If (Value type:C1509($2.value)=Is text:K8:3)
				
				Case of 
						
						  //______________________________________________________
					: ($t="object")
						
						$o.contents:=New object:C1471
						
						  //______________________________________________________
					: ($t="collection")
						
						$o.contents:=New collection:C1472
						
						  //______________________________________________________
					: (Match regex:C1019("(?msi)^(?:\\{.*\\})|(?:\\[.*\\])$";$t;1))
						
						$o.contents:=JSON Parse:C1218($t)
						
						  //______________________________________________________
						  //: (Match regex("(?msi)^\\[.*\\]$";$t;1))
						  //JSON PARSE ARRAY($t;$ar)
						  //$o.contents:=
						
						  //______________________________________________________
					Else 
						
						$o.contents:=New object:C1471
						
						  //______________________________________________________
				End case 
				
			Else 
				
				$o.contents:=$2.value
				
			End if 
			
			  //______________________________________________________
		: ($1="deepMerge")
			
			  // Copy object properties from source to target [#WIP]
			
			If ($o.isObject())
				
				For ($i;2;11;1)
					
					If (${$i}#Null:C1517)
						
						ob deepMerge ($o.contents;${$i})
						
					End if 
				End for 
			End if 
			
			  //______________________________________________________
		: ($1="findPropertyValues")
			
			  // Finds one or more properties and returns its value (s), if found
			
			$o:=ob findPropertyValues (This:C1470.contents;$2.key)
			
			  //______________________________________________________
		: ($1="isEmpty")
			
			If (Value type:C1509($o.contents)=Is object:K8:27)
				
				$o.value:=OB Is empty:C1297($o.contents)
				
			Else 
				
				  // Test collection length
				$o.value:=($o.contents.length=0)
				
			End if 
			
			  //______________________________________________________
		: ($1="createPath")
			
			$c:=Split string:C1554($2.path;".")
			$o.success:=$c.length>0
			
			If ($o.success)
				
				$l:=Num:C11($2.type)
				$l:=Choose:C955($l=0;Is object:K8:27;$l)
				
				$o1:=$o.contents
				
				For each ($t;$c)
					
					$b:=($t=$c[$c.length-1])  // Last item
					
					If ($o1[$t]=Null:C1517)
						
						If ($b)
							
							Case of 
									
									  //…………………………………………………
								: ($l=Is object:K8:27)
									
									$o1[$t]:=New object:C1471
									
									  //…………………………………………………
								: ($l=Is collection:K8:32)
									
									$o1[$t]:=New collection:C1472
									
									  //…………………………………………………
								: ($l=Is text:K8:3)
									
									$o1[$t]:=""
									
									  //…………………………………………………
								: ($l=Is longint:K8:6)
									
									$o1[$t]:=0
									
									  //…………………………………………………
								: ($l=Is date:K8:7)
									
									$o1[$t]:=!00-00-00!
									
									  //…………………………………………………
								: ($l=Is time:K8:8)
									
									$o1[$t]:=?00:00:00?
									
									  //…………………………………………………
								: ($l=Is picture:K8:10)
									
									$o1[$t]:=$p
									
									  //…………………………………………………
								Else 
									
									$o1[$t]:=Null:C1517
									
									  //…………………………………………………
							End case 
							
						Else 
							
							$o1[$t]:=New object:C1471
							$o1:=$o1[$t]
							
						End if 
						
					Else 
						
						If (Not:C34($b))
							
							$o1:=$o1[$t]
							
						End if 
					End if 
					
					If ($2.content#Null:C1517)\
						 & ($b)
						
						$o1[$t]:=$2.content
						
					End if 
				End for each 
				
			Else 
				
				$o.errors.push("Missing path parameter")
				
			End if 
			
			  //______________________________________________________
		: ($1="getByPath")
			
			$o.value:=$o.contents
			
			For each ($t;Split string:C1554($2.path;"."))
				
				$l:=Position:C15("[";$t)
				
				If ($l>0)
					
					$Txt_indx:=Substring:C12($t;$l+1;Position:C15("]";$t)-1)
					$t:=Delete string:C232($t;$l;Length:C16($t))
					
					If (Asserted:C1132(Value type:C1509($o.value[$t])=Is collection:K8:32))
						
						$o.value:=$o.value[$t][Num:C11($Txt_indx)]
						
					End if 
					
				Else 
					
					If (Asserted:C1132(Value type:C1509($o.value[$t])#Is collection:K8:32))
						
						  // Get the property
						$o.value:=$o.value[$t]
						
					End if 
				End if 
			End for each 
			
			  //______________________________________________________
		: ($1="testPath")
			
			$o.value:=False:C215
			
			$o1:=New object:C1471
			$Obj_schem:=$o1
			$ptr:=->$Obj_schem
			
			$c:=Split string:C1554($2.path;".")
			
			For each ($t;$c)
				
				$i:=$i+1
				$ptr->type:="object"
				$ptr->required:=New collection:C1472
				$ptr->required[0]:=$t
				
				If ($i<$c.length)
					
					$o2:=New object:C1471
					
					$ptr->properties:=New object:C1471
					$ptr->properties[$t]:=$o2
					
					$o1:=$o2
					
					$ptr:=->$o1
					
				End if 
			End for each 
			
			$o.value:=JSON Validate:C1456($o.contents;$Obj_schem).success
			
			  //______________________________________________________
		: ($1="remove")
			
			If ($2.key#Null:C1517)
				
				OB REMOVE:C1226($o;String:C10($2.key))
				
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