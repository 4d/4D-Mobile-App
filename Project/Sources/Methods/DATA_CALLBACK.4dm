//%attributes = {"invisible":true}
#DECLARE($in : Variant)

If (False:C215)
	C_VARIANT:C1683(DATA_CALLBACK; $1)
End if 

var $table : Object

Case of 
		//______________________________________________________
	: (Value type:C1509($in)=Is text:K8:3)
		
		Case of 
				//______________________________________________________
			: ($in="update")  // Update data panel after a dataset generation
				
				//$x:=panel("DATA")
				
				//// Update the table list if any
				//var $c : Collection
				//$c:=PROJECT.publishedTables()
				
				//If ($c.length>0)
				
				//For each ($table; $c)
				
				//If ($context.tables.query("tableNumber = :1"; Num($table.tableNumber)).pop()=Null)
				
				//// Add the table
				//$context.tables.push($table)
				
				//End if
				//End for each
				
				//For each ($table; $context.tables)
				
				//If ($c.query("tableNumber = :1"; Num($table.tableNumber)).pop()=Null)
				
				//// Mark to remove
				//$table.toRemove:=True
				
				//End if
				//End for each
				
				//$context.tables:=$context.tables.query("toRemove = null")
				
				//Else
				
				//$context.tables:=New collection
				
				//End if
				
				//$context.dumpSizes()
				
				//OBJECT SET VISIBLE(*; $form.list; False)
				
				//If ($context.tables.length>0)
				
				//$pathname:=dataSet(New object("action"; "path"; \
					"project"; New object("product"; Form.product; "$project"; Form.$project))).path
				
				//// Populate user icons if any
				//For each ($table; $context.tables)
				
				//$index:=$context.tables.indexOf($table)
				
				//If (Length(String($table.filter.string))>0)
				
				//$context.tables[$index].filterIcon:=Choose(Bool($table.filter.parameters); EDITOR.userIcon; EDITOR.filterIcon)
				
				//End if
				
				//If (Bool($table.embedded))\
					 & (Not(Bool($table.filter.parameters)))
				
				//$withSQLlite:=($context.sqlite#Null)
				
				//If ($withSQLlite)
				
				//$t:=formatString("table-name"; $table.name)
				
				//If ($context.sqlite.tables["Z"+Uppercase($t)]#Null)
				
				//$size:=$context.sqlite.tables["Z"+Uppercase($t)]  // Size of the data dump
				
				//If ($size>4096)
				
				//// Add pictures size if any
				//$file:=Folder(asset(New object("action"; "path"; "path"; $pathname)).path+"Pictures"+Folder separator+$t+Folder separator; fk platform path).file("manifest.json")
				
				//If ($file.exists)
				
				//$size:=$size+JSON Parse($file.getText()).contentSize
				
				//End if
				
				//Else
				
				//End if
				
				//Else
				
				//$context.tables[$index].dumpSize:=Get localized string("notAvailable")
				
				//End if
				
				//Else
				
				//$withSQLlite:=False
				
				//End if
				
				//If (Not($withSQLlite))
				
				//$file:=Folder($pathname; fk platform path).file("Resources/Assets.xcassets/Data/"+$table.name+".dataset/"+$table.name+".data.json")
				
				//If ($file.exists)
				
				//// Get document size
				//$x:=$file.getContent()
				//$size:=BLOB size($x)
				//SET BLOB SIZE($x; 0)
				
				//$file:=Folder($pathname; fk platform path).file("Resources/Assets.xcassets/Pictures/"+$table.name+"/manifest.json")
				
				//If ($file.exists)
				
				//$size:=$size+JSON Parse($file.getText()).contentSize
				
				//End if
				
				//Else
				
				//$context.tables[$index].dumpSize:=Get localized string("notAvailable")
				
				//End if
				//End if
				//End if
				//End for each
				
				//If (Num($context.tables.length)>0)
				
				//OBJECT SET VISIBLE(*; $form.list; True)
				//OBJECT SET VISIBLE(*; "noPublishedTable"; False)
				//GOTO OBJECT(*; $form.list)
				
				//// Select the last used table or the first one if none
				//$row:=Choose(Num($context.lastIndex)=0; 1; Num($context.lastIndex))
				//$row:=Choose($row>$context.tables.length; 1; $row)
				//LISTBOX SELECT ROW(*; $form.list; $row; lk replace selection)
				
				//OBJECT SET VISIBLE(*; "01_tables.embeddedLabel"; $context.tables.query("embedded=:1"; True).length>0)
				
				//Else
				
				//$context.lastIndex:=0
				
				//OBJECT SET VISIBLE(*; $form.list; False)
				//OBJECT SET VISIBLE(*; "noPublishedTable"; True)
				
				//OBJECT SET VISIBLE(*; "01_tables.embeddedLabel"; False)
				
				//End if
				
				//Else
				
				//$context.lastIndex:=0
				
				//OBJECT SET VISIBLE(*; $form.list; False)
				//OBJECT SET VISIBLE(*; "noPublishedTable"; True)
				
				//OBJECT SET VISIBLE(*; "01_tables.embeddedLabel"; False)
				
				//End if
				
				//// Redraw list
				//$context.tables:=$context.tables
				
				//$context.listboxUI()
				
				//SET TIMER(-1)
				
				//______________________________________________________
			: (False:C215)
				
				//______________________________________________________
			Else 
				
				// A "Case of" statement should never omit "Else"
				
				//______________________________________________________
		End case 
		
		//______________________________________________________
	: (Value type:C1509($in)=Is object:K8:27)
		
		//______________________________________________________
	Else 
		
		TRACE:C157
		
		//______________________________________________________
End case 