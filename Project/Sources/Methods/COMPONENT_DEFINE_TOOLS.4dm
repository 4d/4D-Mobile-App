//%attributes = {"invisible":true}
// Define common functions

If (Storage:C1525.ƒ=Null:C1517)\
 | (Structure file:C489=Structure file:C489(*))
	
	Use (Storage:C1525)
		
		Storage:C1525.ƒ:=New shared object:C1526
		
		Use (Storage:C1525.ƒ)
			
			// Return true if the passed string is a numeric
			//Storage.ƒ.isNumeric:=Formula(Match regex("(?m-si)^\\d+$"; $1; 1; *))
			
			//Storage.ƒ.isField:=Formula(This.isNumeric($1))
			//Storage.ƒ.isRelationToOne:=Formula($1.relatedDataClass#Null)
			//Storage.ƒ.isRelationToMany:=Formula(($1.relatedEntities#Null) | (String($1.kind)="relatedEntities"))
			//Storage.ƒ.isRelation:=Formula((This.isRelationToOne($1)) | (This.isRelationToMany($1)))
			
			// Tests
			//Storage.ƒ.action:=Formula(New object(\
				"action"; $1))
			
			//Storage.ƒ.structureCatalog:=Formula(_o_structure(This.action("catalog")))
			
			//Storage.ƒ.tableCatalog:=Formula(_o_structure(New object(\
				"action"; "catalog"; \
				"name"; $1)))
			
		End use 
	End use 
End if 