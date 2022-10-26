

Class constructor
	var $1 : Object
	If (Count parameters:C259>0)
		This:C1470.ds:=$1
	Else 
		This:C1470.ds:=ds:C1482
	End if 
	
Function run
	// clean all
	removeAllEntities(This:C1470.ds)
	This:C1470.notify()
	
	// create one records by data class
	This:C1470.newEntityOfEach()
	This:C1470.notify()
	
	// clean again
	removeAllEntities(This:C1470.ds)
	This:C1470.notify()
	
	// create one record of each and attach it
	C_OBJECT:C1216($entitiesByDataClass)
	$entitiesByDataClass:=This:C1470.newEntityOfEach()
	This:C1470.attach($entitiesByDataClass)
	This:C1470.notify()
	
	// remove relations
	This:C1470.unattach($entitiesByDataClass)
	This:C1470.notify()
	
	// create records
	var $i : Integer
	For ($i; 1; 100; 1)
		This:C1470.newEntityOfEach()
	End for 
	This:C1470.notify()
	
	// clean again
	removeAllEntities(This:C1470.ds)
	This:C1470.notify()
	
	// create records and attach
	For ($i; 1; 100; 1)
		$entitiesByDataClass:=This:C1470.newEntityOfEach()
		This:C1470.attach($entitiesByDataClass)
	End for 
	This:C1470.notify()
	
	// delete some
	For ($i; 1; 10; 1)
		This:C1470.randomDeleteOneOfEach()
	End for 
	This:C1470.notify()
	
	// clean again
	removeAllEntities(This:C1470.ds)
	This:C1470.notify()
	
Function newEntityOfEach
	var $dataClassName : Text
	var $0; $result : Object
	$result:=New object:C1471()
	For each ($dataClassName; This:C1470.ds)
		$result[$dataClassName]:=This:C1470.newEntity(This:C1470.ds[$dataClassName])
	End for each 
	$0:=$result
	
Function randomDeleteOneOfEach
	var $dataClassName : Text
	var $0; $result : Object
	var $all : Object  // sel
	
	$result:=New object:C1471()
	For each ($dataClassName; This:C1470.ds)
		$all:=This:C1470.ds[$dataClassName].all()
		$result[$dataClassName]:=$all[Random:C100%$all.length].drop()
	End for each 
	$0:=$result
	
Function attach
	var $entitiesByDataClass; $1 : Object
	$entitiesByDataClass:=$1
	
	var $entities : Variant  // Collection or Selection -> iterable of object
	$entities:=$entitiesByDataClass[OB Keys:C1719($entitiesByDataClass)[0]]
	
	var $classStore : 4D:C1709.DataClass
	$classStore:=This:C1470.ds[OB Keys:C1719($entitiesByDataClass)[0]]
	var $entity : 4D:C1709.Entity
	For each ($entity; $entities)
		var $key : Text
		For each ($key; $classStore)
			
			Case of 
				: ($classStore[$key].kind="relatedEntities")
					
/*$related:=ds[$classStore[$key].relatedDataClass].all()
					
$one:=Random%$related.length
$two:=Random%$related.length
					
$related:=$related.slice(Min($two;$one);Max($two;$one))
					
$entity[$key]:=$related*/
					
				: ($classStore[$key].kind="relatedEntity")
					
					C_OBJECT:C1216($related)
					$related:=ds:C1482[$classStore[$key].relatedDataClass].all()
					C_LONGINT:C283($one)
					$one:=Random:C100%$related.length
					$entity[$key]:=$related[$one]
					
				Else 
					// ignore
			End case 
			
		End for each 
		
		var $status : Object
		$status:=$entity.save()  // check or not?
		ASSERT:C1129($status.success; "Failed to save an entity:"+JSON Stringify:C1217($status))
		
	End for each 
	
	
Function unattach
	var $entitiesByDataClass; $1 : Object
	$entitiesByDataClass:=$1
	
	var $entities : Variant  // Collection or Selection -> iterable of object
	$entities:=$entitiesByDataClass[OB Keys:C1719($entitiesByDataClass)[0]]
	
	var $classStore : 4D:C1709.DataClass
	$classStore:=This:C1470.ds[OB Keys:C1719($entitiesByDataClass)[0]]
	var $entity : 4D:C1709.Entity
	For each ($entity; $entities)
		var $key : Text
		For each ($key; $classStore)
			
			Case of 
				: ($classStore[$key].kind="relatedEntities")
					
				: ($classStore[$key].kind="relatedEntity")
					
					$entity[$key]:=Null:C1517
					
				Else 
					// ignore
			End case 
			
		End for each 
		
		var $status : Object
		$status:=$entity.save()  // check or not?
		ASSERT:C1129($status.success; "Failed to save an entity:"+JSON Stringify:C1217($status))
		
	End for each 
	
