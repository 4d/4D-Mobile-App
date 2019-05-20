  // ----------------------------------------------------
  // Object method : PRODUCT.icon - (4D Mobile Express)
  // ID[C46E89253C914A9FB9E6C65E0250E050]
  // Created #24-5-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_formEvent)
C_POINTER:C301($Ptr_me)
C_TEXT:C284($Txt_me)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event:C388
$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Getting Focus:K2:7)
		
		  //OBJECT GET COORDINATES(*;$Txt_me;$Lon_left;$Lon_;$Lon_;$Lon_)
		  //OBJECT GET COORDINATES(*;"icon.action";$Lon_;$Lon_top;$Lon_right;$Lon_bottom)
		  //$Lon_right:=$Lon_left+($Lon_right-$Lon_)
		  //OBJECT SET COORDINATES(*;"icon.action";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		
		OBJECT SET VISIBLE:C603(*;"icon.action";True:C214)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Losing Focus:K2:8)
		
		OBJECT SET VISIBLE:C603(*;"icon.action";False:C215)
		
		  //______________________________________________________
	: ($Lon_formEvent=On After Edit:K2:43)
		
		  //appiconSet (New object(\
			"do";"set";\
			"image";$Ptr_me->))
		
		  //______________________________________________________
	: ($Lon_formEvent=On Double Clicked:K2:5)
		
		  //appiconSet (New object("do";"browse"))
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 