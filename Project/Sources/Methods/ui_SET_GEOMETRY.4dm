//%attributes = {"invisible":true}
/*
***ui_SET_GEOMETRY*** ( constraints )
 -> constraints (Object)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : ui_SET_GEOMETRY
  // Database: 4D Mobile Express
  // ID[A01333ED1D654898BA99B7DCB0439E6A]
  // Created #15-5-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_horizontal;$Boo_vertical)
C_LONGINT:C283($i;$kLon_margin;$kLon_scrollBarWidth;$kLon_verticalMargin;$l;$Lon_bottom)
C_LONGINT:C283($Lon_height;$Lon_left;$Lon_margin;$Lon_maximum;$Lon_offset;$Lon_parameters)
C_LONGINT:C283($Lon_rBottom;$Lon_rCenter;$Lon_right;$Lon_rLeft;$Lon_rRight;$Lon_rTop)
C_LONGINT:C283($Lon_tBottom;$Lon_tCenter;$Lon_tLeft;$Lon_top;$Lon_tRight;$Lon_tTop)
C_LONGINT:C283($Lon_type;$Lon_width)
C_TEXT:C284($t;$Txt_constraint;$Txt_widget)
C_OBJECT:C1216($Obj_constraints)

ARRAY OBJECT:C1221($tObj_rules;0)

If (False:C215)
	C_OBJECT:C1216(ui_SET_GEOMETRY ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Obj_constraints:=$1
		
	Else 
		
		$t:=Current form name:C1298
		
		Case of 
				
				  //______________________________________________________
			: (Form:C1466.$dialog[$t].constraints#Null:C1517)
				
				$Obj_constraints:=Form:C1466.$dialog[$t].constraints
				
				  //______________________________________________________ #OLD MECHANISM
				  //: (Not(Is nil pointer(OBJECT Get pointer(Object named;"constraints"))))
				  //$Obj_constraints:=(OBJECT Get pointer(Object named;"constraints"))->
				
				  //______________________________________________________
			Else 
				
				  // ASSERT(Structure file#Structure file(*))
				
				  //______________________________________________________
		End case 
	End if 
	
	$kLon_scrollBarWidth:=15
	$kLon_verticalMargin:=2
	$kLon_margin:=14
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Not:C34(Is nil pointer:C315(OBJECT Get pointer:C1124(Object subform container:K67:4))))
	
	  // Place the background & the bottom line {
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($Lon_width;$Lon_height)
	
	  //OBJECT GET COORDINATES(*;"background";$Lon_tLeft;$Lon_tTop;$Lon_tRight;$Lon_tBottom)
	  //OBJECT SET COORDINATES(*;"background";0;0;$Lon_width;$Lon_height)
	
	OBJECT SET COORDINATES:C1248(*;"bottom.line";16;$Lon_height-1;$Lon_width-16;$Lon_height-1)
	
	OBJECT GET COORDINATES:C663(*;"viewport";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
	OBJECT SET COORDINATES:C1248(*;"viewport";$Lon_left;0;$Lon_width-$kLon_scrollBarWidth;$Lon_height)
	  //}
	
End if 

  // Position the local viewport if any
If (OBJECT Get type:C1300(*;"_viewport")#Object type unknown:K79:1)
	
	OBJECT GET COORDINATES:C663(*;"viewport";$l;$l;$Lon_right;$l)
	OBJECT GET COORDINATES:C663(*;"_viewport";$Lon_left;$Lon_top;$l;$Lon_bottom)
	OBJECT SET COORDINATES:C1248(*;"_viewport";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
	
End if 

  // ----------------------------------------------------
  // Handle the constraints
If (OB Is defined:C1231($Obj_constraints))
	
	OB GET ARRAY:C1229($Obj_constraints;"rules";$tObj_rules)
	
	For ($i;1;Size of array:C274($tObj_rules);1)
		
		Case of 
				
				  //========================================================
			: ($tObj_rules{$i}.formula#Null:C1517)
				
				$tObj_rules{$i}.formula.call()
				
				  //========================================================
			: ($tObj_rules{$i}.method#Null:C1517)
				
				If ($tObj_rules{$i}.param#Null:C1517)
					
					EXECUTE METHOD:C1007($tObj_rules{$i}.method;*;$tObj_rules{$i}.param)
					
				Else 
					
					EXECUTE METHOD:C1007($tObj_rules{$i}.method)
					
				End if 
				
				  //========================================================
			Else 
				
				$Txt_widget:=$tObj_rules{$i}.object  // Target object
				
				$Lon_type:=OBJECT Get type:C1300(*;$Txt_widget)
				
				If ($Lon_type#Object type unknown:K79:1)
					
					OBJECT GET COORDINATES:C663(*;$Txt_widget;$Lon_tLeft;$Lon_tTop;$Lon_tRight;$Lon_tBottom)
					
					If ($tObj_rules{$i}.reference#Null:C1517)
						
						  // Reference object
						OBJECT GET COORDINATES:C663(*;$tObj_rules{$i}.reference;$Lon_rLeft;$Lon_rTop;$Lon_rRight;$Lon_rBottom)
						
					Else 
						
						  // Viewport
						OBJECT GET SUBFORM CONTAINER SIZE:C1148($Lon_rRight;$Lon_rBottom)
						$Lon_rRight:=$Lon_rRight-$kLon_scrollBarWidth
						
					End if 
					
					$Txt_constraint:=$tObj_rules{$i}.type
					
					Case of 
							
							  //______________________________________________________
						: ($Txt_constraint="width")  // Set width in percent of the reference
							
							$Lon_width:=($Lon_rRight-$Lon_rLeft)*$tObj_rules{$i}.value+Num:C11($tObj_rules{$i}.offset)
							$Lon_tRight:=$Lon_tLeft+$Lon_width-$kLon_verticalMargin
							
							Case of 
									
									  //……………………………………………………………………………………………………………
								: ($Lon_type=Object type text input:K79:4)
									
									OBJECT GET SCROLLBAR:C1076(*;$Txt_widget;$Boo_horizontal;$Boo_vertical)
									
									If ($Boo_vertical)
										
										$Lon_tRight:=$Lon_tRight-$kLon_scrollBarWidth
										
									End if 
									
									  //……………………………………………………………………………………………………………
								: ($Lon_type=Object type picture input:K79:5)
									
									$Lon_tRight:=$Lon_tRight+$kLon_verticalMargin
									
									  //……………………………………………………………………………………………………………
								: ($Lon_type=Object type listbox:K79:8)
									
									$Lon_tRight:=$Lon_tRight+$kLon_verticalMargin
									
									  //……………………………………………………………………………………………………………
								: ($Lon_type=Object type rectangle:K79:32)
									
									$Lon_tRight:=$Lon_tRight+($kLon_verticalMargin*2)
									
									  //……………………………………………………………………………………………………………
								: ($Lon_type=Object type popup dropdown list:K79:13)
									
									$Lon_tRight:=$Lon_tRight+5
									
									  //……………………………………………………………………………………………………………
							End case 
							
							  // Move the associated help if any
							If (OBJECT Get type:C1300(*;$Txt_widget+".help")#Object type unknown:K79:1)
								
								OBJECT GET COORDINATES:C663(*;$Txt_widget+".help";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
								
								$Lon_width:=$Lon_right-$Lon_left
								
								$Lon_left:=$Lon_tRight-$Lon_width
								$Lon_right:=$Lon_tRight
								
								OBJECT SET COORDINATES:C1248(*;$Txt_widget+".help";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
								
								$Lon_tRight:=$Lon_tRight-$Lon_width-$kLon_margin
								
							End if 
							
							OBJECT SET COORDINATES:C1248(*;$Txt_widget;$Lon_tLeft;$Lon_tTop;$Lon_tRight;$Lon_tBottom)
							
							  //______________________________________________________
						: ($Txt_constraint="fit-width")
							
							$Lon_tRight:=$Lon_tLeft+($Lon_rRight-$Lon_tLeft)-Num:C11($tObj_rules{$i}.offset)
							OBJECT SET COORDINATES:C1248(*;$Txt_widget;$Lon_tLeft;$Lon_tTop;$Lon_tRight;$Lon_tBottom)
							
							  //______________________________________________________
						: ($Txt_constraint="maximum-width")  // Maximum object width
							
							If (OBJECT Get type:C1300(*;$Txt_widget+".help")#Object type unknown:K79:1)
								
								OBJECT GET COORDINATES:C663(*;$Txt_widget+".help";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
								
								If ($Lon_right>$tObj_rules{$i}.value)
									
									$Lon_width:=$Lon_right-$Lon_left
									
									$Lon_right:=$tObj_rules{$i}.value
									$Lon_left:=$Lon_right-$Lon_width
									
									OBJECT SET COORDINATES:C1248(*;$Txt_widget+".help";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
									
									$Lon_tRight:=$Lon_left-$kLon_margin
									
									OBJECT SET COORDINATES:C1248(*;$Txt_widget;$Lon_tLeft;$Lon_tTop;$Lon_tRight;$Lon_tBottom)
									
								End if 
								
							Else 
								
								$Lon_width:=$tObj_rules{$i}.value
								
								Case of 
										
										  //……………………………………………………………………………………………………………
									: ($Lon_type=Object type popup dropdown list:K79:13)
										
										$Lon_width:=$Lon_width+4
										
										  //……………………………………………………………………………………………………………
								End case 
								
								If (($Lon_tRight-$Lon_tLeft)>$Lon_width)
									
									$Lon_tRight:=$Lon_tLeft+$Lon_width
									
									OBJECT SET COORDINATES:C1248(*;$Txt_widget;$Lon_tLeft;$Lon_tTop;$Lon_tRight;$Lon_tBottom)
									
								End if 
							End if 
							
							  //______________________________________________________
						: ($Txt_constraint="minimum-width")  // Minimum object width
							
							If (OBJECT Get type:C1300(*;$Txt_widget+".help")#Object type unknown:K79:1)
								
								OBJECT GET COORDINATES:C663(*;$Txt_widget+".help";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
								
								If ($Lon_right<$tObj_rules{$i}.value)
									
									$Lon_width:=$Lon_right-$Lon_left
									
									$Lon_right:=$tObj_rules{$i}.value
									$Lon_left:=$Lon_right-$Lon_width
									
									OBJECT SET COORDINATES:C1248(*;$Txt_widget+".help";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
									
									$Lon_tRight:=$Lon_left-$kLon_margin
									
									OBJECT SET COORDINATES:C1248(*;$Txt_widget;$Lon_tLeft;$Lon_tTop;$Lon_tRight;$Lon_tBottom)
									
								End if 
								
							Else 
								
								$Lon_width:=$tObj_rules{$i}.value
								
								Case of 
										
										  //……………………………………………………………………………………………………………
									: ($Lon_type=Object type popup dropdown list:K79:13)
										
										$Lon_width:=$Lon_width+4
										
										  //……………………………………………………………………………………………………………
								End case 
								
								If (($Lon_tRight-$Lon_tLeft)<$Lon_width)
									
									$Lon_tRight:=$Lon_tLeft+$Lon_width
									
									OBJECT SET COORDINATES:C1248(*;$Txt_widget;$Lon_tLeft;$Lon_tTop;$Lon_tRight;$Lon_tBottom)
									
								End if 
							End if 
							
							  //______________________________________________________
						: ($Txt_constraint="margin-auto")
							
							$Lon_margin:=(($Lon_rRight-$Lon_rLeft)-($Lon_width))/2
							
							$Lon_width:=$Lon_tRight-$Lon_tLeft
							
							If ($Lon_margin>0)
								
								$Lon_tLeft:=$Lon_rLeft+$Lon_margin
								$Lon_tRight:=$Lon_tLeft+$Lon_width
								
								OBJECT SET COORDINATES:C1248(*;$Txt_widget;$Lon_tLeft;$Lon_tTop;$Lon_tRight;$Lon_tBottom)
								
							End if 
							
							  //______________________________________________________
						: ($Txt_constraint="margin-right")
							
							$Lon_tRight:=$Lon_rLeft-$tObj_rules{$i}.value
							
							OBJECT SET COORDINATES:C1248(*;$Txt_widget;$Lon_tLeft;$Lon_tTop;$Lon_tRight;$Lon_tBottom)
							
							  //______________________________________________________
						: ($Txt_constraint="margin-left")  // Set the distance to the object on the left
							
							$Lon_width:=$Lon_tRight-$Lon_tLeft
							$Lon_tLeft:=$Lon_rRight+$tObj_rules{$i}.value
							$Lon_tRight:=$Lon_tLeft+$Lon_width
							
							OBJECT SET COORDINATES:C1248(*;$Txt_widget;$Lon_tLeft;$Lon_tTop;$Lon_tRight;$Lon_tBottom)
							
							  //______________________________________________________
						: ($Txt_constraint="inline")
							
							If ($tObj_rules{$i}.reference#Null:C1517)
								
								  // Get the margin value if any
								$Lon_margin:=Num:C11($tObj_rules{$i}.margin)
								
								$Lon_width:=$Lon_tRight-$Lon_tLeft
								
								$Lon_tLeft:=$Lon_rRight-$Lon_width+$Lon_margin
								$Lon_tRight:=$Lon_tLeft+$Lon_width
								
								OBJECT SET COORDINATES:C1248(*;$Txt_widget;$Lon_tLeft;$Lon_tTop;$Lon_tRight;$Lon_tBottom)
								
								$Lon_rRight:=$Lon_tLeft-$Lon_width-$Lon_margin
								
								OBJECT SET COORDINATES:C1248(*;$tObj_rules{$i}.reference;$Lon_rLeft;$Lon_rTop;$Lon_rRight;$Lon_rBottom)
								
							End if 
							
							  //______________________________________________________
						: ($Txt_constraint="tile")  // Set width as percent of the reference
							
							  // Calculate proportional width
							$Lon_width:=Int:C8(($Lon_rRight-$Lon_rLeft)*Num:C11($tObj_rules{$i}.value))
							
							If ($tObj_rules{$i}.parent#Null:C1517)
								
								  // Left is the parent right
								OBJECT GET COORDINATES:C663(*;$tObj_rules{$i}.parent;$Lon_rLeft;$Lon_rTop;$Lon_rRight;$Lon_rBottom)
								$Lon_tLeft:=$Lon_rRight+Num:C11(OBJECT Get type:C1300(*;$Txt_widget+".border")#Object type unknown:K79:1)
								
							End if 
							
							$Lon_tRight:=$Lon_tLeft+$Lon_width
							
							OBJECT SET COORDINATES:C1248(*;$Txt_widget;$Lon_tLeft;$Lon_tTop;$Lon_tRight;$Lon_tBottom)
							
							  //______________________________________________________
						: ($Txt_constraint="float")
							
							  // Get the margin value if any
							$Lon_margin:=Num:C11($tObj_rules{$i}.margin)
							
							Case of 
									
									  //……………………………………………………………………………………………
								: ($tObj_rules{$i}.value="left")
									
									$Lon_width:=$Lon_tRight-$Lon_tLeft
									
									If ($tObj_rules{$i}.reference#Null:C1517)
										
										  // Right is the reference left
										$Lon_tRight:=$Lon_rLeft-$Lon_margin
										
									Else 
										
										  // Align to right of the viewport
										$Lon_tRight:=$Lon_rRight
										
									End if 
									
									$Lon_maximum:=Num:C11($tObj_rules{$i}.maximum)
									
									If ($Lon_maximum#0)
										
										$Lon_tRight:=Choose:C955($Lon_tRight>$Lon_maximum;$Lon_maximum;$Lon_tRight)
										
									End if 
									
									$Lon_tLeft:=$Lon_tRight-$Lon_width
									
									OBJECT SET COORDINATES:C1248(*;$Txt_widget;$Lon_tLeft;$Lon_tTop;$Lon_tRight;$Lon_tBottom)
									
									  // Move the associated label if any
									If (OBJECT Get type:C1300(*;$Txt_widget+".label")#Object type unknown:K79:1)
										
										  // Object becomes reference
										OBJECT GET COORDINATES:C663(*;$Txt_widget;$Lon_rLeft;$Lon_rTop;$Lon_rRight;$Lon_rBottom)
										
										OBJECT GET COORDINATES:C663(*;$Txt_widget+".label";$Lon_tLeft;$Lon_tTop;$Lon_tRight;$Lon_tBottom)
										
										$Lon_width:=$Lon_tRight-$Lon_tLeft
										$Lon_tRight:=$Lon_rLeft-$kLon_margin
										$Lon_tLeft:=$Lon_tRight-$Lon_width
										
										OBJECT SET COORDINATES:C1248(*;$Txt_widget+".label";$Lon_tLeft;$Lon_tTop;$Lon_tRight;$Lon_tBottom)
										
									End if 
									
									  //……………………………………………………………………………………………
								Else 
									
									ASSERT:C1129(dev_Matrix ;"Unknown value:"+String:C10($tObj_rules{$i}.value))
									
									  //……………………………………………………………………………………………
							End case 
							
							  //______________________________________________________
						: ($Txt_constraint="right hook")
							
							$Lon_rRight:=$Lon_rRight+Num:C11($tObj_rules{$i}.offset)+$kLon_verticalMargin
							
							OBJECT SET COORDINATES:C1248(*;$Txt_widget;$Lon_tLeft;$Lon_tTop;$Lon_rRight;$Lon_tBottom)
							
							  //______________________________________________________
						: ($Txt_constraint="horizontal alignment")
							
							  // Get the margin value if any
							$Lon_margin:=Num:C11($tObj_rules{$i}.margin)
							
							Case of 
									
									  //……………………………………………………………………………………………
								: ($tObj_rules{$i}.value="center")  // Keep objects vertically centered
									
									  // Calculate middle reference
									$Lon_rCenter:=(($Lon_rRight-$Lon_rLeft)/2)+$Lon_rLeft
									$Lon_tCenter:=(($Lon_tRight-$Lon_tLeft)/2)+$Lon_tLeft
									
									$Lon_offset:=$Lon_rCenter-$Lon_tCenter
									OBJECT MOVE:C664(*;$Txt_widget;$Lon_offset;0)
									
									  //……………………………………………………………………………………………
								: ($tObj_rules{$i}.value="left")  // Keep objects left aligned
									
									$Lon_width:=$Lon_tRight-$Lon_tLeft
									
									$Lon_tLeft:=$Lon_rLeft+$Lon_margin
									$Lon_tRight:=$Lon_tLeft+$Lon_width
									
									OBJECT SET COORDINATES:C1248(*;$Txt_widget;$Lon_tLeft;$Lon_tTop;$Lon_tRight;$Lon_tBottom)
									
									  //……………………………………………………………………………………………
								: ($tObj_rules{$i}.value="right")  // Keep objects right aligned
									
									$Lon_width:=$Lon_tRight-$Lon_tLeft
									
									$Lon_tRight:=$Lon_rRight-$Lon_margin
									$Lon_tLeft:=$Lon_tRight-$Lon_width
									
									OBJECT SET COORDINATES:C1248(*;$Txt_widget;$Lon_tLeft;$Lon_tTop;$Lon_tRight;$Lon_tBottom)
									
									  //……………………………………………………………………………………………
								Else 
									
									ASSERT:C1129(dev_Matrix ;"Unknown value:"+String:C10($tObj_rules{$i}.value))
									
									  //……………………………………………………………………………………………
							End case 
							
							  //______________________________________________________
						Else 
							
							ASSERT:C1129(dev_Matrix ;"Unknown constraint:"+String:C10($tObj_rules{$i}.type))
							
							  //______________________________________________________
					End case 
					
				Else 
					
					ASSERT:C1129(dev_Matrix ;"Unknown constraint:"+String:C10($tObj_rules{$i}.object))
					
				End if 
				
				  // Adjust the border if any
				If (OBJECT Get type:C1300(*;$Txt_widget+".border")#Object type unknown:K79:1)
					
					$Lon_tLeft:=$Lon_tLeft-1
					$Lon_tTop:=$Lon_tTop-1
					$Lon_tRight:=$Lon_tRight+1
					$Lon_tBottom:=$Lon_tBottom+1
					
					OBJECT SET COORDINATES:C1248(*;$Txt_widget+".border";$Lon_tLeft;$Lon_tTop;$Lon_tRight;$Lon_tBottom)
					
				End if 
				
				  //========================================================
		End case 
	End for 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End