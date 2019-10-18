//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : environment
  // ID[A7A5542087B347E18B3D00D01B2D17F5]
  // Created 27-6-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_TEXT:C284($t)
C_OBJECT:C1216($o)

If (False:C215)
	C_OBJECT:C1216(environment ;$0)
	C_TEXT:C284(environment ;$1)
	C_OBJECT:C1216(environment ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470.$_is=Null:C1517)
	
	$o:=New object:C1471(\
		"$_is";"environment";\
		"currencySymbol";Null:C1517;\
		"decimalSeparator";Null:C1517;\
		"thousandSeparator";Null:C1517;\
		"dateSeparator";Null:C1517;\
		"dateDayPosition";Null:C1517;\
		"dateMonthPosition";Null:C1517;\
		"dateYearPosition";Null:C1517;\
		"dateLongPattern";Null:C1517;\
		"dateMediumPattern";Null:C1517;\
		"dateShortPattern";Null:C1517;\
		"timeSeparator";Null:C1517;\
		"timeAMLabel";Null:C1517;\
		"timePMLabel";Null:C1517;\
		"timeLongPattern";Null:C1517;\
		"timeMediumPattern";Null:C1517;\
		"timeShortPattern";Null:C1517;\
		"update";Formula:C1597(environment ("update"))\
		)
	
	$o.update()
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="update")
			
			GET SYSTEM FORMAT:C994(Currency symbol:K60:3;$t)
			$o.currencySymbol:=$t
			
			GET SYSTEM FORMAT:C994(Decimal separator:K60:1;$t)
			$o.decimalSeparator:=$t
			
			GET SYSTEM FORMAT:C994(Thousand separator:K60:2;$t)
			$o.thousandSeparator:=$t
			
			GET SYSTEM FORMAT:C994(Date separator:K60:10;$t)
			$o.dateSeparator:=$t
			
			GET SYSTEM FORMAT:C994(Short date day position:K60:12;$t)
			$o.dateDayPosition:=Num:C11($t)
			
			GET SYSTEM FORMAT:C994(Short date month position:K60:13;$t)
			$o.dateMonthPosition:=Num:C11($t)
			
			GET SYSTEM FORMAT:C994(Short date year position:K60:14;$t)
			$o.dateYearPosition:=Num:C11($t)
			
			GET SYSTEM FORMAT:C994(System date long pattern:K60:9;$t)
			$o.dateLongPattern:=$t
			
			GET SYSTEM FORMAT:C994(System date medium pattern:K60:8;$t)
			$o.dateMediumPattern:=$t
			
			GET SYSTEM FORMAT:C994(System date short pattern:K60:7;$t)
			$o.dateShortPattern:=$t
			
			GET SYSTEM FORMAT:C994(Time separator:K60:11;$t)
			$o.timeSeparator:=$t
			
			GET SYSTEM FORMAT:C994(System time AM label:K60:15;$t)
			$o.timeAMLabel:=$t
			
			GET SYSTEM FORMAT:C994(System time PM label:K60:16;$t)
			$o.timePMLabel:=$t
			
			GET SYSTEM FORMAT:C994(System time long pattern:K60:6;$t)
			$o.timeLongPattern:=$t
			
			GET SYSTEM FORMAT:C994(System time medium pattern:K60:5;$t)
			$o.timeMediumPattern:=$t
			
			GET SYSTEM FORMAT:C994(System time short pattern:K60:4;$t)
			$o.timeShortPattern:=$t
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
			
			  //______________________________________________________
	End case 
End if 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End