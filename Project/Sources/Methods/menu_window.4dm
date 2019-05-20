//%attributes = {"invisible":true}
C_TEXT:C284($Mnu_choice)
C_LONGINT:C283($Win_me;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom;$Lon_leftScreen;$Lon_topScreen;$Lon_rightScreen;$Lon_bottomScreen;$Lon_i;$Lon_screenCount)

$Mnu_choice:=Get selected menu item parameter:C1005
$Win_me:=Current form window:C827

Case of 
		
		  //______________________________________________________
	: (Length:C16($Mnu_choice)=0)
		
		  // NOTHING MORE TO DO
		
		  //______________________________________________________
	: ($Mnu_choice="close")
		
		CALL FORM:C1391($Win_me;"win_CLOSE")
		
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
		
		GET WINDOW RECT:C443($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;$Win_me)
		
		$Lon_i:=1
		$Lon_screenCount:=Count screens:C437
		
		Repeat 
			SCREEN COORDINATES:C438($Lon_leftScreen;$Lon_topScreen;$Lon_rightScreen;$Lon_bottomScreen;$Lon_i)
			$Lon_i:=$Lon_i+1
		Until (($Lon_rightScreen>=$Lon_right) | ($Lon_i>$Lon_screenCount))
		
		
		$Lon_left:=(($Lon_rightScreen-$Lon_leftScreen)-($Lon_right-$Lon_left))/2+$Lon_leftScreen
		$Lon_right:=$Lon_rightScreen-$Lon_left
		$Lon_top:=(($Lon_bottomScreen-$Lon_topScreen)-($Lon_bottom-$Lon_top))/2+$Lon_topScreen
		$Lon_bottom:=$Lon_bottomScreen-$Lon_top
		
		SET WINDOW RECT:C444($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;$Win_me)
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown menu action ("+$Mnu_choice+")")
		
		  //______________________________________________________
End case 