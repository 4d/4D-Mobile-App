//%attributes = {"invisible":true}
/*
result := ***doc_bytesToString*** ( bytes ; param )
 -> bytes (Real)
 -> param (Object) -  {"unit":"o|B",\r"places": >=0,\r"requestedUnit": "G|M|K|O"}
 <- result (Text)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : doc_bytesToString
  // Alias : Tool_gTxt_BytesToString
  // ID[52B600C770EF4DB2BE947A58FB55265E]
  // Created 03/09/12 by Vincent de Lachaux
  // ----------------------------------------------------
  // modifiée par RL le 13 mai 2013
  // ----------------------------------------------------
  // Description:
  // Return a formatted string to the correct unit from a size in bytes
  // The optional object parameter allow to:
  //    - force the unit
  //    - define the precision
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_REAL:C285($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($Lon_parameters;$Lon_places)
C_REAL:C285($Num_bytes)
C_TEXT:C284($Txt_format;$Txt_integerFormat;$Txt_realFormat;$Txt_result)
C_OBJECT:C1216($Obj_param)

If (False:C215)
	C_TEXT:C284(doc_bytesToString ;$0)
	C_REAL:C285(doc_bytesToString ;$1)
	C_OBJECT:C1216(doc_bytesToString ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	$Num_bytes:=$1
	
	If ($Lon_parameters>=2)
		
		$Obj_param:=$2  // {"unit":"o|B", "places": >=0, "requestedUnit": "G|M|K|O"}
		
	Else 
		
		$Obj_param:=New object:C1471
		
	End if 
	
	If (Length:C16(String:C10($Obj_param.unit))=0)
		
		$Obj_param.unit:=Choose:C955(Get database localization:C1009="fr@";"o";"B")
		
	End if 
	
	$Lon_places:=Num:C11($Obj_param.places)
	
	$Txt_integerFormat:="###,###,###,###,###,###,###"
	$Txt_realFormat:="###,###,###,###,###,###,###."+("#"*$Lon_places)
	$Txt_format:=Choose:C955($Lon_places=0;$Txt_integerFormat;$Txt_realFormat)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //                     Null text
		  //_____________________________________________________
	: ($Num_bytes=0)
		
		$Txt_result:=String:C10($Obj_param.nulValue)
		
		  //______________________________________________________
	: ($Obj_param.requestedUnit#Null:C1517)
		
		  //    According to the requested unit (G / M / K / O)
		  //______________________________________________________
		Case of 
				
				  //……………………………………………………………………………
			: ($Obj_param.requestedUnit="G")
				
				$Txt_result:=String:C10(Round:C94($Num_bytes/(2^30);$Lon_places);$Txt_format)+Char:C90(32)+"G"+$Obj_param.unit
				
				  //……………………………………………………………………………
			: ($Obj_param.requestedUnit="M")
				
				$Txt_result:=String:C10(Round:C94($Num_bytes/(2^20);$Lon_places);$Txt_format)+Char:C90(32)+"M"+$Obj_param.unit
				
				  //……………………………………………………………………………
			: ($Obj_param.requestedUnit="K")
				
				$Txt_result:=String:C10(Round:C94($Num_bytes/(2^10);$Lon_places);$Txt_format)+Char:C90(32)+"k"+$Obj_param.unit
				
				  //……………………………………………………………………………
			: ($Obj_param.requestedUnit="O")
				
				$Txt_result:=String:C10($Num_bytes;$Txt_integerFormat)+Char:C90(32)+$Obj_param.unit
				
				  //……………………………………………………………………………
		End case 
		
		  //________________________________________
	Else 
		
		  //       Depending on the size of the value
		  //______________________________________________________
		
		Case of 
				
				  //……………………………………………………………………………
			: ($Num_bytes>=(2^60))  // Exa
				
				$Txt_result:=String:C10(Round:C94($Num_bytes/(2^60);$Lon_places);$Txt_format)+Char:C90(32)+"E"+$Obj_param.unit
				
				  //……………………………………………………………………………
			: ($Num_bytes>=(2^50))  // Peta
				
				$Txt_result:=String:C10(Round:C94($Num_bytes/(2^50);$Lon_places);$Txt_format)+Char:C90(32)+"P"+$Obj_param.unit
				
				  //……………………………………………………………………………
			: ($Num_bytes>=(2^40))  // Tera
				
				$Txt_result:=String:C10(Round:C94($Num_bytes/(2^40);$Lon_places);$Txt_format)+Char:C90(32)+"T"+$Obj_param.unit
				
				  //……………………………………………………………………………
			: ($Num_bytes>=(2^30))  // Giga
				
				$Txt_result:=String:C10(Round:C94($Num_bytes/(2^30);$Lon_places);$Txt_format)+Char:C90(32)+"G"+$Obj_param.unit
				
				  //……………………………………………………………………………
			: ($Num_bytes>=(2^20))  // Mega
				
				$Txt_result:=String:C10(Round:C94($Num_bytes/(2^20);$Lon_places);$Txt_format)+Char:C90(32)+"M"+$Obj_param.unit
				
				  //……………………………………………………………………………
			: ($Num_bytes>=(2^10))  // Kilo
				
				$Txt_result:=String:C10(Round:C94($Num_bytes/(2^10);$Lon_places);$Txt_format)+Char:C90(32)+"k"+$Obj_param.unit
				
				  //……………………………………………………………………………
			Else   // Octets
				
				$Txt_result:=String:C10(Round:C94($Num_bytes;$Lon_places);$Txt_format)+Char:C90(32)+$Obj_param.unit
				
				  //……………………………………………………………………………
		End case 
		
		  //______________________________________________________
End case 

$0:=$Txt_result

  // ----------------------------------------------------