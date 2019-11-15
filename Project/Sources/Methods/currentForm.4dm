//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : currentForm
  // ID[6EAA668489F445829FEC97F4D374610F]
  // Created 14-11-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_TEXT:C284($t)
C_OBJECT:C1216($o)

If (False:C215)
	C_OBJECT:C1216(currentForm ;$0)
	C_TEXT:C284(currentForm ;$1)
	C_OBJECT:C1216(currentForm ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)  // Constructor
	
	If (Count parameters:C259>=1)
		
		$t:=String:C10($1)
		
	End if 
	
	$o:=New object:C1471(\
		"";"currentForm";\
		"callback";$t;\
		"name";Current form name:C1298;\
		"window";Current form window:C827;\
		"eventCode";Null:C1517;\
		"current";Null:C1517;\
		"currentPtr";Null:C1517;\
		"focusedWidget";Null:C1517;\
		"refresh";Formula:C1597(SET TIMER:C645(-1));\
		"call";Formula:C1597(currentForm ("call";Choose:C955(Value type:C1509($1)=Is object:K8:27;$1;New object:C1471("parameters";$1))));\
		"get";Formula:C1597(currentForm );\
		"getEvent";Formula:C1597(currentForm ("getEvent"));\
		"getCurrentWidget";Formula:C1597(currentForm ("getCurrentWidget"));\
		"getFocusedWidget";Formula:C1597(currentForm ("getFocusedWidget"))\
		)
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: (Count parameters:C259=0)  // Update with current values
			
			$o.getEvent()
			$o.getCurrentWidget()
			$o.getFocusedWidget()
			
			  // MOUSEX & MOUSEY are not updated during D&D events
			If ($o.eventCode=On Drag Over:K2:13)\
				 | ($o.eventCode=On Drop:K2:12)
				
				MOUSEX:=Drop position:C608(MOUSEY)
				
			End if 
			
			  //______________________________________________________
		: ($1="getEvent")
			
			$o.eventCode:=Form event code:C388
			
			  //______________________________________________________
		: ($1="getCurrentWidget")
			
			$o.current:=OBJECT Get name:C1087(Object current:K67:2)
			$o.currentPtr:=OBJECT Get pointer:C1124(Object current:K67:2)
			
			  //______________________________________________________
		: ($1="getFocusedWidget")
			
			$o.focusedWidget:=OBJECT Get name:C1087(Object with focus:K67:3)
			
			  //______________________________________________________
		: ($1="call")
			
			If (Length:C16($o.callback)#0)
				
				If (Value type:C1509($2.parameters)=Is collection:K8:32)
					
					If ($2.parameters.length=2)
						
						CALL FORM:C1391($o.window;$o.callback;$2.parameters[0];$2.parameters[1])
						
					Else 
						
						CALL FORM:C1391($o.window;$o.callback;$2.parameters[0])
						
					End if 
					
				Else 
					
					CALL FORM:C1391($o.window;$o.callback;$2.parameters)
					
				End if 
				
			Else 
				
				ASSERT:C1129(False:C215;"Callback method is not defined.")
				
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