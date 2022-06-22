// ----------------------------------------------------
// Form method : PICTURE_GRID - (4D Mobile Express)
// ID[D6D5F74D117A474096110381EDD30111]
// Created 26-10-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
C_BOOLEAN:C305($bDisplay; $bHorizontal; $bRedraw; $bVertical)
C_LONGINT:C283($bottom; $column; $height; $i; $indx; $l)
C_LONGINT:C283($left; $number; $right; $row; $top; $width)
C_PICTURE:C286($p)
C_POINTER:C301($ptr; $Ptr_head)
C_TEXT:C284($tColumn; $tProperty)
C_OBJECT:C1216($event; $ƒ)

ARRAY PICTURE:C279($tPic_data; 0)

// ----------------------------------------------------
// Initialisations
$event:=FORM Event:C1606

// ----------------------------------------------------
// Default values
$ƒ:=New object:C1471(\
"cellWidth"; 40; \
"maxColumn"; 40; \
"cellOffset"; 8)

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($event.code=On Load:K2:1)
		
		// This trick remove the horizontal gap
		OBJECT SET SCROLLBAR:C843(*; "list"; 0; 2)
		
		LISTBOX SET PROPERTY:C1440(*; "list"; lk resizing mode:K53:36; lk manual:K53:60)
		
		// Init if not a form widget
		//$bDisplay:=(Is nil pointer(OBJECT Get pointer(Object subform container)))
		$bDisplay:=(Undefined:C82(OBJECT Get subform container value:C1785))
		
		//______________________________________________________
	: ($event.code=On Bound Variable Change:K2:52)
		
		$bDisplay:=True:C214
		
		If (UI.darkScheme)
			
			OBJECT SET RGB COLORS:C628(*; "selection"; "#76D5FE"; "#0E2732")
			
		Else 
			
			OBJECT SET RGB COLORS:C628(*; "selection"; UI.selectedColor; "aliceblue")
			
		End if 
		
		//______________________________________________________
	: ($event.code=On Unload:K2:2)
		
		OBJECT SET VISIBLE:C603(*; "selection"; False:C215)
		
		//______________________________________________________
	: ($event.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		OBJECT SET VISIBLE:C603(*; "selection"; False:C215)
		
		// Display selection if any
		If (Not:C34(Bool:C1537(Form:C1466.hideSelection)))
			
			If (Num:C11(Form:C1466.selectColumn)>0)\
				 & (Num:C11(Form:C1466.selectRow)>0)
				
				LISTBOX GET CELL COORDINATES:C1330(*; "list"; Form:C1466.selectColumn; Form:C1466.selectRow; $left; $top; $right; $bottom)
				
				If ($top>=0)
					
					OBJECT SET COORDINATES:C1248(*; "selection"; $left+2; $top+1; $right-1; $bottom-1)
					OBJECT SET VISIBLE:C603(*; "selection"; True:C214)
					
				End if 
			End if 
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+String:C10($event.code)+")")
		
		//______________________________________________________
End case 

