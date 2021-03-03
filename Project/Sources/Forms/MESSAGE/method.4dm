// ----------------------------------------------------
// Form method : MESSAGE - (4D Mobile Express)
// ID[F362D3E200984FF7AFD3F7FD4B4311BC]
// Created 30-6-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
C_LONGINT:C283($Lon_bottom; $Lon_formEvent; $Lon_height; $Lon_left; $Lon_right; $Lon_top)
C_LONGINT:C283($Lon_vOffset; $Lon_width)
C_TEXT:C284($Txt_key)
C_OBJECT:C1216($str)
C_COLLECTION:C1488($c)

// ----------------------------------------------------
// Initialisations
$Lon_formEvent:=Form event code:C388

// ----------------------------------------------------

Case of 
		
		//______________________________________________________
	: ($Lon_formEvent=On Load:K2:1)
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($Lon_formEvent=On Unload:K2:2)
		
		//
		
		//______________________________________________________
	: ($Lon_formEvent=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		//______________________________________________________
	: ($Lon_formEvent=On Bound Variable Change:K2:52)
		
		// Reset {
		(OBJECT Get pointer:C1124(Object named:K67:5; "progress"))->:=0
		OBJECT SET VISIBLE:C603(*; "progress"; False:C215)
		
		OBJECT SET TITLE:C194(*; "cancel"; Get localized string:C991("cancel"))
		OBJECT SET VISIBLE:C603(*; "cancel"; False:C215)
		
		OBJECT SET TITLE:C194(*; "ok"; Get localized string:C991("ok"))
		OBJECT SET VISIBLE:C603(*; "ok"; False:C215)
		
		(OBJECT Get pointer:C1124(Object named:K67:5; "title"))->:=""
		(OBJECT Get pointer:C1124(Object named:K67:5; "additional"))->:=""
		
		OBJECT SET SCROLLBAR:C843(*; "additional"; False:C215; False:C215)
		
		OBJECT SET VISIBLE:C603(*; "option"; False:C215)
		OBJECT SET VISIBLE:C603(*; "help"; False:C215)
		//}
		
		$str:=cs:C1710.str.new()
		
		For each ($Txt_key; Form:C1466)
			
			Case of 
					
					//……………………………………………………………………………………………………………………
				: ($Txt_key="title")
					
					If (Value type:C1509(Form:C1466.title)=Is collection:K8:32)
						
						$c:=Form:C1466.title.copy()
						(OBJECT Get pointer:C1124(Object named:K67:5; "title"))->:=$str.setText($c.shift()).localized($c)
						
					Else 
						
						(OBJECT Get pointer:C1124(Object named:K67:5; "title"))->:=$str.setText(Form:C1466.title).localized()
						
					End if 
					
					//……………………………………………………………………………………………………………………
				: ($Txt_key="additional")
					
					If (Value type:C1509(Form:C1466.additional)=Is collection:K8:32)
						
						$c:=Form:C1466.additional.copy()
						(OBJECT Get pointer:C1124(Object named:K67:5; "additional"))->:=$str.setText($c.shift()).localized($c)
						
					Else 
						
						(OBJECT Get pointer:C1124(Object named:K67:5; "additional"))->:=$str.setText(Form:C1466.additional).localized()
						
					End if 
					
					// Resize the message according to the additional text length [
					OBJECT GET BEST SIZE:C717(*; "additional"; $Lon_width; $Lon_height; 393)
					OBJECT GET COORDINATES:C663(*; "additional"; $Lon_left; $Lon_top; $Lon_right; $Lon_bottom)
					$Lon_vOffset:=Choose:C955($Lon_height<54; 54; $Lon_height)-($Lon_bottom-$Lon_top)
					
					If ($Lon_vOffset#0)
						
						OBJECT GET SUBFORM CONTAINER SIZE:C1148($Lon_width; $Lon_height)
						$Lon_height:=$Lon_height+$Lon_vOffset
						
						CALL SUBFORM CONTAINER:C1086(-$Lon_height)
						
					End if 
					//]
					
					//……………………………………………………………………………………………………………………
				: ($Txt_key="scrollbar")
					
					OBJECT SET SCROLLBAR:C843(*; "additional"; False:C215; Bool:C1537(Form:C1466[$Txt_key]))
					
					//……………………………………………………………………………………………………………………
				: ($Txt_key="type")
					
					Case of 
							
							// ---------------------------------------
						: (Form:C1466[$Txt_key]="progress")
							
							OBJECT SET VISIBLE:C603(*; "progress"; True:C214)
							(OBJECT Get pointer:C1124(Object named:K67:5; "progress"))->:=1
							
							// ---------------------------------------
						: (Form:C1466[$Txt_key]="alert")
							
							OBJECT SET VISIBLE:C603(*; "ok"; True:C214)
							
							// ---------------------------------------
						: (Form:C1466[$Txt_key]="confirm")
							
							OBJECT SET VISIBLE:C603(*; "ok"; True:C214)
							OBJECT SET VISIBLE:C603(*; "cancel"; True:C214)
							
							// ---------------------------------------
					End case 
					
					//……………………………………………………………………………………………………………………
				: ($Txt_key="option")
					
					OBJECT SET TITLE:C194(*; "option"; $str.setText(Form:C1466.option.title).localized())
					OBJECT SET VISIBLE:C603(*; "option"; True:C214)
					
					//……………………………………………………………………………………………………………………
				: ($Txt_key="help")
					
					OBJECT SET VISIBLE:C603(*; "help"; True:C214)
					
					//……………………………………………………………………………………………………………………
				: ($Txt_key="ok")
					
					//OBJECT SET TITLE(*;"ok";str_localized (New collection(Form.ok)))
					OBJECT SET TITLE:C194(*; "ok"; $str.setText(Form:C1466.ok).localized())
					OBJECT SET VISIBLE:C603(*; "ok"; True:C214)
					
					//……………………………………………………………………………………………………………………
				: ($Txt_key="cancel")
					
					//OBJECT SET TITLE(*;"cancel";str_localized (New collection(Form.cancel)))
					OBJECT SET TITLE:C194(*; "cancel"; $str.setText(Form:C1466.cancel).localized())
					OBJECT SET VISIBLE:C603(*; "cancel"; True:C214)
					
					//……………………………………………………………………………………………………………………
			End case 
		End for each 
		
		ui_BEST_SIZE(New object:C1471(\
			"widgets"; New collection:C1472("ok"; "cancel"); \
			"alignment"; Align right:K42:4))
		
		If (Form:C1466.autostart#Null:C1517)  // Auto-launch
			
			CALL FORM:C1391(Current form window:C827; Form:C1466.autostart.method; Form:C1466.autostart.action; Form:C1466.autostart.project)
			
			OB REMOVE:C1226(Form:C1466; "autostart")
			
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		//______________________________________________________
End case 