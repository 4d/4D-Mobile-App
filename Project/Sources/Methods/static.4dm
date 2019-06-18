//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : static
  // ID[20AD4B700F0549EFA4FC0E20C0C6731F]
  // Created #14-6-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_OBJECT:C1216($o)

If (False:C215)
	C_OBJECT:C1216(static ;$0)
	C_TEXT:C284(static ;$1)
	C_OBJECT:C1216(static ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470._is=Null:C1517)
	
	$o:=New object:C1471(\
		"_is";"static";\
		"name";$1;\
		"visible";Formula:C1597(OBJECT Get visible:C1075(*;This:C1470.name));\
		"hide";Formula:C1597(OBJECT SET VISIBLE:C603(*;This:C1470.name;False:C215));\
		"show";Formula:C1597(OBJECT SET VISIBLE:C603(*;This:C1470.name;True:C214));\
		"setVisible";Formula:C1597(OBJECT SET VISIBLE:C603(*;This:C1470.name;Bool:C1537($1)));\
		"coordinates";Null:C1517;\
		"windowCoordinates";Null:C1517;\
		"getCoordinates";Formula:C1597(widget ("getCoordinates"));\
		"setCoordinates";Formula:C1597(widget ("setCoordinates";New object:C1471("left";$1;"top";$2;"right";$3;"bottom";$4)));\
		"moveHorizontally";Formula:C1597(widget ("setCoordinates";New object:C1471("left";$1)));\
		"resizeHorizontally";Formula:C1597(widget ("setCoordinates";New object:C1471("right";$1)));\
		"moveVertically";Formula:C1597(widget ("setCoordinates";New object:C1471("top";$1)));\
		"resizeVertically";Formula:C1597(widget ("setCoordinates";New object:C1471("bottom";$1)));\
		"bestSize";Formula:C1597(widget ("bestSize";New object:C1471("alignment";$1;"minWidth";$2;"maxWidth";$3)));\
		"title";Formula:C1597(OBJECT Get title:C1068(*;This:C1470.name));\
		"setTitle";Formula:C1597(OBJECT SET TITLE:C194(*;This:C1470.name;String:C10($1)))\
		)
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="xxxxx")
			
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