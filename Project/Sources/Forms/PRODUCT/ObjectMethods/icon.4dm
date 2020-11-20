var $0 : Integer

var $p : Picture
var $e; $ƒ; $menu : Object

$ƒ:=panel_Definition("PRODUCT")
$e:=$ƒ.event

$0:=-1

Case of 
		
		//______________________________________________________
	: ($e.code=On Clicked:K2:4)
		
		$menu:=cs:C1710.menu.new()
		
		$menu.append("CommonMenuItemPaste"; "setIcon")
		GET PICTURE FROM PASTEBOARD:C522($p)
		$menu.enable(Bool:C1537(OK))
		
		$menu.line()
		$menu.append("browse"; "browseIcon")
		$menu.line()
		$menu.append("showIconsFolder"; "openIconFolder").enable(Bool:C1537($ƒ.assets.folder.exists))
		
		$menu.popup()
		
		If ($menu.selected)
			
			If ($menu.choice="setIcon")
				
				$ƒ.setIcon($p)
				
			Else 
				
				$ƒ[$menu.choice]()
				
			End if 
		End if 
		
		//______________________________________________________
	: ($e.code=On Double Clicked:K2:5)
		
		$ƒ.browseIcon()
		
		//______________________________________________________
	: ($e.code=On Drag Over:K2:13)
		
		GET PICTURE FROM PASTEBOARD:C522($p)
		
		If (Not:C34(Bool:C1537(OK)))
			
			// Alllow pictures
			DOCUMENT:=Get file from pasteboard:C976(1)
			
			If (Length:C16(DOCUMENT)>0)
				
				OK:=Num:C11(Is picture file:C1113(DOCUMENT))
				
				If (Is macOS:C1572 & (OK=0))
					
					// Accept applications
					OK:=Num:C11(Path to object:C1547(DOCUMENT).extension=".app")
					
				End if 
			End if 
		End if 
		
		If (Bool:C1537(OK))
			
			$0:=0
			
		End if 
		
		//______________________________________________________
	: ($e.code=On Drop:K2:12)
		
		GET PICTURE FROM PASTEBOARD:C522($p)
		
		If (Bool:C1537(OK))
			
			$ƒ.setIcon($p)
			
		Else 
			
			DOCUMENT:=Get file from pasteboard:C976(1)
			
			If (Length:C16(DOCUMENT)>0)
				
				$ƒ.getIcon(DOCUMENT)
				
			End if 
		End if 
		
		//______________________________________________________
End case 