//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : dat
  // ID[3EA8AC3B5F6D488CAF273A90C68E2886]
  // Created 2-1-2020 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_DATE:C307($d;$Dat_1;$Dat_2)
C_LONGINT:C283($l;$l2)
C_TEXT:C284($t)
C_OBJECT:C1216($o;$o1)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(dat ;$0)
	C_TEXT:C284(dat ;$1)
	C_OBJECT:C1216(dat ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)  // Constructor
	
	If (Count parameters:C259>=1)
		
		$t:=$1
		
	End if 
	
	$o:=New object:C1471(\
		"";"dat";\
		"date";Null:C1517;\
		"anniversary";Formula:C1597(dat ("anniversary";New object:C1471("date";$1)).result);\
		"bissextile";Formula:C1597(dat ("bissextile";New object:C1471("date";$1)).result);\
		"daysInMonth";Formula:C1597(dat ("daysInMonth";New object:C1471("date";$1)).result);\
		"daysInYear";Formula:C1597(dat ("daysInYear";New object:C1471("date";$1)).result);\
		"easter";Formula:C1597(dat ("easter";New object:C1471("date";$1)).result);\
		"endMonth";Formula:C1597(dat ("endMonth";New object:C1471("date";$1)).result);\
		"friday";Formula:C1597(dat ("weekDay";New object:C1471("day";"friday";"date";$1)).result);\
		"leap";Formula:C1597(This:C1470.bissextile($1));\
		"monday";Formula:C1597(dat ("weekDay";New object:C1471("day";"monday";"date";$1)).result);\
		"paque";Formula:C1597(This:C1470.easter($1));\
		"saturday";Formula:C1597(dat ("weekDay";New object:C1471("day";"saturday";"date";$1)).result);\
		"set";Formula:C1597(dat ("set";New object:C1471("value";$1)));\
		"startMonth";Formula:C1597(dat ("startMonth";New object:C1471("date";$1)).result);\
		"sunday";Formula:C1597(dat ("weekDay";New object:C1471("day";"sunday";"date";$1)).result);\
		"tuesday";Formula:C1597(dat ("weekDay";New object:C1471("day";"tuesday";"date";$1)).result);\
		"thursday";Formula:C1597(dat ("weekDay";New object:C1471("day";"thursday";"date";$1)).result);\
		"wednesday";Formula:C1597(dat ("weekDay";New object:C1471("day";"wednesday";"date";$1)).result);\
		"week";Formula:C1597(dat ("week";New object:C1471("number";Num:C11($1);"date";$2)).result);\
		"weekNumber";Formula:C1597(dat ("weekNumber";New object:C1471("date";$1)).result)\
		)
	
	$o.set($t)
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="set")
			
			Case of 
					
					  //______________________________________________________
				: (Value type:C1509($2.value)=Is date:K8:7)
					
					$o.date:=$2.value
					
					  //______________________________________________________
				: (Value type:C1509($2.value)=Is text:K8:3)
					
					$d:=Current date:C33(*)
					$l:=Split string:C1554("monday;tuesday;wednesday;thursday;friday;saturday;sunday";";").indexOf($2.value)
					$l2:=Split string:C1554("january;february;march;april;may;june;july;august;september;october;november;december";";").indexOf($2.value)
					
					Case of 
							
							  //………………………………………………………………………………………
						: ($2.value="today")\
							 | (Length:C16($2.value)=0)
							
							$o.date:=$d
							
							  //………………………………………………………………………………………
						: ($2.value="yesterday")
							
							$o.date:=$d-1
							
							  //………………………………………………………………………………………
						: ($2.value="tomorrow")
							
							$o.date:=$d+1
							
							  //………………………………………………………………………………………
						: ($l#-1)
							
							$o.date:=$d-((Day number:C114($d)+5)%7)+$l
							
							  //………………………………………………………………………………………
						: ($l2#-1)
							
							$o.date:=Add to date:C393(!00-00-00!;Year of:C25($d);$l2+1;1)
							
							  //………………………………………………………………………………………
						: ($2.value="christmas")  // Next christmas
							
							$o.date:=Add to date:C393(!00-00-00!;Year of:C25($d);12;25)
							
							If ($o.date<=$d)
								
								$o.date:=Add to date:C393($o.date;1;0;0)
								
							End if 
							
							  //………………………………………………………………………………………
						: ($2.value="newYear")  // Next new year
							
							$o.date:=Add to date:C393(!00-00-00!;Year of:C25($d);1;1)
							
							If ($o.date<=$d)
								
								$o.date:=Add to date:C393($o.date;1;0;0)
								
							End if 
							
							  //………………………………………………………………………………………
						: (Match regex:C1019("(?m-si)^\\d+/\\d+/\\d+$";String:C10($2.value);1))  // Date string
							
							$o.date:=Date:C102(String:C10($2.value))
							
							  //………………………………………………………………………………………
						Else 
							
							ASSERT:C1129(False:C215;"Unknown entry point for set(): \""+String:C10($2.value)+"\"")
							
							  //………………………………………………………………………………………
					End case 
					
					  //______________________________________________________
				Else 
					
					ASSERT:C1129(False:C215;"Wrong parameter type for set()")
					
					  //______________________________________________________
			End case 
			
			  //________________________________________
		Else 
			
			If ($2.date#Null:C1517)
				
				$o.set(String:C10($2.date))
				
			Else 
				
				If ($o.date=Null:C1517)
					
					$o.date:=Current date:C33(*)  // Default is current date
					
				End if 
			End if 
			
			Case of 
					
					  //______________________________________________________
				: ($1="anniversary")  // Returns the next anniversary date
					
					$o.result:=Add to date:C393(!00-00-00!;Year of:C25(Current date:C33(*))+1;Month of:C24($o.date);Day of:C23($o.date))
					
					  //______________________________________________________
				: ($1="bissextile")
					
					$o.result:=((Add to date:C393(!00-00-00!;Year of:C25($o.date);12;31)-Add to date:C393(!00-00-00!;Year of:C25($o.date);1;1)+1)=366)
					
					  //______________________________________________________
				: ($1="daysInMonth")  // Returns the number of days of the month
					
					$o.result:=Day of:C23(Add to date:C393(!00-00-00!;Year of:C25($o.date);Month of:C24($o.date)+1;1)-1)
					
					  //______________________________________________________
				: ($1="daysInYear")  // Returns the number of days of the month
					
					$o.result:=Add to date:C393(!00-00-00!;Year of:C25($o.date);12;31)-Add to date:C393(!00-00-00!;Year of:C25($o.date);1;1)+1
					
					  //______________________________________________________
				: ($1="easter")  // Returns the Easter date of the year
					
					$l:=Year of:C25($o.date)
					
					If (Asserted:C1132(($l>=1583)\
						 & ($l<=4100);"This calculation is only valid for the Gregorian calendar with dates between 1583 and 4100"))
						
						$o1:=New object:C1471(\
							"year";$l)
						
						$o1.a:=$l\100
						$o1.b:=$l%100
						$o1.c:=(3*($o1.a+25))\4
						$o1.d:=(3*($o1.a+25))%4
						$o1.e:=(8*($o1.a+11))\25
						$o1.f:=((5*$o1.a)+$o1.b)%19
						$o1.g:=((19*$o1.f)+$o1.c-$o1.e)%30
						$o1.h:=($o1.f+(11*$o1.g))\319
						$o1.j:=((60*(5-$o1.d))+$o1.b)\4
						$o1.k:=((60*(5-$o1.d))+$o1.b)%4
						$o1.m:=((2*$o1.j)-$o1.k-$o1.g+$o1.h)%7
						$o1.month:=($o1.g-$o1.h+$o1.m+114)\31
						$o1.day:=(($o1.g-$o1.h+$o1.m+114)%31)+1
						
						$o.result:=Add to date:C393(!00-00-00!;$o1.year;$o1.month;$o1.day)
						
					End if 
					
					  //______________________________________________________
				: ($1="endMonth")  // Returns date of the last day of the month
					
					$o.result:=Add to date:C393(!00-00-00!;Year of:C25($o.date);Month of:C24($o.date)+1;1)-1
					
					  //______________________________________________________
				: ($1="startMonth")  // Returns date of the first day of the month
					
					$o.result:=Add to date:C393($o.date;0;0;-Day of:C23($o.date)+1)
					
					  //______________________________________________________
				: ($1="weekDay")  // Returns the date of a day of the week. "Monday" by default
					
					$c:=Split string:C1554("monday;tuesday;wednesday;thursday;friday;saturday;sunday";";")
					
					$o.result:=$o.date-((Day number:C114($o.date)+5)%7)+$c.indexOf(String:C10($2.day))
					
					  //______________________________________________________
				: ($1="week")  // Returns the monday date of a the given week
					
					ASSERT:C1129(($2.number>0) & ($2.number<54))
					
					  // Get January 4 of the year
					$d:=Add to date:C393(!00-00-00!;Year of:C25($o.date);1;4)
					
					  // Monday of the first week
					$Dat_2:=$d-((Day number:C114($d)+5)%7)
					
					$o.result:=Add to date:C393($Dat_2;0;0;($2.number-1)*7)
					
					  //______________________________________________________
				: ($1="weekNumber")  // Returns the week number of the date
					
					  // Get Thursday of the week
					$Dat_1:=Add to date:C393($o.date-((Day number:C114($o.date)+5)%7);0;0;3)
					
					  // Get January 4 of the year
					$d:=Add to date:C393(!00-00-00!;Year of:C25($Dat_1);1;4)
					
					  // Monday of the first week
					$Dat_2:=$d-((Day number:C114($d)+5)%7)
					
					  // Result is upper rounding of the number of days between the two dates divided by 7
					$o.result:=(($Dat_1-$Dat_2)\7)+1
					
					  //______________________________________________________
				Else 
					
					ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
					
					  //______________________________________________________
			End case 
			
			  //________________________________________
	End case 
End if 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End