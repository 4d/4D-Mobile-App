  // ----------------------------------------------------
  // Form method : PICTURE_GRID - (4D Mobile Express)
  // ID[D6D5F74D117A474096110381EDD30111]
  // Created #26-10-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($Boo_display;$Boo_horizontal;$Boo_redraw;$Boo_vertical)
C_LONGINT:C283($kLon_cellHeight;$kLon_cellOffset;$kLon_cellWidth;$kLon_maxColumn;$Lon_;$Lon_bottom)
C_LONGINT:C283($Lon_cellNumber;$Lon_column;$Lon_colWidth;$Lon_containerWidth;$Lon_currentColNumber;$Lon_formEvent)
C_LONGINT:C283($Lon_height;$Lon_i;$Lon_item;$Lon_left;$Lon_lineNumber;$Lon_listHeight)
C_LONGINT:C283($Lon_needColumns;$Lon_offset;$Lon_pictureNumber;$Lon_right;$Lon_row;$Lon_scrollbarWidth)
C_LONGINT:C283($Lon_top;$Lon_x)
C_PICTURE:C286($Pic_buffer)
C_POINTER:C301($Ptr_column;$Ptr_head)
C_TEXT:C284($Txt_column;$Txt_property)

ARRAY PICTURE:C279($tPic_data;0)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event:C388

  // ----------------------------------------------------
  // Default values
