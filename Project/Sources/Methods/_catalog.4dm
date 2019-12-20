//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : _catalog
  // ID[EA24F65ED9BE4E64B8616A4B2A31A494]
  // Created 20-12-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_TEXT:C284($t)
C_OBJECT:C1216($o;$oo)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(_catalog ;$0)
	C_TEXT:C284(_catalog ;$1)
	C_OBJECT:C1216(_catalog ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)  // Constructor
	
	$o:=New object:C1471(\
		"";"catalog";\
		"datastore";Null:C1517;\
		"result";Null:C1517;\
		"success";False:C215;\
		"errors";New collection:C1472;\
		"warnings";New collection:C1472;\
		"get";Formula:C1597(_catalog ("get"));\
		"table";Formula:C1597(_catalog ("table";New object:C1471("name";String:C10($1);"kind";$2)))\
		)
	
	If (Count parameters:C259>=1)
		
		If (Count parameters:C259>=2)
			
			$o.datastore:=$2
			
		Else 
			
			$o.get()
			
		End if 
		
		$t:=String:C10($1)
		
		If (Length:C16($t)>0)
			
			$o.table($t)
			
		End if 
		
	Else 
		
		$o.get()
		
	End if 
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="get")
			
			$o.datastore:=Null:C1517
			
			$oo:=Build Exposed Datastore:C1598
			$o.success:=($oo#Null:C1517)
			
			If ($o.success)
				
				$o.datastore:=$oo
				
			Else 
				
				$o.errors.push("Null datastore")
				
			End if 
			
			  //______________________________________________________
		: ($1="table")
			
			ASSERT:C1129($2.name#Null:C1517)
			
			If ($o.datastore=Null:C1517)
				
				$o.get()
				
			End if 
			
			$o.success:=Not:C34($o.datastore=Null:C1517)
			
			If ($o.success)
				
				$o.success:=($o.datastore[$2.name]#Null:C1517)
				
				If ($o.success)
					
					$oo:=$o.datastore[$2.name]
					$o.success:=($oo#Null:C1517)
					
				End if 
				
				If ($o.success)
					
					$o.result:=New object:C1471(\
						"infos";$oo.getInfo();\
						"fields";Null:C1517\
						)
					
					$c:=New collection:C1472  //
					
					For each ($t;$oo)
						
						Case of 
								
								  //………………………………………………………………………………………………
							: ($oo[$t].kind="storage")
								
								$oo[$t].typeLegacy:=$oo[$t].fieldType
								$c.push($oo[$t])
								
								  //………………………………………………………………………………………………
							: ($oo[$t].kind="relatedEntity")
								
								$c.push($oo[$t])
								
								  //………………………………………………………………………………………………
							: ($oo[$t].kind="relatedEntities")
								
								$c.push($oo[$t])
								
								  //………………………………………………………………………………………………
							Else 
								
								$o.warnings.push("Unmanaged kind \""+$oo[$t].kind+"\" for field \""+$oo[$t]+"\"")
								
								  //………………………………………………………………………………………………
						End case 
					End for each 
					
					If ($2.kind#Null:C1517)
						
						$c:=$c.query("kind = :1";String:C10($2.kind))
						
					End if 
					
					$o.result.fields:=$c
					
				Else 
					
					$o.errors.push("Table not found \""+String:C10($2.name)+"\"")
					
				End if 
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