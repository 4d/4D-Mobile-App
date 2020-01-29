//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : search_OBJECTS_HANDLER
  // ID[1F44951160F643B993A29A321D239EEE]
  // Created 11-10-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($event)

  // ----------------------------------------------------
  // Initialisations

  // NO PARAMETERS REQUIRED

  // Optional parameters
If (Count parameters:C259>=1)
	
	  // <NONE>
	
End if 

$event:=FORM Event:C1606

  // ----------------------------------------------------
Case of 
		
		  //==================================================
	: ($event.objectName="box")
		
		Case of 
				
				  //______________________________________________________
			: ($event.code=On Load:K2:1)\
				 | ($event.code=On Unload:K2:2)
				
				  // Restore default properties & positions
				OBJECT SET RGB COLORS:C628(*;"border";0x00E5E5E5;0x00FFFFFF)
				
				search_HANDLER (New object:C1471(\
					"action";"collapse"))
				
				  //______________________________________________________
			: ($event.code=On Getting Focus:K2:7)
				
				OBJECT SET RGB COLORS:C628(*;"border";Highlight menu background color:K23:7)
				
				search_HANDLER (New object:C1471(\
					"action";"expand"))
				
				  //______________________________________________________
			: ($event.code=On Losing Focus:K2:8)
				
				If (Length:C16(Get edited text:C655)=0)
					
					search_HANDLER (New object:C1471(\
						"action";"collapse"))
					
				End if 
				
				OBJECT SET RGB COLORS:C628(*;"border";0x00E5E5E5;0x00FFFFFF)
				
				  //______________________________________________________
			: ($event.code=On After Edit:K2:43)
				
				  // Restore default colors
				OBJECT SET RGB COLORS:C628(*;"box";Foreground color:K23:1;0x00FFFFFF)
				Form:C1466.value:=Get edited text:C655
				CALL SUBFORM CONTAINER:C1086(-1)
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessary ("+$event.description+")")
				
				  //______________________________________________________
		End case 
		
		OBJECT SET VISIBLE:C603(*;"close";Length:C16(String:C10(Form:C1466.value))#0)
		
		  //==================================================
	: ($event.objectName="close")
		
		Case of 
				
				  //______________________________________________________
			: ($event.code=On Clicked:K2:4)
				
				CLEAR VARIABLE:C89(OBJECT Get pointer:C1124(Object named:K67:5;"box")->)
				OBJECT SET VISIBLE:C603(*;$event.objectName;False:C215)
				Form:C1466.value:=""
				CALL SUBFORM CONTAINER:C1086(-1)
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$event.description+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($event.objectName="button")
		
		Case of 
				
				  //______________________________________________________
			: ($event.code=On Clicked:K2:4)
				
				GOTO OBJECT:C206(*;"box")
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$event.description+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End