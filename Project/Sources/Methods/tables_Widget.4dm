//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : tables_Widget
  // Database: 4D Mobile Express
  // ID[F05D79A919D64F9C80B35C2D83E03B35]
  // Created #20-12-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_PICTURE:C286($0)
C_OBJECT:C1216($1)
C_OBJECT:C1216($2)

C_BOOLEAN:C305($Boo_selected)
C_LONGINT:C283($kLon_cellHeight;$kLon_cellWidth;$kLon_iconWidth;$kLon_maxChar;$kLon_offset;$Lon_parameters)
C_LONGINT:C283($Lon_x;$Lon_y)
C_TEXT:C284($Dom_;$Dom_table;$File_;$File_icon;$kTxt_selectedFill;$kTxt_selectedFontColor)
C_TEXT:C284($kTxt_selectedStroke;$kTxt_unselectedFill;$kTxt_unselectedFontColor;$kTxt_unselectedStroke;$Svg_root;$Txt_defaultForm)
C_TEXT:C284($Txt_name;$Txt_table;$Txt_type;$Txt_url)
C_OBJECT:C1216($Obj_dataModel;$Obj_params)

If (False:C215)
	C_PICTURE:C286(tables_Widget ;$0)
	C_OBJECT:C1216(tables_Widget ;$1)
	C_OBJECT:C1216(tables_Widget ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_dataModel:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		$Obj_params:=$2
		
	End if 
	
	If (Not:C34(Is compiled mode:C492))
		
		SVG_SET_OPTIONS (SVG_Get_options  ?+ 5)
		
	End if 
	
	$kLon_cellWidth:=115  // 100
	$kLon_cellHeight:=110  // 70
	$kLon_iconWidth:=80
	$kLon_offset:=5
	
	$kTxt_selectedFill:=ui.colors.backgroundSelectedColor.hex  //SVG_Color_RGB_from_long (ui.backgroundSelectedColor)
	$kTxt_unselectedFill:="white"
	
	$kTxt_selectedStroke:=ui.colors.strokeColor.hex  //SVG_Color_RGB_from_long (ui.strokeColor)
	$kTxt_unselectedStroke:="dimgray"
	
	$kTxt_selectedFontColor:="dimgray"  // "white"
	$kTxt_unselectedFontColor:="dimgray"
	$kLon_maxChar:=18
	
	$Lon_x:=0  // Start x
	$Lon_y:=0  // Start y
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
SVG_SET_OPTIONS (SVG_Get_options  ?- 12)

$Svg_root:=SVG_New   //#TO_DO - cut 4D SVG dependence

SVG_SET_TEXT_RENDERING ($Svg_root;"geometricPrecision")

If ($Obj_dataModel#Null:C1517)
	
	$Txt_type:=Choose:C955(Num:C11(Form:C1466.$dialog.VIEWS.selector)=2;"detail";"list")
	
	  // Load the manifest
	$File_:=_o_Pathname ("templates")+Convert path POSIX to system:C1107("form/"+$Txt_type+"/manifest.json")
	$Txt_defaultForm:=JSON Parse:C1218(Document to text:C1236($File_)).default
	
	For each ($Txt_table;$Obj_dataModel)
		
		$Boo_selected:=($Txt_table=String:C10($Obj_params.tableNumber))
		
		$Dom_table:=SVG_New_group ($Svg_root;$Txt_table)
		
		  // Fill according to selected status
		SVG_SET_FILL_BRUSH ($Dom_table;Choose:C955($Boo_selected;$kTxt_selectedFill;$kTxt_unselectedFill))
		
		  // Background
		SVG_New_rect ($Dom_table;$Lon_x;$Lon_y;$kLon_cellWidth;$kLon_cellHeight;0;0;"none";Choose:C955($Boo_selected;$kTxt_selectedFill;$kTxt_unselectedFill);1)
		
		  // Border & reactive 'button'
		$Dom_:=SVG_New_rect ($Dom_table;$Lon_x+1;$Lon_y+1;$kLon_cellWidth;$kLon_cellHeight;0;0;Choose:C955($Boo_selected;$kTxt_selectedStroke;$kTxt_unselectedStroke);"";1)
		SVG_SET_OPACITY ($Dom_;5;Choose:C955($Boo_selected;100;0))
		
		  // Put the icon [
		If (Form:C1466[$Txt_type][$Txt_table].form=Null:C1517)
			
			  // No form selected
			$Txt_url:="templates/form/"+$Txt_type+"/defaultLayoutIcon.png"
			$File_icon:=Get 4D folder:C485(Current resources folder:K5:16)+Convert path POSIX to system:C1107($Txt_url)
			
		Else 
			
			If (Position:C15("/";String:C10(Form:C1466[$Txt_type][$Txt_table].form))=1)
				
				$File_icon:=_o_Pathname ("host_"+$Txt_type+"Forms")+Delete string:C232(String:C10(Form:C1466[$Txt_type][$Txt_table].form);1;1)+Folder separator:K24:12+"layoutIconx2.png"
				$Txt_url:="file://"+Convert path system to POSIX:C1106($File_icon)
				
				If (Test path name:C476($File_icon)<0)
					
					$File_icon:=Get 4D folder:C485(Current resources folder:K5:16)+Convert path POSIX to system:C1107("images/errorIcon.svg")
					
				End if 
				
			Else 
				
				$Txt_url:="templates/form/"+$Txt_type+"/"+String:C10(Form:C1466[$Txt_type][$Txt_table].form)+"/layoutIconx2.png"
				$File_icon:=Get 4D folder:C485(Current resources folder:K5:16)+Convert path POSIX to system:C1107($Txt_url)
				
				If (Test path name:C476($File_icon)<0)
					
					$File_icon:=Get 4D folder:C485(Current resources folder:K5:16)+Convert path POSIX to system:C1107("images/noIcon.svg")
					
				End if 
				
			End if 
		End if 
		
		SVG_New_image ($Dom_table;"file://"+Convert path POSIX to system:C1107($File_icon);$Lon_x+($kLon_cellWidth/2)-($kLon_iconWidth/2);$Lon_y+5;$kLon_iconWidth;$kLon_iconWidth)
		  //]
		
		  // Avoid too long name [
		$Txt_name:=$Obj_dataModel[$Txt_table].shortLabel
		
		If (Length:C16($Txt_name)>$kLon_maxChar)
			
			$Txt_name:=Substring:C12($Txt_name;1;$kLon_maxChar)+"…"
			
		End if 
		  //]
		
		$Dom_:=SVG_New_textArea ($Dom_table;$Txt_name;$Lon_x;$kLon_cellHeight-20;$kLon_cellWidth;14;"'lucida grande',sans-serif";12;-1;Align center:K42:3)
		SVG_SET_FONT_COLOR ($Dom_;Choose:C955($Boo_selected;$kTxt_selectedFontColor;$kTxt_unselectedFontColor))
		
		$Lon_x:=$Lon_x+$kLon_cellWidth+$kLon_offset
		
	End for each 
End if 

If (ui.debugMode)
	
	DOM EXPORT TO VAR:C863($Svg_root;$Txt_url)
	TEXT TO DOCUMENT:C1237(System folder:C487(Desktop:K41:16)+"DEV"+Folder separator:K24:12+"table.svg";$Txt_url)
	
End if 

  // ----------------------------------------------------
  // Return
$0:=SVG_Export_to_picture ($Svg_root)

SVG_CLEAR ($Svg_root)

  // ----------------------------------------------------
  // End