$kLon_cellWidth:=40
$kLon_maxColumn:=40
$kLon_cellOffset:=8

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Load:K2:1)
		
		  // This trick remove the horizontal gap
		OBJECT SET SCROLLBAR:C843(*;"list";0;2)
		
		  //#96875-1
		  //LISTBOX SET PROPERTY(*;"list";lk resizing mode;lk automatic)
		LISTBOX SET PROPERTY:C1440(*;"list";lk resizing mode:K53:36;lk manual:K53:60)
		
		  // Init if not a form widget
		$Boo_display:=(Is nil pointer:C315(OBJECT Get pointer:C1124(Object subform container:K67:4)))
		
		  //______________________________________________________
	: ($Lon_formEvent=On Bound Variable Change:K2:52)
		
		$Boo_display:=True:C214
		
		  //______________________________________________________
	: ($Lon_formEvent=On Unload:K2:2)
		
		OBJECT SET VISIBLE:C603(*;"selection";False:C215)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		OBJECT SET VISIBLE:C603(*;"selection";False:C215)
		
		  // Display selection if any
		If (Num:C11(Form:C1466.selectColumn)>0)\
			 & (Num:C11(Form:C1466.selectRow)>0)
			
			LISTBOX GET CELL COORDINATES:C1330(*;"list";Form:C1466.selectColumn;Form:C1466.selectRow;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
			
			If ($Lon_top>=0)
				
				$Lon_offset:=3
				
				OBJECT SET COORDINATES:C1248(*;"selection";$Lon_left+$Lon_offset;$Lon_top+$Lon_offset;$Lon_right-$Lon_offset;$Lon_bottom-$Lon_offset)
				OBJECT SET VISIBLE:C603(*;"selection";True:C214)
				
			End if 
		End if 
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 

If ($Boo_display)\
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
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($Lon_right;$Lon_bottom)
	
	OBJECT SET COORDINATES:C1248(*;"background";0;0;$Lon_right;$Lon_bottom)
	OBJECT SET COORDINATES:C1248(*;"list";0;0;$Lon_right;$Lon_bottom)
	
	OBJECT GET COORDINATES:C663(*;"prompt.background";$Lon_;$Lon_;$Lon_;$Lon_bottom)
	OBJECT SET COORDINATES:C1248(*;"prompt.background";0;0;$Lon_right;$Lon_bottom)
	OBJECT SET COORDINATES:C1248(*;"prompt.bottom.line";0;$Lon_bottom;$Lon_right;$Lon_bottom)
	
	For each ($Txt_property;Form:C1466)
		
		Case of 
				
				  //______________________________________________________
			: ($Txt_property="background")
				
				OBJECT SET RGB COLORS:C628(*;"background";Num:C11(Form:C1466.backgroundStroke);Num:C11(Form:C1466.background))
				
				  //______________________________________________________
			: ($Txt_property="noPicture")
				
				OBJECT SET TITLE:C194(*;"NoPicture";String:C10(Form:C1466.noPicture))
				
				  //______________________________________________________
			: ($Txt_property="prompt")
				
				OBJECT SET TITLE:C194(*;"prompt";String:C10(Form:C1466.prompt))
				OBJECT SET VISIBLE:C603(*;"prompt";True:C214)
				
				OBJECT GET COORDINATES:C663(*;"prompt.background";$Lon_;$Lon_top;$Lon_;$Lon_bottom)
				$Lon_height:=$Lon_bottom-$Lon_top
				
				If ($Lon_top<$Lon_height)
					
					OBJECT GET COORDINATES:C663(*;"list";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
					$Lon_top:=$Lon_height
					
					OBJECT SET COORDINATES:C1248(*;"list";$Lon_left;$Lon_top;$Lon_right-1;$Lon_bottom-1)
					OBJECT SET COORDINATES:C1248(*;"prompt.bottom.line";0;$Lon_height;$Lon_right;$Lon_height)
					
				End if 
				
				  //______________________________________________________
			: ($Txt_property="hidePromptSeparator")
				
				OBJECT SET VISIBLE:C603(*;"prompt.bottom.line";Not:C34(Bool:C1537(Form:C1466.hidePromptSeparator)))
				
				  //______________________________________________________
			: ($Txt_property="promptColor")
				
				OBJECT SET RGB COLORS:C628(*;"prompt";Num:C11(Form:C1466.promptColor);Background color none:K23:10)
				
				  //______________________________________________________
			: ($Txt_property="promptBackColor")
				
				OBJECT SET RGB COLORS:C628(*;"prompt.background";Background color none:K23:10;Num:C11(Form:C1466.promptBackColor))
				OBJECT SET VISIBLE:C603(*;"prompt.background";True:C214)
				
				  //______________________________________________________
			: ($Txt_property="pictures")
				
				COLLECTION TO ARRAY:C1562(Form:C1466.pictures;$tPic_data)
				$Lon_pictureNumber:=Size of array:C274($tPic_data)
				
				$kLon_cellWidth:=Choose:C955(Num:C11(Form:C1466.celluleWidth)#0;Form:C1466.celluleWidth;$kLon_cellWidth)
				$kLon_cellHeight:=Choose:C955(Num:C11(Form:C1466.celluleHeight)#0;Form:C1466.celluleHeight;$kLon_cellWidth)
				$kLon_maxColumn:=Choose:C955(Num:C11(Form:C1466.maxColumns)#0;Form:C1466.maxColumns;$kLon_maxColumn)
				$kLon_cellOffset:=Choose:C955(Num:C11(Form:C1466.offset)#0;Form:C1466.offset;$kLon_cellOffset)
				
				$kLon_cellWidth:=$kLon_cellWidth+$kLon_cellOffset
				
				OBJECT GET SCROLLBAR:C1076(*;"list";$Boo_horizontal;$Boo_vertical)
				
				$Lon_scrollbarWidth:=Choose:C955($Boo_vertical;LISTBOX Get property:C917(*;"list";lk ver scrollbar width:K53:9);0)
				
				OBJECT GET COORDINATES:C663(*;"list";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
				$Lon_containerWidth:=$Lon_right-$Lon_left-$Lon_scrollbarWidth
				
				If ($Lon_pictureNumber>0)
					
					$Lon_needColumns:=$Lon_containerWidth\$kLon_cellWidth
					$Lon_needColumns:=$Lon_needColumns+Num:C11($Lon_needColumns<1)
					$Lon_lineNumber:=($Lon_pictureNumber\$Lon_needColumns)+Num:C11(($Lon_pictureNumber%$Lon_needColumns)#0)
					$Lon_cellNumber:=$Lon_needColumns*$Lon_lineNumber
					
					$Lon_listHeight:=$Lon_bottom-$Lon_top
					
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
					
					OBJECT GET COORDINATES:C663(*;"list";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
					OBJECT GET COORDINATES:C663(*;"NoPicture";$Lon_;$Lon_top;$Lon_;$Lon_bottom)
					OBJECT SET COORDINATES:C1248(*;"NoPicture";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
					OBJECT SET VISIBLE:C603(*;"NoPicture";True:C214)
					
				End if 
				
				$Boo_redraw:=True:C214
				
				$Lon_colWidth:=$Lon_containerWidth\$Lon_needColumns
				$Lon_currentColNumber:=LISTBOX Get number of columns:C831(*;"list")
				
				Case of 
						
						  //………………………………………………………………………………………………………………………………………
					: ($Lon_needColumns=0)
						
						LISTBOX DELETE COLUMN:C830(*;"list";1;$Lon_currentColNumber)
						$Boo_redraw:=False:C215
						
						  //………………………………………………………………………………………………………………………………………
					: ($Lon_needColumns=$Lon_currentColNumber)\
						 & (Not:C34(Bool:C1537(Form:C1466.forceRedraw)))
						
						$Boo_redraw:=False:C215
						
						  //………………………………………………………………………………………………………………………………………
					: ($Lon_needColumns>$Lon_currentColNumber)
						
						For ($Lon_i;$Lon_currentColNumber+1;$Lon_needColumns;1)
							
							$Txt_column:="Column_"+String:C10($Lon_i)
							$Ptr_column:=OBJECT Get pointer:C1124(Object named:K67:5;$Txt_column)
							
							LISTBOX INSERT COLUMN:C829(*;"list";$Lon_i+1;$Txt_column;$Ptr_column;"Head_"+String:C10($Lon_i);$Ptr_head)
							
							  //EXECUTE FORMULA("ARRAY PICTURE:C279((OBJECT Get pointer:C1124(Object named:K67:5;\""+$Txt_column+"\"))->;"+String($Lon_LineNumber)+")")
							$Ptr_column:=OBJECT Get pointer:C1124(Object named:K67:5;$Txt_column)
							  //%W-518.5
							ARRAY PICTURE:C279($Ptr_column->;$Lon_lineNumber)
							  //%W+518.5
							
							OBJECT SET FORMAT:C236(*;$Txt_column;Char:C90(1))
							LISTBOX SET COLUMN WIDTH:C833(*;$Txt_column;$Lon_colWidth;$Lon_colWidth;$Lon_colWidth)
							
						End for 
						
						  //………………………………………………………………………………………………………………………………………
					: ($Lon_needColumns<$Lon_currentColNumber)
						
						For ($Lon_i;1;$Lon_currentColNumber;1)
							
							If ($Lon_i>$Lon_needColumns)
								
								LISTBOX DELETE COLUMN:C830(*;"list";$Lon_i;1)
								
							Else 
								
								$Txt_column:="Column_"+String:C10($Lon_i)
								$Ptr_column:=OBJECT Get pointer:C1124(Object named:K67:5;$Txt_column)
								  //%W-518.5
								ARRAY PICTURE:C279($Ptr_column->;$Lon_lineNumber)
								  //%W+518.5
								LISTBOX SET COLUMN WIDTH:C833(*;$Txt_column;$Lon_colWidth;$Lon_colWidth;$Lon_colWidth)
								
							End if 
						End for 
						
						  //………………………………………………………………………………………………………………………………………
				End case 
				
				  //______________________________________________________
		End case 
	End for each 
	
	If ($Boo_redraw)
		
		$Lon_row:=1
		$Lon_column:=1
		
		For ($Lon_i;1;$Lon_cellNumber;1)
			
			If ($Lon_column>$Lon_needColumns)
				
				$Lon_row:=$Lon_row+1
				$Lon_column:=1
				
			End if 
			
			$Txt_column:="Column_"+String:C10($Lon_column)
			$Ptr_column:=OBJECT Get pointer:C1124(Object named:K67:5;$Txt_column)
			
			If (Size of array:C274($Ptr_column->)<$Lon_row)
				
				APPEND TO ARRAY:C911($Ptr_column->;$Pic_buffer)
				
			End if 
			
			If ($Lon_i>$Lon_pictureNumber)
				
				$Ptr_column->{$Lon_row}:=$Ptr_column->{$Lon_row}*0
				
			Else 
				
				$Ptr_column->{$Lon_row}:=$tPic_data{$Lon_i}
				
			End if 
			
			OBJECT SET FORMAT:C236($Ptr_column->{$Lon_row};Char:C90(1))
			
			$Lon_column:=$Lon_column+1
			
		End for 
		
		LISTBOX SET ROWS HEIGHT:C835(*;"list";$kLon_cellHeight+$kLon_cellOffset)
		
	Else 
		
		$Lon_x:=Choose:C955($Lon_currentColNumber>1;$Lon_containerWidth\$Lon_currentColNumber;$kLon_cellWidth)
		
		For ($Lon_i;1;$Lon_currentColNumber;1)
			
			$Txt_column:="Column_"+String:C10($Lon_i)
			LISTBOX SET COLUMN WIDTH:C833(*;$Txt_column;$Lon_x)
			
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