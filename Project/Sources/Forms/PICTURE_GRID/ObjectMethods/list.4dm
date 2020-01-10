  // ----------------------------------------------------
  // Object method : PICTURE_GRID.list - (4D Mobile Express)
  // ID[078AE56128534655A7A97E784BD5F77C]
  // Created 27-10-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_;$Lon_cellIndex;$Lon_column;$Lon_formEvent;$Lon_row;$Lon_x)
C_LONGINT:C283($Lon_y)
C_POINTER:C301($Ptr_me)
C_TEXT:C284($Txt_me)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event code:C388
$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Clicked:K2:4)
		
		If (Not:C34(Macintosh command down:C546))
			
			LISTBOX GET CELL POSITION:C971(*;$Txt_me;$Lon_column;$Lon_row)
			
		End if 
		
		Form:C1466.selectColumn:=$Lon_column
		Form:C1466.selectRow:=$Lon_row
		
		$Lon_cellIndex:=(LISTBOX Get number of columns:C831(*;$Txt_me)*($Lon_row-1))+$Lon_column
		
		If ($Lon_cellIndex<=Form:C1466.pictures.length)
			
			Form:C1466.item:=$Lon_cellIndex
			
		End if 
		
		If (Is nil pointer:C315(OBJECT Get pointer:C1124(Object subform container:K67:4)))
			
			  // Auto valid
			ACCEPT:C269
			
		Else 
			
			  // Call the parent form
			CALL SUBFORM CONTAINER:C1086(-1)
			
		End if 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Scroll:K2:57)
		
		OBJECT SET VISIBLE:C603(*;"selection";False:C215)
		SET TIMER:C645(-1)
		
		  //______________________________________________________
	: (Not:C34(Bool:C1537(Form:C1466.tips)))
		
		  //______________________________________________________
	: ($Lon_formEvent=On Mouse Enter:K2:33)
		
		ui.tips.enable()
		ui.tips.instantly()
		
		  //______________________________________________________
	: ($Lon_formEvent=On Mouse Move:K2:35)
		
		GET MOUSE:C468($Lon_x;$Lon_y;$Lon_)
		
		LISTBOX GET CELL POSITION:C971(*;$Txt_me;$Lon_x;$Lon_y;$Lon_column;$Lon_row)
		
		$Lon_cellIndex:=(LISTBOX Get number of columns:C831(*;$Txt_me)*($Lon_row-1))+$Lon_column
		
		If ($Lon_cellIndex>0)\
			 & ($Lon_cellIndex<=Form:C1466.pictures.length)
			
			If (Form:C1466.pathnames[$Lon_cellIndex-1]=Null:C1517)
				
				If (featuresFlags.with("resourcesBrowser"))
					
					If (Form:C1466.tips[$Lon_cellIndex-1]#Null:C1517)
						
						OBJECT SET HELP TIP:C1181(*;$Txt_me;String:C10(Form:C1466.tips[$Lon_cellIndex-1]))
						
					Else 
						
						OBJECT SET HELP TIP:C1181(*;$Txt_me;Get localized string:C991("findAndDownloadMoreResources"))
						
					End if 
				End if 
				
			Else 
				
				OBJECT SET HELP TIP:C1181(*;$Txt_me;String:C10(Form:C1466.pathnames[$Lon_cellIndex-1]))
				
			End if 
			
		Else 
			
			OBJECT SET HELP TIP:C1181(*;$Txt_me;"")
			
		End if 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Mouse Leave:K2:34)
		
		ui.tips.defaultDelay()
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 