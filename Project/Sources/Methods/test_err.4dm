//%attributes = {}
C_OBJECT:C1216($o)

COMPONENT_INIT

err_TRY

$o:=_o_err("NO_ERROR")
ASSERT:C1129(Method called on error:C704="NO_ERROR")

$o.install("_o_xml_NO_ERROR")
ASSERT:C1129(Method called on error:C704="_o_xml_NO_ERROR")

$o.install("err_CATCH")
ASSERT:C1129(Method called on error:C704="err_CATCH")

$o.deinstall()
ASSERT:C1129(Method called on error:C704="_o_xml_NO_ERROR")

$o.install("NO_ERROR")
ASSERT:C1129(Method called on error:C704="NO_ERROR")

$o.install("_o_xml_NO_ERROR")
ASSERT:C1129(Method called on error:C704="_o_xml_NO_ERROR")

$o.install("err_CATCH")
ASSERT:C1129(Method called on error:C704="err_CATCH")

$o.remove()
ASSERT:C1129(Length:C16(Method called on error:C704)=0)

$o.install("NO_ERROR")
ASSERT:C1129(Method called on error:C704="NO_ERROR")

$o.install("NO_ERROR")
ASSERT:C1129(Method called on error:C704="NO_ERROR")

$o.install("_o_xml_NO_ERROR")
ASSERT:C1129(Method called on error:C704="_o_xml_NO_ERROR")

$o.install("err_CATCH")
ASSERT:C1129(Method called on error:C704="err_CATCH")

$o.deinstall()
ASSERT:C1129(Method called on error:C704="_o_xml_NO_ERROR")

$o.deinstall()
ASSERT:C1129(Method called on error:C704="NO_ERROR")

$o.deinstall()
ASSERT:C1129(Method called on error:C704="NO_ERROR")

$o.deinstall()
ASSERT:C1129(Length:C16(Method called on error:C704)=0)

$o.deinstall()
ASSERT:C1129(Length:C16(Method called on error:C704)=0)

$o.capture()
ASSERT:C1129(Method called on error:C704="err_CAPTURE")

C_TEXT:C284($t)
$t:=$o.$

ASSERT:C1129($o.lastError()#Null:C1517)

$o.release()
ASSERT:C1129(Length:C16(Method called on error:C704)=0)

$o.hide()
ASSERT:C1129(Method called on error:C704="err_HIDE")

$o.show()
ASSERT:C1129(Length:C16(Method called on error:C704)=0)

$o.install("_o_xml_NO_ERROR")
ASSERT:C1129(Method called on error:C704="_o_xml_NO_ERROR")

$o.hide()
ASSERT:C1129(Method called on error:C704="err_HIDE")

$o.reset()

C_TEXT:C284($t)
$t:=$o.$

$o.show()
ASSERT:C1129(Method called on error:C704="_o_xml_NO_ERROR")

$o.deinstall()
ASSERT:C1129(Length:C16(Method called on error:C704)=0)

err_FINALLY