Function newEntity
	var $0; $entities : Collection
	var $1; $classStore : Object
	$classStore:=$1
	$entities:=New collection:C1472()
	
	var $max; $maxStr; $i; $j : Integer
	$max:=1
	$maxStr:=1
	
	var $primaryKey; $fieldName : Text
	$primaryKey:=$classStore.getInfo().primaryKey
	
	var $pictureURL : Text
	$pictureURL:="https://picsum.photos/1000"
	For ($i; 1; $max)
		var $entity : 4D:C1709.Entity
		$entity:=$classStore.new()
		For each ($fieldName; $classStore)
			If ($fieldName=$primaryKey)
				// skip
			Else 
				var $field : Object
				$field:=$classStore[$fieldName]
				// TODO manage primary key
				Case of 
					: ($field.type="string")
						$entity[$fieldName]:=""
						For ($j; 1; $maxStr)
							$entity[$fieldName]:=$entity[$fieldName]+Generate UUID:C1066
						End for 
					: ($field.type="number")
						$entity[$fieldName]:=Random:C100
					: ($field.type="bool")
						$entity[$fieldName]:=(Random:C100%2)>0
					: ($field.type="date")
						$entity[$fieldName]:=Current date:C33  // add random
					: ($field.type="object")
						$entity[$fieldName]:=New object:C1471("num"; Random:C100; "str"; Generate UUID:C1066)
					: ($field.type="image")
						var $hs : Integer
						var $picture : Picture
						var $pictureBlob : Blob
						$hs:=HTTP Get:C1157($pictureURL; $pictureBlob)
						BLOB TO PICTURE:C682($pictureBlob; $picture)
						$entity[$fieldName]:=$picture
					Else 
						
				End case 
			End if 
		End for each 
		var $status : Object
		$status:=$entity.save()  // check or not?
		ASSERT:C1129($status.success; "Failed to save an entity:"+JSON Stringify:C1217($status))
		$entities.push($entity)
	End for 
	$0:=$entities
	
Function stat
	var $dataClassName : Text
	var $entity : 4D:C1709.Entity
	
	var $0; $stat : Object
	$stat:=New object:C1471()
	
	var $all : Object
	
	For each ($dataClassName; This:C1470.ds)
		$all:=This:C1470.ds[$dataClassName].all()
		
		$stat[$dataClassName]:=New object:C1471("count"; $all.length)
		
		$stat[$dataClassName].relation:=This:C1470.statRelation(This:C1470.ds[$dataClassName]; $all)
		
	End for each 
	
	$0:=$stat
	
