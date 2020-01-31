//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : path
  // ID[0882AA13E3A54FD98A42518393CA7BF7]
  // Created 24-1-2020 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_BOOLEAN:C305($bCreate)
C_TEXT:C284($t)
C_OBJECT:C1216($o;$oPath)

If (False:C215)
	C_OBJECT:C1216(path ;$0)
	C_TEXT:C284(path ;$1)
	C_OBJECT:C1216(path ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)  // Constructor
	
	If (Count parameters:C259>=1)
		
		$t:=String:C10($1)
		
	End if 
	
	$o:=New object:C1471(\
		"";"path";\
		"name";$t;\
		"exists";False:C215;\
		"path";Null:C1517;\
		"actionIcons";Formula:C1597(path ("icons"));\
		"databasePreferences";Formula:C1597(path ("databasePreferences"));\
		"detailForms";Formula:C1597(path ("detailForms"));\
		"fieldIcons";Formula:C1597(path ("icons"));\
		"forms";Formula:C1597(path ("forms"));\
		"key";Formula:C1597(path ("key"));\
		"listForms";Formula:C1597(path ("listForms"));\
		"navigationForms";Formula:C1597(path ("navigationForms"));\
		"project";Formula:C1597(path ("project"));\
		"scripts";Formula:C1597(path ("scripts"));\
		"sdk";Formula:C1597(path ("sdk"));\
		"tableIcons";Formula:C1597(path ("icons"));\
		"templates";Formula:C1597(path ("templates"));\
		"projects";Formula:C1597(path ("projects";New object:C1471("create";Bool:C1537($1))));\
		"products";Formula:C1597(path ("products";New object:C1471("create";Bool:C1537($1))));\
		"host";Formula:C1597(path ("host";New object:C1471("create";Bool:C1537($1))));\
		"hostForms";Formula:C1597(path ("hostForms";New object:C1471("create";Bool:C1537($1))));\
		"hostdetailForms";Formula:C1597(path ("hostDetailForms";New object:C1471("create";Bool:C1537($1))));\
		"hostlistForms";Formula:C1597(path ("hostListForms";New object:C1471("create";Bool:C1537($1))));\
		"hostActionIcons";Formula:C1597(path ("hostIcons";New object:C1471("create";Bool:C1537($1))));\
		"hostFieldIcons";Formula:C1597(path ("hostIcons";New object:C1471("create";Bool:C1537($1))));\
		"hostFormatters";Formula:C1597(path ("hostFormatters";New object:C1471("create";Bool:C1537($1))));\
		"hostNavigationForms";Formula:C1597(path ("hostNavigationForms";New object:C1471("create";Bool:C1537($1))));\
		"hostTableIcons";Formula:C1597(path ("hostIcons";New object:C1471("create";Bool:C1537($1))));\
		"list";Formula:C1597(path ("resource";New object:C1471("type";"list";"name";String:C10($1))));\
		"detail";Formula:C1597(path ("resource";New object:C1471("type";"detail";"name";String:C10($1))));\
		"icon";Formula:C1597(path ("resource";New object:C1471("type";"icon";"name";String:C10($1))));\
		"navigation";Formula:C1597(path ("resource";New object:C1471("type";"navigation";"name";String:C10($1))))\
		)
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="databasePreferences")  //  Writable user database preferences folder
			
			$o.path:=Folder:C1567(fk user preferences folder:K87:10).folder(Folder:C1567(Database folder:K5:14;*).name)
			
			  //______________________________________________________
		: ($1="forms")  // Component forms folder
			
			$o.path:=Folder:C1567("/RESOURCES/templates/form")
			
			  //______________________________________________________
		: ($1="icons")  // Component icons folder
			
			$o.path:=Folder:C1567("/RESOURCES/images/tableIcons")
			
			  //______________________________________________________
		: ($1="detailForms")  // Component detail forms folder
			
			$o.path:=Folder:C1567("/RESOURCES/templates/form/detail")
			
			  //______________________________________________________
		: ($1="listForms")  // Component list forms folder
			
			$o.path:=Folder:C1567("/RESOURCES/templates/form/list")
			
			  //______________________________________________________
		: ($1="navigationForms")  // Component navigation forms folder
			
			$o.path:=Folder:C1567("/RESOURCES/templates/form/navigation")
			
			  //______________________________________________________
		: ($1="scripts")  // Component scripts folder
			
			  // Unsandboxed for use with LEP
			$o.path:=Folder:C1567(Folder:C1567("/RESOURCES/scripts").platformPath;fk platform path:K87:2)
			
			  //______________________________________________________
		: ($1="sdk")  // Component sdk folder
			
			$o.path:=Folder:C1567("/RESOURCES/sdk/Versions")
			
			  //______________________________________________________
		: ($1="project")  // Component project folder
			
			$o.path:=Folder:C1567("/RESOURCES/default project")
			
			  //______________________________________________________
		: ($1="templates")  // Component templates folder
			
			$o.path:=Folder:C1567("/RESOURCES/templates")
			
			  //______________________________________________________
		: ($1="key")  // Database 'key' file
			
			$o.path:=Folder:C1567(MobileApps folder:K5:47;*).file("key.mobileapp")
			
			  //______________________________________________________
		: ($1="projects")  // Database 'Mobile Projects' folder
			
			$o.path:=Folder:C1567(fk database folder:K87:14;*).folder("Mobile Projects")
			$bCreate:=$2.create
			
			  //______________________________________________________
		: ($1="products")  // Database 'Products' folder
			
			  //#WARNING - Folder(Database folder;*).parent = Null
			$oPath:=Path to object:C1547(Get 4D folder:C485(Database folder:K5:14;*))
			$o.path:=Folder:C1567($oPath.parentFolder+$oPath.name+" - Mobile"+Folder separator:K24:12;fk platform path:K87:2)
			$bCreate:=$2.create
			
			  //______________________________________________________
		: ($1="host")  // Database 'mobile' folder
			
			$oPath:=Folder:C1567(Get 4D folder:C485(Current resources folder:K5:16;*);fk platform path:K87:2)
			
			If ($oPath.file("mobile").exists)  // Could be an alias
				
				If ($oPath.file("mobile").original#Null:C1517)
					
					$o.path:=$oPath.file("mobile").original
					
				Else 
					
					$o.path:=$oPath.file("mobile")
					
				End if 
				
			Else 
				
				$o.path:=$oPath.folder("mobile")
				$bCreate:=$2.create
				
			End if 
			
			  //______________________________________________________
		: ($1="hostForms")  // Database 'form' folder
			
			$o.path:=$o.host().folder("form")
			$bCreate:=$2.create
			
			  //______________________________________________________
		: ($1="hostFormatters")  // Database 'formatters' folder
			
			$o.path:=$o.host().folder("formatters")
			$bCreate:=$2.create
			
			  //______________________________________________________
		: ($1="hostIcons")  // Database 'icons' folder
			
			$o.path:=$o.host().folder("medias").folder("icons")
			$bCreate:=$2.create
			
			  //______________________________________________________
		: ($1="hostListForms")  // Database 'form/list' folder
			
			$o.path:=$o.hostForms().folder("list")
			$bCreate:=$2.create
			
			  //______________________________________________________
		: ($1="hostDetailForms")  // Database 'form/detail' folder
			
			$o.path:=$o.hostForms().folder("detail")
			$bCreate:=$2.create
			
			  //______________________________________________________
		: ($1="hostNavigationForms")  // Database 'form/navigation' folder
			
			$o.path:=$o.hostForms().folder("navigation")
			$bCreate:=$2.create
			
			  //______________________________________________________
		: ($1="resource")  // Return path of a resource
			
			$t:=$2.name
			
			If ($t[[1]]="/")
				
				$t:=Delete string:C232($t;1;1)
				
				Case of 
						
						  //……………………………………………………………………………
					: ($2.type="list")
						
						$oPath:=$o.hostListForms()
						
						  //……………………………………………………………………………
					: ($2.type="detail")
						
						$oPath:=$o.hostDetailForms()
						
						  //……………………………………………………………………………
					: ($2.type="navigation")
						
						$oPath:=$o.hostNavigationForms()
						
						  //……………………………………………………………………………
					: ($2.type="icon")
						
						  // For the moment, no distinction between table, field or action icons
						$oPath:=$o.hostTableIcons()
						
						  //……………………………………………………………………………
				End case 
				
				If (Path to object:C1547($t).extension=commonValues.archiveExtension)
					
					  // Archive path
					$o.path:=$oPath.path.file($t)
					
				Else 
					
					$o.path:=$oPath.path.folder($t)
					
				End if 
				
			Else 
				
				Case of 
						
						  //……………………………………………………………………………
					: ($2.type="list")
						
						$o.path:=$o.listForms().folder($t)
						
						  //……………………………………………………………………………
					: ($2.type="detail")
						
						$o.path:=$o.detailForms().folder($t)
						
						  //……………………………………………………………………………
					: ($2.type="navigation")
						
						$o.path:=$o.navigationForms().folder($t)
						
						  //……………………………………………………………………………
					: ($2.type="icon")
						
						  // For the moment, no distinction between table, field or action icons
						$o.path:=$o.tableIcons().file($t)
						
						  //……………………………………………………………………………
				End case 
			End if 
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
			
			  //______________________________________________________
	End case 
	
	If ($bCreate)
		
		$o.path.create()
		
	End if 
	
	$o:=$o.path  // One shot
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End