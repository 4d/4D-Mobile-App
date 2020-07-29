//%attributes = {}
// Global initialization
var $1 : Object

If (False:C215)
	C_OBJECT:C1216(INIT; $1)
End if 

var $o : Object

// DATABASE
If (Storage:C1525.database=Null:C1517)  // | (Structure file=Structure file(*))
	
	$o:=New shared object:C1526
	
	Use ($o)
		
		$o:=database
		
		Use ($o)
			
			//  Writable user database preferences folder
			$o.preferences:=New shared object:C1526
			
			Use ($o.preferences)
				
				$o.preferences:=Folder:C1567(fk user preferences folder:K87:10).folder($o.structure.name)
				
			End use 
			
			$o.preferences.create()
			
			// 'Mobile Projects' folder
			$o.projects:=New shared object:C1526
			
			Use ($o.projects)
				
				$o.projects:=$o.root.folder("Mobile Projects")
				
			End use 
			
			$o.projects.create()
			
			// Products folder
			$o.products:=New shared object:C1526
			
			Use ($o.products)
				
				$o.products:=$o.root.parent.folder($o.structure.name+" - Mobile")
				
			End use 
		End use 
	End use 
	
	Use (Storage:C1525)
		
		Storage:C1525.database:=$o
		
	End use 
End if 

$1.trigger()
