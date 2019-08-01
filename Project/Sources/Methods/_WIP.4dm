//%attributes = {}
C_BOOLEAN:C305($Boo_selected)
C_LONGINT:C283($kLon_cellHeight;$kLon_cellWidth;$kLon_iconWidth;$kLon_maxChar;$kLon_offset;$Lon_x)
C_LONGINT:C283($Lon_y)
C_PICTURE:C286($p)
C_TEXT:C284($Dom_;$Dom_table;$File_icon;$kTxt_selectedFill;$kTxt_selectedFontColor;$kTxt_selectedStroke)
C_TEXT:C284($kTxt_unselectedFill;$kTxt_unselectedFontColor;$kTxt_unselectedStroke;$Svg_root;$Txt_name;$Txt_table)
C_TEXT:C284($Txt_type;$Txt_url)
C_OBJECT:C1216($file;$svg)

COMPONENT_INIT 

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
$Boo_selected:=Macintosh option down:C545

  //########################
$Txt_table:="1"
$Txt_type:="list"  //"detail"
$Txt_name:="Table 1"
  //########################

If (Not:C34(Shift down:C543))
	
	$svg:=svg ().textRendering("geometricPrecision")
	
	  // Create a table group. Default fill according to selected status
	$Dom_table:=$svg.group(New object:C1471(\
		svg id;$Txt_table;\
		svg background color;Choose:C955($Boo_selected;$kTxt_selectedFill;"none"))).lastCreatedObject
	
	  // Background
	$svg.rect($Lon_x;$Lon_y;$kLon_cellWidth;$kLon_cellHeight;New object:C1471(\
		svg target;$Dom_table;\
		svg foreground color;Choose:C955($Boo_selected;$kTxt_selectedFill;"none")))
	
	  // Border & reactive 'button'
	$svg.rect($Lon_x+1;$Lon_y+1;$kLon_cellWidth;$kLon_cellHeight;New object:C1471(\
		svg target;$Dom_table;\
		svg foreground color;Choose:C955($Boo_selected;$kTxt_selectedStroke;"none");\
		svg background opacity;5))
	
	$file:=Folder:C1567(Get 4D folder:C485(Current resources folder:K5:16);fk platform path:K87:2).file("templates/form/"+$Txt_type+"/defaultLayoutIcon.png")
	
	If (True:C214)
		
		$svg.image("file://"+Convert path POSIX to system:C1107($file.platformPath);New object:C1471(\
			svg target;$Dom_table;\
			"left";$Lon_x+($kLon_cellWidth/2)-($kLon_iconWidth/2);\
			"top";$Lon_y+5;\
			"width";$kLon_iconWidth;\
			"height";$kLon_iconWidth))
		
	Else 
		
		$svg.image($file;New object:C1471(\
			svg target;$Dom_table;\
			"left";$Lon_x+($kLon_cellWidth/2)-($kLon_iconWidth/2);\
			"top";$Lon_y+5;\
			"width";$kLon_iconWidth;\
			"height";$kLon_iconWidth))
		
	End if 
	
	$svg.textArea($Txt_name;$Lon_x;$kLon_cellHeight-20;New object:C1471(\
		"width";$kLon_cellWidth;\
		svg background color;Choose:C955($Boo_selected;$kTxt_selectedFontColor;$kTxt_unselectedFontColor);\
		svg text alignment;"center"))
	
	EXECUTE METHOD:C1007("SVGTool_SHOW_IN_VIEWER";*;$svg.root)
	
	$p:=$svg.get("picture")
	
	$svg.close()
	
Else 
	
	SVG_SET_OPTIONS (SVG_Get_options  ?+ 5)
	SVG_SET_OPTIONS (SVG_Get_options  ?+ 12)
	
	$Svg_root:=SVG_New 
	SVG_SET_TEXT_RENDERING ($Svg_root;"geometricPrecision")
	
	$Dom_table:=SVG_New_group ($Svg_root;$Txt_table)
	
	  // Fill according to selected status
	SVG_SET_FILL_BRUSH ($Dom_table;Choose:C955($Boo_selected;$kTxt_selectedFill;$kTxt_unselectedFill))
	
	  // Background
	SVG_New_rect ($Dom_table;$Lon_x;$Lon_y;$kLon_cellWidth;$kLon_cellHeight;0;0;"none";Choose:C955($Boo_selected;$kTxt_selectedFill;$kTxt_unselectedFill);1)
	
	  // Border & reactive 'button'
	$Dom_:=SVG_New_rect ($Dom_table;$Lon_x+1;$Lon_y+1;$kLon_cellWidth;$kLon_cellHeight;0;0;Choose:C955($Boo_selected;$kTxt_selectedStroke;$kTxt_unselectedStroke);"";1)
	SVG_SET_OPACITY ($Dom_;5;Choose:C955($Boo_selected;100;0))
	
	$Txt_url:="templates/form/"+$Txt_type+"/defaultLayoutIcon.png"
	$File_icon:=Get 4D folder:C485(Current resources folder:K5:16)+Convert path POSIX to system:C1107($Txt_url)
	
	SVG_New_image ($Dom_table;"file://"+Convert path POSIX to system:C1107($File_icon);$Lon_x+($kLon_cellWidth/2)-($kLon_iconWidth/2);$Lon_y+5;$kLon_iconWidth;$kLon_iconWidth)
	
	$Dom_:=SVG_New_textArea ($Dom_table;$Txt_name;$Lon_x;$kLon_cellHeight-20;$kLon_cellWidth;14;"'lucida grande',sans-serif";12;-1;Align center:K42:3)
	SVG_SET_FONT_COLOR ($Dom_;Choose:C955($Boo_selected;$kTxt_selectedFontColor;$kTxt_unselectedFontColor))
	
	SVGTool_SHOW_IN_VIEWER ($Svg_root)
	
	SVG_CLEAR ($Svg_root)
	
End if 

  //Case of
  //  //______________________________________________________
  //: (True)

  //$o:=svg ().textRendering("geometricPrecision")

  //  //______________________________________________________
  //: (True)  //define s vg  attributes

  //$oo:=New object(\
"viewport-fill";"lavender";\
"viewport-fill-opacity";1;\
"viewBox";"0 0 500 500";\
"preserveAspectRatio";"none")

  //$o:=svg (JSON Stringify($oo)).dimensions(500;500;"px").textRendering("geometricPrecision")

  //  //______________________________________________________
  //: (True)  //define default values

  //$oo:=New object(\
"fill";"lavender")

  //$o:=svg ()

  //  //______________________________________________________
  //End case

  // Fill according to selected status
  //$Dom_table:=SVG_New_group ($Svg_root;$Txt_table)
  //SVG_SET_FILL_BRUSH ($Dom_table;Choose($Boo_selected;$kTxt_selectedFill;$kTxt_unselectedFill))
  //$Dom_table:=$o.group(New object(\
"id";"g1";\
"fill";"lavender")).lastCreatedObject

  // Background
  //SVG_New_rect ($Dom_table;$Lon_x;$Lon_y;$kLon_cellWidth;$kLon_cellHeight;0;0;"none";Choose($Boo_selected;$kTxt_selectedFill;$kTxt_unselectedFill);1)
  //$o.rect(10;10;100;20;New object(\
"holder";$Dom_table;\
"fill";"none";\
"stroke";"blue"))

  //$o.rect(10+1;10+1;100;20;New object(\
"holder";$Dom_table;\
"stroke";"red";\
"fill-opacity";5;\
"stroke-opacity";100))