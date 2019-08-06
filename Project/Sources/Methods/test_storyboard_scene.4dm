//%attributes = {"invisible":true,"preemptive":"capable"}

TRY 

C_OBJECT:C1216($Obj_in;$Obj_out)
C_COLLECTION:C1488($Col_ids)

C_TEXT:C284($Txt_buffer)
$Txt_buffer:=""


  // Get a dom for a scene
$Obj_in:=New object:C1471("action";"scene")
$Obj_out:=storyboard ($Obj_in)

ASSERT:C1129($Obj_out.success;JSON Stringify:C1217($Obj_out))

If ($Obj_out.success)
	
	DOM EXPORT TO VAR:C863($Obj_out.dom;$Txt_buffer)
	ASSERT:C1129(Length:C16($Txt_buffer)>0)
	
	DOM CLOSE XML:C722($Obj_out.dom)
End if 

  // Get a dom for a scene with tag already replaced
$Col_ids:=storyboard (New object:C1471("action";"randomIds";"length";3)).value
$Obj_in:=New object:C1471("action";"scene";"tags";New object:C1471("name";"AListForm";"tagInterfix";"SN";"storyboardIDs";$Col_ids))
$Obj_out:=storyboard ($Obj_in)


ASSERT:C1129($Obj_out.success;JSON Stringify:C1217($Obj_out))

If ($Obj_out.success)
	
	DOM EXPORT TO VAR:C863($Obj_out.dom;$Txt_buffer)
	ASSERT:C1129(Length:C16($Txt_buffer)>0)
	
	ASSERT:C1129(Position:C15("AListForm";$Txt_buffer)>0)
	ASSERT:C1129(Position:C15("TAG-SN";$Txt_buffer)=0)
	
	DOM CLOSE XML:C722($Obj_out.dom)
End if 

FINALLY 