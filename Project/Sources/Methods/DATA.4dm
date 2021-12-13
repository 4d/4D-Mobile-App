//%attributes = {"invisible":true}
// ----------------------------------------------------
// DATA pannel management
// ----------------------------------------------------
// Declarations
var $e; $ƒ : Object

// ----------------------------------------------------
// Initialisations
$ƒ:=panel_Load

// ----------------------------------------------------
If (FORM Event:C1606.objectName=Null:C1517)  // <== FORM METHOD
	
	$e:=panel_Common(On Load:K2:1; On Timer:K2:25)
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Load:K2:1)
			
			$ƒ.onLoad()
			
			//______________________________________________________
		: ($e.code=On Timer:K2:25)
			
			$ƒ.update()
			
			//______________________________________________________
	End case 
	
Else   // <== WIDGETS METHOD
	
	$e:=$ƒ.event
	
	Case of 
			
			//==============================================
		: ($ƒ.filter.catch())
			
			$ƒ.doFilter($e)
			
			//==============================================
		: ($ƒ.list.catch())
			
			$ƒ.doList($e)
			
			//==============================================
		: ($ƒ.method.catch($e; On Clicked:K2:4))
			
			EDITOR.editAuthenticationMethod()
			
			//==============================================
		: ($ƒ.validate.catch($e; On Clicked:K2:4))\
			 | ($ƒ.enter.catch($e; On Clicked:K2:4))
			
			$ƒ.list.focus()
			
			$ƒ.doValidateFilter()
			
			//==============================================
		: ($ƒ.embedded.catch($e; On Clicked:K2:4))
			
			var $table : Object
			$table:=$ƒ.current
			
			If (Bool:C1537($table.embedded))
				
				Form:C1466.dataModel[String:C10($table.tableNumber)][""].embedded:=True:C214
				
			Else 
				
				OB REMOVE:C1226(Form:C1466.dataModel[String:C10($table.tableNumber)][""]; "embedded")
				
			End if 
			
			PROJECT.save()
			$ƒ.update()
			
			//==============================================
		: ($ƒ.queryWidget.catch($e; On Clicked:K2:4))
			
			$ƒ.doQueryWidget()
			
			//________________________________________
	End case 
End if 