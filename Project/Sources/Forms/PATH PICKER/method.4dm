  // ----------------------------------------------------
  // Form method : PATH PICKER
  // ID[FA1AC624FC504898B4D7D3EF0766501C]
  // Created #9-9-2014 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($bottom;$l;$left;$Lon_width;$offset;$right)
C_LONGINT:C283($top;$width)
C_OBJECT:C1216($event)

  // ----------------------------------------------------
  // Initialisations
$event:=FORM Event:C1606

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($event.code=On Resize:K2:27)
		
		If (Form:C1466.inited=Null:C1517)
			
			Form:C1466.inited:=True:C214
			
			OBJECT GET SUBFORM CONTAINER SIZE:C1148($width;$l)
			
			FORM GET PROPERTIES:C674(Current form name:C1298;$Lon_width;$l)
			
			$offset:=$width-$Lon_width-8
			
			OBJECT GET COORDINATES:C663(*;"browse";$left;$top;$right;$bottom)
			OBJECT SET COORDINATES:C1248(*;"browse";$left+$offset;$top;$right+$offset;$bottom)
			$right:=$left+$offset-5
			
			OBJECT GET COORDINATES:C663(*;"label";$left;$top;$l;$bottom)
			OBJECT SET COORDINATES:C1248(*;"label";$left;$top;$right;$bottom)
			
			OBJECT GET COORDINATES:C663(*;"menu.expand";$left;$top;$l;$bottom)
			OBJECT SET COORDINATES:C1248(*;"menu.expand";$left;$top;$right;$bottom)
			
			OBJECT GET COORDINATES:C663(*;"border";$left;$top;$l;$bottom)
			OBJECT SET COORDINATES:C1248(*;"border";$left;$top;$right;$bottom)
			
		End if 
		
		SET TIMER:C645(1)
		
		  //______________________________________________________
	: ($event.code=On Load:K2:1)\
		 | ($event.code=On Bound Variable Change:K2:52)
		
		SET TIMER:C645(1)
		
		  //______________________________________________________
	: ($event.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		If (Bool:C1537(Form:C1466.browse))
			
			If (Not:C34(OBJECT Get visible:C1075(*;"browse")))
				
				OBJECT SET VISIBLE:C603(*;"browse";True:C214)
				
				OBJECT GET COORDINATES:C663(*;"browse";$left;$top;$right;$bottom)
				$right:=$left-5
				
				OBJECT GET COORDINATES:C663(*;"label";$left;$top;$l;$bottom)
				OBJECT SET COORDINATES:C1248(*;"label";$left;$top;$right;$bottom)
				
				OBJECT GET COORDINATES:C663(*;"menu.expand";$left;$top;$l;$bottom)
				OBJECT SET COORDINATES:C1248(*;"menu.expand";$left;$top;$right;$bottom)
				
				OBJECT GET COORDINATES:C663(*;"border";$left;$top;$l;$bottom)
				OBJECT SET COORDINATES:C1248(*;"border";$left;$top;$right;$bottom)
				
			End if 
			
		Else 
			
			If (OBJECT Get visible:C1075(*;"browse"))
				
				OBJECT SET VISIBLE:C603(*;"browse";False:C215)
				
				OBJECT GET COORDINATES:C663(*;"browse";$left;$top;$right;$bottom)
				
				OBJECT GET COORDINATES:C663(*;"label";$left;$top;$l;$bottom)
				OBJECT SET COORDINATES:C1248(*;"label";$left;$top;$right;$bottom)
				
				OBJECT GET COORDINATES:C663(*;"menu.expand";$left;$top;$l;$bottom)
				OBJECT SET COORDINATES:C1248(*;"menu.expand";$left;$top;$right;$bottom)
				
				OBJECT GET COORDINATES:C663(*;"border";$left;$top;$l;$bottom)
				OBJECT SET COORDINATES:C1248(*;"border";$left;$top;$right;$bottom)
				
			End if 
		End if 
		
		OBJECT SET PLACEHOLDER:C1295(*;"label";String:C10(Form:C1466.placeHolder))
		
		OBJECT SET VISIBLE:C603(*;"menu@";Length:C16(String:C10(Form:C1466.label))>0)
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessary ("+String:C10($event.code)+")")
		
		  //______________________________________________________
End case 