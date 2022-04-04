//%attributes = {"invisible":true}
#DECLARE($form : Text)->$definition : Object

If (False:C215)
	C_TEXT:C284(panel_Load; $1)
	C_OBJECT:C1216(panel_Load; $0)
End if 

// The name of the managed form, the current form if omitted.
$form:=$form || Current form name:C1298

// Create the object if any
If (Form:C1466.$dialog=Null:C1517)
	
	Logger.info("📍 Create $dialog (panel_Definition: "+$form+")")
	Form:C1466.$dialog:=New object:C1471
	
End if 

If (Form:C1466.$dialog[$form]=Null:C1517)
	
	Logger.info("👀 Create "+$form+"'s object (panel_Definition)")
	Form:C1466.$dialog[$form]:=New object:C1471
	
End if 

If (OB Is empty:C1297(Form:C1466.$dialog[$form]))
	
	// Instantiate the corresponding dialog class
	Logger.info("🚧 Create "+$form+"'s class (panel_Definition)")
	Form:C1466.$dialog[$form]:=cs:C1710[$form].new()
	
	// Define local functions ***** SHOULD BE NO MORE NECESSARY WHEN CLASSES WILL BE USED ANYWHERE ****
	Form:C1466.$dialog[$form].callWorker:=Formula:C1597(CALL WORKER:C1389("4D Mobile ("+String:C10(Form:C1466.$dialog[$form].window)+")"; $1; $2))
	
End if 

$definition:=Form:C1466.$dialog[$form]

// Always return the current event
$definition.event:=FORM Event:C1606