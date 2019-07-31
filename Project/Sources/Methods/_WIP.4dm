//%attributes = {}
C_PICTURE:C286($Pic_svg)
C_TEXT:C284($Dom_table;$Txt_xml)
C_OBJECT:C1216($o)

  //$Svg_root:=SVG_New
  //SVG_SET_TEXT_RENDERING ($Svg_root;"geometricPrecision")
$o:=svg .dimensions(500;500;"px").textRendering("geometricPrecision")

  // Fill according to selected status
  //$Dom_table:=SVG_New_group ($Svg_root;$Txt_table)
  //SVG_SET_FILL_BRUSH ($Dom_table;Choose($Boo_selected;$kTxt_selectedFill;$kTxt_unselectedFill))
$Dom_table:=$o.group(New object:C1471(\
"id";"g1";\
"fill";"lavender")).lastCreatedObject

  // Background
  //SVG_New_rect ($Dom_table;$Lon_x;$Lon_y;$kLon_cellWidth;$kLon_cellHeight;0;0;"none";Choose($Boo_selected;$kTxt_selectedFill;$kTxt_unselectedFill);1)
$o.rect(10;10;100;20;New object:C1471(\
"holder";$Dom_table;\
"stroke";"none";\
"stroke-width";1;\
"unit";"px"))

  // Border & reactive 'button'
  //$Dom_:=SVG_New_rect ($Dom_table;$Lon_x+1;$Lon_y+1;$kLon_cellWidth;$kLon_cellHeight;0;0;Choose($Boo_selected;$kTxt_selectedStroke;$kTxt_unselectedStroke);"";1)
  //SVG_SET_OPACITY ($Dom_;5;Choose($Boo_selected;100;0))

  //SVGTool_SHOW_IN_VIEWER ($o.root)

$Pic_svg:=$o.get("picture")
$Txt_xml:=$o.get("xml")

  //SVG_CLEAR ($Svg_root)
$o.close()