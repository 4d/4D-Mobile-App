//%attributes = {"invisible":true}
C_TEXT:C284($Mnu_choice)
C_LONGINT:C283($Win_me; $Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Lon_leftScreen; $Lon_topScreen; $Lon_rightScreen; $Lon_bottomScreen; $Lon_i; $Lon_screenCount)

$Mnu_choice:=Get selected menu item parameter:C1005
$Win_me:=Current form window:C827

Case of 
		
		//______________________________________________________
	: (Length:C16($Mnu_choice)=0)
		
		// NOTHING MORE TO DO
		
		//______________________________________________________
	: ($Mnu_choice="close")
		
		CALL FORM:C1391($Win_me; Formula:C1597(win_CLOSE).source)
		
		//______________________________________________________
	: ($Mnu_choice="minimize")
		
		MINIMIZE WINDOW:C454($Win_me)
		
		//______________________________________________________
	: ($Mnu_choice="maximize")
		
		MAXIMIZE WINDOW:C453($Win_me)
		
		//______________________________________________________
	: ($Mnu_choice="hide")
		
		HIDE WINDOW:C436($Win_me)
		
		//______________________________________________________
	: ($Mnu_choice="centered")
		
		GET WINDOW RECT:C443($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Win_me)
		
		$Lon_i:=1
		$Lon_screenCount:=Count screens:C437
		
		Repeat 
			SCREEN COORDINATES:C438($Lon_leftScreen; $Lon_topScreen; $Lon_rightScreen; $Lon_bottomScreen; $Lon_i)
			$Lon_i:=$Lon_i+1
		Until (($Lon_rightScreen>=$Lon_right) | ($Lon_i>$Lon_screenCount))
		
		
		$Lon_left:=(($Lon_rightScreen-$Lon_leftScreen)-($Lon_right-$Lon_left))/2+$Lon_leftScreen
		$Lon_right:=$Lon_rightScreen-$Lon_left
		$Lon_top:=(($Lon_bottomScreen-$Lon_topScreen)-($Lon_bottom-$Lon_top))/2+$Lon_topScreen
		$Lon_bottom:=$Lon_bottomScreen-$Lon_top
		
		SET WINDOW RECT:C444($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Win_me)
		
		//______________________________________________________
	: ($Mnu_choice="dev")
		
		var $name : Text
		var $barHeight; $dock; $explo; $vlWnd : Integer
		
		$barHeight:=84  // Tool bar height + 30 ?
		$dock:=90
		$explo:=304
		ARRAY LONGINT:C221($alWnd; 0)
		WINDOW LIST:C442($alWnd)
		
		For ($vlWnd; 1; Size of array:C274($alWnd))
			
			$name:=Get window title:C450($alWnd{$vlWnd})
			
			Case of 
				: (Length:C16($name)=0)
				: ($name="4D Mobile App - Explorer")
					SET WINDOW RECT:C444(0; $barHeight; $explo; Screen height:C188()-90; $alWnd{$vlWnd})
				: ($name="4D Mobile App - Compiler")
					SET WINDOW RECT:C444($explo; Screen height:C188()-$explo; Screen width:C187(); Screen height:C188()-$dock; $alWnd{$vlWnd})
				: (Position:C15("Method: "; $name)=1)
					SET WINDOW RECT:C444($explo; $barHeight+28; Screen width:C187(); Screen height:C188()-$dock-220; $alWnd{$vlWnd})
				Else 
			End case 
		End for 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown menu action ("+$Mnu_choice+")")
		
		//______________________________________________________
End case 