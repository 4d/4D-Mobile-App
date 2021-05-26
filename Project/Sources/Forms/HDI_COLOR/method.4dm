var $e : Object
$e:=FORM Event:C1606

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		Form:C1466.color:=cs:C1710.color.new("coral")
		Form:C1466.main:=Form:C1466.color.main
		
		Form:C1466.foreground:=Choose:C955(FORM Get color scheme:C1761="dark"; 0x00FFFFFF; "silver")
		
		OBJECT SET VALUE:C1742("4DPalette"; New object:C1471(\
			"index"; 0))
		OBJECT SET VALUE:C1742("dominant"; 1)
		
		Form:C1466.nammedDropdown:=New object:C1471(\
			"values"; JSON Parse:C1218(File:C1566("/RESOURCES/colors.json").getText()).named.extract("name"); \
			"index"; 8)
		
		Form:C1466.complementaryDropdown:=New object:C1471(\
			"values"; New collection:C1472(\
			"Complementary (1)"; \
			"Split-Complementary (2)"; \
			"Triadic complementary (2)"; \
			"Analogous (2)"; \
			"Monochromatic (3)"; \
			"Tetradic (4)"); \
			"index"; 5)
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($e.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		OBJECT SET RGB COLORS:C628(*; "main"; Form:C1466.main; Form:C1466.main)
		
		var $c : Collection
		$c:=Form:C1466.color.setColor(Form:C1466.main).getMatchingColors(Form:C1466.complementaryDropdown.index)
		
		var $i : Integer
		For ($i; 0; 3; 1)
			
			If ($i<$c.length)
				
				OBJECT SET VISIBLE:C603(*; "color_"+String:C10($i); True:C214)
				OBJECT SET RGB COLORS:C628(*; "color_"+String:C10($i); $c[$i]; $c[$i])
				
			Else 
				
				OBJECT SET VISIBLE:C603(*; "color_"+String:C10($i); False:C215)
				
			End if 
		End for 
		
		OBJECT SET RGB COLORS:C628(*; "main.css"; Form:C1466.color.fontColor())
		
		//______________________________________________________
End case 