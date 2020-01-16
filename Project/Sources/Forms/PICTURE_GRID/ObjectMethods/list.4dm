  // ----------------------------------------------------
  // Object method : PICTURE_GRID.list - (4D Mobile Express)
  // ID[078AE56128534655A7A97E784BD5F77C]
  // Created 27-10-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($column;$indx;$l;$Lon_x;$Lon_y;$row)
C_TEXT:C284($Txt_me)
C_OBJECT:C1216($event)

  // ----------------------------------------------------
  // Initialisations
$event:=FORM Event:C1606
$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($event.code=On Clicked:K2:4)
		
		If (Not:C34(Macintosh command down:C546))
			
			LISTBOX GET CELL POSITION:C971(*;$Txt_me;$column;$row)
			
		End if 
		
		Form:C1466.selectColumn:=$column
		Form:C1466.selectRow:=$row
		
		$indx:=(LISTBOX Get number of columns:C831(*;$Txt_me)*($row-1))+$column
		
		If ($indx<=Form:C1466.pictures.length)
			
			Form:C1466.item:=$indx
			
		End if 
		
		If (Is nil pointer:C315(OBJECT Get pointer:C1124(Object subform container:K67:4)))
			
			ACCEPT:C269  // Auto valid
			
		Else 
			
			CALL SUBFORM CONTAINER:C1086(-1)  // Call the parent form
			
		End if 
		
		  //______________________________________________________
	: ($event.code=On Scroll:K2:57)
		
		OBJECT SET VISIBLE:C603(*;"selection";False:C215)
		SET TIMER:C645(-1)
		
		  //______________________________________________________
	: (Not:C34(Bool:C1537(Form:C1466.tips)))
		
		  // No tips
		
		  //______________________________________________________
	: ($event.code=On Mouse Enter:K2:33)
		
		ui.tips.enable()
		ui.tips.instantly()
		ui.tips.setDuration(45*5)
		
		  //______________________________________________________
	: ($event.code=On Mouse Move:K2:35)
		
		GET MOUSE:C468($Lon_x;$Lon_y;$l)
		LISTBOX GET CELL POSITION:C971(*;$Txt_me;$Lon_x;$Lon_y;$column;$row)
		
		$indx:=(LISTBOX Get number of columns:C831(*;$Txt_me)*($row-1))+$column
		
		If ($indx>0)\
			 & ($indx<=Form:C1466.pictures.length)
			
			If (Form:C1466.pathnames[$indx-1]=Null:C1517)
				
				If (featuresFlags.with("resourcesBrowser"))
					
					OBJECT SET HELP TIP:C1181(*;$Txt_me;Get localized string:C991("findAndDownloadMoreResources"))
					
				End if 
				
			Else 
				
				If (Form:C1466.helpTips[$indx-1]#Null:C1517)
					
					OBJECT SET HELP TIP:C1181(*;$Txt_me;String:C10(Form:C1466.helpTips[$indx-1]))
					
				Else 
					
					OBJECT SET HELP TIP:C1181(*;$Txt_me;String:C10(Form:C1466.pathnames[$indx-1]))
					
				End if 
			End if 
			
		Else 
			
			OBJECT SET HELP TIP:C1181(*;$Txt_me;"")
			
		End if 
		
		  //______________________________________________________
	: ($event.code=On Mouse Leave:K2:34)
		
		ui.tips.defaultDelay()
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($event.code)+")")
		
		  //______________________________________________________
End case 