Function statRelation
	var $1; $dataClass : 4D:C1709.DataClass  // 
	var $2; $entities : Object  //selection
	$dataClass:=$1
	$entities:=$2
	var $entity : 4D:C1709.Entity
	var $0 : Object
	$0:=New object:C1471()
	
	var $key : Text
	For each ($key; $dataClass)
		Case of 
			: ($dataClass[$key].kind="relatedEntities")
				// reverve stat?
				
			: ($dataClass[$key].kind="relatedEntity")
				$0[$key]:=0
				// $0[$key]:=$entities.count($key) // not working with relation? why? not user friendly
				For each ($entity; $entities)
					If ($entity[$key]#Null:C1517)
						$0[$key]:=$0[$key]+1
					End if 
				End for each 
				
			Else 
				// ignore
		End case 
		
	End for each 
	
Function notify
	If (This:C1470.callback#Null:C1517)
		This:C1470.callback.call(This:C1470.stat())
	Else 
		This:C1470._callback(This:C1470.stat())
	End if 
	
Function _callback
	var $1; $stat : Object  //stat
	$stat:=$1
	C_OBJECT:C1216($dumpFolder)
	// here we could launch task, study mobile app etc.., or pass a "callback" function to this class
	
	// replace following code by simctl class (in qa database)
	
	var $scheme; $url; $udid; $callback : Text
	$scheme:="testa"  // in ios app info.plist com.4d.qa.urlScheme and also in url types, scheme
	$callback:="http://"+WEB Get server info:C1531().options.webIPAddressToListen[0]+":"+String:C10(WEB Get server info:C1531().options.webPortID)+"/4DAction/dev_test_data"  // XXX must be encoded?
	$url:=$scheme+"://x-callback-url/sync?x-success="+$callback+"?success=1&x-error="+$callback+"?success=0"
	
	This:C1470.waiting:=True:C214
	$udid:="booted"  // simu id
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
	LAUNCH EXTERNAL PROCESS:C811("xcrun simctl openurl "+$udid+" "+$url)
	
	// wait sync end
	This:C1470.wait()
	
	If (Not:C34(This:C1470.lastCallbackInfo.success))
		TRACE:C157
	End if 
	
	// comment this line if command no supported in 18R, or maybe a rest request instead to check?
	//ASSERT(String(Get Global Stamp)=This.lastCallbackInfo.globalStamp; "Not sync to "+String(Get Global Stamp)+" but only "+This.lastCallbackInfo.globalStamp)
	
	This:C1470.waiting:=True:C214
	$url:=$scheme+"://x-callback-url/dump?x-success="+$callback+"?success=1&x-error="+$callback+"?success=0"
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
	LAUNCH EXTERNAL PROCESS:C811("xcrun simctl openurl "+$udid+" "+$url)
	This:C1470.wait()
	
	If (Not:C34(This:C1470.lastCallbackInfo.success))
		TRACE:C157
	Else 
		//var $dumpFolder : 4D.Folder
		C_TEXT:C284($path)
		$dumpFolder:=Folder:C1567(This:C1470.lastCallbackInfo.path)
		var $dbFile; $jsonFile : 4D:C1709.File
		$dbFile:=$dumpFolder.file("Structures.sqlite")
		// TODO CHECK db ? using sqlite3 command line
		
		var $dataClassName : Text
		For each ($dataClassName; This:C1470.ds)
			$jsonFile:=$dumpFolder.file($dataClassName+".json")
			// TODO CHECK json 
			var $parsed; $mobileStat : Object
			$parsed:=JSON Parse:C1218($jsonFile.getText())  // XXX will failed if file not exist
			$mobileStat:=This:C1470.mobileStat(This:C1470.ds[$dataClassName]; $parsed)
			If ($mobileStat.count#$stat[$dataClassName].count)
				TRACE:C157
				// ASSERT (False; "Not correct number of records for dataclass "+$dataClassName)
			End if 
			
			var $key : Text
			For each ($key; $mobileStat.relation)  // $stat[$dataClassName]["relation"]), we use mobile json because maybe all fields are not in mobile database
				
				If ($mobileStat.relation[$key]#$stat[$dataClassName].relation[$key])
					TRACE:C157
					// ASSERT (False; "Not correct number of records relation for dataclass "+$dataClassName+" and key "+$key)
				End if 
				
			End for each 
			
		End for each 
	End if 
	
Function mobileStat
	var $0; $1; $dataClass; $2 : Object
	$0:=New object:C1471("count"; $2.records.length; "relation"; This:C1470.mobileStatRelation($1; $2.records))
	
	
Function mobileStatRelation
	var $0; $1; $dataClass : Object
	var $2 : Collection
	$dataClass:=$1
	$0:=New object:C1471()
	var $key : Text
	For each ($key; $dataClass)
		Case of 
			: ($dataClass[$key].kind="relatedEntities")
				// reverve stat?
				
			: ($dataClass[$key].kind="relatedEntity")
				
				var $keyExist : Boolean
				$keyExist:=False:C215
				$0[$key]:=0
				var $entity : Object
				For each ($entity; $2)
					If ($entity[$key]#Null:C1517)
						$0[$key]:=$0[$key]+1
					End if 
					//%W-518.7
					If (Not:C34(Undefined:C82($entity[$key])))  // null must be defined (we want here a method ob has key
						$keyExist:=True:C214
					End if 
					//%W+518.7
				End for each 
				If (Not:C34($keyExist))
					OB REMOVE:C1226($0; $key)
				End if 
			Else 
				// ignore
		End case 
		
	End for each 
	// XXX factorrize with ds Stat relation?
	
Function wait
/*var $min : Integer  // min time to wait (study maybe bug with sync/dump)
$min:=Milliseconds+5000
While (This.waiting | (Milliseconds<$min))
IDLE  //or there is better ?
End while */
	
	While (This:C1470.waiting)
		IDLE:C311  //or there is better ?
	End while 
	// XXX maybe also add a time max, and stop current process if too much time
	
Function xCallback
	var $1 : Object
	This:C1470.lastCallbackInfo:=$1
	This:C1470.lastCallbackInfo.success:=Bool:C1537(Num:C11(This:C1470.lastCallbackInfo.success))
	
	var $html : Text
	$html:="<html><body><h1><font size=\"7\">"
	$html:=$html+JSON Stringify:C1217($1)
	$html:=$html+"</h1></font></body></html>"
	WEB SEND TEXT:C677($html)  // just to have a response from this 4daction (maybe add later progress)
	
	This:C1470.waiting:=False:C215  // stop waiting block
	