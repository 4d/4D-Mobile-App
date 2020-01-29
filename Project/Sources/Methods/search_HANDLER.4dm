//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : search_HANDLER
  // ID[6A9694008D0340B49FEAEEE879F690CB]
  // Created 11-10-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_LONGINT:C283($bottom;$height;$left;$right;$top;$width)
C_TEXT:C284($t)
C_OBJECT:C1216($event;$oIN)

If (False:C215)
	C_OBJECT:C1216(search_HANDLER ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations

  // NO PARAMETERS REQUIRED

  // Optional parameters
If (Count parameters:C259>=1)
	
	$oIN:=$1
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //=========================================================
	: ($oIN=Null:C1517)  // Form method
		
		$event:=FORM Event:C1606
		
		Case of 
				
				  //___________________________________________
			: ($event.code=On Load:K2:1)
				
				  // OBJECT SET RGB COLORS(*;"border";0x00E5E5E5)
				
				  //___________________________________________
			: ($event.code=On Bound Variable Change:K2:52)
				
				$t:=String:C10(Form:C1466.value)
				
				If (Not:C34(Is nil pointer:C315(OBJECT Get pointer:C1124(Object named:K67:5;"box"))))
					
					(OBJECT Get pointer:C1124(Object named:K67:5;"box"))->:=$t
					
				End if 
				
				OBJECT SET VISIBLE:C603(*;"close";Length:C16($t)#0)
				
				search_HANDLER (New object:C1471(\
					"action";Choose:C955(Length:C16($t)#0;"expand";"collapse")))
				
				OBJECT SET PLACEHOLDER:C1295(*;"box";String:C10(Form:C1466.placeholder))
				(OBJECT Get pointer:C1124(Object named:K67:5;"placeholder"))->:=String:C10(Form:C1466.placeholder)
				
				If (Not:C34(Bool:C1537(Form:C1466.expanded)))
					
					search_HANDLER (New object:C1471(\
						"action";"_collapse"))
					
				End if 
				
				  //___________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$event.description+")")
				
				  //___________________________________________
		End case 
		
		  //=========================================================
	: ($oIN.action=Null:C1517)
		
		ASSERT:C1129(False:C215;"Missing parameter \"action\"")
		
		  //=========================================================
	: ($oIN.action="expand")
		
		If (Not:C34(Bool:C1537(Form:C1466.expanded)))
			
			OBJECT GET COORDINATES:C663(*;"border";$left;$top;$right;$bottom)
			OBJECT SET COORDINATES:C1248(*;"glass";$left+3;$top+3;$left+3+14;$top+3+14)
			OBJECT SET COORDINATES:C1248(*;"box";$left+3+17;$top+2;$right-3;$bottom-2)
			
			Form:C1466.expanded:=True:C214
			
		End if 
		
		  //=========================================================
	: ($oIN.action="collapse")
		
		If (Bool:C1537(Form:C1466.expanded))
			
			search_HANDLER (New object:C1471(\
				"action";"_collapse"))
			
			Form:C1466.expanded:=False:C215
			
		End if 
		
		  //=========================================================
	: ($oIN.action="_collapse")
		
		OBJECT GET COORDINATES:C663(*;"border";$left;$top;$right;$bottom)
		
		OBJECT GET BEST SIZE:C717(*;"placeholder";$width;$height)
		$width:=$width+14  // 14 = width of the glass
		$left:=($right-$left)\2-($width\2)
		
		OBJECT SET COORDINATES:C1248(*;"glass";$left;$top+3;$left+14;$top+3+14)
		
		$left:=$left+14+2
		OBJECT SET COORDINATES:C1248(*;"box";$left;$top+2;$left+$width;$bottom-2)
		
		  //=========================================================
	: ($oIN.action="search")
		
		GOTO OBJECT:C206(*;"box")
		
		  //=========================================================
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$oIN.action+"\"")
		
		  //=========================================================
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End