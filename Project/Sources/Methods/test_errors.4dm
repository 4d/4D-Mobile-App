//%attributes = {}
C_OBJECT:C1216($o)

COMPONENT_INIT 

TRY 

$o:=err ("NO_ERROR")
ASSERT:C1129(Method called on error:C704="NO_ERROR")

$o.install("xml_NO_ERROR")
ASSERT:C1129(Method called on error:C704="xml_NO_ERROR")

$o.install("CATCH")
ASSERT:C1129(Method called on error:C704="CATCH")

$o.deinstall()
ASSERT:C1129(Method called on error:C704="xml_NO_ERROR")

$o.install("NO_ERROR")
ASSERT:C1129(Method called on error:C704="NO_ERROR")

$o.install("xml_NO_ERROR")
ASSERT:C1129(Method called on error:C704="xml_NO_ERROR")

$o.install("CATCH")
ASSERT:C1129(Method called on error:C704="CATCH")

$o.remove()
ASSERT:C1129(Length:C16(Method called on error:C704)=0)

$o.install("NO_ERROR")
ASSERT:C1129(Method called on error:C704="NO_ERROR")

$o.install("NO_ERROR")
ASSERT:C1129(Method called on error:C704="NO_ERROR")

$o.install("xml_NO_ERROR")
ASSERT:C1129(Method called on error:C704="xml_NO_ERROR")

$o.install("CATCH")
ASSERT:C1129(Method called on error:C704="CATCH")

$o.deinstall()
ASSERT:C1129(Method called on error:C704="xml_NO_ERROR")

$o.deinstall()
ASSERT:C1129(Method called on error:C704="NO_ERROR")

$o.deinstall()
ASSERT:C1129(Method called on error:C704="NO_ERROR")

$o.deinstall()
ASSERT:C1129(Length:C16(Method called on error:C704)=0)

$o.deinstall()
ASSERT:C1129(Length:C16(Method called on error:C704)=0)

$o.capture()
ASSERT:C1129(Method called on error:C704="errors_CAPTURE")

C_TEXT:C284($t)
$t:=$o.$

ASSERT:C1129($o.lastError()#Null:C1517)

$o.release()
ASSERT:C1129(Length:C16(Method called on error:C704)=0)

$o.hide()
ASSERT:C1129(Method called on error:C704="errors_HIDE")

$o.show()
ASSERT:C1129(Length:C16(Method called on error:C704)=0)

$o.install("xml_NO_ERROR")
ASSERT:C1129(Method called on error:C704="xml_NO_ERROR")

$o.hide()
ASSERT:C1129(Method called on error:C704="errors_HIDE")

$o.reset()

C_TEXT:C284($t)
$t:=$o.$

$o.show()
ASSERT:C1129(Method called on error:C704="xml_NO_ERROR")

$o.deinstall()
ASSERT:C1129(Length:C16(Method called on error:C704)=0)

FINALLY 

If (Structure file:C489=Structure file:C489(*))
	
	ALERT:C41("Done")
	
End if 