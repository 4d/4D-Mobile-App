//%attributes = {}
C_TEXT:C284($t;$tt)

TRY 

  //ASSERT(COMPONENT_Pathname ("databasePreferences").platformPath=_o_Pathname ("databasePreferences"))
  //ASSERT(COMPONENT_Pathname ("projects").platformPath=_o_Pathname ("projects"))
  //ASSERT(COMPONENT_Pathname ("products").platformPath=_o_Pathname ("products"))
  //  //ASSERT(COMPONENT_Pathname ("dataSet").platformPath=_o_Pathname ("dataSet")) I think this entrypoint is no more used
  //ASSERT(COMPONENT_Pathname ("sdk").platformPath=_o_Pathname ("sdk"))
  //ASSERT(COMPONENT_Pathname ("project").platformPath=_o_Pathname ("project"))
  //ASSERT(COMPONENT_Pathname ("templates").platformPath=_o_Pathname ("templates"))
  //ASSERT(COMPONENT_Pathname ("scripts").platformPath=_o_Pathname ("scripts"))
  //ASSERT(COMPONENT_Pathname ("tableIcons").platformPath=(_o_Pathname ("tableIcons")+Folder separator))
  //ASSERT(COMPONENT_Pathname ("fieldIcons").platformPath=(_o_Pathname ("fieldIcons")+Folder separator))
  //ASSERT(COMPONENT_Pathname ("actionIcons").platformPath=(_o_Pathname ("actionIcons")+Folder separator))
  //ASSERT(COMPONENT_Pathname ("forms").platformPath=_o_Pathname ("forms"))
  //ASSERT(COMPONENT_Pathname ("listForms").platformPath=_o_Pathname ("listForms"))
  //ASSERT(COMPONENT_Pathname ("detailForms").platformPath=_o_Pathname ("detailForms"))
  //ASSERT(COMPONENT_Pathname ("navigationForms").platformPath=_o_Pathname ("navigationForms"))

  //ASSERT(COMPONENT_Pathname ("host").platformPath=_o_Pathname ("host"))

  //If (COMPONENT_Pathname ("host").exists)  //could not exists if the original of an alias is no more available

  //ASSERT(COMPONENT_Pathname ("host_forms").platformPath=_o_Pathname ("host_forms"))
  //ASSERT(COMPONENT_Pathname ("host_listForms").platformPath=_o_Pathname ("host_listForms"))
  //ASSERT(COMPONENT_Pathname ("host_detailForms").platformPath=_o_Pathname ("host_detailForms"))
  //ASSERT(COMPONENT_Pathname ("host_tableIcons").platformPath=(_o_Pathname ("host_tableIcons")+Folder separator))
  //ASSERT(COMPONENT_Pathname ("host_fieldIcons").platformPath=(_o_Pathname ("host_fieldIcons")+Folder separator))
  //ASSERT(COMPONENT_Pathname ("host_actionIcons").platformPath=(_o_Pathname ("host_actionIcons")+Folder separator))
  //ASSERT(COMPONENT_Pathname ("host_formatters").platformPath=_o_Pathname ("host_formatters"))

  //End if 

  //ASSERT(COMPONENT_Pathname ("key").platformPath=_o_Pathname ("key"))

  //ASSERT(_o_env_userPath ("home")=env_userPathname ("home").platformPath)
  //ASSERT(_o_env_userPath ("home";True)=env_userPathname ("home").path)
  //ASSERT(_o_env_userPath ("library")=env_userPathname ("library").platformPath)
  //ASSERT(_o_env_userPath ("library";True)=env_userPathname ("library").path)
  //ASSERT(_o_env_userPath ("preferences")=env_userPathname ("preferences").platformPath)
  //ASSERT(_o_env_userPath ("preferences";True)=env_userPathname ("preferences").path)
  //ASSERT(_o_env_userPath ("caches")=env_userPathname ("caches").platformPath)
  //ASSERT(_o_env_userPath ("caches";True)=env_userPathname ("caches").path)
  //ASSERT(_o_env_userPath ("cache")=env_userPathname ("cache").platformPath)
  //ASSERT(_o_env_userPath ("cache";True)=env_userPathname ("cache").path)
  //ASSERT(_o_env_userPath ("logs")=env_userPathname ("logs").platformPath)
  //ASSERT(_o_env_userPath ("logs";True)=env_userPathname ("logs").path)
  //ASSERT(_o_env_userPath ("applicationSupport")=env_userPathname ("applicationSupport").platformPath)
  //ASSERT(_o_env_userPath ("applicationSupport";True)=env_userPathname ("applicationSupport").path)
  //ASSERT(_o_env_userPath ("simulators")=env_userPathname ("simulators").platformPath)
  //ASSERT(_o_env_userPath ("simulators";True)=env_userPathname ("simulators").path)
  //ASSERT(_o_env_userPath ("derivedData")=env_userPathname ("derivedData").platformPath)
  //ASSERT(_o_env_userPath ("derivedData";True)=env_userPathname ("derivedData").path)
  //ASSERT(_o_env_userPath ("archives")=env_userPathname ("archives").platformPath)
  //ASSERT(_o_env_userPath ("archives";True)=env_userPathname ("archives").path)

  //COMPONENT_INIT 
  //$t:=_o_env_userPath ("cache")+".sdk"+Folder separator+commonValues.thirdParty
  //$tt:=env_userPathname ("cache").file(".sdk/"+commonValues.thirdParty).platformPath
  //ASSERT($t=$tt)
  //$t:=_o_env_userPath ("preferences")+"com.apple.iphonesimulator.plist"
  //$tt:=env_userPathname ("preferences").file("com.apple.iphonesimulator.plist").platformPath
  //ASSERT($t=$tt)

FINALLY 