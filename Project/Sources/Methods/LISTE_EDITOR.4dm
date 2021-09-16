//%attributes = {}
var $e; $ƒ : Object

$e:=FORM Event:C1606

$ƒ:=Form:C1466.$

If ($ƒ=Null:C1517)
	
	// Instantiation of the dialog class
	Form:C1466.$:=cs:C1710.LIST_EDITOR.new()
	$ƒ:=Form:C1466.$
	
End if 

If ($e.objectName=Null:C1517)  // <== FORM METHOD
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Load:K2:1)
			
			// Select the format radio button
			$ƒ[Form:C1466.format].setValue(True:C214)
			
			$ƒ.static.setValue(Form:C1466.choiceList.dataSource=Null:C1517)
			
			If (Bool:C1537($ƒ.static.getValue()))
				
				Case of 
						
						//______________________________________________________
					: (Not:C34(OB Is empty:C1297(Form:C1466.choiceList)))
						
						// <NOTHING MORE TO DO>
						
						//______________________________________________________
					: ((Form:C1466.type="bool")\
						 | (Form:C1466.type="boolean"))
						
						Form:C1466.choiceList:=New object:C1471(\
							"0"; "False"; \
							"1"; "True")
						
						//________________________________________
					: ((Form:C1466.type="number")\
						 | (Form:C1466.type="integer")\
						 | (Form:C1466.type="real"))
						
						Form:C1466.choiceList:=New object:C1471(\
							"0"; "zero"; \
							"1"; "one"; \
							"2"; "two")
						
						//________________________________________
					: ((Form:C1466.type="string")\
						 | (Form:C1466.type="text"))
						
						Form:C1466.choiceList:=New object:C1471(\
							"value1"; "Displayed value1"; \
							"value2"; "Displayed value2")
						
						//______________________________________________________
					Else 
						
						// A "Case of" statement should never omit "Else"
						//______________________________________________________
				End case 
				
				Form:C1466._choiceList:=OB Entries:C1720(Form:C1466.choiceList)
				
				$ƒ.label.setValue(Form:C1466.binding=Null:C1517)
				
			Else 
				
			End if 
			
			$ƒ.name.focus()
			
			SET TIMER:C645(-1)
			
			//______________________________________________________
		: ($e.code=On Timer:K2:25)
			
			SET TIMER:C645(0)
			
			$ƒ.choiceListGroup.show($ƒ.static.getValue())
			
			//______________________________________________________
	End case 
	
Else   // <== WIDGETS METHOD
	
	Case of 
			
			//==============================================
		: ($ƒ.static.catch())\
			 | ($ƒ.datasource.catch())
			
			$ƒ.refresh()
			
			//==============================================
	End case 
End if 