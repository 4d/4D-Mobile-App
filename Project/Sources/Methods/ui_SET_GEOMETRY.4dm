//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : ui_SET_GEOMETRY
// ID[A01333ED1D654898BA99B7DCB0439E6A]
// Created 15-5-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($1)

C_BOOLEAN:C305($b)
C_LONGINT:C283($bottom; $bottomRef; $bottomTarget; $height; $l; $left)
C_LONGINT:C283($leftRef; $leftTarget; $marginH; $marginV; $max; $middleRef)
C_LONGINT:C283($middleTarget; $offset; $right; $rightRef; $rightTarget; $top)
C_LONGINT:C283($topRef; $topTarget; $type; $width; $widthScrollBar)
C_TEXT:C284($t; $Txt_widget)
C_OBJECT:C1216($o; $Obj_constraints)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(ui_SET_GEOMETRY; $1)
End if 

// ----------------------------------------------------
// Initialisations

// NO PARAMETERS REQUIRED

// Optional parameters
If (Count parameters:C259>=1)
	
	$Obj_constraints:=$1
	
Else 
	
	$t:=Current form name:C1298
	
	Case of 
			
			//______________________________________________________
		: (Form:C1466.$dialog[$t].constraints#Null:C1517)
			
			$Obj_constraints:=Form:C1466.$dialog[$t].constraints
			
			//______________________________________________________
		Else 
			
			// ASSERT(Structure file#Structure file(*))
			
			//______________________________________________________
	End case 
End if 

$widthScrollBar:=15
$marginV:=2
$marginH:=14

// ----------------------------------------------------
If (Not:C34(Is nil pointer:C315(OBJECT Get pointer:C1124(Object subform container:K67:4))))
	
	// Place the background & the bottom line {
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
	OBJECT SET COORDINATES:C1248(*; "bottom.line"; 16; $height-1; $width-16; $height-1)
	OBJECT GET COORDINATES:C663(*; "viewport"; $left; $top; $right; $bottom)
	OBJECT SET COORDINATES:C1248(*; "viewport"; $left; 0; $width-$widthScrollBar; $height)
	//}
	
End if 

// Position the local viewport if any
If (OBJECT Get type:C1300(*; "_viewport")#Object type unknown:K79:1)
	
	OBJECT GET COORDINATES:C663(*; "viewport"; $l; $l; $right; $l)
	OBJECT GET COORDINATES:C663(*; "_viewport"; $left; $top; $l; $bottom)
	OBJECT SET COORDINATES:C1248(*; "_viewport"; $left; $top; $right; $bottom)
	
End if 

// ----------------------------------------------------
// Handle the constraints
If ($Obj_constraints.rules#Null:C1517)
	
	For each ($o; $Obj_constraints.rules)
		
		Case of 
				
				//========================================================
			: ($o.formula#Null:C1517)
				
				$o.formula.call()
				
				//========================================================
			: ($o.method#Null:C1517)
				
				If ($o.param#Null:C1517)
					
					EXECUTE METHOD:C1007($o.method; *; $o.param)
					
				Else 
					
					EXECUTE METHOD:C1007($o.method)
					
				End if 
				
				//========================================================
			Else 
				
				Case of 
						
						//______________________________________________________
					: (Value type:C1509($o.object)=Is text:K8:3)
						
						$c:=New collection:C1472($o.object)
						
						//______________________________________________________
					: (Value type:C1509($o.object)=Is collection:K8:32)
						
						$c:=$o.object
						
						//______________________________________________________
					Else 
						
						// A "Case of" statement should never omit "Else"
						//______________________________________________________
				End case 
				
				For each ($Txt_widget; $c)
					
					$type:=OBJECT Get type:C1300(*; $Txt_widget)
					
					If ($type#Object type unknown:K79:1)
						
						OBJECT GET COORDINATES:C663(*; $Txt_widget; $leftTarget; $topTarget; $rightTarget; $bottomTarget)
						
						If ($o.reference#Null:C1517)
							
							// Reference object
							OBJECT GET COORDINATES:C663(*; $o.reference; $leftRef; $topRef; $rightRef; $bottomRef)
							
						Else 
							
							// Viewport
							OBJECT GET SUBFORM CONTAINER SIZE:C1148($rightRef; $bottomRef)
							$rightRef:=$rightRef-$widthScrollBar
							
						End if 
						
						Case of 
								
								//______________________________________________________
							: ($o.type="width")  // Set width in percent of the reference
								
								$width:=($rightRef-$leftRef)*Num:C11($o.value)+Num:C11($o.offset)
								$rightTarget:=$leftTarget+$width-$marginV
								
								Case of 
										
										//……………………………………………………………………………………………………………
									: ($type=Object type text input:K79:4)
										
										OBJECT GET SCROLLBAR:C1076(*; $Txt_widget; $b; $b)
										
										If ($b)
											
											$rightTarget:=$rightTarget-$widthScrollBar
											
										End if 
										
										//……………………………………………………………………………………………………………
									: ($type=Object type picture input:K79:5)
										
										$rightTarget:=$rightTarget+$marginV
										
										//……………………………………………………………………………………………………………
									: ($type=Object type listbox:K79:8)
										
										$rightTarget:=$rightTarget+$marginV
										
										//……………………………………………………………………………………………………………
									: ($type=Object type rectangle:K79:32)
										
										$rightTarget:=$rightTarget+($marginV*2)
										
										//……………………………………………………………………………………………………………
									: ($type=Object type popup dropdown list:K79:13)
										
										$rightTarget:=$rightTarget+5
										
										//……………………………………………………………………………………………………………
								End case 
								
								// Move the associated help if any
								If (OBJECT Get type:C1300(*; $Txt_widget+".help")#Object type unknown:K79:1)
									
									OBJECT GET COORDINATES:C663(*; $Txt_widget+".help"; $left; $top; $right; $bottom)
									
									$width:=$right-$left
									
									$left:=$rightTarget-$width
									$right:=$rightTarget
									
									OBJECT SET COORDINATES:C1248(*; $Txt_widget+".help"; $left; $top; $right; $bottom)
									
									$rightTarget:=$rightTarget-$width-$marginH
									
								End if 
								
								OBJECT SET COORDINATES:C1248(*; $Txt_widget; $leftTarget; $topTarget; $rightTarget; $bottomTarget)
								
								//______________________________________________________
							: ($o.type="fit-width")
								
								$rightTarget:=$leftTarget+($rightRef-$leftTarget)-Num:C11($o.offset)
								OBJECT SET COORDINATES:C1248(*; $Txt_widget; $leftTarget; $topTarget; $rightTarget; $bottomTarget)
								
								//______________________________________________________
							: ($o.type="maximum-width")  // Maximum object width
								
								If (OBJECT Get type:C1300(*; $Txt_widget+".help")#Object type unknown:K79:1)
									
									OBJECT GET COORDINATES:C663(*; $Txt_widget+".help"; $left; $top; $right; $bottom)
									
									If ($right>$o.value)
										
										$width:=$right-$left
										
										$right:=$o.value
										$left:=$right-$width
										
										OBJECT SET COORDINATES:C1248(*; $Txt_widget+".help"; $left; $top; $right; $bottom)
										
										$rightTarget:=$left-$marginH
										
										OBJECT SET COORDINATES:C1248(*; $Txt_widget; $leftTarget; $topTarget; $rightTarget; $bottomTarget)
										
									End if 
									
								Else 
									
									$width:=$o.value
									
									Case of 
											
											//……………………………………………………………………………………………………………
										: ($type=Object type popup dropdown list:K79:13)
											
											$width:=$width+4
											
											//……………………………………………………………………………………………………………
									End case 
									
									If (($rightTarget-$leftTarget)>$width)
										
										$rightTarget:=$leftTarget+$width
										
										OBJECT SET COORDINATES:C1248(*; $Txt_widget; $leftTarget; $topTarget; $rightTarget; $bottomTarget)
										
									End if 
								End if 
								
								//______________________________________________________
							: ($o.type="minimum-width")  // Minimum object width
								
								If (OBJECT Get type:C1300(*; $Txt_widget+".help")#Object type unknown:K79:1)
									
									OBJECT GET COORDINATES:C663(*; $Txt_widget+".help"; $left; $top; $right; $bottom)
									
									If ($right<$o.value)
										
										$width:=$right-$left
										
										$right:=$o.value
										$left:=$right-$width
										
										OBJECT SET COORDINATES:C1248(*; $Txt_widget+".help"; $left; $top; $right; $bottom)
										
										$rightTarget:=$left-$marginH
										
										OBJECT SET COORDINATES:C1248(*; $Txt_widget; $leftTarget; $topTarget; $rightTarget; $bottomTarget)
										
									End if 
									
								Else 
									
									$width:=$o.value
									
									Case of 
											
											//……………………………………………………………………………………………………………
										: ($type=Object type popup dropdown list:K79:13)
											
											$width:=$width+4
											
											//……………………………………………………………………………………………………………
									End case 
									
									If (($rightTarget-$leftTarget)<$width)
										
										$rightTarget:=$leftTarget+$width
										
										OBJECT SET COORDINATES:C1248(*; $Txt_widget; $leftTarget; $topTarget; $rightTarget; $bottomTarget)
										
									End if 
								End if 
								
								//______________________________________________________
							: ($o.type="margin-auto")
								
								$l:=(($rightRef-$leftRef)-($width))/2
								
								$width:=$rightTarget-$leftTarget
								
								If ($l>0)
									
									$leftTarget:=$leftRef+$l
									$rightTarget:=$leftTarget+$width
									
									OBJECT SET COORDINATES:C1248(*; $Txt_widget; $leftTarget; $topTarget; $rightTarget; $bottomTarget)
									
								End if 
								
								//______________________________________________________
							: ($o.type="margin-right")
								
								$rightTarget:=$leftRef-$o.value
								
								OBJECT SET COORDINATES:C1248(*; $Txt_widget; $leftTarget; $topTarget; $rightTarget; $bottomTarget)
								
								//______________________________________________________
							: ($o.type="margin-left")  // Set the distance to the object on the left
								
								$width:=$rightTarget-$leftTarget
								$leftTarget:=$rightRef+$o.value
								$rightTarget:=$leftTarget+$width
								
								OBJECT SET COORDINATES:C1248(*; $Txt_widget; $leftTarget; $topTarget; $rightTarget; $bottomTarget)
								
								//______________________________________________________
							: ($o.type="inline")
								
								If ($o.reference#Null:C1517)
									
									$width:=$rightTarget-$leftTarget
									
									$leftTarget:=$rightRef-$width+Num:C11($o.margin)
									$rightTarget:=$leftTarget+$width
									
									OBJECT SET COORDINATES:C1248(*; $Txt_widget; $leftTarget; $topTarget; $rightTarget; $bottomTarget)
									
									$rightRef:=$leftTarget-$width-Num:C11($o.margin)
									
									OBJECT SET COORDINATES:C1248(*; $o.reference; $leftRef; $topRef; $rightRef; $bottomRef)
									
								End if 
								
								//______________________________________________________
							: ($o.type="tile")  // Set width as percent of the reference
								
								// Calculate proportional width
								$width:=Int:C8(($rightRef-$leftRef)*Num:C11($o.value))
								
								If ($o.parent#Null:C1517)
									
									// Left is the parent right
									OBJECT GET COORDINATES:C663(*; $o.parent; $leftRef; $topRef; $rightRef; $bottomRef)
									$leftTarget:=$rightRef+Num:C11(OBJECT Get type:C1300(*; $Txt_widget+".border")#Object type unknown:K79:1)
									
								End if 
								
								$rightTarget:=$leftTarget+$width
								
								OBJECT SET COORDINATES:C1248(*; $Txt_widget; $leftTarget; $topTarget; $rightTarget; $bottomTarget)
								
								//______________________________________________________
							: ($o.type="float")
								
								Case of 
										
										//……………………………………………………………………………………………
									: ($o.value="left")
										
										$width:=$rightTarget-$leftTarget
										
										If ($o.reference#Null:C1517)
											
											// Right is the reference left
											$rightTarget:=$leftRef-Num:C11($o.margin)
											
										Else 
											
											// Align to right of the viewport
											$rightTarget:=$rightRef
											
										End if 
										
										$max:=Num:C11($o.maximum)
										
										If ($max#0)
											
											$rightTarget:=Choose:C955($rightTarget>$max; $max; $rightTarget)
											
										End if 
										
										$leftTarget:=$rightTarget-$width
										
										OBJECT SET COORDINATES:C1248(*; $Txt_widget; $leftTarget; $topTarget; $rightTarget; $bottomTarget)
										
										// Move the associated label if any
										If (OBJECT Get type:C1300(*; $Txt_widget+".label")#Object type unknown:K79:1)
											
											// Object becomes reference
											OBJECT GET COORDINATES:C663(*; $Txt_widget; $leftRef; $topRef; $rightRef; $bottomRef)
											
											OBJECT GET COORDINATES:C663(*; $Txt_widget+".label"; $leftTarget; $topTarget; $rightTarget; $bottomTarget)
											
											$width:=$rightTarget-$leftTarget
											$rightTarget:=$leftRef-$marginH
											$leftTarget:=$rightTarget-$width
											
											OBJECT SET COORDINATES:C1248(*; $Txt_widget+".label"; $leftTarget; $topTarget; $rightTarget; $bottomTarget)
											
										End if 
										
										//……………………………………………………………………………………………
									Else 
										
										ASSERT:C1129(dev_Matrix; "Unknown value:"+String:C10($o.value))
										
										//……………………………………………………………………………………………
								End case 
								
								//______________________________________________________
							: ($o.type="right hook")
								
								$rightRef:=$rightRef+Num:C11($o.offset)+$marginV
								
								OBJECT SET COORDINATES:C1248(*; $Txt_widget; $leftTarget; $topTarget; $rightRef; $bottomTarget)
								
								//______________________________________________________
							: ($o.type="horizontal alignment")
								
								Case of 
										
										//……………………………………………………………………………………………
									: ($o.value="center")  // Keep objects vertically centered
										
										// Calculate middle reference
										$middleRef:=(($rightRef-$leftRef)/2)+$leftRef
										$middleTarget:=(($rightTarget-$leftTarget)/2)+$leftTarget
										
										$offset:=$middleRef-$middleTarget
										OBJECT MOVE:C664(*; $Txt_widget; $offset; 0)
										
										//……………………………………………………………………………………………
									: ($o.value="left")  // Keep objects left aligned
										
										$width:=$rightTarget-$leftTarget
										
										$leftTarget:=$leftRef+Num:C11($o.margin)
										$rightTarget:=$leftTarget+$width
										
										OBJECT SET COORDINATES:C1248(*; $Txt_widget; $leftTarget; $topTarget; $rightTarget; $bottomTarget)
										
										//……………………………………………………………………………………………
									: ($o.value="right")  // Keep objects right aligned
										
										$width:=$rightTarget-$leftTarget
										
										$rightTarget:=$rightRef-Num:C11($o.margin)
										$leftTarget:=$rightTarget-$width
										
										OBJECT SET COORDINATES:C1248(*; $Txt_widget; $leftTarget; $topTarget; $rightTarget; $bottomTarget)
										
										//……………………………………………………………………………………………
									Else 
										
										ASSERT:C1129(dev_Matrix; "Unknown value:"+String:C10($o.value))
										
										//……………………………………………………………………………………………
								End case 
								
								//______________________________________________________
							Else 
								
								ASSERT:C1129(dev_Matrix; "Unknown constraint:"+String:C10($o.type))
								
								//______________________________________________________
						End case 
						
					Else 
						
						ASSERT:C1129(dev_Matrix; "Unknown constraint:"+String:C10($Txt_widget))
						
					End if 
					
					// Adjust the border if any
					If (OBJECT Get type:C1300(*; $Txt_widget+".border")#Object type unknown:K79:1)
						
						$leftTarget:=$leftTarget-1
						$topTarget:=$topTarget-1
						$rightTarget:=$rightTarget+1
						$bottomTarget:=$bottomTarget+1
						
						OBJECT SET COORDINATES:C1248(*; $Txt_widget+".border"; $leftTarget; $topTarget; $rightTarget; $bottomTarget)
						
					End if 
				End for each 
				
				//========================================================
		End case 
	End for each 
End if 

// ----------------------------------------------------
// Return
// <NONE>
// ----------------------------------------------------
// End