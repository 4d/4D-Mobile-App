//%attributes = {"invisible":true,"preemptive":"incapable"}
  // ----------------------------------------------------
  // Project method : DO_MESSAGE
  // ID[D57C4FF31B0C49C98965D4645A31B3B1]
  // Created 3-7-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_keys)
C_OBJECT:C1216($o;$Obj_in;$Obj_message)

If (False:C215)
	C_OBJECT:C1216(DO_MESSAGE ;$1)
End if 

  // ----------------------------------------------------
  // Declarations

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (String:C10($Obj_in.action)="reset")
	
	(OBJECT Get pointer:C1124(Object named:K67:5;"message"))->:=New object:C1471
	
Else 
	
	$Obj_message:=(OBJECT Get pointer:C1124(Object named:K67:5;"message"))->
	
	Case of 
			
			  //______________________________________________________
		: ($Obj_in.action=Null:C1517)
			
			  // NOTHING MORE TO DO
			
			  //______________________________________________________
		: ($Obj_in.action="show")
			
			  // Get help tips status
			$o:=ui.tips
			
			$Obj_message:=ob_createPath ($Obj_message;"tips")
			$Obj_message.tips:=$o
			
			$o.disable()
			
			OBJECT SET VISIBLE:C603(*;"message@";True:C214)
			
			  //______________________________________________________
		: ($Obj_in.action="hide")
			
			  // Don't dismiss an alert or confirmation
			If ($Obj_message.type#"alert")\
				 & ($Obj_message.type#"confirm")
				
				OBJECT SET VISIBLE:C603(*;"message@";False:C215)
				
			End if 
			
			If ($Obj_message.tips.enabled)
				
				  // Restore help tips status
				$o:=ui.tips
				$o.enable()
				$o.setDuration($Obj_message.tips.delay)
				
			End if 
			
			  //______________________________________________________
		: ($Obj_in.action="reset")
			
			$Obj_in:=New object:C1471
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$Obj_in.action+"\"")
			
			  //______________________________________________________
	End case 
	
	If ($Obj_message=Null:C1517)
		
		$Obj_message:=New object:C1471
		
	End if 
	
	For each ($Txt_keys;$Obj_in)
		
		$Obj_message[$Txt_keys]:=$Obj_in[$Txt_keys]
		
	End for each 
	
	(OBJECT Get pointer:C1124(Object named:K67:5;"message"))->:=$Obj_message
	
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End