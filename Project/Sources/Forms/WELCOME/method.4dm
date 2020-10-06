// ----------------------------------------------------
// Form method : WELCOME - (4D Mobile App)
// ID[15416DA1E1EA420FA0EA9C61C7BC8156]
// Created 2-3-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
C_BOOLEAN:C305($Boo_geometry)
C_LONGINT:C283($i; $l; $Lon_bottom; $Lon_formEvent; $Lon_height; $Lon_left)
C_LONGINT:C283($Lon_middle; $Lon_right; $Lon_top; $Lon_width)
C_OBJECT:C1216($str)

// ----------------------------------------------------
// Initialisations
$Lon_formEvent:=Form event code:C388

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Lon_formEvent=On Load:K2:1)
		
		ARRAY PICTURE:C279($tPic_; 4)
		ARRAY TEXT:C222($tTxt_; 4)
		
		READ PICTURE FILE:C678(Folder:C1567("/RESOURCES/images/welcome/").file("structure.png").platformPath; $tPic_{1})
		READ PICTURE FILE:C678(Folder:C1567("/RESOURCES/images/welcome/").file("design.png").platformPath; $tPic_{2})
		READ PICTURE FILE:C678(Folder:C1567("/RESOURCES/images/welcome/").file("generateAndTest.png").platformPath; $tPic_{3})
		READ PICTURE FILE:C678(Folder:C1567("/RESOURCES/images/welcome/").file("deploy.png").platformPath; $tPic_{4})
		
		$str:=_o_str("<span style='color:dimgray'><span style='font-size: 14pt;font-weight: bold'>"\
			+"{title}"\
			+"</span>"\
			+"<br/>"\
			+"<span style='font-size: 13pt;font-weight: normal'>"\
			+"{description}"\
			+"</span></span>")
		
		For ($i; 1; 4; 1)
			
			$tTxt_{$i}:=$str.localized(New collection:C1472("wel_title_"+String:C10($i); "wel_description_"+String:C10($i)))
			
		End for 
		
		//%W-518.1
		COPY ARRAY:C226($tPic_; (OBJECT Get pointer:C1124(Object named:K67:5; "icons"))->)
		COPY ARRAY:C226($tTxt_; (OBJECT Get pointer:C1124(Object named:K67:5; "texts"))->)
		//%W+518.1
		
		ui_BEST_SIZE(New object:C1471(\
			"widgets"; New collection:C1472("doNotShowAgain")))
		
		ui_BEST_SIZE(New object:C1471(\
			"widgets"; New collection:C1472("continue"); \
			"alignment"; Align center:K42:3))
		
		$Boo_geometry:=True:C214
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($Lon_formEvent=On Bound Variable Change:K2:52)\
		 | ($Lon_formEvent=On Resize:K2:27)
		
		$Boo_geometry:=True:C214
		
		//______________________________________________________
	: ($Lon_formEvent=On Unload:K2:2)
		
		//______________________________________________________
	: ($Lon_formEvent=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		$Boo_geometry:=True:C214
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		//______________________________________________________
End case 

If ($Boo_geometry)
	
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($Lon_width; $Lon_height)
	$Lon_middle:=$Lon_width\2
	
	OBJECT SET COORDINATES:C1248(*; "background"; 0; 0; $Lon_width; $Lon_height)
	
	OBJECT GET COORDINATES:C663(*; "title"; $Lon_left; $Lon_top; $Lon_right; $Lon_bottom)
	OBJECT SET COORDINATES:C1248(*; "title"; 0; $Lon_top; $Lon_width; $Lon_bottom)
	
	OBJECT GET COORDINATES:C663(*; "subtitle"; $Lon_left; $Lon_top; $Lon_right; $Lon_bottom)
	OBJECT SET COORDINATES:C1248(*; "subtitle"; 0; $Lon_top; $Lon_width; $Lon_bottom)
	
	OBJECT GET COORDINATES:C663(*; "list"; $Lon_left; $Lon_top; $Lon_right; $Lon_bottom)
	$Lon_width:=$Lon_right-$Lon_left
	$Lon_left:=$Lon_middle-($Lon_width\2)
	$Lon_right:=$Lon_left+$Lon_width
	OBJECT SET COORDINATES:C1248(*; "list"; $Lon_left; $Lon_top; $Lon_right; $Lon_bottom)
	
	OBJECT GET COORDINATES:C663(*; "doNotShowAgain"; $l; $Lon_top; $Lon_right; $Lon_bottom)
	$Lon_width:=$Lon_right-$l
	$Lon_right:=$Lon_left+$Lon_width
	OBJECT SET COORDINATES:C1248(*; "doNotShowAgain"; $Lon_left; $Lon_top; $Lon_right; $Lon_bottom)
	
	OBJECT GET COORDINATES:C663(*; "continue"; $Lon_left; $Lon_top; $Lon_right; $Lon_bottom)
	$Lon_width:=$Lon_right-$Lon_left
	$Lon_left:=$Lon_middle-($Lon_width\2)
	$Lon_right:=$Lon_left+$Lon_width
	OBJECT SET COORDINATES:C1248(*; "continue"; $Lon_left; $Lon_top; $Lon_right; $Lon_bottom)
	
End if 