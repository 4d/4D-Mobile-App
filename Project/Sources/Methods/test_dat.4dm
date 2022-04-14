//%attributes = {}
C_DATE:C307($d; $d2)
C_LONGINT:C283($i; $l)
C_OBJECT:C1216($o)

err_TRY

$d:=Current date:C33(*)

// --------------------------------------
// Initialization
$o:=dat  // Default is today
ASSERT:C1129($o.date=$d)

$o:=dat("today")
ASSERT:C1129($o.date=$d)

$o:=dat("yesterday")
ASSERT:C1129($o.date=($d-1))

$o:=dat("tomorrow")
ASSERT:C1129($o.date=($d+1))

$o:=dat("monday")  // Monday of the current week
ASSERT:C1129(Day number:C114($o.date)=Monday:K10:13)

$o:=dat  // Default is today

// --------------------------------------
// set()
ASSERT:C1129($o.set("today").date=$d)
ASSERT:C1129($o.set("yesterday").date=($d-1))
ASSERT:C1129($o.set("tomorrow").date=($d+1))

ASSERT:C1129(Day number:C114($o.set("monday").date)=Monday:K10:13)
ASSERT:C1129(Day number:C114($o.set("tuesday").date)=Tuesday:K10:14)
ASSERT:C1129(Day number:C114($o.set("wednesday").date)=Wednesday:K10:15)
ASSERT:C1129(Day number:C114($o.set("thursday").date)=Thursday:K10:16)
ASSERT:C1129(Day number:C114($o.set("friday").date)=Friday:K10:17)
ASSERT:C1129(Day number:C114($o.set("saturday").date)=Saturday:K10:18)
ASSERT:C1129(Day number:C114($o.set("sunday").date)=Sunday:K10:19)

ASSERT:C1129($o.set($d).date=$d)
ASSERT:C1129($o.set(!1958-08-08!).date=!1958-08-08!)

// --------------------------------------
// weekNumber()
ASSERT:C1129(dat(String:C10(!2020-01-01!)).weekNumber()=1)
ASSERT:C1129(dat(String:C10(!2017-01-01!)).weekNumber()=52)
ASSERT:C1129(dat.weekNumber(!2020-01-01!)=1)
ASSERT:C1129(dat.weekNumber(!2017-01-01!)=52)

For ($i; 1900; 2050; 1)
	
	$l:=$o.set(Add to date:C393(!00-00-00!; $i; 1; 1)).weekNumber()
	ASSERT:C1129($l>=1)
	ASSERT:C1129($l<=53)
	
End for 

ASSERT:C1129($o.set(!1997-12-30!).weekNumber()=1)

// --------------------------------------
// week()
$o:=$o.set(!2020-01-01!)

$d2:=!2019-12-30!

For ($i; 1; 53; 1)
	
	$d2:=$d2+(7*Num:C11($i>1))
	ASSERT:C1129($o.week($i)=$d2)
	
End for 

// --------------------------------------
// startMonth()
ASSERT:C1129($o.startMonth(!1958-08-08!)=!1958-08-01!)

// --------------------------------------
// endMonth()
ASSERT:C1129($o.endMonth(!1958-08-08!)=!1958-08-31!)
ASSERT:C1129($o.endMonth(!1958-02-01!)=!1958-02-28!)
ASSERT:C1129($o.endMonth(!1960-02-01!)=!1960-02-29!)

// --------------------------------------
// daysInMonth()
ASSERT:C1129($o.daysInMonth(!2020-01-01!)=31)

ASSERT:C1129($o.set("january").daysInMonth()=31)

ASSERT:C1129($o.daysInMonth(!2019-02-01!)=28)
ASSERT:C1129($o.daysInMonth(!2020-02-01!)=29)
ASSERT:C1129($o.daysInMonth(!2021-02-01!)=28)
ASSERT:C1129($o.daysInMonth(!2022-02-01!)=28)
ASSERT:C1129($o.daysInMonth(!2023-02-01!)=28)
ASSERT:C1129($o.daysInMonth(!2024-02-01!)=29)

