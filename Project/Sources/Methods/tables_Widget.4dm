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
C_TEXT:C284($Dom_table;$kTxt_selectedFill;$kTxt_selectedStroke;$Txt_defaultForm;$Txt_name;$Txt_table)
C_TEXT:C284($Txt_type)
C_OBJECT:C1216($file;$o;$Obj_dataModel;$Obj_params;$Path_hostRoot;$Path_root)

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
	
	$kLon_cellWidth:=115  // 100
	$kLon_cellHeight:=110  // 70
	$kLon_iconWidth:=80
	$kLon_offset:=5
	
	$kTxt_selectedFill:=ui.colors.backgroundSelectedColor.hex  // SVG_Color_RGB_from_long (ui.backgroundSelectedColor)
	$kTxt_selectedStroke:=ui.colors.strokeColor.hex  // SVG_Color_RGB_from_long (ui.strokeColor)
	
	$kLon_maxChar:=18
	
	$Lon_x:=0  // Start x
	$Lon_y:=0  // Start y
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$o:=svg ("{\"viewport-fill\":\"none\"}")

If ($Obj_dataModel#Null:C1517)
	
	$Txt_type:=Choose:C955(Num:C11(Form:C1466.$dialog.VIEWS.selector)=2;"detail";"list")
	
	$Path_root:=Folder:C1567(Get 4D folder:C485(Current resources folder:K5:16);fk platform path:K87:2)
	$Path_hostRoot:=COMPONENT_Pathname ("host_"+$Txt_type+"Forms")
	
	  // Get the default form
	$Txt_defaultForm:=JSON Parse:C1218($Path_root.file("templates/form/"+$Txt_type+"/manifest.json").getText()).default
	
	For each ($Txt_table;$Obj_dataModel)
		
		$Boo_selected:=($Txt_table=String:C10($Obj_params.tableNumber))
		
		  // Create a table group. Default fill according to selected status
		$Dom_table:=$o.group(New object:C1471(\
			svg id;$Txt_table;\
			svg background color;Choose:C955($Boo_selected;$kTxt_selectedFill;"none"))).lastCreatedObject
		
		  // Background
		$o.rect($Lon_x;$Lon_y;$kLon_cellWidth;$kLon_cellHeight;New object:C1471(\
			svg target;$Dom_table;\
			svg foreground color;Choose:C955($Boo_selected;$kTxt_selectedFill;"none")))
		
		  // Border & reactive 'button'
		$o.rect($Lon_x+1;$Lon_y+1;$kLon_cellWidth;$kLon_cellHeight;New object:C1471(\
			svg target;$Dom_table;\
			svg foreground color;Choose:C955($Boo_selected;$kTxt_selectedStroke;"none");\
			svg background opacity;5))
		
		  // Put the icon [
		If (Form:C1466[$Txt_type][$Txt_table].form=Null:C1517)
			
			  // No form selected
			$file:=$Path_root.file("templates/form/"+$Txt_type+"/defaultLayoutIcon.png")
			
		Else 
			
			If (Position:C15("/";String:C10(Form:C1466[$Txt_type][$Txt_table].form))=1)
				
				$file:=$Path_hostRoot.file(Delete string:C232(String:C10(Form:C1466[$Txt_type][$Txt_table].form);1;1)+"/layoutIconx2.png")
				
				If (Not:C34($file.exists))
					
					$file:=$Path_root.file("images/errorIcon.svg")
					
				End if 
				
			Else 
				
				$file:=$Path_root.file("templates/form/"+$Txt_type+"/"+String:C10(Form:C1466[$Txt_type][$Txt_table].form)+"/layoutIconx2.png")
				
				If (Not:C34($file.exists))
					
					$file:=$Path_root.file("images/noIcon.svg")
					
				End if 
			End if 
		End if 
		
		$o.image($file;New object:C1471(\
			svg target;$Dom_table;\
			"left";$Lon_x+($kLon_cellWidth/2)-($kLon_iconWidth/2);\
			"top";$Lon_y+5;\
			"width";$kLon_iconWidth;\
			"height";$kLon_iconWidth))
		
		  // Avoid too long name
		$Txt_name:=$Obj_dataModel[$Txt_table].shortLabel
		
		If (Length:C16($Txt_name)>$kLon_maxChar)
			
			$Txt_name:=Substring:C12($Txt_name;1;$kLon_maxChar)+"…"
			
		End if 
		
		$o.textArea($Txt_name;$Lon_x;$kLon_cellHeight-20;New object:C1471(\
			"width";$kLon_cellWidth;\
			"height";14;\
			svg background color;Choose:C955($Boo_selected;"dimgray";"dimgray");\
			svg text alignment;"center"))
		
		$Lon_x:=$Lon_x+$kLon_cellWidth+$kLon_offset
		
	End for each 
End if 

If (ui.debugMode)
	
	TEXT TO DOCUMENT:C1237(System folder:C487(Desktop:K41:16)+"DEV"+Folder separator:K24:12+"table.svg";$o.get("xml"))
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$o.get("picture")

$o.close()

  // ----------------------------------------------------
  // End