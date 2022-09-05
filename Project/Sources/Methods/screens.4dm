//%attributes = {}
var $group; $space : Text
var $bottom; $height; $left; $maxHeight; $maxWidth; $right : Integer
var $screen; $top; $width : Integer
var $svg : cs:C1710.svg

$svg:=cs:C1710.svg.new()\
.translate(20; 20)\
.scale(0.25)\
.fontFamily("sans-serif")\
.fontSize(36)\
.fontStyle(Bold:K14:2)

$maxWidth:=0
$maxHeight:=0

For ($screen; 1; Count screens:C437; 1)
	
	SCREEN COORDINATES:C438($left; $top; $right; $bottom; $screen)
	
	$width:=$right-$left
	$height:=$bottom-$top
	
	$maxWidth+=$width
	If ($height>$maxHeight)
		
		$maxHeight:=$height
		
	End if 
	
	$group:="screen_"+String:C10($screen)
	$svg.group($group; "root")
	
	$svg.rect($width; $height; $group)\
		.position($left; $top)\
		.fillColor("white")\
		.strokeColor("blue")
	
	If ($width=Screen width:C187) && ($height=Screen height:C188)  // Main screen
		
		$svg.rect($width; 65; $group)\
			.position($left; $top)\
			.fillColor("grey")\
			.fillOpacity(0.2)\
			.strokeColor("none")
		
		If (Is macOS:C1572)
			
			$svg.text(Char:C90(0xF8FF); $group)\
				.position(10; 48)\
				.fontSize(48)
			
			$svg.textArea(""; $group)\
				.position(70; 8)\
				.push("menu")
			
		Else 
			
			$svg.textArea("")\
				.position(10; 8)\
				.push("menu")
			
		End if 
		
		$space:=Char:C90(160)*2
		$svg.setText("4D"+$space+"File"+$space+"Edit"+$space+"Run"+$space+"Design"+$space+"Records"+$space+"Tools"+$space+"Method"+$space+"Window"+$space+"Help"; "menu")
		
	End if 
	
	$svg.text(String:C10($screen); $group)\
		.position($left+($width/2)-48; $top+($height/2)-256)\
		.fontSize(96*2)\
		.fillColor("blue")\
		.alignment(Align center:K42:3)
	
	$svg.text(String:C10($width)+"px x "+String:C10($height)+"px"; $group)\
		.position($left+($width/2)-48; $top+($height/2)-80)\
		.fontSize(72)\
		.fontStyle(Plain:K14:1)\
		.alignment(Align center:K42:3)
	
End for 

$svg.viewbox(0; 0; $maxWidth; $maxHeight)
$svg.setAttributes(New object:C1471("width"; $maxWidth; "height"; $maxHeight); $svg._getTarget("root"))

$svg.preview()