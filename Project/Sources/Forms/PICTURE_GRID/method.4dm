  // ----------------------------------------------------
  // Form method : PICTURE_GRID - (4D Mobile Express)
  // ID[D6D5F74D117A474096110381EDD30111]
  // Created 26-10-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($bDisplay;$bHorizontal;$bRedraw;$bVertical)
C_LONGINT:C283($bottom;$column;$i;$kLon_cellHeight;$kLon_cellOffset;$kLon_cellWidth)
C_LONGINT:C283($kLon_maxColumn;$l;$left;$Lon_cellNumber;$Lon_colWidth;$Lon_containerWidth)
C_LONGINT:C283($Lon_currentColNumber;$height;$Lon_item;$Lon_lineNumber;$Lon_listHeight;$Lon_needColumns)
C_LONGINT:C283($Lon_pictureNumber;$Lon_scrollbarWidth;$Lon_x;$offset;$right;$row)
C_LONGINT:C283($top)
C_PICTURE:C286($p)
C_POINTER:C301($Ptr_column;$Ptr_head)
C_TEXT:C284($tColumn;$tProperty)
C_OBJECT:C1216($event)

ARRAY PICTURE:C279($tPic_data;0)

  // ----------------------------------------------------
  // Initialisations
$event:=FORM Event:C1606

  // ----------------------------------------------------
  // Default values
$kLon_cellWidth:=40
$kLon_maxColumn:=40
$kLon_cellOffset:=8

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($event.code=On Load:K2:1)
		
		  // This trick remove the horizontal gap
		OBJECT SET SCROLLBAR:C843(*;"list";0;2)
		
		  //#96875-1
		  //LISTBOX SET PROPERTY(*;"list";lk resizing mode;lk automatic)
		LISTBOX SET PROPERTY:C1440(*;"list";lk resizing mode:K53:36;lk manual:K53:60)
		
		  // Init if not a form widget
		$bDisplay:=(Is nil pointer:C315(OBJECT Get pointer:C1124(Object subform container:K67:4)))
		
		  //______________________________________________________
	: ($event.code=On Bound Variable Change:K2:52)
		
		$bDisplay:=True:C214
		
		  //______________________________________________________
	: ($event.code=On Unload:K2:2)
		
		OBJECT SET VISIBLE:C603(*;"selection";False:C215)
		
		  //______________________________________________________
	: ($event.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		OBJECT SET VISIBLE:C603(*;"selection";False:C215)
		
		  // Display selection if any
		If (Num:C11(Form:C1466.selectColumn)>0)\
			 & (Num:C11(Form:C1466.selectRow)>0)
			
			LISTBOX GET CELL COORDINATES:C1330(*;"list";Form:C1466.selectColumn;Form:C1466.selectRow;$left;$top;$right;$bottom)
			
			If ($top>=0)
				
				$offset:=5
				
				OBJECT SET COORDINATES:C1248(*;"selection";$left+$offset;$top+$offset;$right-$offset;$bottom-$offset)
				OBJECT SET VISIBLE:C603(*;"selection";True:C214)
				
			End if 
		End if 
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($event.code)+")")
		
		  //______________________________________________________
End case 

