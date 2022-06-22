// ----------------------------------------------------
// Form method : TITLE - (4D Mobile App)
// ID[92DED2A5CB2248A3AA5B14A594D33CFF]
// Created 31-1-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $page : Text
var $bottom; $height; $l; $left; $right; $top : Integer
var $width : Integer

$page:=OBJECT Get subform container value:C1785

OBJECT SET FORMAT:C236(*; "icon"; "#images/toolbar/"+$page+".png")
OBJECT SET TITLE:C194(*; "title"; Get localized string:C991("page_"+$page))
OBJECT SET TITLE:C194(*; "comment"; Get localized string:C991("comment_"+$page))

OBJECT GET BEST SIZE:C717(*; "title"; $width; $height)

OBJECT GET COORDINATES:C663(*; "title"; $left; $top; $right; $bottom)
$right:=$left+$width
OBJECT SET COORDINATES:C1248(*; "title"; $left; $top; $right; $bottom)

$left:=$right+20
OBJECT GET COORDINATES:C663(*; "comment"; $l; $top; $right; $bottom)
OBJECT SET COORDINATES:C1248(*; "comment"; $left; $top; $right; $bottom)