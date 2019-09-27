//%attributes = {"invisible":true}
C_TEXT:C284($Mnu_choice)
C_OBJECT:C1216($Obj_project)

$Mnu_choice:=Get selected menu item parameter:C1005
$Obj_project:=(OBJECT Get pointer:C1124(Object named:K67:5;"project"))->

Case of 
		
		  //______________________________________________________
	: (Length:C16($Mnu_choice)=0)
		
		  // NOTHING MORE TO DO
		
		  //______________________________________________________
	: ($Mnu_choice="buildAndRun")
		
		project_BUILD (New object:C1471(\
			"caller";Current form window:C827;\
			"project";$Obj_project;\
			"create";True:C214;\
			"build";True:C214;\
			"run";True:C214;\
			"verbose";True:C214))
		
		  //______________________________________________________
	: ($Mnu_choice="create")
		
		project_BUILD (New object:C1471(\
			"caller";Current form window:C827;\
			"project";$Obj_project;\
			"create";True:C214;\
			"build";False:C215;\
			"run";False:C215;\
			"verbose";True:C214))
		
		  //______________________________________________________
	: ($Mnu_choice="build")
		
		project_BUILD (New object:C1471(\
			"caller";Current form window:C827;\
			"project";$Obj_project;\
			"create";False:C215;\
			"build";True:C214;\
			"run";True:C214;\
			"verbose";True:C214))
		
		  //______________________________________________________
	: ($Mnu_choice="run")
		
		project_BUILD (New object:C1471(\
			"caller";Current form window:C827;\
			"project";$Obj_project;\
			"create";False:C215;\
			"build";False:C215;\
			"run";True:C214;\
			"verbose";True:C214))
		
		  //______________________________________________________
	: ($Mnu_choice="reveal")
		
		SHOW ON DISK:C922(COMPONENT_Pathname ("products").folder($Obj_project.product.name).platformPath)
		
		  //______________________________________________________
	: ($Mnu_choice="xcdatamodel")
		
		C_TEXT:C284($Txt_path)
		$Txt_path:=Temporary folder:C486+Folder separator:K24:12+Generate UUID:C1066+Folder separator:K24:12
		
		dataModel (New object:C1471(\
			"action";"xcdatamodel";\
			"dataModel";$Obj_project.dataModel;\
			"flat";False:C215;\
			"relationship";True:C214;\
			"path";$Txt_path+"Structures.xcdatamodeld"))
		
		SHOW ON DISK:C922($Txt_path)
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown menu action ("+$Mnu_choice+")")
		
		  //______________________________________________________
End case 