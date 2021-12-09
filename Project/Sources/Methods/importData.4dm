//%attributes = {"invisible":true}
var $fieldName; $primaryKey; $url : Text
var $picture : Picture
var $withPicture : Boolean
var $defaultHowMany; $defaultMaxStr; $howMany; $hs; $i; $maxStr : Integer
var $attribute; $o; $status : Object
var $dataClass; $defaultDataClass : 4D:C1709.DataClass
var $entity : 4D:C1709.Entity
var $err : cs:C1710.error

$defaultDataClass:=ds:C1482.ALL_TYPES
$defaultHowMany:=1000
$defaultMaxStr:=10

If (Shift down:C543)
	
	$dataClass:=ds:C1482[Request:C163("class store name?")]
	$howMany:=Num:C11(Request:C163("how many?"))
	$maxStr:=Num:C11(Request:C163("string concatenate?"))
	
End if 

$dataClass:=($dataClass#Null:C1517) ? $dataClass : $defaultDataClass

If (Asserted:C1132($dataClass#Null:C1517; "This class store do not exists"))
	
	$howMany:=($howMany<=0) ? $defaultHowMany : $howMany
	$maxStr:=($maxStr<=0) ? $defaultMaxStr : $maxStr
	$primaryKey:=$dataClass.getInfo().primaryKey
	
	$url:="https://randomuser.me/api/?results="+String:C10($howMany)  //"https://picsum.photos/200"
	HTTP SET OPTION:C1160(HTTP timeout:K71:10; 2)
	
/* START HIDING ERRORS */$err:=cs:C1710.error.new("capture")
	$hs:=HTTP Get:C1157($url; $o)
/* STOP HIDING ERRORS */$err.show()
	
	$withPicture:=$err.noError() && ($o.error=Null:C1517)
	
	For ($i; 1; $howMany; 1)
		
		$entity:=$dataClass.new()
		
		For each ($fieldName; $dataClass)
			
			If ($fieldName=$primaryKey)
				
				// Skip
				
			Else 
				
				$attribute:=$dataClass[$fieldName]
				
				Case of 
						
						//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
					: (Bool:C1537($attribute.readOnly))
						
						// Getter without setter
						
						//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
					: ($attribute.type="string")
						
						$entity[$fieldName]:=Generate UUID:C1066*$howMany
						
						//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
					: ($attribute.type="number")
						
						$entity[$fieldName]:=Random:C100
						
						//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
					: ($attribute.type="bool")
						
						$entity[$fieldName]:=(Random:C100%2)>0
						
						//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
					: ($attribute.type="date")
						
						$entity[$fieldName]:=Add to date:C393(!1958-08-08!; 0; 0; Random:C100%((Current date:C33-!1958-08-08!)+1))
						
						//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
					: ($attribute.type="object")
						
						$entity[$fieldName]:=New object:C1471(\
							"num"; Random:C100; \
							"str"; Generate UUID:C1066)
						
						//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
					: (($attribute.type="image") && $withPicture)
						
						HTTP Get:C1157($o.results[$i-1].picture.medium; $picture)
						$entity[$fieldName]:=$picture
						
						//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
					Else 
						
						//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
				End case 
			End if 
		End for each 
		
		$status:=$entity.save()
		
	End for 
	
	BEEP:C151
	
End if 