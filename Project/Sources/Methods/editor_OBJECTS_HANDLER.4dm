//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : editor_OBJECTS_HANDLER
  // ID[52D7D7A0793F480ABC65C764E08F0C31]
  // Created 17-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($bottom;$height;$left;$right;$top;$width)
C_POINTER:C301($ptr)
C_OBJECT:C1216($event;$o)

  // ----------------------------------------------------
  // Initialisations
$event:=FORM Event:C1606

  // ----------------------------------------------------
Case of 
		
		  //==================================================
	: ($event.objectName="browser")
		
		If ($event.code=-1)  // Hide
			
			CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"hideBrowser")
			
			$o:=Self:C308->
			
			If ($o.form#Null:C1517)
				
				Case of 
						
						  //______________________________________________________
					: ($o.selector="form-list")\
						 | ($o.selector="form-detail")  // Forms
						
						$o.action:="forms"
						$o.selector:=Replace string:C233($o.selector;"form-";"")
						CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"setForm";$o)
						
						  //______________________________________________________
					: ($o.selector="form-formatter")
						
						  //
						
						  //______________________________________________________
					: ($o.selector="form-login")
						
						  //
						
						  //______________________________________________________
					Else 
						
						  // A "Case of" statement should never omit "Else"
						  //______________________________________________________
				End case 
			End if 
		End if 
		
		  //==================================================
	: ($event.objectName="message")
		
		Case of 
				
				  //______________________________________________________
			: ($event.code<0)  // <SUBFORM EVENTS>
				
				$ptr:=OBJECT Get pointer:C1124(Object current:K67:2)
				
				Case of 
						
						  //…………………………………………………………………………………………………
					: ($event.code=-2)\
						 | ($event.code=-1)  // Close
						
						If ($ptr->tips.enabled)
							
							  // Restore help tips status
							$o:=ui.tips
							$o.enable()
							$o.setDuration($ptr->tips.delay)
							
						End if 
						
						$ptr->:=New object:C1471
						
						OBJECT SET VISIBLE:C603(*;"message@";False:C215)
						
						  //…………………………………………………………………………………………………
					Else 
						
						  // Resizing
						OBJECT GET COORDINATES:C663(*;$event.objectName;$left;$top;$right;$bottom)
						
						$bottom:=$top+Abs:C99($event.code)
						
						  // Limit to the window's height [
						OBJECT GET SUBFORM CONTAINER SIZE:C1148($width;$height)
						
						If ($bottom>($height-20))
							
							$bottom:=$height-20
							
							$ptr->scrollbar:=True:C214
							$ptr->:=$ptr->  // Touch
							
						End if 
						  //]
						
						OBJECT SET COORDINATES:C1248(*;$event.objectName;$left;$top;$right;$bottom)
						
						  //…………………………………………………………………………………………………
				End case 
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$event.description+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	Else 
		
		ASSERT:C1129(False:C215;"Unknown object: \""+$event.objectName+"\"")
		
		  //==================================================
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End