If ($bDisplay)\
 & (Form:C1466#Null:C1517)
	
	  // Reset default values
	OBJECT SET VISIBLE:C603(*;"prompt";False:C215)
	OBJECT SET VISIBLE:C603(*;"prompt.background";False:C215)
	OBJECT SET VISIBLE:C603(*;"prompt.bottom.line";False:C215)
	OBJECT SET TITLE:C194(*;"NoPicture";"")
	OBJECT SET VISIBLE:C603(*;"selection";False:C215)
	
	  // Delete all columns
	LISTBOX DELETE COLUMN:C830(*;"list";1;LISTBOX Get number of columns:C831(*;"list"))
	
	  // Place objects
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($right;$bottom)
	
	OBJECT SET COORDINATES:C1248(*;"background";0;0;$right;$bottom)
	OBJECT SET COORDINATES:C1248(*;"list";0;0;$right;$bottom)
	
	OBJECT GET COORDINATES:C663(*;"prompt.background";$l;$l;$l;$bottom)
	OBJECT SET COORDINATES:C1248(*;"prompt.background";0;0;$right;$bottom)
	OBJECT SET COORDINATES:C1248(*;"prompt.bottom.line";0;$bottom;$right;$bottom)
	
	For each ($tProperty;Form:C1466)
		
		Case of 
				
				  //______________________________________________________
			: ($tProperty="background")
				
				OBJECT SET RGB COLORS:C628(*;"background";Num:C11(Form:C1466.backgroundStroke);Num:C11(Form:C1466.background))
				
				  //______________________________________________________
			: ($tProperty="noPicture")
				
				OBJECT SET TITLE:C194(*;"NoPicture";String:C10(Form:C1466.noPicture))
				
				  //______________________________________________________
			: ($tProperty="prompt")
				
				OBJECT SET TITLE:C194(*;"prompt";String:C10(Form:C1466.prompt))
				OBJECT SET VISIBLE:C603(*;"prompt";True:C214)
				
				OBJECT GET COORDINATES:C663(*;"prompt.background";$l;$top;$l;$bottom)
				$height:=$bottom-$top
				
				If ($top<$height)
					
					OBJECT GET COORDINATES:C663(*;"list";$left;$top;$right;$bottom)
					$top:=$height
					
					OBJECT SET COORDINATES:C1248(*;"list";$left;$top;$right-1;$bottom-1)
					OBJECT SET COORDINATES:C1248(*;"prompt.bottom.line";0;$height;$right;$height)
					
				End if 
				
				  //______________________________________________________
			: ($tProperty="hidePromptSeparator")
				
				OBJECT SET VISIBLE:C603(*;"prompt.bottom.line";Not:C34(Bool:C1537(Form:C1466.hidePromptSeparator)))
				
				  //______________________________________________________
			: ($tProperty="promptColor")
				
				OBJECT SET RGB COLORS:C628(*;"prompt";Num:C11(Form:C1466.promptColor);Background color none:K23:10)
				
				  //______________________________________________________
			: ($tProperty="promptBackColor")
				
				OBJECT SET RGB COLORS:C628(*;"prompt.background";Background color none:K23:10;Num:C11(Form:C1466.promptBackColor))
				OBJECT SET VISIBLE:C603(*;"prompt.background";True:C214)
				
				  //______________________________________________________
			: ($tProperty="pictures")
				
				COLLECTION TO ARRAY:C1562(Form:C1466.pictures;$tPic_data)
				$Lon_pictureNumber:=Size of array:C274($tPic_data)
				
				$kLon_cellWidth:=Choose:C955(Num:C11(Form:C1466.celluleWidth)#0;Form:C1466.celluleWidth;$kLon_cellWidth)
				$kLon_cellHeight:=Choose:C955(Num:C11(Form:C1466.celluleHeight)#0;Form:C1466.celluleHeight;$kLon_cellWidth)
				$kLon_maxColumn:=Choose:C955(Num:C11(Form:C1466.maxColumns)#0;Form:C1466.maxColumns;$kLon_maxColumn)
				$kLon_cellOffset:=Choose:C955(Num:C11(Form:C1466.offset)#0;Form:C1466.offset;$kLon_cellOffset)
				
				$kLon_cellWidth:=$kLon_cellWidth+$kLon_cellOffset
				
				OBJECT GET SCROLLBAR:C1076(*;"list";$bHorizontal;$bVertical)
				
				$Lon_scrollbarWidth:=Choose:C955($bVertical;LISTBOX Get property:C917(*;"list";lk ver scrollbar width:K53:9);0)
				
				OBJECT GET COORDINATES:C663(*;"list";$left;$top;$right;$bottom)
				$Lon_containerWidth:=$right-$left-$Lon_scrollbarWidth
				
				If ($Lon_pictureNumber>0)
					
					$Lon_needColumns:=$Lon_containerWidth\$kLon_cellWidth
					$Lon_needColumns:=$Lon_needColumns+Num:C11($Lon_needColumns<1)
					$Lon_lineNumber:=($Lon_pictureNumber\$Lon_needColumns)+Num:C11(($Lon_pictureNumber%$Lon_needColumns)#0)
					$Lon_cellNumber:=$Lon_needColumns*$Lon_lineNumber
					
					$Lon_listHeight:=$bottom-$top
					
					If ($Lon_scrollbarWidth=0)
						
						If (($Lon_lineNumber*$kLon_cellHeight)>$Lon_listHeight)
							
							$Lon_containerWidth:=$Lon_containerWidth-15
							$Lon_needColumns:=Int:C8($Lon_containerWidth/$kLon_cellWidth)
							$Lon_needColumns:=$Lon_needColumns+Num:C11($Lon_needColumns<1)
							$Lon_lineNumber:=Int:C8($Lon_pictureNumber/$Lon_needColumns)+Num:C11(Mod:C98($Lon_pictureNumber;$Lon_needColumns)#0)
							$Lon_cellNumber:=$Lon_needColumns*$Lon_lineNumber
							
						End if 
						
					Else 
						
						If (($Lon_lineNumber*$kLon_cellHeight)<=$Lon_listHeight)
							
							$Lon_containerWidth:=$Lon_containerWidth+15
							$Lon_needColumns:=Int:C8($Lon_containerWidth/$kLon_cellWidth)
							$Lon_needColumns:=$Lon_needColumns+Num:C11($Lon_needColumns<1)
							$Lon_lineNumber:=Int:C8($Lon_pictureNumber/$Lon_needColumns)+Num:C11(Mod:C98($Lon_pictureNumber;$Lon_needColumns)#0)
							$Lon_cellNumber:=$Lon_needColumns*$Lon_lineNumber
							
						End if 
					End if 
					
					If ($Lon_needColumns>$kLon_maxColumn)
						
						$Lon_needColumns:=$kLon_maxColumn
						
					End if 
					
					OBJECT SET VISIBLE:C603(*;"NoPicture";False:C215)
					
				Else 
					
					OBJECT GET COORDINATES:C663(*;"list";$left;$top;$right;$bottom)
					OBJECT GET COORDINATES:C663(*;"NoPicture";$l;$top;$l;$bottom)
					OBJECT SET COORDINATES:C1248(*;"NoPicture";$left;$top;$right;$bottom)
					OBJECT SET VISIBLE:C603(*;"NoPicture";True:C214)
					
				End if 
				
				$bRedraw:=True:C214
				
				$Lon_colWidth:=$Lon_containerWidth\$Lon_needColumns
				$Lon_currentColNumber:=LISTBOX Get number of columns:C831(*;"list")
				
				Case of 
						
						  //………………………………………………………………………………………………………………………………………
					: ($Lon_needColumns=0)
						
						LISTBOX DELETE COLUMN:C830(*;"list";1;$Lon_currentColNumber)
						$bRedraw:=False:C215
						
						  //………………………………………………………………………………………………………………………………………
					: ($Lon_needColumns=$Lon_currentColNumber)\
						 & (Not:C34(Bool:C1537(Form:C1466.forceRedraw)))
						
						$bRedraw:=False:C215
						
						  //………………………………………………………………………………………………………………………………………
					: ($Lon_needColumns>$Lon_currentColNumber)
						
						For ($i;$Lon_currentColNumber+1;$Lon_needColumns;1)
							
							$tColumn:="Column_"+String:C10($i)
							$Ptr_column:=OBJECT Get pointer:C1124(Object named:K67:5;$tColumn)
							
							LISTBOX INSERT COLUMN:C829(*;"list";$i+1;$tColumn;$Ptr_column;"Head_"+String:C10($i);$Ptr_head)
							
							  //EXECUTE FORMULA("ARRAY PICTURE:C279((OBJECT Get pointer:C1124(Object named:K67:5;\""+$Txt_column+"\"))->;"+String($Lon_LineNumber)+")")
							$Ptr_column:=OBJECT Get pointer:C1124(Object named:K67:5;$tColumn)
							  //%W-518.5
							ARRAY PICTURE:C279($Ptr_column->;$Lon_lineNumber)
							  //%W+518.5
							
							OBJECT SET FORMAT:C236(*;$tColumn;Char:C90(1))
							LISTBOX SET COLUMN WIDTH:C833(*;$tColumn;$Lon_colWidth;$Lon_colWidth;$Lon_colWidth)
							
						End for 
						
						  //………………………………………………………………………………………………………………………………………
					: ($Lon_needColumns<$Lon_currentColNumber)
						
						For ($i;1;$Lon_currentColNumber;1)
							
							If ($i>$Lon_needColumns)
								
								LISTBOX DELETE COLUMN:C830(*;"list";$i;1)
								
							Else 
								
								$tColumn:="Column_"+String:C10($i)
								$Ptr_column:=OBJECT Get pointer:C1124(Object named:K67:5;$tColumn)
								  //%W-518.5
								ARRAY PICTURE:C279($Ptr_column->;$Lon_lineNumber)
								  //%W+518.5
								LISTBOX SET COLUMN WIDTH:C833(*;$tColumn;$Lon_colWidth;$Lon_colWidth;$Lon_colWidth)
								
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
		
		For ($i;1;$Lon_cellNumber;1)
			
			If ($column>$Lon_needColumns)
				
				$row:=$row+1
				$column:=1
				
			End if 
			
			$tColumn:="Column_"+String:C10($column)
			$Ptr_column:=OBJECT Get pointer:C1124(Object named:K67:5;$tColumn)
			
			If (Size of array:C274($Ptr_column->)<$row)
				
				APPEND TO ARRAY:C911($Ptr_column->;$p)
				
			End if 
			
			If ($i>$Lon_pictureNumber)
				
				$Ptr_column->{$row}:=$Ptr_column->{$row}*0
				
			Else 
				
				$Ptr_column->{$row}:=$tPic_data{$i}
				
			End if 
			
			OBJECT SET FORMAT:C236($Ptr_column->{$row};Char:C90(1))
			
			$column:=$column+1
			
		End for 
		
		LISTBOX SET ROWS HEIGHT:C835(*;"list";$kLon_cellHeight+$kLon_cellOffset)
		
	Else 
		
		$Lon_x:=Choose:C955($Lon_currentColNumber>1;$Lon_containerWidth\$Lon_currentColNumber;$kLon_cellWidth)
		
		For ($i;1;$Lon_currentColNumber;1)
			
			$tColumn:="Column_"+String:C10($i)
			LISTBOX SET COLUMN WIDTH:C833(*;$tColumn;$Lon_x)
			
		End for 
		
		LISTBOX SET ROWS HEIGHT:C835(*;"list";$kLon_cellHeight+$kLon_cellOffset)
		
	End if 
	
	OBJECT SET SCROLLBAR:C843(*;"list";False:C215;($Lon_lineNumber*$kLon_cellHeight)>$Lon_listHeight)
	
	$Lon_item:=Num:C11(Form:C1466.item)
	
	If (($Lon_item%$Lon_needColumns)>0)
		
		Form:C1466.selectRow:=($Lon_item\$Lon_needColumns)+1
		Form:C1466.selectColumn:=$Lon_item%$Lon_needColumns
		
	Else 
		
		Form:C1466.selectRow:=($Lon_item\$Lon_needColumns)
		Form:C1466.selectColumn:=$Lon_needColumns
		
	End if 
	
	OBJECT SET SCROLL POSITION:C906(*;"list";Form:C1466.selectRow;Form:C1466.selectColumn)
	
	SET TIMER:C645(-1)
	
End if 