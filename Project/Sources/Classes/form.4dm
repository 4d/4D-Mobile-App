//=== === === === === === === === === === === === === === === === === === === === === 
Class constructor($method : Text)
	
	Super:C1705()
	
	This:C1470.name:=Current form name:C1298
	This:C1470.window:=Current form window:C827
	
	This:C1470.toBeInitialized:=True:C214
	
	This:C1470.callback:=Null:C1517
	This:C1470.worker:=Null:C1517
	
	This:C1470.isSubform:=False:C215
	
	This:C1470.focused:=Null:C1517
	This:C1470.current:=Null:C1517
	
	This:C1470.widgets:=New object:C1471
	
	If (Count parameters:C259>=1)
		
		This:C1470.setCallBack($method)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function init()
	
	ASSERT:C1129(False:C215; "👀 init() must be overriden by the subclass!")
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function saveContext()
	
	ASSERT:C1129(False:C215; "👀 saveContext() must overriden done by the subclass!")
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function restoreContext()
	
	ASSERT:C1129(False:C215; "👀 restore() must be overriden by the subclass!")
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// 🛠 IN WORKS
Function getWidgets()
	
	var $name : Text
	var $i; $type : Integer
	ARRAY TEXT:C222($objects; 0)
	
	FORM GET OBJECTS:C898($objects; Form all pages:K67:7)
	
	For ($i; 1; Size of array:C274($objects); 1)
		
		$name:=$objects{$i}
		$type:=OBJECT Get type:C1300(*; $name)
		
		Case of 
				//______________________________________________________
			: ($type=Object type push button:K79:16)\
				 | ($type=Object type radio button:K79:23)\
				 | ($type=Object type checkbox:K79:26)\
				 | ($type=Object type 3D button:K79:17)\
				 | ($type=Object type 3D checkbox:K79:27)\
				 | ($type=Object type 3D radio button:K79:24)\
				 | ($type=Object type picture button:K79:20)
				
				This:C1470[$name]:=cs:C1710.button($name)
				
				//______________________________________________________
			: ($type=Object type static text:K79:2)\
				 | ($type=Object type static picture:K79:3)\
				 | ($type=Object type line:K79:33)\
				 | ($type=Object type rectangle:K79:32)\
				 | ($type=Object type rounded rectangle:K79:34)\
				 | ($type=Object type oval:K79:35)
				
				This:C1470[$name]:=cs:C1710.static($name)
				
				//______________________________________________________
			: (False:C215)
				
				//______________________________________________________
			Else 
				
				// A "Case of" statement should never omit "Else"
				
				//______________________________________________________
		End case 
		
	End for 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Add form event(s) of the current form
Function appendEvents($events)
	
	This:C1470._setEvents($events; Enable events others unchanged:K42:38)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Remove form event(s) of the current form
Function removeEvents($events)
	
	This:C1470._setEvents($events; Disable events others unchanged:K42:39)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Define the event(s) of the current form
Function setEvents($events)
	
	This:C1470._setEvents($events; Enable events disable others:K42:37)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Set window title
Function setTitle($title : Text)
	
	SET WINDOW TITLE:C213($title; This:C1470.window)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Defines the name of the callback method
Function setCallBack($method : Text)
	
	This:C1470.callback:=$method
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Start a timer to update the user interface
	// Default delay is ASAP
Function refresh($delay : Integer)
	
	If (Count parameters:C259>=1)
		
		SET TIMER:C645($delay)
		
	Else 
		
		SET TIMER:C645(-1)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Creates a CALL FORM of the current form (callback) & with current callback method
	// .callMeBack ()
	// .callMeBack ( param : Collection )
	// .callMeBack ( param1, param2, …, paramN )
