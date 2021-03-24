//%attributes = {}
#DECLARE()->$version : Text

var $applicationVersion; $majorVersion; $releaseNumber; $revisionNumber : Text

// The Application version command returns an encoded string value that expresses
// The version number of the 4D environment you are running.

// - If you pass the optional * parameter, an 8-character string is returned,
// Formatted as follows:
//     1      "F" denotes a final version
//            "B" denotes a beta version
//            Other characters denote an 4D internal version
//     2-3-4  Internal 4D compilation number
//     5-6    Version number
//     7      "R" number
//     8      Revision number

$applicationVersion:=Application version:C493(*)

Case of 
		
		//………………………………………………………
	: ($applicationVersion[[1]]="F")  //"F" denotes a final version
		
		// NOTHING MORE TO DO
		
		//………………………………………………………
	: ($applicationVersion[[1]]="B")  //"B" denotes a beta version
		
		// NOTHING MORE TO DO
		
		//………………………………………………………
	Else   // Other characters denote an 4D internal version
		
		$version:="main"
		
		//………………………………………………………
End case 

// The Application version command returns an encoded string value that expresses
// The version number of the 4D environment you are running.
// - If you do not pass the optional * parameter, a 4-character string is returned,
// Formatted as follows:
//     1-2   Version number
//     3     "R" number
//     4     Revision number

$applicationVersion:=Application version:C493

// Application version will return:
//"1820" for v18 R2
//"1830" for v18 R3
//"1801" for v18.1 (first fix release of v18)
//"1802" for v18.2 (second fix release of v18)

If (Length:C16($version)=0)
	
	$majorVersion:=$applicationVersion[[1]]+$applicationVersion[[2]]  // 18
	$releaseNumber:=$applicationVersion[[3]]  // Rx
	$revisionNumber:=$applicationVersion[[4]]  // .x
	
	If ($releaseNumber="0")
		
		// 4D v18.x
		$version:=$majorVersion+Choose:C955($revisionNumber#"0"; "."+$revisionNumber; "")
		
	Else 
		
		// 4D v18 Rx
		$version:=$majorVersion+" R"+$releaseNumber
		
	End if 
End if 