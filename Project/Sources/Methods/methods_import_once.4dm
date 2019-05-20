//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : methods_import_test
  // ----------------------------------------------------
  // Description: Open file dialog and import selected
  //  .method files
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($File_patch;$path;$code;$name;$Dir_methods)
C_LONGINT:C283($Lon_i)
ARRAY TEXT:C222($File_patchs;0)

  // ----------------------------------------------------

$Dir_methods:=Get 4D folder:C485(Database folder:K5:14;*)

Repeat 
	
	$Dir_methods:=Delete string:C232($Dir_methods;Length:C16($Dir_methods);1)
	
Until ($Dir_methods[[Length:C16($Dir_methods)]]#Folder separator:K24:12)

$Dir_methods:=Replace string:C233($Dir_methods;".4dbase";"")+" Project"+Folder separator:K24:12

If (Test path name:C476($Dir_methods)#Is a folder:K24:2)
	
	$Dir_methods:=""
	
End if 

$File_patch:=Select document:C905($Dir_methods;".4dm";"Select methods";Package open:K24:8+Use sheet window:K24:11+Multiple files:K24:7;$File_patchs)

For ($Lon_i;1;Size of array:C274($File_patchs);1)
	
	$path:=$File_patchs{$Lon_i}
	
	$code:=Document to text:C1236($path;"UTF-8")
	
	$name:=Path to object:C1547($path).name
	
	METHOD SET CODE:C1194($name;$code)
	
	If (Shift down:C543)
		
		METHOD OPEN PATH:C1213($name)
		
	End if 
End for 

  // ----------------------------------------------------
  // End