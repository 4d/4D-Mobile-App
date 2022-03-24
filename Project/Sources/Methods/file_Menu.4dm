//%attributes = {"invisible":true}
C_OBJECT:C1216($1)

C_OBJECT:C1216($menu; $o)

If (False:C215)
	C_OBJECT:C1216(file_Menu; $1)
End if 

$menu:=cs:C1710.menu.new()

For each ($o; Folder:C1567("/PACKAGE/Mobile Projects").folders())
	
	If ($o.files().query("name = 'project'").length=1)
		
		$menu.append($o.name; $o.platformPath).method(Formula:C1597(menu_file).source)
		
	End if 
End for each 

$1.append("Open"; $menu)

$1.append("New…"; "new")\
.method(Formula:C1597(C_NEW_MOBILE_PROJECT).source)\
.shortcut(New object:C1471("key"; "N"; "modifier"; Command key mask:K16:1))

$1.line()

$1.append("Close"; "close")\
.method(Formula:C1597(menu_window).source)\
.shortcut(New object:C1471("key"; "W"; "modifier"; Command key mask:K16:1))