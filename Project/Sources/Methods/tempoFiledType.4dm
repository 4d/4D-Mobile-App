//%attributes = {}
/*
Long Integer := ***tempoFiledType*** ( Param_1 )
 -> Param_1 (Long Integer)
________________________________________________________

*/
C_LONGINT:C283($0)
C_LONGINT:C283($1)

C_COLLECTION:C1488($Col_types)

If (False:C215)
	C_LONGINT:C283(tempoFiledType ;$0)
	C_LONGINT:C283(tempoFiledType ;$1)
End if 

  // #TEMPORARY REMAPPING FOR THE FIELD TYPE
$Col_types:=New collection:C1472
$Col_types[0]:=10  // text
$Col_types[Is boolean:K8:9]:=1
$Col_types[Is integer:K8:5]:=3
$Col_types[Is longint:K8:6]:=4
$Col_types[Is integer 64 bits:K8:25]:=5
$Col_types[Is real:K8:4]:=6
$Col_types[Is float:K8:26]:=6
$Col_types[Is date:K8:7]:=8
$Col_types[Is time:K8:8]:=9
$Col_types[Is text:K8:3]:=10
$Col_types[Is picture:K8:10]:=12
$Col_types[Is BLOB:K8:12]:=18
$Col_types[Is object:K8:27]:=21

$0:=$Col_types[$1]