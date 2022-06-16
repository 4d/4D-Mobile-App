//%attributes = {}
#DECLARE($in)->$out : Object

$out:=New object:C1471()

$out.success:=($in.table#Null:C1517)
If (Not:C34($out.success))
	$out.errors:=New collection:C1472("Missing table property")
	return 
End if 

$out.fields:=New collection:C1472()
$out.expand:=New collection:C1472()

ASSERT:C1129($in.catalog#Null:C1517; "Need catalog definition to dump data")

If (Value type:C1509($in.catalog)=Is collection:K8:32)
	$in.catalog:=cs:C1710.CatalogBuildWrapper.new($in.catalog)
End if 

If (PROJECT=Null:C1517)
	PROJECT:=cs:C1710.project.new()
End if 

var $recu; $recuOut : Object
var $fieldKey : Text  // field id or name
For each ($fieldKey; $in.table)
	Case of 
			//………………………………………………………………………………………………………………………
		: (Length:C16($fieldKey)=0)
			
			// meta data: add primary key
			$out.fields.push($in.table[""].primaryKey)
			
			//………………………………………………………………………………………………………
		: (Value type:C1509($in.table[$fieldKey])#Is object:K8:27)
			
			// ignore: not a field data
			
			//………………………………………………………………………………………………………
		: ((PROJECT.isField($fieldKey)) || (PROJECT.isComputedAttribute($in.table[$fieldKey])))
			
			$out.fields.push($in.table[$fieldKey].name || $fieldKey)
			
			//………………………………………………………………………………………………………
		: (PROJECT.isRelationToMany($in.table[$fieldKey]))
			
			If (($in.table[$fieldKey].relatedDataClass=Null:C1517) && ($in.table[$fieldKey].relatedEntities#Null:C1517))
				// To remove if relatedEntities deleted and relatedDataClass already filled #109019
				$in.table[$fieldKey].relatedDataClass:=$in.table[$fieldKey].relatedEntities
				ASSERT:C1129(Not:C34(dev_Matrix); "missing relatedDataClass ?")
				
			End if 
			
			If ($out.expand.indexOf($fieldKey)<0)
				
				$out.expand.push($fieldKey)
				
			End if 
			
			// add primary key if missing (destination table must be published, id allow to match link [OPTI: inverse relation n-1 could be sufficient])
			var $relatedDataClass : Object
			$relatedDataClass:=$in.catalog.getTable(String:C10($in.table[$fieldKey].relatedDataClass))
			If (Asserted:C1132($relatedDataClass#Null:C1517; "Unknown data class '"+String:C10($in.table[$fieldKey].relatedDataClass)+"' pointed by link "+$fieldKey))
				
				$out.fields.push($fieldKey+"."+$relatedDataClass.primaryKey)
				
			End if 
			
			//………………………………………………………………………………………………………
		: (PROJECT.isRelationToOne($in.table[$fieldKey]))
			
			If ($out.expand.indexOf($fieldKey)<0)
				
				$out.expand.push($fieldKey)
				
			End if 
			
			$recu:=New object:C1471()
			$recu.table:=OB Copy:C1225($in.table[$fieldKey])
			$recu.table[""]:=$in.catalog.getTableInfo(String:C10($in.table[$fieldKey].relatedDataClass))
			$recu.catalog:=$in.catalog
			
			$recuOut:=dumpFieldNames($recu)
			
			var $recuField : Text
			For each ($recuField; $recuOut.fields)
				
				$out.fields.push($fieldKey+"."+$recuField)
				
			End for each 
			
			//………………………………………………………………………………………………………
		: (Feature.with("alias") && PROJECT.isAlias($in.table[$fieldKey]))
			
			$recuOut:=$in.catalog.aliasPath($in.table[""].name; $in.table[$fieldKey])
			
			$out.fields.push($recuOut.path)
			$out.fields.combine($recuOut.primaryKeys)
			
			// ASKME: do we really need all recursive fields data here, just maybe by doing a first pass to get them,
			// we could just keep id, and data must be retrieved by their own table request.
			
	End case 
	
End for each 

// Remove duplicated fields (due to primary key already added or alias?)
$out.fields:=$out.fields.distinct()