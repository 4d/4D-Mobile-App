var $id : Integer

$id:=OBJECT Get value:C1743(OBJECT Get name:C1087(Object current:K67:2)).index

If ($id>0)
	
	Form:C1466.main:=Form:C1466.color.setColorIndexed($id).main
	SET TIMER:C645(-1)
	
End if 