//====================================================================
Class extends tools

//====================================================================
Class constructor($method : Text)
	
	Super:C1705()
	
	This:C1470.name:=Current form name:C1298
	This:C1470.window:=Current form window:C827
	This:C1470.callback:=Null:C1517
	
	This:C1470.focused:=Null:C1517
	This:C1470.current:=Null:C1517
	
	This:C1470.callback:=""
	
	If (Count parameters:C259>=1)
		
		This:C1470.setCallBack($method)
		
	End if 
	
	//====================================================================
Function setTitle($title : Text)
	
	SET WINDOW TITLE:C213($title; This:C1470.window)
	
	//====================================================================
	// Defines the name of the callback method
Function setCallBack($method : Text)
	
	This:C1470.callback:=$method
	
	//====================================================================
	// Start a timer to update the user interface
	// Default delay is ASAP
Function refresh($delay : Integer)
	
	If (Count parameters:C259>=1)
		
		SET TIMER:C645($delay)
		
	Else 
		
		SET TIMER:C645(-1)
		
	End if 
	
	//===================================================================================
	// Post a simple action message for the current form (retro-call)
Function post($action : Text)
	
	CALL FORM:C1391(This:C1470.window; This:C1470.callback; $action)
	
	//====================================================================
	// Generates a CALL FORM using the current form (retro-call)
	// .call()
	// .call( param : Collection )
	// .call( param1, param2, …, paramN )
Function call($param; $param1; $paramN)
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
	
	//====================================================================
	// Execute a project method in the context of a subform (without return value)
	// .execute( subform : Text ; method : Text )
	// .execute( subform : Text ; method : Text ; param : Collection )
	// .execute( subform : Text ; method : Text ; param1, param2, …, paramN )
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
	
	//====================================================================
Function dimensions()->$dimensions : Object
	
	var $height; $width : Integer
	
	FORM GET PROPERTIES:C674(String:C10(This:C1470.name); $width; $height)
	
	$dimensions:=New object:C1471("width"; $width; "height"; $height)
	
	//====================================================================
Function height()->$height : Integer
	
	$height:=This:C1470.dimensions().height
	
	//====================================================================
Function width()->$width : Integer
	
	$width:=This:C1470.dimensions().width
	
	//====================================================================
Function goToPage($page : Integer)
	
	FORM GOTO PAGE:C247($page)
	
	//====================================================================
Function getPage()->$page : Integer
	
	$page:=FORM Get current page:C276
	
	//====================================================================
Function firstPage()
	
	FORM FIRST PAGE:C250
	
	//====================================================================
Function lastPage()
	
	FORM LAST PAGE:C251
	
	//====================================================================
Function nextPage()
	
	FORM NEXT PAGE:C248
	
	//====================================================================
Function previousPage()
	
	FORM PREVIOUS PAGE:C249
	
	