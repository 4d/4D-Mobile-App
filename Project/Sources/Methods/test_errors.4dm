//%attributes = {}
C_OBJECT:C1216($o)

COMPONENT_INIT 

TRY 

$o:=errors ("noError")
ASSERT:C1129(Method called on error:C704="noError")

$o.install("xml_NO_ERROR")
ASSERT:C1129(Method called on error:C704="xml_NO_ERROR")

$o.install("CATCH")
ASSERT:C1129(Method called on error:C704="CATCH")

$o.deinstall()
ASSERT:C1129(Method called on error:C704="xml_NO_ERROR")

$o.install("noError")
ASSERT:C1129(Method called on error:C704="noError")

$o.install("xml_NO_ERROR")
ASSERT:C1129(Method called on error:C704="xml_NO_ERROR")

$o.install("CATCH")
ASSERT:C1129(Method called on error:C704="CATCH")

$o.stopCatch()
ASSERT:C1129(Length:C16(Method called on error:C704)=0)

$o.install("noError")
ASSERT:C1129(Method called on error:C704="noError")

$o.install("noError")
ASSERT:C1129(Method called on error:C704="noError")

$o.install("xml_NO_ERROR")
ASSERT:C1129(Method called on error:C704="xml_NO_ERROR")

$o.install("CATCH")
ASSERT:C1129(Method called on error:C704="CATCH")

$o.deinstall()
ASSERT:C1129(Method called on error:C704="xml_NO_ERROR")

$o.deinstall()
ASSERT:C1129(Method called on error:C704="noError")

$o.deinstall()
ASSERT:C1129(Method called on error:C704="noError")

$o.deinstall()
ASSERT:C1129(Length:C16(Method called on error:C704)=0)

$o.deinstall()
ASSERT:C1129(Length:C16(Method called on error:C704)=0)

FINALLY 