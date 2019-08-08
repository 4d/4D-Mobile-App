//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : editor_MENU_BUILD
  // Database: 4D Mobile Express
  // ID[A4B34AA7AA3641ACBB84988DBDB07BED]
  // Created 6-10-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)

C_LONGINT:C283($Lon_formEvent;$Lon_parameters)
C_TEXT:C284($Dir_app;$Dir_build;$Dir_product;$Mnu_choice;$Mnu_pop)
C_OBJECT:C1216($Obj_could;$Obj_project)

If (False:C215)
	C_TEXT:C284(_o_editor_MENU_BUILD ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Mnu_choice:=$1
		
	End if 
	
	$Lon_formEvent:=Form event code:C388
	
	$Obj_project:=(OBJECT Get pointer:C1124(Object named:K67:5;"project"))->
	
	  // Autosave
	project_SAVE 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: (Length:C16($Mnu_choice)#0)
		
		  // NOTHING MORE TO DO
		
		  //______________________________________________________
	: ($Lon_formEvent=On Clicked:K2:4)
		
		$Mnu_choice:=Choose:C955(Bool:C1537(Form:C1466.xCode.ready);"buildAndRun";"create")
		
		  //______________________________________________________
	: ($Lon_formEvent=On Long Click:K2:37) | ($Lon_formEvent=On Alternative Click:K2:36)
		
		If (String:C10($Obj_project.product.name)#"")
			
			$Dir_product:=_o_Pathname ("products")+$Obj_project.product.name+Folder separator:K24:12
			$Dir_build:=$Dir_product+"build"+Folder separator:K24:12
			$Dir_app:=$Dir_build+Convert path POSIX to system:C1107("Build/Products/Debug-iphonesimulator/")+$Obj_project.$project.product+".app"
			
		Else 
			
			$Obj_could:=New object:C1471
			
		End if 
		
		$Obj_could:=New object:C1471("create";True:C214;"build";Form:C1466.xCode.ready;"run";Form:C1466.xCode.ready)
		
		$Obj_could.buildWithoutCreate:=$Obj_could.build & (Test path name:C476($Dir_product)=Is a folder:K24:2)
		$Obj_could.runWithoutBuilding:=$Obj_could.run & (Test path name:C476($Dir_app)=Is a folder:K24:2)
		
		$Mnu_pop:=Create menu:C408
		
		APPEND MENU ITEM:C411($Mnu_pop;":xliff:mnuBuildAndRun")
		SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"buildAndRun")
		
		If (Not:C34(Bool:C1537($Obj_could.run) & Bool:C1537($Obj_could.create) & Bool:C1537($Obj_could.build)))
			
			DISABLE MENU ITEM:C150($Mnu_pop;-1)
			
		End if 
		
		APPEND MENU ITEM:C411($Mnu_pop;"-")
		APPEND MENU ITEM:C411($Mnu_pop;":xliff:mnuCreateWorkspace")
		SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"create")
		
		If (Not:C34(Bool:C1537($Obj_could.create)))
			
			DISABLE MENU ITEM:C150($Mnu_pop;-1)
			
		End if 
		
		APPEND MENU ITEM:C411($Mnu_pop;":xliff:mnuBuild")
		SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"build")
		
		If (Not:C34(Bool:C1537($Obj_could.buildWithoutCreate)))
			
			DISABLE MENU ITEM:C150($Mnu_pop;-1)
			
		End if 
		
		APPEND MENU ITEM:C411($Mnu_pop;":xliff:mnuRunWithoutBuilding")
		SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"run")
		
		If (Not:C34(Bool:C1537($Obj_could.runWithoutBuilding)))
			
			DISABLE MENU ITEM:C150($Mnu_pop;-1)
			
		End if 
		
		$Mnu_choice:=Dynamic pop up menu:C1006($Mnu_pop)
		RELEASE MENU:C978($Mnu_pop)
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 

Case of 
		
		  //______________________________________________________
	: (Length:C16($Mnu_choice)=0)
		
		  // NOTHING MORE TO DO
		
		  //______________________________________________________
	: ($Mnu_choice="buildAndRun")
		
		project_BUILD (New object:C1471("caller";Current form window:C827;"project";$Obj_project;"create";True:C214;"build";True:C214;"run";True:C214;"verbose";Bool:C1537(Form:C1466.verbose)))
		
		  //______________________________________________________
	: ($Mnu_choice="create")
		
		project_BUILD (New object:C1471("caller";Current form window:C827;"project";$Obj_project;"create";True:C214;"build";False:C215;"run";False:C215;"verbose";Bool:C1537(Form:C1466.verbose)))
		
		  //______________________________________________________
	: ($Mnu_choice="build")
		
		project_BUILD (New object:C1471("caller";Current form window:C827;"project";$Obj_project;"create";False:C215;"build";True:C214;"run";True:C214;"verbose";Bool:C1537(Form:C1466.verbose)))
		
		  //______________________________________________________
	: ($Mnu_choice="run")
		
		project_BUILD (New object:C1471("caller";Current form window:C827;"project";$Obj_project;"create";False:C215;"build";False:C215;"run";True:C214;"verbose";Bool:C1537(Form:C1466.verbose)))
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown menu action ("+$Mnu_choice+")")
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End