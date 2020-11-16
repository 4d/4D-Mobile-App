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

var $formName; $name; $table; $typeForm : Text
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
	$params.maxChar:=Choose:C955(Get database localization:C1009="ja"; 7; 15)
	
	$params.selectedFill:=UI.colors.backgroundSelectedColor.hex
	$params.selectedStroke:=UI.colors.strokeColor.hex
	
	$str:=cs:C1710.str.new()
	$error:=cs:C1710.error.new()
	$svg:=cs:C1710.svg.new()
	
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
		
		// Create a table group filled according to selected status
		$svg.layer($table).fill(Choose:C955($isSelected; $params.selectedFill; "none"))
		
		If ($svg.useOf($table))
			
			// Background
			$svg.rect($params.cell.width; $params.cell.height)\
				.position($params.x+0.5; $params.y+0.5)\
				.stroke(Choose:C955($isSelected; $params.selectedStroke; "none"))
			
			// Put the icon [
			If (Form:C1466[$typeForm][$table].form=Null:C1517)
				
				// No form selected
				$file:=File:C1566("/RESOURCES/templates/form/"+$typeForm+"/defaultLayoutIcon.png")
				
			Else 
				
				$formName:=String:C10(Form:C1466[$typeForm][$table].form)
				$formRoot:=tmpl_form($formName; $typeForm)
				
				If ($formRoot.exists)
					
					$file:=$formRoot.file("layoutIconx2.png")
					
					If (Not:C34($file.exists))
						
						$file:=File:C1566("/RESOURCES/images/noIcon.svg")
						$svg.setAttribute("tips"; Replace string:C233($formName; "/"; ""); $svg.fetch($table))
						
					End if 
					
				Else 
					
					// Error
					$file:=File:C1566("/RESOURCES/images/errorIcon.svg")
					
				End if 
			End if 
			
			If ($formRoot.extension=SHARED.archiveExtension)  // Archive
				
				$x:=$file.getContent()
				BLOB TO PICTURE:C682($x; $picture)
				CLEAR VARIABLE:C89($x)
				
				CREATE THUMBNAIL:C679($picture; $picture; $params.icon.width; $params.icon.width)
				$svg.imageEmbedded($picture).position($params.x+18; 5)
				CLEAR VARIABLE:C89($picture)
				
			Else 
				
				$svg.imageRef($file)\
					.position($params.x+($params.cell.width/2)-($params.icon.width/2); $params.y+5)\
					.dimensions($params.icon.width; $params.icon.width)
				
			End if 
			
			// Avoid too long name
			$name:=$str.setText($dataModel[$table][""].name).truncate($params.maxChar)
			
			$svg.textArea($name)\
				.position($params.x; $params.cell.height-18)\
				.width($params.cell.width)\
				.fill(Choose:C955($isSelected; $params.selectedStroke; "dimgray"))\
				.alignment(Align center:K42:3)\
				.fontStyle(Choose:C955($isSelected; Bold:K14:2; Normal:K14:15))
			
			// Border & reactive 'button'
			$svg.rect(Num:C11($params.cell.width); Num:C11($params.cell.height))\
				.position(Num:C11($params.x)+1; Num:C11($params.y)+1)\
				.stroke(Choose:C955($isSelected; $params.selectedStroke; "none"))\
				.fill("white")\
				.fillOpacity(0.01)
			
			If ($name#$dataModel[$table][""].name)
				
				// Set a tips
				$svg.setAttribute("tips"; $dataModel[$table][""].name; $svg.fetch($table))
				
			End if 
		End if 
		
		$params.x:=$params.x+$params.cell.width+$params.hOffset
		
	End for each 
	
/* STOP HIDING ERRORS */
	$error.show()
	
End if 

If (FEATURE.with("debug"))
	
	Folder:C1567(fk desktop folder:K87:19).file("DEV/table.svg").setText($svg.content(True:C214))
	
End if 



// ----------------------------------------------------
// Return
$0:=$svg.picture()

// ----------------------------------------------------
// End