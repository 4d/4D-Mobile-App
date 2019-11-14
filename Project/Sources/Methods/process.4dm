//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : process
  // ID[95A9C48322674708AFC2C26C4F571CD4]
  // Created 27-6-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($Lon_mode;$Lon_origin;$Lon_state;$Lon_time;$Lon_uid)
C_TEXT:C284($t;$Txt_name)
C_OBJECT:C1216($o)

If (False:C215)
	C_OBJECT:C1216(process ;$0)
	C_TEXT:C284(process ;$1)
	C_OBJECT:C1216(process ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)  // Constructor
	
	$t:=String:C10($1)
	
	$o:=New object:C1471(\
		"";"process";\
		"number";Choose:C955(Count parameters:C259=0;Current process:C322;Process number:C372($t));\
		"name";"";\
		"state";0;\
		"time";0;\
		"mode";0;\
		"uid";0;\
		"origin";0;\
		"visible";False:C215;\
		"isPreemptif";False:C215;\
		"isCooperatif";True:C214;\
		"frontmost";True:C214;\
		"update";Formula:C1597(process ("update"));\
		"hide";Formula:C1597(process ("hide"));\
		"show";Formula:C1597(process ("show"));\
		"toFront";Formula:C1597(process ("toFront"));\
		"pause";Formula:C1597(PAUSE PROCESS:C319(This:C1470.number));\
		"resume";Formula:C1597(RESUME PROCESS:C320(This:C1470.number))\
		)
	
	$o.update()
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="update")
			
			PROCESS PROPERTIES:C336($o.number;$Txt_name;$Lon_state;$Lon_time;$Lon_mode;$Lon_uid;$Lon_origin)
			
			$o.name:=$Txt_name
			$o.state:=$Lon_state
			$o.time:=$Lon_time
			$o.mode:=$Lon_mode
			$o.uid:=$Lon_uid
			$o.origin:=$Lon_origin
			$o.visible:=($Lon_mode ?? 0)
			$o.isPreemptif:=($Lon_mode ?? 1)
			$o.isCooperatif:=Not:C34($o.isPreemptif)
			
			If ($o.isCooperatif)
				
				$o.frontmost:=Formula from string:C1601(":C327=$1").call(Null:C1517;$o.number)
				
			End if 
			
			  //______________________________________________________
		: ($o.isPreemptif)
			
			_4D THROW ERROR:C1520(New object:C1471(\
				"component";"CLAS";\
				"code";1;\
				"description";"The method "+String:C10($1)+"() for class "+String:C10($o._is)+" can't be called in preemptive mode"))
			
			  //______________________________________________________
		: ($1="hide")
			
			Formula from string:C1601("C324($1)").call(Null:C1517;$o.number)
			
			  //______________________________________________________
		: ($1="show")
			
			Formula from string:C1601("C325($1)").call(Null:C1517;$o.number)
			
			  //______________________________________________________
		: ($1="toFront")
			
			Formula from string:C1601("C326($1)").call(Null:C1517;$o.number)
			
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