C_OBJECT:C1216($o)

$o:=(OBJECT Get pointer:C1124(Object named:K67:5;"project"))->

Case of 
		
		  //______________________________________________________
	: (FORM Event:C1606.code=On Load:K2:1)
		
		Self:C308->:=Bool:C1537(featuresFlags.newDataModel)
		
		  //______________________________________________________
	: (FORM Event:C1606.code=On Clicked:K2:4)
		
		OB REMOVE:C1226($o;"dataModel")
		
		featuresFlags.newDataModel:=Bool:C1537(Self:C308->)
		
		CALL WORKER:C1389("4D Mobile ("+String:C10(Current form window:C827)+")";"updateFeaturesFlags";featuresFlags)
		
		  //______________________________________________________
End case 