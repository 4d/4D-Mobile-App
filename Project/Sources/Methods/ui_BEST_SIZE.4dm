//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : ui_BEST_SIZE
  // Database: 4D Mobile App
  // ID[87FD2330815449B992747C8102C3BE5E]
  // Created 17-10-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_;$Lon_bottom;$Lon_height;$Lon_left;$Lon_offset;$Lon_parameters)
C_LONGINT:C283($Lon_right;$Lon_top;$Lon_type;$Lon_width)
C_TEXT:C284($Txt_widget)
C_OBJECT:C1216($Obj_in;$Obj_values)

If (False:C215)
	C_OBJECT:C1216(ui_BEST_SIZE ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	
	  // Default values
	$Obj_values:=New object:C1471
	$Obj_values.alignment:=Align left:K42:2
	$Obj_values.minimumWidth:=80
	$Obj_values.factor:=1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	If ($Obj_in.alignment#Null:C1517)
		
		$Obj_values.alignment:=$Obj_in.alignment
		
	End if 
	
	If ($Obj_in.minimumWidth#Null:C1517)
		
		$Obj_values.minimumWidth:=$Obj_in.minimumWidth
		
	End if 
	
	If ($Obj_in.factor#Null:C1517)
		
		$Obj_values.factor:=$Obj_in.factor
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Asserted:C1132($Obj_in.widgets#Null:C1517))
	
	If ($Obj_values.alignment=Align center:K42:3)
		
		  // Get the total width defined in design mode
		OBJECT GET COORDINATES:C663(*;$Obj_in.widgets[0];$Lon_left;$Lon_;$Lon_;$Lon_)
		OBJECT GET COORDINATES:C663(*;$Obj_in.widgets[$Obj_in.widgets.length-1];$Lon_;$Lon_;$Lon_right;$Lon_)
		
		$Obj_values.currentWidth:=$Lon_right-$Lon_left
		
	End if 
	
	For each ($Txt_widget;$Obj_in.widgets)
		
		  // Move current object if any
		OBJECT MOVE:C664(*;$Txt_widget;$Lon_offset;0)
		
		$Lon_type:=OBJECT Get type:C1300(*;$Txt_widget)
		
		Case of 
				
				  //________________________________________
			: ($Lon_type=Object type progress indicator:K79:28)
				
				  // Just get current dimensions
				OBJECT GET COORDINATES:C663(*;$Txt_widget;$Lon_left;$Lon_;$Lon_;$Lon_)
				OBJECT GET COORDINATES:C663(*;$Txt_widget;$Lon_;$Lon_;$Lon_right;$Lon_)
				
				$Lon_width:=$Lon_right-$Lon_left
				
				  //________________________________________
			Else 
				
				OBJECT GET BEST SIZE:C717(*;$Txt_widget;$Lon_width;$Lon_height)
				
				  // Add margin, if any
				$Lon_width:=$Lon_width*$Obj_values.factor
				
				  // Minimum width
				$Lon_width:=Choose:C955($Lon_width<$Obj_values.minimumWidth;$Obj_values.minimumWidth;$Lon_width)
				
				  //________________________________________
		End case 
		
		  // Get current object coordinates
		OBJECT GET COORDINATES:C663(*;$Txt_widget;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		
		If ($Obj_values.alignment=Align left:K42:2)\
			 | ($Obj_values.alignment=Align center:K42:3)
			
			  // Resize current object
			OBJECT SET COORDINATES:C1248(*;$Txt_widget;$Lon_left;$Lon_top;$Lon_left+$Lon_width;$Lon_bottom)
			
			  // Calculate the cumulative shift
			$Lon_offset:=$Lon_offset-(($Lon_right-$Lon_left)-$Lon_width)
			
		Else 
			
			  // Resize current object
			OBJECT SET COORDINATES:C1248(*;$Txt_widget;$Lon_right-$Lon_width;$Lon_top;$Lon_right;$Lon_bottom)
			
			  // Calculate the cumulative shift
			$Lon_offset:=$Lon_offset+($Lon_right-$Lon_left)-$Lon_width
			
		End if 
	End for each 
	
	If ($Obj_values.alignment=Align center:K42:3)
		
		  // Get the new total width…
		OBJECT GET COORDINATES:C663(*;$Obj_in.widgets[0];$Lon_left;$Lon_;$Lon_;$Lon_)
		OBJECT GET COORDINATES:C663(*;$Obj_in.widgets[$Obj_in.widgets.length-1];$Lon_;$Lon_;$Lon_right;$Lon_)
		
		  //…to calculate the offset
		$Lon_offset:=Round:C94(($Obj_values.currentWidth-($Lon_right-$Lon_left))/2;0)
		
		  // Then move objects
		For each ($Txt_widget;$Obj_in.widgets)
			
			OBJECT MOVE:C664(*;$Txt_widget;$Lon_offset;0)
			
		End for each 
	End if 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End