If ($bDisplay)\
 & (Form:C1466#Null:C1517)
	
	// Reset default values
	OBJECT SET VISIBLE:C603(*; "prompt"; False:C215)
	OBJECT SET VISIBLE:C603(*; "prompt.background"; False:C215)
	OBJECT SET VISIBLE:C603(*; "prompt.bottom.line"; False:C215)
	OBJECT SET TITLE:C194(*; "NoPicture"; "")
	OBJECT SET VISIBLE:C603(*; "selection"; False:C215)
	
	// Delete all columns
	LISTBOX DELETE COLUMN:C830(*; "list"; 1; LISTBOX Get number of columns:C831(*; "list"))
	
	// Place objects
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($right; $bottom)
	OBJECT SET COORDINATES:C1248(*; "background"; 0; 0; $right; $bottom)
	OBJECT SET COORDINATES:C1248(*; "list"; 0; 0; $right; $bottom)
	OBJECT GET COORDINATES:C663(*; "prompt.background"; $l; $l; $l; $bottom)
	OBJECT SET COORDINATES:C1248(*; "prompt.background"; 0; 0; $right; $bottom)
	OBJECT SET COORDINATES:C1248(*; "prompt.bottom.line"; 0; $bottom; $right; $bottom)
	
	For each ($tProperty; Form:C1466)
		
		Case of 
				
				//______________________________________________________
			: ($tProperty="background")
				
				OBJECT SET RGB COLORS:C628(*; "background"; Form:C1466.backgroundStroke; Form:C1466.background)
				
				//______________________________________________________
			: ($tProperty="noPicture")
				
				OBJECT SET TITLE:C194(*; "NoPicture"; String:C10(Form:C1466.noPicture))
				
				//______________________________________________________
			: ($tProperty="prompt")
				
				OBJECT SET TITLE:C194(*; "prompt"; String:C10(Form:C1466.prompt))
				OBJECT SET VISIBLE:C603(*; "prompt"; True:C214)
				
				OBJECT GET COORDINATES:C663(*; "prompt.background"; $l; $top; $l; $bottom)
				$height:=$bottom-$top
				
				If ($top<$height)
					
					OBJECT GET COORDINATES:C663(*; "list"; $left; $top; $right; $bottom)
					$top:=$height
					
					OBJECT SET COORDINATES:C1248(*; "list"; $left; $top; $right-1; $bottom-1)
					OBJECT SET COORDINATES:C1248(*; "prompt.bottom.line"; 0; $height; $right; $height)
					
				End if 
				
				//______________________________________________________
			: ($tProperty="hidePromptSeparator")
				
				OBJECT SET VISIBLE:C603(*; "prompt.bottom.line"; Not:C34(Bool:C1537(Form:C1466.hidePromptSeparator)))
				
				//______________________________________________________
			: ($tProperty="promptColor")
				
				OBJECT SET RGB COLORS:C628(*; "prompt"; Num:C11(Form:C1466.promptColor); Background color none:K23:10)
				
				//______________________________________________________
			: ($tProperty="promptBackColor")
				
				OBJECT SET RGB COLORS:C628(*; "prompt.background"; Background color none:K23:10; Num:C11(Form:C1466.promptBackColor))
				OBJECT SET VISIBLE:C603(*; "prompt.background"; True:C214)
				
				//______________________________________________________
			: ($tProperty="pictures")
				
				COLLECTION TO ARRAY:C1562(Form:C1466.pictures; $tPic_data)
				
				$ƒ.pictureNumber:=Size of array:C274($tPic_data)
				$ƒ.cellWidth:=Choose:C955(Num:C11(Form:C1466.celluleWidth)#0; Form:C1466.celluleWidth; $ƒ.cellWidth)
				$ƒ.cellHeight:=Choose:C955(Num:C11(Form:C1466.celluleHeight)#0; Form:C1466.celluleHeight; $ƒ.cellWidth)
				$ƒ.maxColumn:=Choose:C955(Num:C11(Form:C1466.maxColumns)#0; Form:C1466.maxColumns; $ƒ.maxColumn)
				$ƒ.cellOffset:=Choose:C955(Num:C11(Form:C1466.offset)#0; Form:C1466.offset; $ƒ.cellOffset)
				$ƒ.cellWidth:=$ƒ.cellWidth+$ƒ.cellOffset
				
				OBJECT GET SCROLLBAR:C1076(*; "list"; $bHorizontal; $bVertical)
				
				$ƒ.scrollbarWidth:=Choose:C955($bVertical; LISTBOX Get property:C917(*; "list"; lk ver scrollbar width:K53:9); 0)
				
				OBJECT GET COORDINATES:C663(*; "list"; $left; $top; $right; $bottom)
				$ƒ.containerWidth:=$right-$left-$ƒ.scrollbarWidth
				
				If ($ƒ.pictureNumber>0)
					
					$ƒ.needColumns:=$ƒ.containerWidth\$ƒ.cellWidth
					$ƒ.needColumns:=$ƒ.needColumns+Num:C11($ƒ.needColumns<1)
					$ƒ.lineNumber:=($ƒ.pictureNumber\$ƒ.needColumns)+Num:C11(($ƒ.pictureNumber%$ƒ.needColumns)#0)
					$number:=$ƒ.needColumns*$ƒ.lineNumber
					
					If ($ƒ.scrollbarWidth=0)
						
						If (($ƒ.lineNumber*$ƒ.cellHeight)>($bottom-$top))
							
							$ƒ.containerWidth:=$ƒ.containerWidth-15
							$ƒ.needColumns:=Int:C8($ƒ.containerWidth/$ƒ.cellWidth)
							$ƒ.needColumns:=$ƒ.needColumns+Num:C11($ƒ.needColumns<1)
							$ƒ.lineNumber:=Int:C8($ƒ.pictureNumber/$ƒ.needColumns)+Num:C11(Mod:C98($ƒ.pictureNumber; $ƒ.needColumns)#0)
							$number:=$ƒ.needColumns*$ƒ.lineNumber
							
						End if 
						
					Else 
						
						If (($ƒ.lineNumber*$ƒ.cellHeight)<=($bottom-$top))
							
							$ƒ.containerWidth:=$ƒ.containerWidth+15
							$ƒ.needColumns:=Int:C8($ƒ.containerWidth/$ƒ.cellWidth)
							$ƒ.needColumns:=$ƒ.needColumns+Num:C11($ƒ.needColumns<1)
							$ƒ.lineNumber:=Int:C8($ƒ.pictureNumber/$ƒ.needColumns)+Num:C11(Mod:C98($ƒ.pictureNumber; $ƒ.needColumns)#0)
							$number:=$ƒ.needColumns*$ƒ.lineNumber
							
						End if 
					End if 
					
					If ($ƒ.needColumns>$ƒ.maxColumn)
						
						$ƒ.needColumns:=$ƒ.maxColumn
						
					End if 
					
					OBJECT SET VISIBLE:C603(*; "NoPicture"; False:C215)
					
				Else 
					
					OBJECT GET COORDINATES:C663(*; "list"; $left; $top; $right; $bottom)
					OBJECT GET COORDINATES:C663(*; "NoPicture"; $l; $top; $l; $bottom)
					OBJECT SET COORDINATES:C1248(*; "NoPicture"; $left; $top; $right; $bottom)
					OBJECT SET VISIBLE:C603(*; "NoPicture"; True:C214)
					
				End if 
				
				$bRedraw:=True:C214
				
				$ƒ.colWidth:=$ƒ.containerWidth\$ƒ.needColumns
				$ƒ.currentColNumber:=LISTBOX Get number of columns:C831(*; "list")
				
				Case of 
						
						//………………………………………………………………………………………………………………………………………
					: ($ƒ.needColumns=0)
						
						LISTBOX DELETE COLUMN:C830(*; "list"; 1; $ƒ.currentColNumber)
						$bRedraw:=False:C215
						
						//………………………………………………………………………………………………………………………………………
					: ($ƒ.needColumns=$ƒ.currentColNumber)\
						 & (Not:C34(Bool:C1537(Form:C1466.forceRedraw)))
						
						$bRedraw:=False:C215
						
						//………………………………………………………………………………………………………………………………………
					: ($ƒ.needColumns>$ƒ.currentColNumber)
						
						For ($i; $ƒ.currentColNumber+1; $ƒ.needColumns; 1)
							
							$tColumn:="Column_"+String:C10($i)
							$ptr:=OBJECT Get pointer:C1124(Object named:K67:5; $tColumn)
							
							LISTBOX INSERT COLUMN:C829(*; "list"; $i+1; $tColumn; $ptr; "Head_"+String:C10($i); $Ptr_head)
							
							$ptr:=OBJECT Get pointer:C1124(Object named:K67:5; $tColumn)
							
							//%W-518.5
							ARRAY PICTURE:C279($ptr->; $ƒ.lineNumber)
							//%W+518.5
							
							OBJECT SET FORMAT:C236(*; $tColumn; Char:C90(6))
							
							LISTBOX SET COLUMN WIDTH:C833(*; $tColumn; $ƒ.colWidth; $ƒ.colWidth; $ƒ.colWidth)
							
						End for 
						
						//………………………………………………………………………………………………………………………………………
					: ($ƒ.needColumns<$ƒ.currentColNumber)
						
						For ($i; 1; $ƒ.currentColNumber; 1)
							
							If ($i>$ƒ.needColumns)
								
								LISTBOX DELETE COLUMN:C830(*; "list"; $i; 1)
								
							Else 
								
								$tColumn:="Column_"+String:C10($i)
								
								$ptr:=OBJECT Get pointer:C1124(Object named:K67:5; $tColumn)
								
								//%W-518.5
								ARRAY PICTURE:C279($ptr->; $ƒ.lineNumber)
								//%W+518.5
								
								LISTBOX SET COLUMN WIDTH:C833(*; $tColumn; $ƒ.colWidth; $ƒ.colWidth; $ƒ.colWidth)
								
							End if 
						End for 
						
						//………………………………………………………………………………………………………………………………………
				End case 
				
				//______________________________________________________
		End case 
	End for each 
	
	If ($bRedraw)
		
		$row:=1
		$column:=1
		
		For ($i; 1; $number; 1)
			
			If ($column>$ƒ.needColumns)
				
				$row:=$row+1
				$column:=1
				
			End if 
			
			$tColumn:="Column_"+String:C10($column)
			$ptr:=OBJECT Get pointer:C1124(Object named:K67:5; $tColumn)
			
			If (Size of array:C274($ptr->)<$row)
				
				APPEND TO ARRAY:C911($ptr->; $p)
				
			End if 
			
			If ($i>$ƒ.pictureNumber)
				
				$ptr->{$row}:=$ptr->{$row}*0
				
			Else 
				
				$ptr->{$row}:=$tPic_data{$i}
				
			End if 
			
			OBJECT SET FORMAT:C236($ptr->{$row}; Char:C90(6))
			
			$column:=$column+1
			
		End for 
		
		LISTBOX SET ROWS HEIGHT:C835(*; "list"; $ƒ.cellHeight+$ƒ.cellOffset)
		
	Else 
		
		$width:=Choose:C955($ƒ.currentColNumber>1; $ƒ.containerWidth\$ƒ.currentColNumber; $ƒ.cellWidth)
		
		For ($i; 1; $ƒ.currentColNumber; 1)
			
			$tColumn:="Column_"+String:C10($i)
			LISTBOX SET COLUMN WIDTH:C833(*; $tColumn; $width)
			
		End for 
		
		LISTBOX SET ROWS HEIGHT:C835(*; "list"; $ƒ.cellHeight+$ƒ.cellOffset)
		
	End if 
	
	OBJECT SET SCROLLBAR:C843(*; "list"; False:C215; ($ƒ.lineNumber*$ƒ.cellHeight)>($bottom-$top))
	
	$indx:=Num:C11(Form:C1466.item)
	
	If (($indx%$ƒ.needColumns)>0)
		
		Form:C1466.selectRow:=($indx\$ƒ.needColumns)+1
		Form:C1466.selectColumn:=$indx%$ƒ.needColumns
		
	Else 
		
		Form:C1466.selectRow:=($indx\$ƒ.needColumns)
		Form:C1466.selectColumn:=$ƒ.needColumns
		
	End if 
	
	OBJECT SET SCROLL POSITION:C906(*; "list"; Form:C1466.selectRow; Form:C1466.selectColumn)
	
	SET TIMER:C645(-1)
	
End if 