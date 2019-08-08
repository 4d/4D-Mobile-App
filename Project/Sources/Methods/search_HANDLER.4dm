//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : search_HANDLER
  // Database: 4D Mobile Express
  // ID[6A9694008D0340B49FEAEEE879F690CB]
  // Created 11-10-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_;$Lon_bottom;$Lon_formEvent;$Lon_left;$Lon_parameters;$Lon_right)
C_LONGINT:C283($Lon_top;$Lon_width)
C_OBJECT:C1216($Obj_in)

If (False:C215)
	C_OBJECT:C1216(search_HANDLER ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Obj_in:=$1
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //=========================================================
	: ($Obj_in=Null:C1517)  // Form method
		
		$Lon_formEvent:=Form event code:C388
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Load:K2:1)
				
				  //OBJECT SET RGB COLORS(*;"border";0x00E5E5E5;Background color) #MOJAVE_TURN_AROUND
				OBJECT SET RGB COLORS:C628(*;"border";0x00E5E5E5;0x00FFFFFF)
				
				  //______________________________________________________
			: ($Lon_formEvent=On Bound Variable Change:K2:52)
				
				If (Not:C34(Is nil pointer:C315(OBJECT Get pointer:C1124(Object named:K67:5;"box"))))
					
					(OBJECT Get pointer:C1124(Object named:K67:5;"box"))->:=String:C10(Form:C1466.value)
					
				End if 
				
				OBJECT SET VISIBLE:C603(*;"close";Length:C16(String:C10(Form:C1466.value))#0)
				
				search_HANDLER (New object:C1471(\
					"action";Choose:C955(Length:C16(String:C10(Form:C1466.value))#0;"expand";"collapse")))
				
				OBJECT SET PLACEHOLDER:C1295(*;"box";String:C10(Form:C1466.placeholder))
				(OBJECT Get pointer:C1124(Object named:K67:5;"placeholder"))->:=String:C10(Form:C1466.placeholder)
				
				If (Not:C34(Bool:C1537(Form:C1466.expanded)))
					
					search_HANDLER (New object:C1471(\
						"action";"_collapse"))
					
				End if 
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
		  //=========================================================
	: ($Obj_in.action=Null:C1517)
		
		ASSERT:C1129(False:C215;"Missing parameter \"action\"")
		
		  //=========================================================
	: ($Obj_in.action="expand")
		
		If (Not:C34(Bool:C1537(Form:C1466.expanded)))
			
			OBJECT GET COORDINATES:C663(*;"border";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
			OBJECT SET COORDINATES:C1248(*;"glass";$Lon_left+3;$Lon_top+3;$Lon_left+3+14;$Lon_top+3+14)
			OBJECT SET COORDINATES:C1248(*;"box";$Lon_left+3+17;$Lon_top+2;$Lon_right-3;$Lon_bottom-2)
			
			Form:C1466.expanded:=True:C214
			
		End if 
		
		  //=========================================================
	: ($Obj_in.action="collapse")
		
		If (Bool:C1537(Form:C1466.expanded))
			
			search_HANDLER (New object:C1471(\
				"action";"_collapse"))
			
			Form:C1466.expanded:=False:C215
			
		End if 
		
		  //=========================================================
	: ($Obj_in.action="_collapse")
		
		OBJECT GET COORDINATES:C663(*;"border";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		
		OBJECT GET BEST SIZE:C717(*;"placeholder";$Lon_width;$Lon_)
		$Lon_width:=$Lon_width+14  // 14 = width of the glass
		$Lon_left:=($Lon_right-$Lon_left)\2-($Lon_width\2)
		
		OBJECT SET COORDINATES:C1248(*;"glass";$Lon_left;$Lon_top+3;$Lon_left+14;$Lon_top+3+14)
		
		$Lon_left:=$Lon_left+14+2
		OBJECT SET COORDINATES:C1248(*;"box";$Lon_left;$Lon_top+2;$Lon_left+$Lon_width;$Lon_bottom-2)
		
		  //=========================================================
	: ($Obj_in.action="search")
		
		GOTO OBJECT:C206(*;"box")
		
		  //=========================================================
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Obj_in.action+"\"")
		
		  //=========================================================
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End