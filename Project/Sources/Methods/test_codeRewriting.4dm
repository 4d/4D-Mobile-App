//%attributes = {}
TRY 

ASSERT:C1129(COMPONENT_Pathname ("databasePreferences").platformPath=_o_Pathname ("databasePreferences"))
ASSERT:C1129(COMPONENT_Pathname ("projects").platformPath=_o_Pathname ("projects"))
ASSERT:C1129(COMPONENT_Pathname ("products").platformPath=_o_Pathname ("products"))
  //ASSERT(COMPONENT_Pathname ("dataSet").platformPath=_o_Pathname ("dataSet")) I think this entrypoint is no more used
ASSERT:C1129(COMPONENT_Pathname ("sdk").platformPath=_o_Pathname ("sdk"))
ASSERT:C1129(COMPONENT_Pathname ("project").platformPath=_o_Pathname ("project"))
ASSERT:C1129(COMPONENT_Pathname ("templates").platformPath=_o_Pathname ("templates"))
ASSERT:C1129(COMPONENT_Pathname ("scripts").platformPath=_o_Pathname ("scripts"))
ASSERT:C1129(COMPONENT_Pathname ("tableIcons").platformPath=(_o_Pathname ("tableIcons")+Folder separator:K24:12))
ASSERT:C1129(COMPONENT_Pathname ("fieldIcons").platformPath=(_o_Pathname ("fieldIcons")+Folder separator:K24:12))
ASSERT:C1129(COMPONENT_Pathname ("actionIcons").platformPath=(_o_Pathname ("actionIcons")+Folder separator:K24:12))
ASSERT:C1129(COMPONENT_Pathname ("forms").platformPath=_o_Pathname ("forms"))
ASSERT:C1129(COMPONENT_Pathname ("listForms").platformPath=_o_Pathname ("listForms"))
ASSERT:C1129(COMPONENT_Pathname ("detailForms").platformPath=_o_Pathname ("detailForms"))
ASSERT:C1129(COMPONENT_Pathname ("navigationForms").platformPath=_o_Pathname ("navigationForms"))

ASSERT:C1129(COMPONENT_Pathname ("host").platformPath=_o_Pathname ("host"))

If (COMPONENT_Pathname ("host").exists)  //could not exists if the original of an alias is no more available
	
	ASSERT:C1129(COMPONENT_Pathname ("host_forms").platformPath=_o_Pathname ("host_forms"))
	ASSERT:C1129(COMPONENT_Pathname ("host_listForms").platformPath=_o_Pathname ("host_listForms"))
	ASSERT:C1129(COMPONENT_Pathname ("host_detailForms").platformPath=_o_Pathname ("host_detailForms"))
	ASSERT:C1129(COMPONENT_Pathname ("host_tableIcons").platformPath=(_o_Pathname ("host_tableIcons")+Folder separator:K24:12))
	ASSERT:C1129(COMPONENT_Pathname ("host_fieldIcons").platformPath=(_o_Pathname ("host_fieldIcons")+Folder separator:K24:12))
	ASSERT:C1129(COMPONENT_Pathname ("host_actionIcons").platformPath=(_o_Pathname ("host_actionIcons")+Folder separator:K24:12))
	ASSERT:C1129(COMPONENT_Pathname ("host_formatters").platformPath=_o_Pathname ("host_formatters"))
	
End if 

ASSERT:C1129(COMPONENT_Pathname ("key").platformPath=_o_Pathname ("key"))
ASSERT:C1129(_o_env_userPath ("home")=env_userPathname ("home").platformPath)
ASSERT:C1129(_o_env_userPath ("home";True:C214)=env_userPathname ("home").path)
ASSERT:C1129(_o_env_userPath ("library")=env_userPathname ("library").platformPath)
ASSERT:C1129(_o_env_userPath ("library";True:C214)=env_userPathname ("library").path)
ASSERT:C1129(_o_env_userPath ("preferences")=env_userPathname ("preferences").platformPath)
ASSERT:C1129(_o_env_userPath ("preferences";True:C214)=env_userPathname ("preferences").path)
ASSERT:C1129(_o_env_userPath ("caches")=env_userPathname ("caches").platformPath)
ASSERT:C1129(_o_env_userPath ("caches";True:C214)=env_userPathname ("caches").path)
ASSERT:C1129(_o_env_userPath ("cache")=env_userPathname ("cache").platformPath)
ASSERT:C1129(_o_env_userPath ("cache";True:C214)=env_userPathname ("cache").path)
ASSERT:C1129(_o_env_userPath ("logs")=env_userPathname ("logs").platformPath)
ASSERT:C1129(_o_env_userPath ("logs";True:C214)=env_userPathname ("logs").path)
ASSERT:C1129(_o_env_userPath ("applicationSupport")=env_userPathname ("applicationSupport").platformPath)
ASSERT:C1129(_o_env_userPath ("applicationSupport";True:C214)=env_userPathname ("applicationSupport").path)
ASSERT:C1129(_o_env_userPath ("simulators")=env_userPathname ("simulators").platformPath)
ASSERT:C1129(_o_env_userPath ("simulators";True:C214)=env_userPathname ("simulators").path)
ASSERT:C1129(_o_env_userPath ("derivedData")=env_userPathname ("derivedData").platformPath)
ASSERT:C1129(_o_env_userPath ("derivedData";True:C214)=env_userPathname ("derivedData").path)
ASSERT:C1129(_o_env_userPath ("archives")=env_userPathname ("archives").platformPath)
ASSERT:C1129(_o_env_userPath ("archives";True:C214)=env_userPathname ("archives").path)

FINALLY 