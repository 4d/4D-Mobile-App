//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : COMPONENT_Pathname
  // Database: 4D Mobile App
  // ID[269E96575CA2421F8830076D2FFD841D]
  // Created 20-3-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)

C_BOOLEAN:C305($Boo_treated)
C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_target)
C_OBJECT:C1216($o;$Obj_path)

If (False:C215)
	C_OBJECT:C1216(COMPONENT_Pathname ;$0)
	C_TEXT:C284(COMPONENT_Pathname ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_target:=$1
	
	  // Default values
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Obj_path:=New object:C1471(\
		"exists";False:C215;\
		"platformPath";"")
	
	$Boo_treated:=True:C214
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  //                     DATABASE
  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Txt_target="databasePreferences")  //  Writable user database preferences folder
		
		$Obj_path:=Folder:C1567(fk user preferences folder:K87:10).folder(Folder:C1567(Database folder:K5:14;*).name)
		
		  //______________________________________________________
	: ($Txt_target="projects")  // 'Mobile Projects' folder
		
		$Obj_path:=Folder:C1567(fk database folder:K87:14;*).folder("Mobile Projects")
		
		  //______________________________________________________
	: ($Txt_target="products")  // Products folder
		
		  //#WARNING - Folder(Database folder;*).parent = Null
		$o:=Path to object:C1547(Get 4D folder:C485(Database folder:K5:14;*))
		$Obj_path:=Folder:C1567($o.parentFolder+$o.name+" - Mobile"+Folder separator:K24:12;fk platform path:K87:2)
		
		  //______________________________________________________
	: ($Txt_target="host")  // 'mobile' folder
		
		$o:=Folder:C1567(fk resources folder:K87:11;*)
		
		If ($o.file("mobile").exists)  // Could be an alias
			
			If ($o.file("mobile").original#Null:C1517)
				
				$Obj_path:=$o.file("mobile").original
				
			Else 
				
				  // Can't resolve original
				
			End if 
			
		Else 
			
			If ($o.folder("mobile").exists)
				
				$Obj_path:=$o.folder("mobile")
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($Txt_target="host_forms")
		
		$o:=COMPONENT_Pathname ("host")
		
		If ($o.exists)
			
			$Obj_path:=$o.folder("form")
			
		End if 
		
		  //______________________________________________________
	: ($Txt_target="host_listForms")
		
		$o:=COMPONENT_Pathname ("host_forms")
		
		If ($o.exists)
			
			$Obj_path:=$o.folder("list")
			
		End if 
		
		  //______________________________________________________
	: ($Txt_target="host_detailForms")
		
		$o:=COMPONENT_Pathname ("host_forms")
		
		If ($o.exists)
			
			$Obj_path:=$o.folder("detail")
			
		End if 
		
		  //______________________________________________________
	: ($Txt_target="host_tableIcons")\
		 | ($Txt_target="host_fieldIcons")\
		 | ($Txt_target="host_actionIcons")
		
		$o:=COMPONENT_Pathname ("host")
		
		If ($o.exists)
			
			$Obj_path:=$o.folder("medias").folder("icons")
			
		End if 
		
		  //______________________________________________________
	: ($Txt_target="host_formatters")
		
		$o:=COMPONENT_Pathname ("host")
		
		If ($o.exists)
			
			$Obj_path:=$o.folder("formatters")
			
		End if 
		
		  //______________________________________________________
	: ($Txt_target="key")  // key file
		
		$Obj_path:=Folder:C1567(MobileApps folder:K5:47;*).file("key.mobileapp")
		
		  //________________________________________
	Else 
		
		$Boo_treated:=False:C215
		
		  //________________________________________
End case 

  // ----------------------------------------------------
  //                      COMPONENT
  // ----------------------------------------------------

Case of 
		
		  //______________________________________________________
	: ($Boo_treated)
		
		  // <NOTHING MORE TO DO>
		
		  //______________________________________________________
	: ($Txt_target="project")
		
		$Obj_path:=Folder:C1567("/RESOURCES/default project")
		
		  //______________________________________________________
	: ($Txt_target="sdk")
		
		$Obj_path:=Folder:C1567("/RESOURCES/sdk/Versions")
		
		  //______________________________________________________
	: ($Txt_target="templates")
		
		$Obj_path:=Folder:C1567("/RESOURCES/templates")
		
		  //______________________________________________________
	: ($Txt_target="scripts")
		
		$Obj_path:=Folder:C1567("/RESOURCES/scripts")
		
		  //______________________________________________________
	: ($Txt_target="tableIcons")\
		 | ($Txt_target="fieldIcons")\
		 | ($Txt_target="actionIcons")
		
		$Obj_path:=Folder:C1567("/RESOURCES/images/tableIcons")
		
		  //______________________________________________________
	: ($Txt_target="forms")
		
		$Obj_path:=Folder:C1567("/RESOURCES/templates/form")
		
		  //______________________________________________________
	: ($Txt_target="listForms")
		
		$Obj_path:=Folder:C1567("/RESOURCES/templates/form/list")
		
		  //______________________________________________________
	: ($Txt_target="detailForms")
		
		$Obj_path:=Folder:C1567("/RESOURCES/templates/form/detail")
		
		  //______________________________________________________
	: ($Txt_target="navigationForms")
		
		$Obj_path:=Folder:C1567("/RESOURCES/templates/form/navigation")
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Txt_target+"\"")
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=$Obj_path

  // ----------------------------------------------------
  // End