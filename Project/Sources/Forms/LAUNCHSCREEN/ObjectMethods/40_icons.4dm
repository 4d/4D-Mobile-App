  // ----------------------------------------------------
  // Object method : PRODUCT.40_icons - (4D Mobile Express)
  // ID[A5C888692263456791B98AE5C4E13823]
  // Created #24-5-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_formEvent;$Lon_i)
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
	: ($Lon_formEvent=On Load:K2:1)
		
		  //appiconSet (New object(\
									"do";"init";\
									"me";$Txt_me))
		
		For ($Lon_i;0;Form:C1466.assets.icons.images.length;1)
			
			LISTBOX SET ROW COLOR:C1270(*;$Txt_me;$Lon_i+1;0x00FFFFFF;lk background color:K53:25)
			
		End for 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Getting Focus:K2:7)
		
		  //LISTBOX GET CELL POSITION(*;$Txt_me;$Lon_column;$Lon_row)
		  //$Ptr_back:=LISTBOX Get array(*;$Txt_me;lk background color array)
		  //$Lon_count:=Form.assets.icons.images.length
		  //For ($Lon_i;0;$Lon_count-1;1)
		  //If (Form.assets.icons.images[$Lon_i]=selected)
		  //LISTBOX SET ROW COLOR(*;$Txt_me;$Lon_i+1;-7;lk background color)
		  //Else
		  //LISTBOX SET ROW COLOR(*;$Txt_me;$Lon_i+1;-2;lk background color)
		  //End if
		  //End for
		
		OBJECT SET VISIBLE:C603(*;"icon.action";True:C214)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Losing Focus:K2:8)
		
		OBJECT SET VISIBLE:C603(*;"icon.action";False:C215)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Selection Change:K2:29)
		
		  //appiconSet (New object(\
									"do";"display";\
									"me";$Txt_me))
		
		  //______________________________________________________
	: ($Lon_formEvent=On Double Clicked:K2:5)
		
		  //appiconSet (New object("do";"openFolder"))
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 