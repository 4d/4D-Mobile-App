//%attributes = {"invisible":true}
/*
transparent := ***pic_isTransparent*** ( image )
 -> image (Picture)
 <- transparent (Boolean)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : pic_isTransparent
  // Database: 4D Mobile Express
  // ID[5293AD24049A4DA6BBC347722ED599E5]
  // Created #23-5-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Return true if the passed picture use transparency
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($0)
C_PICTURE:C286($1)

C_BOOLEAN:C305($Boo_transparent)
C_LONGINT:C283($Lon_height;$Lon_parameters;$Lon_width)
C_PICTURE:C286($Pic_buffer;$Pic_image;$Pic_mask;$Pic_result)
C_TEXT:C284($Svg_code;$Svg_root)

If (False:C215)
	C_BOOLEAN:C305(pic_isTransparent ;$0)
	C_PICTURE:C286(pic_isTransparent ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Pic_image:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
PICTURE PROPERTIES:C457($Pic_image;$Lon_width;$Lon_height)

$Svg_code:="<?xml version='1.0' encoding='UTF-8' standalone='yes' ?>\r"\
+"<svg xmlns='http://www.w3.org/2000/svg' height='<!--#4DEVAL $1-->' viewport-fill='white' viewport-fill-opacity='1' width='<!--#4DEVAL $2-->'/>"

PROCESS 4D TAGS:C816($Svg_code;$Svg_code;$Lon_height;$Lon_width)

$Svg_root:=DOM Parse XML variable:C720($Svg_code)
SVG EXPORT TO PICTURE:C1017($Svg_root;$Pic_buffer;Get XML data source:K45:16)
DOM CLOSE XML:C722($Svg_root)

COMBINE PICTURES:C987($Pic_result;$Pic_buffer;Superimposition:K61:10;$Pic_image)

$Boo_transparent:=Not:C34(Equal pictures:C1196($Pic_result;$Pic_image;$Pic_mask))

  // ----------------------------------------------------
  // Return
$0:=$Boo_transparent

  // ----------------------------------------------------
  // End