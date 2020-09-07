//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : tables_Widget
// ID[F05D79A919D64F9C80B35C2D83E03B35]
// Created 20-12-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $0 : Picture
var $1 : Object
var $2 : Object

If (False:C215)
	C_PICTURE:C286(tables_Widget; $0)
	C_OBJECT:C1216(tables_Widget; $1)
	C_OBJECT:C1216(tables_Widget; $2)
End if 

var $fill; $formName; $name; $stroke; $t; $table; $typeForm : Text
var $picture : Picture
var $isSelected : Boolean
var $x : Blob
var $dataModel; $params; $str : Object

var $formRoot : 4D:C1709.Directory
var $file : 4D:C1709.Document
var $error : cs:C1710.error
var $svg : cs:C1710.svg

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	// Required parameters
	$dataModel:=$1
	
	// Optional parameters
	If (Count parameters:C259>=2)
		
		$params:=$2
		
	Else 
		
		$params:=New object:C1471
		
	End if 
	
	$params.x:=0  // Start x
	$params.y:=0  // Start y
	
	$params.cell:=New object:C1471(\
		"width"; 115; \
		"height"; 110)
	
	$params.icon:=New object:C1471(\
		"width"; 80; \
		"height"; 110)
	
	$params.hOffset:=5
	$params.maxChar:=18  // Choose(Get database localization="ja";9;18)
	
	$params.selectedFill:=UI.colors.backgroundSelectedColor.hex
	$params.selectedStroke:=UI.colors.strokeColor.hex
	
	$str:=str()
	
	$svg:=cs:C1710.svg.new()
	$error:=cs:C1710.error.new()
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If ($dataModel#Null:C1517)
	
	$typeForm:=Choose:C955(Num:C11(Form:C1466.$dialog[Choose:C955(FEATURE.with("newViewUI"); "VIEWS"; "_o_VIEWS")].selector)=2; "detail"; "list")
	
/* START HIDING ERRORS */
	$error.hide()
	
	For each ($table; $dataModel)
		
		$isSelected:=($table=String:C10($params.tableNumber))
		
		$fill:=Choose:C955($isSelected; $params.selectedFill; "none")
		$stroke:=Choose:C955($isSelected; $params.selectedStroke; "none")
		
		// Create a table group. filled according to selected status
		$svg.group("root")\
			.id($table)\
			.fill($fill)\
			.push($table)  // Memorize table group address
		
		// Background
		$svg.rect($params.cell.width; $params.cell.height; $table)\
			.position($params.x; $params.y)\
			.stroke($fill)
		
		// Put the icon [
		If (Form:C1466[$typeForm][$table].form=Null:C1517)
			
			// No form selected
			$file:=Folder:C1567(Get 4D folder:C485(Current resources folder:K5:16); fk platform path:K87:2).file("templates/form/"+$typeForm+"/defaultLayoutIcon.png")
			
		Else 
			
			$formName:=String:C10(Form:C1466[$typeForm][$table].form)
			$formRoot:=tmpl_form($formName; $typeForm)
			
			If ($formRoot.exists)
				
				$file:=$formRoot.file("layoutIconx2.png")
				
			Else 
				
				// Error
				$file:=Folder:C1567(Get 4D folder:C485(Current resources folder:K5:16); fk platform path:K87:2).file("images/errorIcon.svg")
				
			End if 
		End if 
		
		If (FEATURE.with("resourcesBrowser"))
			
			If ($formRoot.extension=SHARED.archiveExtension)  // Archive
				
				$x:=$file.getContent()
				BLOB TO PICTURE:C682($x; $picture)
				CLEAR VARIABLE:C89($x)
				
				CREATE THUMBNAIL:C679($picture; $picture; $params.icon.width; $params.icon.width)
				$svg.embedPicture($picture; $table).position($params.x+18; 5)
				CLEAR VARIABLE:C89($picture)
				
			Else 
				
				$svg.image($file; $table)\
					.position($params.x+($params.cell.width/2)-($params.icon.width/2); $params.y+5)\
					.dimensions($params.icon.width; $params.icon.width)
				
			End if 
			
		Else 
			
			$svg.image($file; $table)\
				.position($params.x+($params.cell.width/2)-($params.icon.width/2); $params.y+5)\
				.dimensions($params.icon.width)
			
		End if 
		
		// Avoid too long name
		$name:=$dataModel[$table][""].shortLabel
		
		If (Length:C16($name)>$params.maxChar)
			
			$name:=Substring:C12($name; 1; $params.maxChar)+"..."
			
		End if 
		
		$t:=$str.setText($name).truncate($params.maxChar)
		
		$svg.textArea($t; $table)\
			.position($params.x; $params.cell.height-18)\
			.dimensions($params.cell.width)\
			.setAttribute("text-align"; "center")\
			.fill(Choose:C955($isSelected; "dimgray"; "dimgray"))
		
		// Border & reactive 'button'
		$svg.rect(Num:C11($params.cell.width); Num:C11($params.cell.height); $table)\
			.position(Num:C11($params.x)+1; Num:C11($params.y)+1)\
			.stroke($stroke)\
			.fill("white").fillOpacity(0.05)
		
		$params.x:=$params.x+$params.cell.width+$params.hOffset
		
	End for each 
	
/* STOP HIDING ERRORS */
	$error.show()
	
End if 

If (FEATURE.with("debug"))
	
	Folder:C1567(fk desktop folder:K87:19).file("DEV/table.svg").setText($svg.getText(True:C214))
	
End if 

// ----------------------------------------------------
// Return
$0:=$svg.getPicture()

// ----------------------------------------------------
// End