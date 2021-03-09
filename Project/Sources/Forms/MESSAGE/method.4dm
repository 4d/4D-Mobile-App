// ----------------------------------------------------
// Form method : MESSAGE - (4D Mobile Express)
// ID[F362D3E200984FF7AFD3F7FD4B4311BC]
// Created 30-6-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $key : Text
var $bottom; $height; $left; $right; $top; $vOffset; $width : Integer
var $e : Object
var $c : Collection
var $str : cs:C1710.str

// ----------------------------------------------------
// Initialisations
$e:=FORM Event:C1606

// ----------------------------------------------------

Case of 
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($e.code=On Unload:K2:2)
		
		//
		
		//______________________________________________________
	: ($e.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		//______________________________________________________
	: ($e.code=On Bound Variable Change:K2:52)
		
		If (Form:C1466.ƒ=Null:C1517)
			
			Form:C1466.ƒ:=New object:C1471
			Form:C1466.ƒ.progress:=cs:C1710.thermometer.new("progress").asynchronous()
			Form:C1466.ƒ.cancel:=cs:C1710.button.new("cancel")
			Form:C1466.ƒ.ok:=cs:C1710.button.new("ok")
			Form:C1466.ƒ.title:=cs:C1710.widget.new("title")
			Form:C1466.ƒ.additional:=cs:C1710.scrollable.new("additional")
			Form:C1466.ƒ.option:=cs:C1710.button.new("option")
			Form:C1466.ƒ.help:=cs:C1710.button.new("help")
			
			Form:C1466.ƒ.buttonGroup:=cs:C1710.group.new(Form:C1466.ƒ.ok; Form:C1466.ƒ.cancel)
			
		End if 
		
		// Reset
		Form:C1466.ƒ.progress.hide().stop()
		Form:C1466.ƒ.cancel.setTitle("cancel").hide()
		Form:C1466.ƒ.ok.setTitle("ok").hide()
		Form:C1466.ƒ.title.setValue("")
		Form:C1466.ƒ.additional.setScrollbars(False:C215; False:C215).setValue("")
		Form:C1466.ƒ.option.hide()
		Form:C1466.ƒ.help.hide()
		
		$str:=cs:C1710.str.new()
		
		For each ($key; Form:C1466)
			
			Case of 
					
					//……………………………………………………………………………………………………………………
				: ($key="title")
					
					If (Value type:C1509(Form:C1466.title)=Is collection:K8:32)
						
						$c:=Form:C1466.title.copy()
						Form:C1466.ƒ.title.setValue($str.setText($c.shift()).localized($c))
						
					Else 
						
						Form:C1466.ƒ.title.setValue($str.setText(Form:C1466.title).localized())
						
					End if 
					
					//……………………………………………………………………………………………………………………
				: ($key="additional")
					
					If (Value type:C1509(Form:C1466.additional)=Is collection:K8:32)
						
						$c:=Form:C1466.additional.copy()
						Form:C1466.ƒ.additional.setValue($str.setText($c.shift()).localized($c))
						
					Else 
						
						Form:C1466.ƒ.additional.setValue($str.setText(Form:C1466.additional).localized())
						
					End if 
					
					// Resize the message according to the additional text length
					OBJECT GET BEST SIZE:C717(*; "additional"; $width; $height; 393)
					OBJECT GET COORDINATES:C663(*; "additional"; $left; $top; $right; $bottom)
					$vOffset:=Choose:C955($height<54; 54; $height)-($bottom-$top)
					
					If ($vOffset#0)
						
						OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
						$height:=$height+$vOffset
						
						CALL SUBFORM CONTAINER:C1086(-$height)
						
					End if 
					
					//……………………………………………………………………………………………………………………
				: ($key="scrollbar")
					
					Form:C1466.ƒ.additional.setScrollbars(False:C215; Bool:C1537(Form:C1466[$key]))
					
					//……………………………………………………………………………………………………………………
				: ($key="type")
					
					Case of 
							
							// ---------------------------------------
						: (Form:C1466[$key]="progress")
							
							Form:C1466.ƒ.progress.show().start()
							
							// ---------------------------------------
						: (Form:C1466[$key]="alert")
							
							Form:C1466.ƒ.ok.show()
							
							// ---------------------------------------
						: (Form:C1466[$key]="confirm")
							
							Form:C1466.ƒ.ok.show()
							Form:C1466.ƒ.cancel.show()
							
							// ---------------------------------------
					End case 
					
					//……………………………………………………………………………………………………………………
				: ($key="option")
					
					Form:C1466.ƒ.option.setTitle($str.setText(Form:C1466.option.title).localized()).show()
					
					//……………………………………………………………………………………………………………………
				: ($key="help")
					
					Form:C1466.ƒ.help.show()
					
					//……………………………………………………………………………………………………………………
				: ($key="ok")
					
					Form:C1466.ƒ.ok.setTitle($str.setText(Form:C1466.ok).localized()).show()
					
					//……………………………………………………………………………………………………………………
				: ($key="cancel")
					
					Form:C1466.ƒ.cancel.setTitle($str.setText(Form:C1466.cancel).localized()).show()
					
					//……………………………………………………………………………………………………………………
			End case 
		End for each 
		
		Form:C1466.ƒ.buttonGroup.distributeRigthToLeft()
		
		// Auto-launch
		If (Form:C1466.autostart#Null:C1517)
			
			CALL FORM:C1391(Current form window:C827; Form:C1466.autostart.method; Form:C1466.autostart.action; Form:C1466.autostart.project)
			OB REMOVE:C1226(Form:C1466; "autostart")
			
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 