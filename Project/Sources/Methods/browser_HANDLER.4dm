//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : BROWSER_Handler
  // ID[E97E394A05F8412382AF3E00D5EB20D1]
  // Created 9-1-2020 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_OBJECT:C1216($event;$form;$Obj_in;$Obj_out)

If (False:C215)
	C_OBJECT:C1216(BROWSER_Handler ;$0)
	C_OBJECT:C1216(BROWSER_Handler ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations

  // NO PARAMETERS REQUIRED

  // Optional parameters
If (Count parameters:C259>=1)
	
	$Obj_in:=$1
	
End if 

$form:=New object:C1471(\
"web";ui.web("webArea");\
"wait";ui.widget("spinner")\
)

  // ----------------------------------------------------

Case of 
		
		  //=========================================================
	: ($Obj_in=Null:C1517)  // Form method
		
		$event:=FORM Event:C1606
		
		Case of 
				
				  //______________________________________________________
			: ($event.code=On Load:K2:1)
				
				(OBJECT Get pointer:C1124(Object named:K67:5;"spinner"))->:=1
				
				SET TIMER:C645(-1)
				
				  //______________________________________________________
			: ($event.code=On Unload:K2:2)
				
				  //
				
				  //______________________________________________________
			: ($event.code=On Timer:K2:25)
				
				SET TIMER:C645(0)
				
				  //______________________________________________________
			: ($event.code=On Bound Variable Change:K2:52)
				
				$form.web.openURL(Form:C1466.url)
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($event.code)+")")
				
				  //______________________________________________________
		End case 
		
		  //=========================================================
	: ($Obj_in.action=Null:C1517)  // Error
		
		ASSERT:C1129(False:C215;"Missing parameter \"action\"")
		
		  //=========================================================
	: ($Obj_in.action="init")  // Return the form objects definition
		
		$Obj_out:=$form
		
		  //=========================================================
End case 

  // ----------------------------------------------------
  // Return
  //%W-518.7
Case of 
		
		  //________________________________________
	: (Undefined:C82($Obj_out))
		
		  //________________________________________
	: ($Obj_out=Null:C1517)
		
		  //________________________________________
	: (Value type:C1509(($Obj_out=Null:C1517))=Is undefined:K8:13)
		
		  //________________________________________
	Else 
		
		$0:=$Obj_out
		
		  //________________________________________
End case 
  //%W+518.7
  // ----------------------------------------------------
  // End