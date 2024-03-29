// ----------------------------------------------------
// Object method : PICTURE_GRID.list - (4D Mobile Express)
// ID[078AE56128534655A7A97E784BD5F77C]
// Created 27-10-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
C_BOOLEAN:C305($bContinue)
C_LONGINT:C283($bottom; $index; $l; $lCursor; $left; $Lon_x)
C_LONGINT:C283($Lon_y; $right; $top)
C_OBJECT:C1216($event; $o)

// ----------------------------------------------------
// Initialisations
$event:=FORM Event:C1606

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($event.code=On Clicked:K2:4)
		
		Form:C1466.selectColumn:=$event.column
		Form:C1466.selectRow:=$event.row
		
		$index:=(LISTBOX Get number of columns:C831(*; $event.objectName)*($event.row-1))+$event.column
		
		If ($index>0)\
			 & ($index<=Form:C1466.pictures.length)
			
			If (Contextual click:C713)
				
				If (Form:C1466.contextual#Null:C1517)
					
					Form:C1466.contextual.formula.call(Null:C1517; Form:C1466.contextual.target[$index-1])
					
				End if 
				
			Else 
				
				$bContinue:=True:C214
				
				If (Form:C1466.hotZones#Null:C1517)
					
					GET MOUSE:C468($Lon_x; $Lon_y; $l)  // Relative to the window
					LISTBOX GET CELL COORDINATES:C1330(*; $event.objectName; $event.column; $event.row; $left; $top; $right; $bottom)  // Relative to the form
					
					// Convert to screen coordinates
					CONVERT COORDINATES:C1365($Lon_x; $Lon_y; XY Current window:K27:6; XY Screen:K27:7)
					CONVERT COORDINATES:C1365($left; $top; XY Current form:K27:5; XY Screen:K27:7)
					
					For each ($o; Form:C1466.hotZones) While ($bContinue)
						
						If ($Lon_x>=($left+$o.left))\
							 & ($Lon_x<=($left+$o.left+$o.width))\
							 & ($Lon_y>=($top+$o.top)) & ($Lon_y<=($top+$o.top+$o.height))
							
							$bContinue:=False:C215
							If (Bool:C1537($o.clickable))
								If ($o.target[$index-1].formula=Null:C1517)  // default
									$o.formula.call(Null:C1517; $o.target[$index-1])
								Else 
									$o.target[$index-1].formula.call(Null:C1517; $o.target[$index-1])
								End if 
							End if 
							
						End if 
					End for each 
				End if 
				
				If ($bContinue)
					
					Form:C1466.item:=$index
					
					//If (Is nil pointer(OBJECT Get pointer(Object subform container)))
					If (Undefined:C82(OBJECT Get subform container value:C1785))
						
						ACCEPT:C269  // Auto valid
						
					Else 
						
						CALL SUBFORM CONTAINER:C1086(-1)  // Call the parent form
						
					End if 
				End if 
			End if 
		End if 
		
		//______________________________________________________
	: ($event.code=On Scroll:K2:57)
		
		OBJECT SET VISIBLE:C603(*; "selection"; False:C215)
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: (Not:C34(Bool:C1537(Form:C1466.tips)))
		
		// No tips
		
		//______________________________________________________
	: ($event.code=On Mouse Enter:K2:33)
		
		UI.tips.setDuration(45*5)
		
		//______________________________________________________
	: ($event.code=On Mouse Move:K2:35)
		
		$index:=(LISTBOX Get number of columns:C831(*; $event.objectName)*(Num:C11($event.row)-1))+Num:C11($event.column)
		
		If ($index>0)\
			 & ($index<=Form:C1466.pictures.length)
			
			If (Form:C1466.hotZones#Null:C1517)
				
				GET MOUSE:C468($Lon_x; $Lon_y; $l)  // Relative to the window
				LISTBOX GET CELL COORDINATES:C1330(*; $event.objectName; $event.column; $event.row; $left; $top; $right; $bottom)  // Relative to the form
				
				// Convert to screen coordinates
				CONVERT COORDINATES:C1365($Lon_x; $Lon_y; XY Current window:K27:6; XY Screen:K27:7)
				CONVERT COORDINATES:C1365($left; $top; XY Current form:K27:5; XY Screen:K27:7)
				
				$bContinue:=True:C214
				
				For each ($o; Form:C1466.hotZones) While ($bContinue)
					
					If ($Lon_x>=($left+$o.left))\
						 & ($Lon_x<=($left+$o.left+$o.width))\
						 & ($Lon_y>=($top+$o.top)) & ($Lon_y<=($top+$o.top+$o.height))
						
						If ($o.target[$index-1]#Null:C1517)
							
							var $tips : Text
							
							If ($o.target[$index-1].tips#Null:C1517)
								
								// Prefer target
								$tips:=String:C10($o.target[$index-1].tips)
								
							Else 
								
								$tips:=String:C10($o.tips)
								
							End if 
							
							If (Length:C16($tips)>0)
								
								OBJECT SET HELP TIP:C1181(*; $event.objectName; Get localized string:C991($tips))
								$lCursor:=Num:C11($o.cursor)
								$o.clickable:=True:C214  // Maybe check clickable before instead of tips
								
							Else 
								
								$o.clickable:=$o.formula#Null:C1517
								
							End if 
							
							$bContinue:=False:C215  // Done
							
						End if 
					End if 
				End for each 
				
				SET CURSOR:C469($lCursor)
				
			End if 
			
			If ($bContinue)
				
				If (Form:C1466.pathnames[$index-1]=Null:C1517)
					
					SET CURSOR:C469(9000)
					OBJECT SET HELP TIP:C1181(*; $event.objectName; Get localized string:C991("findAndDownloadMoreResources"))
					
				Else 
					
					If (Form:C1466.helpTips[$index-1]#Null:C1517)
						
						OBJECT SET HELP TIP:C1181(*; $event.objectName; String:C10(Form:C1466.helpTips[$index-1]))
						
					Else 
						
						OBJECT SET HELP TIP:C1181(*; $event.objectName; String:C10(Form:C1466.pathnames[$index-1]))
						
					End if 
				End if 
				
			End if 
			
		Else 
			
			OBJECT SET HELP TIP:C1181(*; $event.objectName; "")
			
		End if 
		
		//______________________________________________________
	: ($event.code=On Mouse Leave:K2:34)
		
		UI.tips.restore()
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$event.description+")")
		
		//______________________________________________________
End case 