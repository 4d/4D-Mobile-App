//%attributes = {"invisible":true}
/*
result := ***Pathname*** ( info ; param )
 -> info (Text)
 -> param (Object)
 <- result (Text)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : Pathname
  // Database: 4D Mobile Express
  // ID[824D04E637FD404DAA6AA7E8518EC924]
  // Created #26-6-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_info;$Txt_property;$Txt_result)
C_OBJECT:C1216($Obj_param;$Obj_path)

If (False:C215)
	C_TEXT:C284(_o_Pathname ;$0)
	C_TEXT:C284(_o_Pathname ;$1)
	C_OBJECT:C1216(_o_Pathname ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_info:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		$Obj_param:=$2
		
	End if 
	
	If (Storage:C1525.path=Null:C1517)
		
		$Obj_path:=Path to object:C1547(Get 4D folder:C485(Database folder:K5:14;*))
		
		Use (Storage:C1525)
			
			Storage:C1525.path:=New shared object:C1526
			
			Use (Storage:C1525.path)
				
				Storage:C1525.path.database:=Get 4D folder:C485(Database folder:K5:14;*)
				
			End use 
			
			Storage:C1525.database:=New shared object:C1526
			
			Use (Storage:C1525.database)
				
				For each ($Txt_property;$Obj_path)
					
					Storage:C1525.database[$Txt_property]:=$Obj_path[$Txt_property]
					
				End for each 
				
				Storage:C1525.database.resources:=Get 4D folder:C485(Current resources folder:K5:16;*)
				
			End use 
		End use 
	End if 
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Txt_info="databasePreferences")
		
		If (Storage:C1525.path.databasePreferences=Null:C1517)
			
			Use (Storage:C1525.path)
				
				Storage:C1525.path.databasePreferences:=Get 4D folder:C485(Active 4D Folder:K5:10)\
					+Path to object:C1547(Storage:C1525.path.database).name+Folder separator:K24:12
				
			End use 
		End if 
		
		$Txt_result:=Storage:C1525.path.databasePreferences
		
		  //______________________________________________________
	: ($Txt_info="projects")
		
		If (Storage:C1525.path.projects=Null:C1517)
			
			Use (Storage:C1525.path)
				
				Storage:C1525.path.projects:=Storage:C1525.path.database+"Mobile Projects"+Folder separator:K24:12
				
			End use 
		End if 
		
		$Txt_result:=Storage:C1525.path.projects
		CREATE FOLDER:C475($Txt_result;*)
		
		  //______________________________________________________
	: ($Txt_info="products")
		
		If (Storage:C1525.path.products=Null:C1517)
			
			Use (Storage:C1525.path)
				
				Storage:C1525.path.products:=Storage:C1525.database.parentFolder+Storage:C1525.database.name+" - Mobile"+Folder separator:K24:12
				
			End use 
		End if 
		
		$Txt_result:=Storage:C1525.path.products
		
		  //______________________________________________________
	: ($Txt_info="dataSet")
		
		If (Storage:C1525.path.dataSet=Null:C1517)
			
			Use (Storage:C1525.path)
				
				  //If (Bool(featuresFlags._103112))
				
				  // We want it in project folder
				Storage:C1525.path.dataSet:=_o_Pathname ("projects")
				
				  //Else 
				  //Storage.path.dataSet:=_o_Pathname ("products")+".dataSet"+Folder separator
				  //End if 
				
			End use 
		End if 
		
		$Txt_result:=Storage:C1525.path.dataSet
		
		  //______________________________________________________
	: ($Txt_info="sdk")
		
		If (Storage:C1525.path.sdk=Null:C1517)
			
			Use (Storage:C1525.path)
				
				Storage:C1525.path.sdk:=Get 4D folder:C485(Current resources folder:K5:16)\
					+"sdk"+Folder separator:K24:12\
					+"Versions"+Folder separator:K24:12
				
			End use 
		End if 
		
		$Txt_result:=Storage:C1525.path.sdk
		
		  //______________________________________________________
	: ($Txt_info="project")
		
		If (Storage:C1525.path.project=Null:C1517)
			
			Use (Storage:C1525.path)
				
				Storage:C1525.path.project:=Get 4D folder:C485(Current resources folder:K5:16)\
					+"default project"+Folder separator:K24:12
				
			End use 
		End if 
		
		$Txt_result:=Storage:C1525.path.project
		
		  //______________________________________________________
	: ($Txt_info="templates")
		
		If (Storage:C1525.path.templates=Null:C1517)
			
			Use (Storage:C1525.path)
				
				Storage:C1525.path.templates:=Get 4D folder:C485(Current resources folder:K5:16)\
					+"templates"+Folder separator:K24:12
				
			End use 
		End if 
		
		$Txt_result:=Storage:C1525.path.templates
		
		  //______________________________________________________
	: ($Txt_info="scripts")
		
		If (Storage:C1525.path.scripts=Null:C1517)
			
			Use (Storage:C1525.path)
				
				Storage:C1525.path.scripts:=Get 4D folder:C485(Current resources folder:K5:16)\
					+"scripts"+Folder separator:K24:12
				
			End use 
		End if 
		
		$Txt_result:=Storage:C1525.path.scripts
		
		  //______________________________________________________
	: ($Txt_info="tableIcons")\
		 | ($Txt_info="fieldIcons")\
		 | ($Txt_info="actionIcons")
		
		If (Storage:C1525.path[$Txt_info]=Null:C1517)
			
			Use (Storage:C1525.path)
				
				Storage:C1525.path[$Txt_info]:=Get 4D folder:C485(Current resources folder:K5:16)\
					+"images"+Folder separator:K24:12\
					+"tableIcons"  // #TO_DO add Folder separator, check all caller
				
			End use 
		End if 
		
		$Txt_result:=Storage:C1525.path[$Txt_info]
		
		  //______________________________________________________
	: ($Txt_info="formatterImages")
		
		If (Storage:C1525.path.formatterImages=Null:C1517)
			
			Use (Storage:C1525.path)
				
				Storage:C1525.path.formatterImages:=Get 4D folder:C485(Current resources folder:K5:16)\
					+"images"+Folder separator:K24:12\
					+"formatters"+Folder separator:K24:12
				
			End use 
		End if 
		
		$Txt_result:=Storage:C1525.path.formatterImages
		
		  //______________________________________________________
	: ($Txt_info="forms")
		
		If (Storage:C1525.path.forms=Null:C1517)
			
			Use (Storage:C1525.path)
				
				Storage:C1525.path.forms:=Get 4D folder:C485(Current resources folder:K5:16)\
					+"templates"+Folder separator:K24:12\
					+"form"+Folder separator:K24:12
				
			End use 
		End if 
		
		$Txt_result:=Storage:C1525.path.forms
		
		  //______________________________________________________
	: ($Txt_info="listForms")
		
		If (Storage:C1525.path.listForms=Null:C1517)
			
			Use (Storage:C1525.path)
				
				Storage:C1525.path.listForms:=Get 4D folder:C485(Current resources folder:K5:16)\
					+"templates"+Folder separator:K24:12\
					+"form"+Folder separator:K24:12\
					+"list"+Folder separator:K24:12
				
			End use 
		End if 
		
		$Txt_result:=Storage:C1525.path.listForms
		
		  //______________________________________________________
	: ($Txt_info="detailForms")
		
		If (Storage:C1525.path.detailForms=Null:C1517)
			
			Use (Storage:C1525.path)
				
				Storage:C1525.path.detailForms:=Get 4D folder:C485(Current resources folder:K5:16)\
					+"templates"+Folder separator:K24:12\
					+"form"+Folder separator:K24:12\
					+"detail"+Folder separator:K24:12
				
			End use 
		End if 
		
		$Txt_result:=Storage:C1525.path.detailForms
		
		  //______________________________________________________
	: ($Txt_info="navigationForms")
		
		If (Storage:C1525.path.navigationForms=Null:C1517)
			
			Use (Storage:C1525.path)
				
				Storage:C1525.path.navigationForms:=Get 4D folder:C485(Current resources folder:K5:16)\
					+"templates"+Folder separator:K24:12\
					+"form"+Folder separator:K24:12\
					+"navigation"+Folder separator:K24:12
				
			End use 
		End if 
		
		$Txt_result:=Storage:C1525.path.navigationForms
		
		  //______________________________________________________
	: ($Txt_info="host")
		
		$Txt_result:=Object to path:C1548(New object:C1471(\
			"name";"mobile";\
			"isFolder";True:C214;\
			"parentFolder";Storage:C1525.database.resources))
		
		  //#redmine:100498
		If (Test path name:C476($Txt_result)#Is a folder:K24:2)
			
			  // Search for a valid "mobile" alias
			$Txt_result:=Object to path:C1548(New object:C1471(\
				"name";"mobile";\
				"isFolder";False:C215;\
				"parentFolder";Storage:C1525.database.resources))
			
			$Txt_result:=doc_resolveAlias ($Txt_result)
			
		End if 
		
		  //______________________________________________________
	: ($Txt_info="host_forms")
		
		$Txt_result:=_o_Pathname ("host")\
			+"form"+Folder separator:K24:12
		
		  //______________________________________________________
	: ($Txt_info="host_listForms")
		
		$Txt_result:=_o_Pathname ("host")\
			+"form"+Folder separator:K24:12\
			+"list"+Folder separator:K24:12
		
		  //______________________________________________________
	: ($Txt_info="host_detailForms")
		
		$Txt_result:=_o_Pathname ("host")\
			+"form"+Folder separator:K24:12\
			+"detail"+Folder separator:K24:12
		
		  //______________________________________________________
	: ($Txt_info="host_tableIcons")\
		 | ($Txt_info="host_fieldIcons")\
		 | ($Txt_info="host_actionIcons")
		
		$Txt_result:=_o_Pathname ("host")\
			+"medias"+Folder separator:K24:12\
			+"icons"  // #TO_DO add Folder separator, check all caller
		
		  //______________________________________________________
	: ($Txt_info="host_formatters")
		
		$Txt_result:=_o_Pathname ("host")\
			+"formatters"+Folder separator:K24:12
		
		  //______________________________________________________
	: ($Txt_info="host_actions")
		
		$Txt_result:=_o_Pathname ("host")\
			+"actions"+Folder separator:K24:12
		
		  //______________________________________________________
	: ($Txt_info="key")
		
		If (Storage:C1525.path.key=Null:C1517)
			
			Use (Storage:C1525.path)
				
				Storage:C1525.path.key:=Get 4D folder:C485(MobileApps folder:K5:47;*)+"key.mobileapp"
				
			End use 
		End if 
		
		$Txt_result:=Storage:C1525.path.key
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Txt_info+"\"")
		
		  //______________________________________________________
End case 

If (Bool:C1537($Obj_param.posix))
	
	$Txt_result:=Convert path system to POSIX:C1106($Txt_result)
	
End if 
  // ----------------------------------------------------
  // Return
$0:=$Txt_result

  // ----------------------------------------------------
  // End