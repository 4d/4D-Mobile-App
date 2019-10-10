//%attributes = {"invisible":true,"preemptive":"capable"}
ARRAY LONGINT:C221($tLon_codes;0)
ARRAY TEXT:C222($tTxt_components;0)
ARRAY TEXT:C222($tTxt_errors;0)

err:=New object:C1471(\
"error";ERROR;\
"method";ERROR METHOD;\
"line";ERROR LINE;\
"formula";ERROR FORMULA;\
"stack";New collection:C1472)

GET LAST ERROR STACK:C1015($tLon_codes;$tTxt_components;$tTxt_errors)

ARRAY TO COLLECTION:C1563(err.stack;$tLon_codes;"code";$tTxt_components;"component";$tTxt_errors;"error")

