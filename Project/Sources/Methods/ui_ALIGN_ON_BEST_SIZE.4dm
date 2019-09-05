//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : ui_ALIGN_ON_BEST_SIZE
  // ID[C4F630C70E63475A8F5DEA93FE611F72]
  // Created 8-6-2016 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($1)
C_TEXT:C284($2)
C_TEXT:C284(${3})

C_LONGINT:C283($Lon_;$Lon_alignment;$Lon_bottom;$Lon_height;$Lon_i;$Lon_left)
C_LONGINT:C283($Lon_offset;$Lon_currentWidth;$Lon_parameters;$Lon_right;$Lon_top;$Lon_width)
C_TEXT:C284($Txt_objectName)

If (False:C215)
	C_LONGINT:C283(ui_ALIGN_ON_BEST_SIZE ;$1)
	C_TEXT:C284(ui_ALIGN_ON_BEST_SIZE ;$2)
	C_TEXT:C284(ui_ALIGN_ON_BEST_SIZE ;${3})
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  // Required parameters
	$Lon_alignment:=$1
	$Txt_objectName:=$2  // Object name
	
	  // Optional parameters
	If ($Lon_parameters>=3)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------

If ($Lon_alignment=Align center:K42:3)
	
	  // Get the total width defined in design mode
	$Txt_objectName:=$2
	OBJECT GET COORDINATES:C663(*;$Txt_objectName;$Lon_left;$Lon_;$Lon_;$Lon_)
	
	$Txt_objectName:=${$Lon_parameters}
	OBJECT GET COORDINATES:C663(*;$Txt_objectName;$Lon_;$Lon_;$Lon_right;$Lon_)
	
	$Lon_currentWidth:=$Lon_right-$Lon_left
	
End if 

For ($Lon_i;2;$Lon_parameters;1)
	
	$Txt_objectName:=${$Lon_i}
	
	  // Move current object if any
	OBJECT MOVE:C664(*;$Txt_objectName;$Lon_offset;0)
	
	OBJECT GET BEST SIZE:C717(*;$Txt_objectName;$Lon_width;$Lon_height)
	
	  // Add a little margin
	$Lon_width:=$Lon_width*1.1
	
	  // Minimum width
	$Lon_width:=Choose:C955($Lon_width<80;80;$Lon_width)
	
	  // Get current object coordinates
	OBJECT GET COORDINATES:C663(*;$Txt_objectName;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
	
	If ($Lon_alignment=Align left:K42:2)\
		 | ($Lon_alignment=Align center:K42:3)
		
		  // Resize current object
		OBJECT SET COORDINATES:C1248(*;$Txt_objectName;$Lon_left;$Lon_top;$Lon_left+$Lon_width;$Lon_bottom)
		
		  // Calculate the cumulative shift
		$Lon_offset:=$Lon_offset-(($Lon_right-$Lon_left)-$Lon_width)
		
	Else 
		
		  // Resize current object
		OBJECT SET COORDINATES:C1248(*;$Txt_objectName;$Lon_right-$Lon_width;$Lon_top;$Lon_right;$Lon_bottom)
		
		  // Calculate the cumulative shift
		$Lon_offset:=$Lon_offset+($Lon_right-$Lon_left)-$Lon_width
		
	End if 
End for 

If ($Lon_alignment=Align center:K42:3)
	
	  // Get the new total width…
	$Txt_objectName:=$2
	OBJECT GET COORDINATES:C663(*;$Txt_objectName;$Lon_left;$Lon_;$Lon_;$Lon_)
	
	$Txt_objectName:=${$Lon_parameters}
	OBJECT GET COORDINATES:C663(*;$Txt_objectName;$Lon_;$Lon_;$Lon_right;$Lon_)
	
	  //…to calculate the offset
	$Lon_offset:=Round:C94(($Lon_currentWidth-($Lon_right-$Lon_left))/2;0)
	
	  // Then move objects
	For ($Lon_i;2;$Lon_parameters;1)
		
		$Txt_objectName:=${$Lon_i}
		OBJECT MOVE:C664(*;$Txt_objectName;$Lon_offset;0)
		
	End for 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End