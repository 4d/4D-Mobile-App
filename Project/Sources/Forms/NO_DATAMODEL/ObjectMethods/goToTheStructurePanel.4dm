// ----------------------------------------------------
// Object method : NO_DATAMODEL.goToTheStructurePanel - (4D Mobile App)
// ID[7A86CE71B87543D2B34CEB786B737641]
// Created 9-3-2022 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $me : Text
var $bottom; $height; $left; $right; $top; $width : Integer
var $e : Object

// ----------------------------------------------------
// Initialisations
$me:=OBJECT Get name:C1087(Object current:K67:2)
$e:=FORM Event:C1606

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		OBJECT GET BEST SIZE:C717(*; $me; $width; $height)
		OBJECT GET COORDINATES:C663(*; $me; $left; $top; $right; $bottom)
		OBJECT SET COORDINATES:C1248(*; $me; $left; $top; $left+$width; $top+$height)
		
		//______________________________________________________
	: ($e.code=On Mouse Enter:K2:33)
		
		OBJECT SET FONT STYLE:C166(*; $me; Underline:K14:4)
		//______________________________________________________
	: ($e.code=On Mouse Move:K2:35)
		
		OBJECT SET FONT STYLE:C166(*; $me; Underline:K14:4)
		
		//______________________________________________________
	: ($e.code=On Mouse Leave:K2:34)
		
		OBJECT SET FONT STYLE:C166(*; $me; Plain:K14:1)
		
		//______________________________________________________
	: ($e.code=On Clicked:K2:4)
		
		CALL FORM:C1391(Current form window:C827; Formula:C1597(editor_CALLBACK).source; "goToPage"; New object:C1471(\
			"page"; "structure"))
		
		//______________________________________________________
End case 