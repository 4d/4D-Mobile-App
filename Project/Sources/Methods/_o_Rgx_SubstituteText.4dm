//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Method : Rgx_SubstituteText
// Created 28/09/07 by Vincent
// ----------------------------------------------------
// Description
// Alias "QF_RESubstituteText"
// ----------------------------------------------------
// Paramètres
//$1 = Regular expression
//$2 = Replacement text
//$3 = Target text
//$4 = Regular expression flags
//$0 = Error result
// ----------------------------------------------------
C_LONGINT:C283($0)
C_TEXT:C284($1)
C_TEXT:C284($2)
C_POINTER:C301($3)
C_LONGINT:C283($4)

C_BOOLEAN:C305($Boo_OK)
C_LONGINT:C283($Lon_i; $Lon_Index; $Lon_options; $Lon_parameters; $Lon_Size; $Lon_Start)
C_POINTER:C301($Ptr_target)
C_TEXT:C284($Txt_Buffer; $Txt_Error_Method; $Txt_pattern; $Txt_replacement; $Txt_Target)

ARRAY LONGINT:C221($tLon_Lengths; 0)
ARRAY LONGINT:C221($tLon_Positions; 0)
ARRAY LONGINT:C221($tLon_Tempo_Index; 0)

ARRAY LONGINT:C221($tLon_Tempo_Lengths; 100)
ARRAY LONGINT:C221($tLon_Tempo_Positions; 100)
ARRAY TEXT:C222($tTxt_Tempo; 100)

ARRAY LONGINT:C221($tLon_Tempo_Lengths; 0)
ARRAY LONGINT:C221($tLon_Tempo_Positions; 0)
ARRAY TEXT:C222($tTxt_Tempo; 0)

If (False:C215)
	C_LONGINT:C283(_o_Rgx_SubstituteText; $0)
	C_TEXT:C284(_o_Rgx_SubstituteText; $1)
	C_TEXT:C284(_o_Rgx_SubstituteText; $2)
	C_POINTER:C301(_o_Rgx_SubstituteText; $3)
	C_LONGINT:C283(_o_Rgx_SubstituteText; $4)
End if 

$Lon_parameters:=Count parameters:C259

If ($Lon_parameters<3)
	
	_o_rgx_Lon_Error:=-50  //Parameter error
	
Else 
	
	$Txt_pattern:=$1
	
	If ($Lon_parameters>3)
		
		$Lon_options:=$4
		
		$Txt_pattern:=_o_rgx_Options($Lon_options)+$Txt_pattern
		
	End if 
	
	$Txt_replacement:=$2
	$Ptr_target:=$3
	
	$Txt_Target:=$Ptr_target->
	
	_o_rgx_Lon_Error:=0
	
	If (Length:C16($Txt_Target)>0)
		
		$Txt_Error_Method:=Method called on error:C704
		ON ERR CALL:C155("_o_rgx_NO_ERROR")
		
		$Lon_Start:=1
		
		Repeat 
			
			$Boo_OK:=Match regex:C1019($Txt_pattern; $Txt_Target; $Lon_Start; $tLon_Positions; $tLon_Lengths)
			
			If ($Boo_OK)
				
				$Lon_Index:=0
				
				$Lon_Size:=Size of array:C274($tLon_Positions)
				
				For ($Lon_i; 0; $Lon_Size; 1)
					
					$Txt_Buffer:=Substring:C12($Txt_Target; $tLon_Positions{$Lon_i}; $tLon_Lengths{$Lon_i})
					
					If ($tLon_Positions{$Lon_i}>0)
						
						$Lon_Start:=$tLon_Positions{$Lon_i}+$tLon_Lengths{$Lon_i}
						
					End if 
					
					If ($tLon_Lengths{$Lon_i}=0)
						
						$Boo_OK:=($Lon_i>0)
						
						If ($Boo_OK)
							
							$Boo_OK:=($tLon_Positions{$Lon_i}#$tLon_Positions{$Lon_i-1})
							
						End if 
						
					End if 
					
					If ($Boo_OK)
						
						APPEND TO ARRAY:C911($tTxt_Tempo; $Txt_Buffer)
						
						APPEND TO ARRAY:C911($tLon_Tempo_Positions; $tLon_Positions{$Lon_i})
						APPEND TO ARRAY:C911($tLon_Tempo_Lengths; $tLon_Lengths{$Lon_i})
						APPEND TO ARRAY:C911($tLon_Tempo_Index; $Lon_Index)
						
						$Lon_Index:=$Lon_Index+1
						
					Else 
						
						$Lon_i:=$Lon_Size+1
						
					End if 
					
				End for 
				
			End if 
			
		Until (Not:C34($Boo_OK))
		
		$Lon_Size:=Size of array:C274($tTxt_Tempo)
		
		If ($Lon_Size>0)
			
			$Lon_Index:=$Lon_Size
			
			Repeat 
				
				If ($tLon_Tempo_Index{$Lon_Index}#0)
					
					$Txt_Buffer:="\\"+String:C10($tLon_Tempo_Index{$Lon_Index})
					
					If (Position:C15($Txt_Buffer; $Txt_replacement)>0)
						
						$Txt_replacement:=Replace string:C233($Txt_replacement; $Txt_Buffer; $tTxt_Tempo{$Lon_Index})
						
					End if 
					
				Else 
					
					$Ptr_target->:=Delete string:C232($Ptr_target->; $tLon_Tempo_Positions{$Lon_Index}; $tLon_Tempo_Lengths{$Lon_Index})
					$Ptr_target->:=Insert string:C231($Ptr_target->; $Txt_replacement; $tLon_Tempo_Positions{$Lon_Index})
					$Txt_replacement:=$2
					
				End if 
				
				$Lon_Index:=$Lon_Index-1
				
			Until ($Lon_Index=0)
			
		End if 
		
		ON ERR CALL:C155($Txt_Error_Method)
	End if 
	
End if 

$0:=_o_rgx_Lon_Error

_o_rgx_Lon_Error:=0