Function callMeBack($param; $param1; $paramN)
	
	C_VARIANT:C1683(${1})
	
	var $code : Text
	var $i : Integer
	var $parameters : Collection
	
	If (Length:C16(String:C10(This:C1470.callback))#0)
		
		If (Count parameters:C259=0)
			
			CALL FORM:C1391(This:C1470.window; This:C1470.callback)
			
		Else 
			
			$code:="<!--#4DCODE CALL FORM:C1391("+String:C10(This:C1470.window)+"; \""+This:C1470.callback+"\""
			
			If (Value type:C1509($1)=Is collection:K8:32)
				
				$parameters:=$1
				
				For ($i; 0; $parameters.length-1; 1)
					
					$code:=$code+"; $1["+String:C10($i)+"]"
					
				End for 
				
			Else 
				
				$parameters:=New collection:C1472
				
				For ($i; 1; Count parameters:C259; 1)
					
					$parameters.push(${$i})
					
					$code:=$code+"; $1["+String:C10($i-1)+"]"
					
				End for 
			End if 
			
			$code:=$code+")-->"
			
			PROCESS 4D TAGS:C816($code; $code; $parameters)
			
		End if 
		
	Else 
		
		ASSERT:C1129(False:C215; "Callback method is not defined.")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Creates a CALL FORM of the current form (callback) with the passed method
	// .callMe ( method : Text )
	// .callMe ( method : Text ; param : Collection )
	// .callMe ( method : Text ; param1, param2, …, paramN )
Function callMe($method : Text; $param1; $paramN)
	
	C_VARIANT:C1683(${2})
	
	var $code : Text
	var $i : Integer
	var $parameters : Collection
	
	If (Count parameters:C259=1)
		
		CALL FORM:C1391(This:C1470.window; $method)
		
	Else 
		
		$code:="<!--#4DCODE CALL FORM:C1391("+String:C10(This:C1470.window)+"; \""+$method+"\""
		
		If (Value type:C1509($2)=Is collection:K8:32)
			
			$parameters:=$2
			
			For ($i; 0; $parameters.length-1; 1)
				
				$code:=$code+"; $1["+String:C10($i)+"]"
				
			End for 
			
		Else 
			
			$parameters:=New collection:C1472
			
			For ($i; 2; Count parameters:C259; 1)
				
				$parameters.push(${$i})
				$code:=$code+"; $1["+String:C10($i-2)+"]"
				
			End for 
		End if 
		
		$code:=$code+")-->"
		
		PROCESS 4D TAGS:C816($code; $code; $parameters)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Associate a worker to the current form
Function setWorker($worker)
	
	var $type : Integer
	$type:=Value type:C1509($worker)
	
	If (Asserted:C1132(($type=Is text:K8:3) | ($type=Is real:K8:4) | ($type=Is longint:K8:6); "Wrong parameter type"))
		
		This:C1470.worker:=$worker
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Assigns a task to the associated worker
	// .callWorker ( method : Text )
	// .callWorker ( method : Text ; param : Collection )
	// .callWorker ( method : Text ; param1, param2, …, paramN )
	// ---------------------------------------------------------------------------------
	//#TO_DO : Accept an integer as first parameter to allow calling a specific worker.
	// .callWorker ( process : Integer ; method : Text )
	// .callWorker ( process : Integer ; method : Text ; param : Collection )
	// .callWorker ( process : Integer ; method : Text ; param1, param2, …, paramN )
	// ---------------------------------------------------------------------------------
Function callWorker($method; $param; $param1; $paramN)
	
	C_VARIANT:C1683(${2})
	
	var $code : Text
	var $i : Integer
	var $parameters : Collection
	
	If (This:C1470.worker#Null:C1517)
		
		If (Count parameters:C259=1)
			
			If (Asserted:C1132(This:C1470.worker#Null:C1517; "No associated worker"))
				
				CALL WORKER:C1389(This:C1470.worker; $method)
				
			End if 
			
		Else 
			
			$code:="<!--#4DCODE CALL WORKER:C1389(\""+This:C1470.worker+"\"; \""+$method+"\""
			
			If (Value type:C1509($2)=Is collection:K8:32)
				
				$parameters:=$2
				
				For ($i; 0; $parameters.length-1; 1)
					
					$code:=$code+"; $1["+String:C10($i)+"]"
					
				End for 
				
			Else 
				
				$parameters:=New collection:C1472
				
				For ($i; 2; Count parameters:C259; 1)
					
					$parameters.push(${$i})
					$code:=$code+"; $1["+String:C10($i-2)+"]"
					
				End for 
			End if 
			
			$code:=$code+")-->"
			
			PROCESS 4D TAGS:C816($code; $code; $parameters)
			
		End if 
		
	Else 
		
		ASSERT:C1129(False:C215; "Worker is not is not defined.")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Executes a project method in the context of a subform (without returned value)
	// .executeInSubform ( subform : Text ; method : Text )
	// .executeInSubform ( subform : Text ; method : Text ; param : Collection )
	// .executeInSubform ( subform : Text ; method : Text ; param1, param2, …, paramN )
Function callChild($subform : Text; $method : Text; $param; $param1; $paramN)
	
	C_VARIANT:C1683(${3})
	
	var $code : Text
	var $i : Integer
	var $parameters : Collection
	
	ARRAY TEXT:C222($widgets; 0)
	FORM GET OBJECTS:C898($widgets; Form all pages:K67:7)
	
	If (Find in array:C230($widgets; $subform)>0)
		
		If (Count parameters:C259=2)
			
			EXECUTE METHOD IN SUBFORM:C1085($subform; $method)
			
		Else 
			
			$code:="<!--#4DCODE EXECUTE METHOD IN SUBFORM:C1085(\""+$subform+"\"; \""+$method+"\";*"
			
			If (Value type:C1509($3)=Is collection:K8:32)
				
				$parameters:=$3
				
				For ($i; 0; $parameters.length-1; 1)
					
					$code:=$code+"; $1["+String:C10($i)+"]"
					
				End for 
				
			Else 
				
				$parameters:=New collection:C1472
				
				For ($i; 3; Count parameters:C259; 1)
					
					$parameters.push(${$i})
					
					$code:=$code+"; $1["+String:C10($i-3)+"]"
					
				End for 
			End if 
			
			$code:=$code+")-->"
			
			PROCESS 4D TAGS:C816($code; $code; $parameters)
			
		End if 
		
	Else 
		
		ASSERT:C1129(Structure file:C489=Structure file:C489(*); "Subform not found: "+$subform)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Send an event to the subform container
Function callParent($event : Integer)
	
	If (Asserted:C1132(This:C1470.isSubform; "🛑 Only applicable for sub-forms!"))
		
		CALL SUBFORM CONTAINER:C1086($event)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function dimensions()->$dimensions : Object
	
	var $height; $width : Integer
	
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
	
	$dimensions:=New object:C1471(\
		"width"; $width; \
		"height"; $height)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function height()->$height : Integer
	
	$height:=This:C1470.dimensions().height
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function width()->$width : Integer
	
	$width:=This:C1470.dimensions().width
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function goToPage($page : Integer; $subform : Boolean)
	
	var $_subform : Boolean
	
	If (Count parameters:C259>=2)
		
		// User's request
		$_subform:=$subform
		
	Else 
		
		$_subform:=This:C1470.isSubform
		
	End if 
	
	If ($_subform)
		
		// Change page of current subform
		FORM GOTO PAGE:C247($page; *)
		
	Else 
		
		FORM GOTO PAGE:C247($page)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function page($subform : Boolean)->$page : Integer
	
	var $_subform : Boolean
	
	If (Count parameters:C259>=1)
		
		// User's request
		$_subform:=$subform
		
	Else 
		
		$_subform:=This:C1470.isSubform
		
	End if 
	
	If ($_subform)
		
		// Current subform page
		$page:=FORM Get current page:C276(*)
		
	Else 
		
		$page:=FORM Get current page:C276
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// ⚠️ No optional parameter to allow the distinction between form and subform
Function firstPage()
	
	FORM FIRST PAGE:C250
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// ⚠️ No optional parameter to allow the distinction between form and subform
Function lastPage()
	
	FORM LAST PAGE:C251
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// ⚠️ No optional parameter to allow the distinction between form and subform
Function nextPage()
	
	FORM NEXT PAGE:C248
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// ⚠️ No optional parameter to allow the distinction between form and subform
Function previousPage()
	
	FORM PREVIOUS PAGE:C249
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Gives the focus to a widget in the current form
Function goTo($widget : Text)
	
	GOTO OBJECT:C206(*; $widget)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Remove any focus in the current form
Function removeFocus()
	
	GOTO OBJECT:C206(*; "")
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// [PRIVATE] set form events
Function _setEvents($events; $mode : Integer)
	
	ARRAY LONGINT:C221($codes; 0)
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($events)=Is collection:K8:32)
			
			COLLECTION TO ARRAY:C1562($events; $codes)
			
			//______________________________________________________
		: (Value type:C1509($events)=Is integer:K8:5)\
			 | (Value type:C1509($events)=Is longint:K8:6)\
			 | (Value type:C1509($events)=Is real:K8:4)
			
			ARRAY LONGINT:C221($codes; 1)
			APPEND TO ARRAY:C911($codes; $events)
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "The event parameter must be a n integer or a collection")
			
			//______________________________________________________
	End case 
	
	OBJECT SET EVENTS:C1239(*; ""; $codes; $mode)
	
	