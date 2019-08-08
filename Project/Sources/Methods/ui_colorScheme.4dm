//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : ui_colorScheme
  // Database: 4D Mobile App
  // ID[D3B9FB0808EE47E79518C159B704340F]
  // Created 17-1-2019 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // Get information about OS color scheme
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)

C_TEXT:C284($Txt_in;$Txt_out)
C_OBJECT:C1216($Obj_out)

If (False:C215)
	C_OBJECT:C1216(ui_colorScheme ;$0)
End if 

$Obj_out:=New object:C1471(\
"isDarkStyle";False:C215)

Case of 
		
		  //________________________________________
	: (dev_Matrix )  // deactivate if not dev mode
		
		  //________________________________________
	: (Is macOS:C1572)
		
		  // Get global apple interface style
		LAUNCH EXTERNAL PROCESS:C811("defaults read -g AppleInterfaceStyle";$Txt_in;$Txt_out)
		$Obj_out.isDarkStyle:="Dark\n"=$Txt_out
		
		If ($Obj_out.isDarkStyle)
			
			  // Check if app override style (same as defaults read <bundle id>)
			LAUNCH EXTERNAL PROCESS:C811("defaults read -app '"+Convert path system to POSIX:C1106(Application file:C491)+"' NSRequiresAquaSystemAppearance";$Txt_in;$Txt_out)
			
			If ($Txt_out="1\n")
				
				$Obj_out.isDarkStyle:=False:C215
				
			Else 
				
				  // Check plist file
				LAUNCH EXTERNAL PROCESS:C811("defaults read '"+Convert path system to POSIX:C1106(Application file:C491)+"/Contents/Info.plist"+"' NSRequiresAquaSystemAppearance";$Txt_in;$Txt_out)
				
				If ($Txt_out="1\n")
					
					$Obj_out.isDarkStyle:=False:C215
					
				End if 
			End if 
		End if 
		
		  //LAUNCH EXTERNAL PROCESS("defaults read -g AppleHighlightColor";$Txt_in;$Txt_out)
		  //$Txt_out:=Replace string($Txt_out;"\n";"")
		  //$Obj_out.highlightColor:=$Txt_out
		  //$Obj_out.highlightColor:=Split string($Obj_out.highlightColor;" ")
		
		  // in defaults
		  // 0.968627 0.831373 1.000000 Purple
		  // 1.000000 0.749020 0.823529 Pink
		  // 1.000000 0.733333 0.721569 Red
		  // 1.000000 0.874510 0.701961 Orange
		  // 1.000000 0.937255 0.690196 Yellow
		  // 0.752941 0.964706 0.678431 Green
		  // 0.847059 0.847059 0.862745 Graphite
		
		  //LAUNCH EXTERNAL PROCESS("defaults read -g AppleAccentColor";$Txt_in;$Txt_out)
		  //$Txt_out:=Replace string($Txt_out;"\n";"")
		  //$Obj_out.accentColor:=$Txt_out //  {"": "blue", "-1": "graphite", "0": red, "1": orange, "2": yellow, "3": "green", "5": "purple", "6": "pink"}
		
		  // Else (other OS)
		
		  //________________________________________
End case 

$0:=$Obj_out