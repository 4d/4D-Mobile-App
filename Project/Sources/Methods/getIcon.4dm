//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : getIcon
  // Database: 4D Mobile App
  // ID[F5FA2667A3A443EC97EC7501B9B9D50C]
  // Created 28-3-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Return icon image according to the relative path value
  // ----------------------------------------------------
  // Declarations
C_PICTURE:C286($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_LONGINT:C283($Lon_parameters)
C_PICTURE:C286($p)
C_TEXT:C284($Txt_icon;$Txt_type)
C_OBJECT:C1216($o)

If (False:C215)
	C_PICTURE:C286(getIcon ;$0)
	C_TEXT:C284(getIcon ;$1)
	C_TEXT:C284(getIcon ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_icon:=$1  // icon path
	
	  // Default values
	$Txt_type:="tableIcons"
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		$Txt_type:=$2  // Will be useful for separate directories for tableIcons/fieldIcons/actionIcons
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Length:C16($Txt_icon)=0)
	
	$o:=File:C1566(ui.noIcon;fk platform path:K87:2)
	
Else 
	
	If (Position:C15("/";$Txt_icon)=1)  // User resources
		
		$o:=COMPONENT_Pathname ("host_"+$Txt_type)
		
		If ($o.exists)
			
			$o:=File:C1566($o.path+Delete string:C232($Txt_icon;1;1))
			
		End if 
		
		If (Not:C34($o.exists))
			
			$o:=File:C1566(ui.errorIcon;fk platform path:K87:2)
			
		End if 
		
	Else 
		
		$o:=File:C1566("/RESOURCES/images/"+$Txt_type+"/"+$Txt_icon)
		
		If (Not:C34($o.exists))
			
			$o:=File:C1566(ui.noIcon;fk platform path:K87:2)
			
		End if 
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