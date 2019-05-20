//%attributes = {}
C_LONGINT:C283($Lon_end;$Lon_start)
C_TEXT:C284($Txt_message)
C_OBJECT:C1216($Obj_buffer;$Obj_test)
C_COLLECTION:C1488($Col_bench)

$Col_bench:=New collection:C1472

$Lon_start:=Milliseconds:C459
$Obj_buffer:=doc_Folder (Get 4D folder:C485(Current resources folder:K5:16;*);New object:C1471(\
"writable";True:C214;\
"properties";True:C214))
$Lon_end:=Milliseconds:C459

$Col_bench.push(New object:C1471(\
"name";"writable/propertie/no depth";\
"start";$Lon_start;\
"end";$Lon_end;\
"duration";String:C10($Lon_end-$Lon_start)))

$Lon_start:=Milliseconds:C459
$Obj_buffer:=doc_Folder (Get 4D folder:C485(Current resources folder:K5:16;*);New object:C1471(\
"writable";True:C214;\
"properties";True:C214;\
"depth";1))
$Lon_end:=Milliseconds:C459

$Col_bench.push(New object:C1471(\
"name";"writable/properties/depth = 1";\
"start";$Lon_start;\
"end";$Lon_end;\
"duration";String:C10($Lon_end-$Lon_start)))

$Lon_start:=Milliseconds:C459
$Obj_buffer:=doc_Folder (Get 4D folder:C485(Current resources folder:K5:16;*))
$Lon_end:=Milliseconds:C459

$Col_bench.push(New object:C1471(\
"name";"no depth";\
"start";$Lon_start;\
"end";$Lon_end;\
"duration";String:C10($Lon_end-$Lon_start)))

$Lon_start:=Milliseconds:C459
$Obj_buffer:=doc_Folder (Get 4D folder:C485(Current resources folder:K5:16;*);New object:C1471(\
"depth";1))
$Lon_end:=Milliseconds:C459

$Col_bench.push(New object:C1471(\
"name";"depth = 1";\
"start";$Lon_start;\
"end";$Lon_end;\
"duration";String:C10($Lon_end-$Lon_start)))

$Txt_message:=Choose:C955(Is compiled mode:C492;"COMPILED";"INTERPRETED")

For each ($Obj_test;$Col_bench)
	
	$Txt_message:=$Txt_message+"\r - ("+$Obj_test.duration+") "+$Obj_test.name
	
End for each 

ALERT:C41($Txt_message)