//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : itunes_lookup
  // ID[96B756353E7C46B2ACE896B1RD9C0058]
  // Created 11-12-2017 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // Itunes store web service search api
  // https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/
  // You can for instance search your application by bundleId:
  // 
  //   itunes (New object("bundleId";"com.apple.iBooks"))
  // ----------------------------------------------------

  // TODO : share this "itunes" method to external composant which

  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_OBJECT:C1216($Obj_in;$Obj_out;$Obj_json)

C_LONGINT:C283($Lon_i;$Lon_parameters;$Lon_result)

ARRAY TEXT:C222($tTxt_names;0)
ARRAY LONGINT:C221($tLon_types;0)

C_TEXT:C284($Txt_value;$Txt_query;$Txt_url)


If (False:C215)
	C_OBJECT:C1216(itunes_lookup ;$0)
	C_OBJECT:C1216(itunes_lookup ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Obj_out:=New object:C1471()
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------

$Txt_query:=""

OB GET PROPERTY NAMES:C1232($Obj_in;$tTxt_names;$tLon_types)

For ($Lon_i;1;Size of array:C274($tTxt_names);1)
	
	$Txt_value:=OB Get:C1224($Obj_in;$tTxt_names{$Lon_i})
	
	If ($Lon_i#1)
		
		$Txt_query:=$Txt_query+"&"
		
	End if 
	
	  // XXX maybe add encoding for safe url or add "$Txt_value" for some element
	
	$Txt_query:=$Txt_query+$tTxt_names{$Lon_i}+"="+$Txt_value
	
End for 

$Txt_url:="http://itunes.apple.com/lookup?"+$Txt_query

$Lon_result:=HTTP Get:C1157($Txt_url;$Obj_json)

$Obj_out.httpCode:=$Lon_result
$Obj_out.httpSuccess:=$Lon_result=200

If (Num:C11($Obj_json.resultCount)>0)
	
	$Obj_out.success:=True:C214
	$Obj_out.resultCount:=$Obj_json.resultCount
	$Obj_out.results:=$Obj_json.results
	$Obj_out.result:=$Obj_json.results[0]
	
Else 
	
	$Obj_out.errors:=New collection:C1472("Could not find object using the iTunes API:"+$Txt_url)
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End