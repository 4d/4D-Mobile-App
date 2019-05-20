//%attributes = {"invisible":true}
/*
***TEMPO_1*** ( pathname )
 -> pathname (Text)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : TEMPO_1
  // Database: 4D Mobile App
  // ID[F2D312A2212D43599C43A56AC1C9BB53]
  // Created #26-6-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Traitement des json "dumpés"
  // On remplace /rest/ par /mobileapp/ dans les champs __deferred.uri
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)

C_LONGINT:C283($Lon_i;$Lon_parameters)
C_TEXT:C284($Dir_root;$Txt_pathname;$Txt_property)
C_OBJECT:C1216($Obj_buffer;$Obj_entity)

ARRAY TEXT:C222($tTxt_files;0)

If (False:C215)
	C_TEXT:C284(TEMPO_1 ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_pathname:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Dir_root:=Object to path:C1548(New object:C1471(\
"name";"JSON";\
"parentFolder";$Txt_pathname;\
"isFolder";True:C214))

If (Asserted:C1132(Test path name:C476($Dir_root)=Is a folder:K24:2))
	
	DOCUMENT LIST:C474($Dir_root;$tTxt_files;Absolute path:K24:14+Ignore invisible:K24:16)
	
	For ($Lon_i;1;Size of array:C274($tTxt_files);1)
		
		If ($tTxt_files{$Lon_i}="@.data.json")
			
			$Obj_buffer:=JSON Parse:C1218(Document to text:C1236($tTxt_files{$Lon_i}))
			
			For each ($Obj_entity;$Obj_buffer.__ENTITIES)
				
				For each ($Txt_property;$Obj_entity)
					
					If (Value type:C1509($Obj_entity[$Txt_property])=Is object:K8:27)
						
						If ($Obj_entity[$Txt_property].__deferred.uri#Null:C1517)
							
							$Obj_entity[$Txt_property].__deferred.uri:=Replace string:C233($Obj_entity[$Txt_property].__deferred.uri;"/rest/";"/mobileapp/")
							
						End if 
					End if 
				End for each 
			End for each 
			
			TEXT TO DOCUMENT:C1237($tTxt_files{$Lon_i};JSON Stringify:C1217($Obj_buffer;*))
			
		End if 
	End for 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End