var $0 : Integer

var $e : Object

$e:=FORM Event:C1606

Case of 
		
		//______________________________________________________
	: ($e.code=On Begin Drag Over:K2:44)
		
		//Form.$.doBeginDrag()
		
		//______________________________________________________
	: ($e.code=On Drag Over:K2:13)\
		 | ($e.code=On Drop:K2:12)
		
		$0:=Form:C1466.$.doStaticDragAndDrop()
		
		//______________________________________________________
End case 