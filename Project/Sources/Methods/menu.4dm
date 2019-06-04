//%attributes = {"invisible":true}
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($i)
C_TEXT:C284($t)
C_OBJECT:C1216($o)

If (False:C215)
	C_OBJECT:C1216(menu ;$0)
	C_TEXT:C284(menu ;$1)
	C_OBJECT:C1216(menu ;$2)
End if 

If (This:C1470=Null:C1517)
	
	$o:=New object:C1471(\
		"ref";Create menu:C408;\
		"choice";"";\
		"autoclose";Choose:C955(Count parameters:C259=0;True:C214;Position:C15("autoclose";String:C10($1))>0);\
		"append";Formula:C1597(menu ("append";New object:C1471("item";String:C10($1);"param";String:C10($2);"mark";Bool:C1537($3))));\
		"appendMenu";Formula:C1597(menu ("append";New object:C1471("item";String:C10($1);"menu";$2)));\
		"line";Formula:C1597(APPEND MENU ITEM:C411(This:C1470.ref;"-"));\
		"release";Formula:C1597(RELEASE MENU:C978(This:C1470.ref));\
		"count";Formula:C1597(Count menu items:C405(This:C1470.ref));\
		"disable";Formula:C1597(DISABLE MENU ITEM:C150(This:C1470.ref;Choose:C955(Count parameters:C259=1;$1;-1)));\
		"delete";Formula:C1597(DELETE MENU ITEM:C413(This:C1470.ref;Choose:C955(Count parameters:C259=1;$1;-1)));\
		"popup";Formula:C1597(menu ("popup";New object:C1471("default";$1;"x";$2;"y";$3)));\
		"cleanup";Formula:C1597(menu ("cleanup"))\
		)
	
	  //$o:=New object(\
		"ref";Create menu;\
		"choice";"";\
		"autoclose";Choose(Count parameters=0;True;Position("autoclose";String($1))>0);\
		"line";Formula(APPEND MENU ITEM(This.ref;"-"));\
		"release";Formula(RELEASE MENU(This.ref));\
		"count";Formula(Count menu items(This.ref));\
		"disable";Formula(DISABLE MENU ITEM(This.ref;Choose(Count parameters=1;$1;-1)));\
		"delete";Formula(DELETE MENU ITEM(This.ref;Choose(Count parameters=1;$1;-1)));\
		"popup";Formula(menu ("popup";New object("default";$1;"x";$2;"y";$3)));\
		"cleanup";Formula(menu ("cleanup"));\
		"appendItem";Formula(menu ("append";New object("item";String($1);"param";String($2);"mark";Bool($3))));\
		"appendMenu";Formula(menu ("append";New object("item";String($1);"menu";$2)))\
		)
	
	  //$o.append:=Choose(Value type($2)=Is text;$o.appendItem($1;$2;$3);$o.appendMenu($1;$2))
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
			  //: ($1="appendItem")
			
			  //APPEND MENU ITEM($o.ref;String($2.item))
			  //SET MENU ITEM PARAMETER($o.ref;-1;String($2.param))
			  //SET MENU ITEM MARK($o.ref;-1;Char(18)*Num($2.mark))
			
			  //  //______________________________________________________
			  //: ($1="appendMenu")
			
			  //APPEND MENU ITEM($o.ref;String($2.item);$2.menu.ref)
			  //RELEASE MENU($2.menu.ref)
			
			  //______________________________________________________
		: ($1="append")
			
			If ($2.menu#Null:C1517)
				
				APPEND MENU ITEM:C411($o.ref;String:C10($2.item);$2.menu.ref)
				RELEASE MENU:C978($2.menu.ref)
				
			Else 
				
				APPEND MENU ITEM:C411($o.ref;String:C10($2.item))
				SET MENU ITEM PARAMETER:C1004($o.ref;-1;String:C10($2.param))
				SET MENU ITEM MARK:C208($o.ref;-1;Char:C90(18)*Num:C11($2.mark))
				
			End if 
			
			  //______________________________________________________
		: ($1="popup")
			
			$o.cleanup()
			
			If ($2.x#Null:C1517)
				
				$o.choice:=Dynamic pop up menu:C1006($o.ref;String:C10($2.default);Num:C11($2.x);Num:C11($2.y))
				
			Else 
				
				$o.choice:=Dynamic pop up menu:C1006($o.ref;String:C10($2.default))
				
			End if 
			
			If ($o.autoclose)
				
				$o.release()
				
			End if 
			
			  //______________________________________________________
		: ($1="cleanup")
			
			Repeat   // Remove unnecessary lines at the end
				
				$i:=$o.count()
				
				$t:=Get menu item:C422($o.ref;$i)
				
				If ($t="-")
					
					$o.delete($i)
					
				End if 
			Until ($t#"-")
			
			  // #TO_DO
			  // Remove duplicates (lines or items)
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
			
			  //______________________________________________________
	End case 
End if 

$0:=$o