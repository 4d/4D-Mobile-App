//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : getIcon
  // ID[F5FA2667A3A443EC97EC7501B9B9D50C]
  // Created 28-3-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Return icon image according to the relative path value
  // ----------------------------------------------------
  // Declarations
C_PICTURE:C286($0)
C_TEXT:C284($1)

C_PICTURE:C286($p)
C_TEXT:C284($tIcon)
C_OBJECT:C1216($o)

If (False:C215)
	C_PICTURE:C286(getIcon ;$0)
	C_TEXT:C284(getIcon ;$1)
End if 

  //C_TEXT($2)

If (False:C215)
	
	  //C_TEXT(getIcon ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
If (Asserted:C1132(Count parameters:C259>=1;"Missing parameter"))
	
	  // Required parameters
	$tIcon:=$1  // icon path
	
	  // Default values
	  // $tType:="tableIcons"
	
	  // Optional parameters
	If (Count parameters:C259>=2)
		
		  // $tType:=$2  // Will be useful for separate directories for tableIcons/fieldIcons/actionIcons
		  // For the moment, no distinction between table, field or action icons
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Length:C16($tIcon)=0)
	
	$o:=File:C1566(ui.noIcon;fk platform path:K87:2)
	
Else 
	
	$o:=path .icon($tIcon)
	
	If (Not:C34($o.exists))
		
		$o:=File:C1566(ui.errorIcon;fk platform path:K87:2)
		
	End if 
End if 

If ($o.exists)
	
	READ PICTURE FILE:C678($o.platformPath;$p)
	CREATE THUMBNAIL:C679($p;$p;24;24;Scaled to fit:K6:2)
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$p

  // ----------------------------------------------------
  // End