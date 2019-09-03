//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : tips
  // ID[9C19706DC1804A97BA6A00C104BEE765]
  // Created 3-9-2019 by Vincent de Lachaux
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
	C_OBJECT:C1216(tips ;$0)
	C_TEXT:C284(tips ;$1)
	C_OBJECT:C1216(tips ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470._is=Null:C1517)  // Constructor
	
	$t:=String:C10($1)
	
	$o:=New object:C1471(\
		"_is";"tips";\
		"enabled";(Get database parameter:C643(Tips enabled:K37:79)=1);\
		"delay";Get database parameter:C643(Tips delay:K37:80);\
		"duration";Get database parameter:C643(Tips duration:K37:81);\
		"enable";Formula:C1597(SET DATABASE PARAMETER:C642(Tips enabled:K37:79;1));\
		"disable";Formula:C1597(SET DATABASE PARAMETER:C642(Tips enabled:K37:79;0));\
		"instantly";Formula:C1597(SET DATABASE PARAMETER:C642(Tips delay:K37:80;1));\
		"setDuration";Formula:C1597(SET DATABASE PARAMETER:C642(Tips duration:K37:81;$1));\
		"default";Formula:C1597(tips ("default"));\
		"defaultDelay";Formula:C1597(SET DATABASE PARAMETER:C642(Tips delay:K37:80;45));\
		"defaultDuration";Formula:C1597(SET DATABASE PARAMETER:C642(Tips duration:K37:81;720))\
		)
	
Else 
	
	$o:=This:C1470
	
	Case of 
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="default")
			
			SET DATABASE PARAMETER:C642(Tips delay:K37:80;45)
			SET DATABASE PARAMETER:C642(Tips duration:K37:81;720)
			
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