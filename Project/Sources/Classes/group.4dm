Class constructor
	
	C_VARIANT:C1683($1)
	C_OBJECT:C1216(${2})
	
	C_LONGINT:C283($i)
	C_TEXT:C284($t)
	
	Case of 
			
			  //___________________________
		: (Value type:C1509($1)=Is collection:K8:32)
			
			This:C1470.target:=$1
			
			  //___________________________
		: (Value type:C1509($1)=Is object:K8:27)  // 1 to n objects
			
			This:C1470.target:=New collection:C1472
			
			For ($i;1;Count parameters:C259;1)
				
				This:C1470.target.push(${$i})
				
			End for 
			
			  //___________________________
		: (Value type:C1509($1)=Is text:K8:3)  // Comma separated list of object names
			
			This:C1470.target:=New collection:C1472
			
			For each ($t;Split string:C1554($1;","))
				
				This:C1470.target.push(cs:C1710.widget.new($t))  // Widget by default
				
			End for each 
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Bad parameter type")
			
			  //______________________________________________________
	End case 
	
/*===============================================*/
Function include
	
	C_BOOLEAN:C305($0)
	C_VARIANT:C1683($1)
	
	Case of 
			
			  //______________________________________________________
		: (Value type:C1509($1)=Is object:K8:27)
			
			$0:=(This:C1470.target.indexOf($1)#-1)
			
			  //______________________________________________________
		: (Value type:C1509($1)=Is text:K8:3)
			
			$0:=(This:C1470.target.query("name=:1";$1).pop()#Null:C1517)
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unmanaged parameter type")
			
			  //______________________________________________________
	End case 
	
/*===============================================*/
Function distributeHorizontally
	
	C_OBJECT:C1216($1)
	
	C_LONGINT:C283($lGap;$offset)
	C_LONGINT:C283($lMinWidth;$lMaxWidth)
	C_OBJECT:C1216($o)
	
	If (Count parameters:C259>=1)
		
		If ($1.start#Null:C1517)
			
			$offset:=Num:C11($1.start)
			
		End if 
		
		If ($1.gap#Null:C1517)
			
			$lGap:=Num:C11($1.gap)
			
		End if 
		
		If ($1.minWidth#Null:C1517)
			
			$lMinWidth:=Num:C11($1.minWidth)
			
		End if 
		
		If ($1.maxWidth#Null:C1517)
			
			$lMaxWidth:=Num:C11($1.maxWidth)
			
		End if 
	End if 
	
	For each ($o;This:C1470.target)
		
		$o.bestSize()
		
		If ($offset#0)
			
			$o.moveHorizontally($offset-$o.coordinates.left)
			
		End if 
		
		  // Calculate the cumulative shift
		If ($lGap=0)
			
			Case of 
					
					  //_______________________________
				: ($o.type=Object type push button:K79:16)
					
					$offset:=$o.coordinates.right+20
					
					  //_______________________________
				: (False:C215)
					
					
					  //_______________________________
				Else 
					
					$offset:=$o.coordinates.right
					
					  //_______________________________
			End case 
			
		Else 
			
			$offset:=$o.coordinates.right+$lGap
			
		End if 
		
		
	End for each 
	
/*===============================================*/