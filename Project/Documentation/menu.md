# menu

Manipulate menus as objects and make code more readable.

## Instantiate a new menu in memory

_menuObject_ [object] := ***menu*** {(_param_ [text])}

- _param_ is an optional text enumeration semicolons separated like `"keepReference;displayMetacharacters"`.

  1. `keepReference` indicate that the menu reference should be kept in memory after use. In this case, don't omit to [release memory](### How to remove menu from memory) when menu will no more used.
  2. `displayMetacharacters` indicate that the special characters included in the item text will be considered as metacharacters.
  
- _menuObject_ returned object containing the menu reference in memory and associated member methods.

 Methods      | Action
------------- |-------------
.append()     | Appends new menu item to the menu
.insert()     | Inserts new menu item into the menu
.line()       | Appends a menu line to the menu
.method()     | Sets the 4D project method associated with a menu item
.action()     | Associates a standard action with a menu item
.shortcut()   | Sets the shortcut key associated with a menu item
.icon()       | Sets the icon associated with a menu item
.remove()     | Deletes the menu item
.release()    | Removes the menu from memory
.count()      | Returns the number of menu items present in the menu 
.disable()    | Disables a menu item
.delete()     | Deletes a menu item
.popup()      | Display a hierarchical pop-up of the menu
	

## How to

### Append an item

>*menuObject*.**append** ( _item_ [text] {; _param_ [text] {; _mark_ (bool)}}) -> [menuObject]

- _item_ is the menu item label
- _param_ is a custom character string associated with the new menu item
- _mark_ allow to associate a check mark to the new menu item

### Append a submenu

>*menuObject*.**append** ( _item_ [text] ; _menuObject_ [object] ) -> [menuObject]

- _item_ is the menu item label
- _menuObject_ is the menu to associate with the new menu item

### Insert an item

>*menuObject*.**insert** ( _item_ [text] ; _after_ [number] {; _param_ [text] {; _mark_ (bool)}}) -> [menuObject]

- _item_ is the menu item label
- _after_ is the number of the menu item after which the new menu item will be inserted
- _param_ is a custom character string associated with the new menu item
- _mark_ allow to associate a check mark to the new menu item

### Insert a submenu

>*menuObject*.**insert** ( _item_ [text] ; _after_ [number] ; _menuObject_ [object] ) -> [menuObject]

- _item_ is the menu item label
- _after_ is the number of the menu item after which the new menu item will be inserted
- _menuObject_ is the menu to associate with the new menu item

### Append a line

>*menuObject*.**line** () -> [menuObject]

### Set a project method

>*menuObject*.**method** ( _methodName_ [text] {; _item_ [number]}) -> [menuObject]

- _methodName_ is the name of a 4D project method
- _item_ is the menu item number - last item added if omitted

### Set a standard action

>*menuObject*.**action** ( _action_ [text/number] {; _item_ [number]}) -> [menuObject]

- _action_ is the standard action to associate to the menu item (use 4D constants)
- _item_ is the menu item number - last item added if omitted

### Define a shortcut

>*menuObject*.**shortcut** ( _key_ [text/number] {; _modifier_ {; _item_ [number]}}) -> [menuObject]

- _key_ is the letter or the character code
- _modifier_ is the modifier to associate - Ctrl/Cmd by default (use 4D constants)
- _item_ is the menu item number - last item added if omitted

### Associate an icon

>*menuObject*.**icon** ( _path_ [text] {; _item_ [number]}) -> [menuObject]

- _path_ is the relative POSIX path of the file to use into the resources folder
- _item_ is the menu item number - last item added if omitted

### Remove menu from memory

>*menuObject*.**release** ()

**Note** Must be used for each instantied menu with deactivation of the auto memory release.

### Get the number of menu items

>*menuObject*.**count** () -> [number]

### Disable a menu item

>*menuObject*.**disable** ( {item (number)} )  -> [menuObject]

- _item_ is the menu item number to disable - last item added if omitted

### Delete a menu item>*menuObject*.**delete** ( {item (number)} ) -> [menuObject]

- _item_ is the menu item number to delete - last item added if omitted

### Display menu as popup>*menuObject*.**popup** ( {_default_ [text] {; _xCoord_ [number] ; _yCoord_ [number }} ) -> [menuObject]

or

>*menuObject*.**popup** ( _default_ [text] ; _widget_ [object] ) -> [menuObject]

- _default_ is the parameter of item selected by default
- _xCoord_ & _yCoord_ are the X & Y coordinates who specify of the top left corner of the pop-up menu to be displayed
- _widget_ is a widget object to use as reference to display the popup


## Sample code

`$m:=menu                                         // Create a main menu`  `$m.append("Line 1";"fisrtLine")                  // Append a first item`     `$m.line()                                        // Append a line`    `$m.append("Line 3";"thirdLine";True)             // Append a second item with check mark`     `$s:=menu                                         // Create a sub menu`    `$s.append("Sub menu line 1";"subFisrtLine")      // Append a first item`    `$s.append("Sub menu line 2";"subSecondLine")     // Append a second item`    `$m.line()                                        // Add a line (will be automatically deleted because this is the last item)`     `$m.append("Sub menu";$s)                         // Append the sub menu to the main menu (memory is automatically released)`     `$m.popup("thirdLine")                            // Display as popup with third line selected (memory is automatically released)`     `If ($m.selected)                                 // If user select an item `      `  Case of                                        // Do something according to the user's choice`  `    : ($m.choice="fisrtLine")`  `      // … ` 			  `    : ($m.choice="thirdLine")`  `      // …`  `    : ($m.choice="subFisrtLine")`  `      // …`  
`    : ($m.choice="subSecondLine")`   `      // …`   `  End case`  `End if`  

**Note** Since all the used methods return the object menu, if you want a more concise (but less readable) code or if you want to use it in a **Formula** object, you can create and display the menu in just one line of code, by replacing lines 1 to 20 with:

`$m:=menu.append("Line 1";"fisrtLine").line().append("Line 3";"thirdLine";True).append("Sub menu";menu .append("Sub menu line 1";"subFisrtLine").append("Sub menu line 2";"subSecondLine")).popup("thirdLine")`  


