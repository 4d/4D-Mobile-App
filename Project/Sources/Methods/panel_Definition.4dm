//%attributes = {"invisible":true}
#DECLARE($name : Text)->$definition : Object

var $form : Text

// The name of the managed form
If (Count parameters:C259>=1)
	
	$form:=$name
	
Else 
	
	// Default
	$form:=Current form name:C1298
	
End if 

// Create the object if any
If (Form:C1466.$dialog=Null:C1517)
	
	RECORD.info("🛑 CREATE $dialog (panel_Definition)")
	
	Form:C1466.$dialog:=New object:C1471(\
		$form; New object:C1471)
	
Else 
	
	If (Form:C1466.$dialog[$form]=Null:C1517)
		
		RECORD.info("👀 Create "+$form+"'s context (panel_Definition)")
		Form:C1466.$dialog[$form]:=New object:C1471
		
	End if 
End if 

If (OB Is empty:C1297(Form:C1466.$dialog[$form]))
	
	// Instantiate the corresponding dialog class instance
	RECORD.info("🚧 Create "+$form+"'s class (panel_Definition)")
	Form:C1466.$dialog[$form]:=cs:C1710[$form].new()
	
	// Define local functions ***** SHOULD BE NO MORE NECESSARY WHEN CLASSES WILL BE USED ANYWHERE ****
	Form:C1466.$dialog[$form].callWorker:=Formula:C1597(CALL WORKER:C1389("4D Mobile ("+String:C10(Form:C1466.$dialog[$form].window)+")"; $1; $2))
	
End if 

$definition:=Form:C1466.$dialog[$form]

// Always return the current event
$definition.event:=FORM Event:C1606

//and the focused widget
$definition.focused:=OBJECT Get name:C1087(Object with focus:K67:3)
