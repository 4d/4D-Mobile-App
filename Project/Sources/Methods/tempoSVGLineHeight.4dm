//%attributes = {"invisible":true}
//var $1 : Text  // text
//var $2 : Text  // font-family
//var $3 : Real  // font-size
//var $4 : Text  // font-style
//var $5 : Text  // font-weight
//var $6 : Text  // text-align
//var $7 : Text  // text-decoration
//var $8 : Pointer  // -> width
//var $9 : Pointer  // -> height

//If (False)
//C_TEXT(test_svg; $1)
//C_TEXT(test_svg; $2)
//C_REAL(test_svg; $3)
//C_TEXT(test_svg; $4)
//C_TEXT(test_svg; $5)
//C_TEXT(test_svg; $6)
//C_TEXT(test_svg; $7)
//C_POINTER(test_svg; $8)
//C_POINTER(test_svg; $9)
//End if 

var $fontSize; $height; $high; $width : Real
var $append; $breaks; $dom; $fontFamily; $fontStyle; $fontWeight; $line; $tbreak; $text; $textAlign : Text
var $textDecoration : Text
var $p : Picture
var $count; $i; $j : Integer
var $svg : Text
ARRAY TEXT:C222($tbreaks; 0)
ARRAY LONGINT:C221($len; 0)
ARRAY LONGINT:C221($pos; 0)

//$text:=$1
//$fontFamily:=$2
//$fontSize:=$3
//$fontStyle:=$4
//$fontWeight:=$5
//$textAlign:=$6
//$textDecoration:=$7

$svg:=DOM Create XML Ref:C861("svg"; \
"http://www.w3.org/2000/svg"; \
"xmlns:svg"; "http://www.w3.org/2000/svg"; \
"xmlns:xlink"; "http://www.w3.org/1999/xlink")

$dom:=DOM Create XML element:C865($svg; "text"; \
"x"; 0; \
"y"; 0; \
"fill"; "red"; \
"fill-opacity"; 0.4; \
"font-family"; $fontFamily; \
"font-size"; $fontSize; \
"font-style"; $fontStyle; \
"font-weight"; $fontWeight; \
"text-anchor"; $textAlign; \
"text-decoration"; $textDecoration; \
"text-rendering"; "auto")

// 1] Calculate the height of the last line
$line:=$text

// Keep only the last line
If (Match regex:C1019("(?i-ms).*$"; $text; 1; $pos; $len))
	
	$line:=Substring:C12($text; $pos{0}; $len{0})
	
End if 

DOM SET XML ELEMENT VALUE:C868($dom; $line)
SVG EXPORT TO PICTURE:C1017($svg; $p)
PICTURE PROPERTIES:C457($p; $width; $height)

// 2] Measure the width and height of the text itself.
DOM SET XML ATTRIBUTE:C866($dom; \
"fill-opacity"; 0)

$dom:=DOM Create XML element:C865($svg; "textArea"; \
"x"; 0; \
"y"; 0; \
"fill"; "red"; \
"fill-opacity"; 0.4; \
"font-family"; $fontFamily; \
"font-size"; $fontSize; \
"font-style"; $fontStyle; \
"font-weight"; $fontWeight; \
"text-align"; $textAlign; \
"text-decoration"; $textDecoration; \
"text-rendering"; "auto")

//Editor_TEXT_EDIT_SET_VALUE($dom; $text)

$count:=DOM Count XML elements:C726($dom; "tbreak")

$tbreak:=DOM Find XML element:C864($dom; "textArea/tbreak"; $tbreaks)

For ($i; 1; Size of array:C274($tbreaks); 1)
	
	DOM REMOVE XML ELEMENT:C869($tbreaks{$i})
	
End for 

$i:=1

While (Match regex:C1019("(.+)"; $text; $i; $pos; $len))
	
	$line:=Substring:C12($text; $pos{1}; $len{1})
	
	If ($i=1)
		
		DOM SET XML ELEMENT VALUE:C868($dom; $line)
		
	Else 
		
		$breaks:=Substring:C12($text; $i; $pos{1}-$i)
		$count:=Length:C16(Replace string:C233($breaks; "\r\n"; "\n"; *))
		
		For ($j; 1; $count; 1)
			
			$tbreak:=DOM Create XML element:C865($dom; "tbreak")
			
		End for 
		
		$append:=DOM Append XML child node:C1080($dom; XML DATA:K45:12; $line)
		
	End if 
	
	$i:=$pos{1}+$len{1}
	
End while 

SVG EXPORT TO PICTURE:C1017($svg; $p)
PICTURE PROPERTIES:C457($p; $width; $high)

DOM SET XML ATTRIBUTE:C866($dom; \
"height"; $high+$height)

$dom:=DOM Create XML element:C865($svg; "rect"; \
"x"; 0; \
"y"; 0; \
"width"; $width; \
"height"; $high+$height-4; \
"fill-opacity"; 0.1; \
"shape-rendering"; "geometricPrecision")

SVG EXPORT TO PICTURE:C1017($svg; $p)

PICTURE PROPERTIES:C457($p; $width; $height)

DOM CLOSE XML:C722($svg)

//$8->:=$width
//$9->:=$height