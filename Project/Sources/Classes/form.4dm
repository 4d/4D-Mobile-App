//===================================================================================
Class constructor($method : Text)
	
	Super:C1705()
	
	This:C1470.name:=Current form name:C1298
	This:C1470.window:=Current form window:C827
	
	This:C1470.callback:=Null:C1517
	This:C1470.worker:=Null:C1517
	
	This:C1470.widgets:=New object:C1471
	This:C1470.focused:=Null:C1517
	This:C1470.current:=Null:C1517
	
	If (Count parameters:C259>=1)
		
		This:C1470.setCallBack($method)
		
	End if 
	
	//===================================================================================
Function setTitle($title : Text)
	
	SET WINDOW TITLE:C213($title; This:C1470.window)
	
	//===================================================================================
	// Defines the name of the callback method
Function setCallBack($method : Text)
	
	This:C1470.callback:=$method
	
	//===================================================================================
	// Start a timer to update the user interface
	// Default delay is ASAP
Function refresh($delay : Integer)
	
	If (Count parameters:C259>=1)
		
		SET TIMER:C645($delay)
		
	Else 
		
		SET TIMER:C645(-1)
		
	End if 
	
	//===================================================================================
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
	
	//===================================================================================
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
	
	//===================================================================================
	// Associate a worker to the current form
Function setWorker($worker)
	
	var $type : Integer
	$type:=Value type:C1509($worker)
	
	If (Asserted:C1132(($type=Is text:K8:3) | ($type=Is real:K8:4) | ($type=Is longint:K8:6); "Wrong parameter type"))
		
		This:C1470.worker:=$worker
		
	End if 
	
	//===================================================================================
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
	
	//===================================================================================
	// Executes a project method in the context of a subform (without returned value)
	// .executeInSubform ( subform : Text ; method : Text )
	// .executeInSubform ( subform : Text ; method : Text ; param : Collection )
	// .executeInSubform ( subform : Text ; method : Text ; param1, param2, …, paramN )
Function executeInSubform($subform : Text; $method : Text; $param; $param1; $paramN)
	
	C_VARIANT:C1683(${3})
	
	var $code : Text
	var $i : Integer
	var $parameters : Collection
	
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
	
	//===================================================================================
Function dimensions()->$dimensions : Object
	
	var $height; $width : Integer
	
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
	
	$dimensions:=New object:C1471(\
		"width"; $width; \
		"height"; $height)
	
	//===================================================================================
Function height()->$height : Integer
	
	$height:=This:C1470.dimensions().height
	
	//===================================================================================
Function width()->$width : Integer
	
	$width:=This:C1470.dimensions().width
	
	//===================================================================================
Function goToPage($page : Integer)
	
	FORM GOTO PAGE:C247($page)
	
	//===================================================================================
Function page()->$page : Integer
	
	$page:=FORM Get current page:C276
	
	//===================================================================================
Function firstPage()
	
	FORM FIRST PAGE:C250
	
	//===================================================================================
Function lastPage()
	
	FORM LAST PAGE:C251
	
	//===================================================================================
Function nextPage()
	
	FORM NEXT PAGE:C248
	
	//===================================================================================
Function previousPage()
	
	FORM PREVIOUS PAGE:C249
	
	