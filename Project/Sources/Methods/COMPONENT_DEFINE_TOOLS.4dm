//%attributes = {"invisible":true}
// Define common functions

If (Storage:C1525.ƒ=Null:C1517)\
 | (Structure file:C489=Structure file:C489(*))
	
	Use (Storage:C1525)
		
		Storage:C1525.ƒ:=New shared object:C1526
		
		Use (Storage:C1525.ƒ)
			
			// Return true if the passed string is a numeric
			Storage:C1525.ƒ.isNumeric:=Formula:C1597(Match regex:C1019("(?m-si)^\\d+$"; $1; 1; *))
			
			Storage:C1525.ƒ.isField:=Formula:C1597(This:C1470.isNumeric($1))
			Storage:C1525.ƒ.isRelationToOne:=Formula:C1597($1.relatedDataClass#Null:C1517)
			Storage:C1525.ƒ.isRelationToMany:=Formula:C1597(($1.relatedEntities#Null:C1517) | (String:C10($1.kind)="relatedEntities"))
			Storage:C1525.ƒ.isRelation:=Formula:C1597((This:C1470.isRelationToOne($1)) | (This:C1470.isRelationToMany($1)))
			
			// Tests
			Storage:C1525.ƒ.action:=Formula:C1597(New object:C1471(\
				"action"; $1))
			
			Storage:C1525.ƒ.structureCatalog:=Formula:C1597(structure(This:C1470.action("catalog")))
			
			Storage:C1525.ƒ.tableCatalog:=Formula:C1597(structure(New object:C1471(\
				"action"; "catalog"; \
				"name"; $1)))
			
		End use 
	End use 
End if 