ASSERT:C1129($o.set("march").daysInMonth()=31)
ASSERT:C1129($o.set("april").daysInMonth()=30)
ASSERT:C1129($o.set("may").daysInMonth()=31)
ASSERT:C1129($o.set("june").daysInMonth()=30)
ASSERT:C1129($o.set("july").daysInMonth()=31)
ASSERT:C1129($o.set("august").daysInMonth()=31)
ASSERT:C1129($o.set("september").daysInMonth()=30)
ASSERT:C1129($o.set("october").daysInMonth()=31)
ASSERT:C1129($o.set("november").daysInMonth()=30)
ASSERT:C1129($o.set("december").daysInMonth()=31)

// --------------------------------------
// bissextile() & alias leap()

ASSERT:C1129($o.set(!1600-01-01!).bissextile())
ASSERT:C1129(Not:C34($o.set(!1700-01-01!).bissextile()))
ASSERT:C1129(Not:C34($o.set(!1800-01-01!).bissextile()))
ASSERT:C1129(Not:C34($o.set(!1900-01-01!).bissextile()))
ASSERT:C1129($o.set(!2000-01-01!).bissextile())
ASSERT:C1129(Not:C34($o.set(!2100-01-01!).bissextile()))
ASSERT:C1129(Not:C34($o.set(!2200-01-01!).bissextile()))
ASSERT:C1129(Not:C34($o.set(!2300-01-01!).bissextile()))

ASSERT:C1129($o.set(!2008-01-01!).bissextile())
ASSERT:C1129($o.set(!2020-01-01!).bissextile())

ASSERT:C1129($o.set(!2000-01-01!).leap())
ASSERT:C1129(Not:C34($o.set(!1900-01-01!).leap()))

// --------------------------------------
// monday() -> sunday()
For ($i; 1; 5; 1)
	
	$o:=$o.set(Add to date:C393(!00-00-00!; 2020; 1; $i))
	
	ASSERT:C1129($o.monday()=!2019-12-30!)
	ASSERT:C1129($o.tuesday()=!2019-12-31!)
	ASSERT:C1129($o.wednesday()=!2020-01-01!)
	ASSERT:C1129($o.thursday()=!2020-01-02!)
	ASSERT:C1129($o.friday()=!2020-01-03!)
	ASSERT:C1129($o.saturday()=!2020-01-04!)
	ASSERT:C1129($o.sunday()=!2020-01-05!)
	
End for 

For ($i; $i; 12; 1)
	
	$o:=$o.set(Add to date:C393(!00-00-00!; 2020; 1; $i))
	
	ASSERT:C1129($o.monday()=!2020-01-06!)
	ASSERT:C1129($o.tuesday()=!2020-01-07!)
	ASSERT:C1129($o.wednesday()=!2020-01-08!)
	ASSERT:C1129($o.thursday()=!2020-01-09!)
	ASSERT:C1129($o.friday()=!2020-01-10!)
	ASSERT:C1129($o.saturday()=!2020-01-11!)
	ASSERT:C1129($o.sunday()=!2020-01-12!)
	
End for 

// --------------------------------------
// easter() & alias paque()
ASSERT:C1129($o.easter(!1583-01-01!)=!1583-04-10!)
ASSERT:C1129($o.easter(!2008-01-01!)=!2008-03-23!)
ASSERT:C1129($o.easter(!2401-01-01!)=!2401-04-01!)
ASSERT:C1129($o.easter(!3170-01-01!)=!3170-03-29!)

ASSERT:C1129($o.paque(!1583-01-01!)=!1583-04-10!)
ASSERT:C1129($o.paque(!2008-01-01!)=!2008-03-23!)
ASSERT:C1129($o.paque(!2401-01-01!)=!2401-04-01!)
ASSERT:C1129($o.paque(!3170-01-01!)=!3170-03-29!)

// --------------------------------------
//             TIPS & TRICKS
// --------------------------------------

// First day of the current month
$d:=dat.startMonth()

// Today's week number
$l:=dat.weekNumber()

// Don't miss my next birthday!
$d:=dat.set(!1958-08-08!).anniversary()

// Monday of the current week
$d:=dat.monday()

// Next Christmas date
$o:=dat("christmas")

// Next New year date
$o:=dat("newYear")

err_FINALLY