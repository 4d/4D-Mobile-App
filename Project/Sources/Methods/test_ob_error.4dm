//%attributes = {"preemptive":"capable"}
C_TEXT:C284($Txt_buffer)
C_OBJECT:C1216($Obj_out)

err_TRY

$Obj_out:=New object:C1471(\
)

ob_error_add($Obj_out; "A textual error")
ASSERT:C1129($Obj_out.errors[0]="A textual error")

$Obj_out.errors.push(New object:C1471(\
"message"; "an object error with a message"; \
"errorCode"; 404))

ob_error_add($Obj_out; "A textual error2")
ASSERT:C1129($Obj_out.errors[2]="A textual error2")

$Obj_out.errors.push(New object:C1471(\
"text"; "an object error without a message"; \
"errorCode"; 404))

$Txt_buffer:=ob_error_string($Obj_out)
ASSERT:C1129(Length:C16($Txt_buffer)>0; "No text")

ASSERT:C1129(Position:C15("A textual error"; $Txt_buffer)=1; "No first error message")
ASSERT:C1129(Position:C15("an object error with a message"; $Txt_buffer)>0; "Missing error message 1")
ASSERT:C1129(Position:C15("an object error without a message"; $Txt_buffer)>0; "Missing error message 2")
ASSERT:C1129(Position:C15("A textual error2"; $Txt_buffer)>0; "Missing error message 3")

ASSERT:C1129($Txt_buffer[[Length:C16($Txt_buffer)]]#"\n"; "must not have separator at the end of error string")

err_FINALLY