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
C_PICTURE:C286($0)
C_OBJECT:C1216($1)
C_OBJECT:C1216($2)

C_BLOB:C604($x)
C_BOOLEAN:C305($bSelected)
C_PICTURE:C286($p)
C_TEXT:C284($domTable;$tFormName;$tName;$tTable;$tTypeForm)
C_OBJECT:C1216($errors;$file;$oDataModel;$oParams;$pathForm;$str)
C_OBJECT:C1216($svg)

If (False:C215)
	C_PICTURE:C286(tables_Widget ;$0)
	C_OBJECT:C1216(tables_Widget ;$1)
	C_OBJECT:C1216(tables_Widget ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
If (Asserted:C1132(Count parameters:C259>=1;"Missing parameter"))
	
	  // Required parameters
	$oDataModel:=$1
	
	  // Optional parameters
	If (Count parameters:C259>=2)
		
		$oParams:=$2
		
	Else 
		
		$oParams:=New object:C1471
		
	End if 
	
	$oParams.x:=0  // Start x
	$oParams.y:=0  // Start y
	
	$oParams.cell:=New object:C1471(\
		"width";115;\
		"height";110)
	
	$oParams.icon:=New object:C1471(\
		"width";80;\
		"height";110)
	
	$oParams.hOffset:=5
	$oParams.maxChar:=18  //Choose(Get database localization="ja";9;18)
	
	$oParams.selectedFill:=ui.colors.backgroundSelectedColor.hex
	$oParams.selectedStroke:=ui.colors.strokeColor.hex
	
	$str:=str ()
	$svg:=svg ()
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($oDataModel#Null:C1517)
	
	$tTypeForm:=Choose:C955(Num:C11(Form:C1466.$dialog[Choose:C955(feature.with("newViewUI");"VIEWS";"_o_VIEWS")].selector)=2;"detail";"list")
	
/* START HIDING ERRORS */$errors:=err .hide()
	
	For each ($tTable;$oDataModel)
		
		$bSelected:=($tTable=String:C10($oParams.tableNumber))
		
		  // Create a table group. filled according to selected status
		$domTable:=$svg.group($tTable)\
			.setFill(Choose:C955($bSelected;$oParams.selectedFill;"none")).latest
		
		  // Background
		$svg.rect($oParams.x;$oParams.y;$oParams.cell.width;$oParams.cell.height;New object:C1471("target";$domTable))\
			.setStroke(Choose:C955($bSelected;$oParams.selectedFill;"none"))
		
		  // Border & reactive 'button'
		$svg.rect($oParams.x+1;$oParams.y+1;$oParams.cell.width;$oParams.cell.height;New object:C1471("target";$domTable))\
			.setStroke(Choose:C955($bSelected;$oParams.selectedStroke;"none"))\
			.setFill("white";5)
		
		  // Put the icon [
		If (Form:C1466[$tTypeForm][$tTable].form=Null:C1517)
			
			  // No form selected
			$file:=Folder:C1567(Get 4D folder:C485(Current resources folder:K5:16);fk platform path:K87:2).file("templates/form/"+$tTypeForm+"/defaultLayoutIcon.png")
			
		Else 
			
			$tFormName:=String:C10(Form:C1466[$tTypeForm][$tTable].form)
			$pathForm:=tmpl_form ($tFormName;$tTypeForm)
			
			If ($pathForm.exists)
				
				$file:=$pathForm.file("layoutIconx2.png")
				
			Else 
				
				  // Error
				$file:=Folder:C1567(Get 4D folder:C485(Current resources folder:K5:16);fk platform path:K87:2).file("images/errorIcon.svg")
				
			End if 
		End if 
		
		If (feature.with("resourcesBrowser"))
			
			If ($pathForm.extension=shared.archiveExtension)  // Archive
				
				$x:=$file.getContent()
				BLOB TO PICTURE:C682($x;$p)
				CLEAR VARIABLE:C89($x)
				
				CREATE THUMBNAIL:C679($p;$p;$oParams.icon.width;$oParams.icon.width)
				$svg.embedPicture($p;$oParams.x+18;5;New object:C1471(\
					"target";$domTable))
				CLEAR VARIABLE:C89($p)
				
			Else 
				
				$svg.image($file;New object:C1471(\
					"target";$domTable;\
					"left";$oParams.x+($oParams.cell.width/2)-($oParams.icon.width/2);\
					"top";$oParams.y+5))\
					.setDimensions($oParams.icon.width)
				
			End if 
			
		Else 
			
			$svg.image($file;New object:C1471(\
				"target";$domTable;\
				"left";$oParams.x+($oParams.cell.width/2)-($oParams.icon.width/2);\
				"top";$oParams.y+5))\
				.setDimensions($oParams.icon.width)
			
		End if 
		
		  // Avoid too long name
		$tName:=Choose:C955(feature.with("newDataModel");$oDataModel[$tTable][""].shortLabel;$oDataModel[$tTable].shortLabel)
		
		If (Length:C16($tName)>$oParams.maxChar)
			
			$tName:=Substring:C12($tName;1;$oParams.maxChar)+"…"
			
		End if 
		
		$svg.textArea($str.setText($tName).truncate($oParams.maxChar);$oParams.x;$oParams.cell.height-20;New object:C1471("target";$domTable))\
			.setDimensions($oParams.cell.width;14)\
			.setFill(Choose:C955($bSelected;"dimgray";"dimgray"))\
			.setAttribute("text-align";"center")
		
		$oParams.x:=$oParams.x+$oParams.cell.width+$oParams.hOffset
		
	End for each 
	
/* STOP HIDING ERRORS */$errors.show()
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$svg.getPicture()

  // ----------------------------------------------------
  // End