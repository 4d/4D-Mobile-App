// ----------------------------------------------------
// Form method : WIZARD_NEW_PROJECT - (4D Mobile App)
// ID[A5933AFAD9094AD9A7A59673CF3B2E79]
// Created 21-1-2021 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $item : Text
var $icon : Picture
var $i : Integer
var $e : Object
var $c : Collection
var $medias : 4D:C1709.Folder
var $template : cs:C1710.str

// ----------------------------------------------------
// Initialisations
$e:=FORM Event:C1606

// ----------------------------------------------------
Case of 
		
		//__________________________________________________________________________________________
	: ($e.code=On Load:K2:1)
		
		EDITOR:=cs:C1710.editor.new()
		
		Form:C1466._message:=cs:C1710.subform.new("message").setValue(New object:C1471)
		
		// Populate the message list
		If (Is macOS:C1572)
			
			$template:=cs:C1710.str.new("<span style='color:dimgray'><span style='font-size: 14pt;font-weight: bold'>"\
				+"{title}"\
				+"</span>"\
				+"<br/>"\
				+"<span style='font-size: 13pt;font-weight: normal'>"\
				+"{description}"\
				+"</span></span>")
			
		Else 
			
			$template:=cs:C1710.str.new("<span style='color:dimgray'><span style='font-size: 13pt;font-weight: bold'>"\
				+"{title}"\
				+"</span>"\
				+"<br/>"\
				+"<span style='font-size: 12pt;font-weight: normal'>"\
				+"{description}"\
				+"</span></span>")
			
		End if 
		
		Form:C1466._list:=New collection:C1472
		
		$medias:=Folder:C1567("/RESOURCES/images/welcome/")
		
		If (EDITOR.isDark)
			
			$c:=New collection:C1472("structure-dark.png"; "design-dark.png"; "generateAndTest-dark.png"; "deploy-dark.png")
			
		Else 
			
			$c:=New collection:C1472("structure.png"; "design.png"; "generateAndTest.png"; "deploy.png")
			
		End if 
		
		For each ($item; $c)
			
			$i:=$i+1
			READ PICTURE FILE:C678($medias.file($item).platformPath; $icon)
			
			If ($i<3)
				
				$item:=$template.localized(New collection:C1472("wel_title_"+String:C10($i); "wel_description_"+String:C10($i)))
				
			Else 
				
				$item:=$template.localized(New collection:C1472("wel_title_"+String:C10($i); "wel_description_"+String:C10($i)+"2"))
				
			End if 
			
			Form:C1466._list.push(New object:C1471(\
				"icon"; $icon; \
				"text"; $item))
			
		End for each 
		
		Form:C1466._continue:=cs:C1710.button.new("continue").bestSize(Align center:K42:3; 70)
		Form:C1466._new:=cs:C1710.widget.new("newProject").setValue(Form:C1466)  // Pass the baby 🤣
		
		Form:C1466._centered:=cs:C1710.group.new("list,continue,newProject,message")
		
		If (Not:C34(FEATURE.with("androidBeta"))) | Is Windows:C1573
			
			Form:C1466._new.resizeVertically(-120).moveVertically(50)
			Form:C1466._listbox:=cs:C1710.listbox.new("list")
			Form:C1466._listbox.resizeVertically(50).setRowsHeight(Choose:C955(Is macOS:C1572; 6; 5); lk lines:K53:23)
			
		End if 
		
		SET TIMER:C645(-1)
		
		//__________________________________________________________________________________________
	: ($e.code=On Resize:K2:27)
		
		Form:C1466._centered.centerVertically()
		
		//__________________________________________________________________________________________
	: ($e.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		Form:C1466._new.focus()
		Form:C1466._centered.centerVertically()
		
		//__________________________________________________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//__________________________________________________________________________________________
End case 