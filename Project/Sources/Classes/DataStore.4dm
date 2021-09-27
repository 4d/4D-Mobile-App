
/*

DOES NOT WORK AS A COMPONENT
BECAUSE THE COMPONENT DATASTORE IS NOT LOADED

*/

Class extends DataStoreImplementation

//=== === === === === === === === === === === === === ===
// $o:=ds.str("hello world")
Function str($param : Text)->$str : cs:C1710.str
	
	$str:=cs:C1710.str.new()
	
	If (Count parameters:C259>=1)
		
		$str.setText($param)
		
	End if 