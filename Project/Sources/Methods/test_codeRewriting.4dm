//%attributes = {}
C_OBJECT:C1216($o;$oo)

TRY 

  //================================
  // COMPONENT PATHNAMES
  //================================

$o:=path .projects()
ASSERT:C1129($o.platformPath=COMPONENT_Pathname ("projects").platformPath)

$o:=path .products()
ASSERT:C1129($o.platformPath=COMPONENT_Pathname ("products").platformPath)

$o:=path .sdk()
ASSERT:C1129($o.platformPath=COMPONENT_Pathname ("sdk").platformPath)
ASSERT:C1129($o.exists)

$o:=path .project()
ASSERT:C1129($o.platformPath=COMPONENT_Pathname ("project").platformPath)
ASSERT:C1129($o.exists)

$o:=path .templates()
ASSERT:C1129($o.platformPath=COMPONENT_Pathname ("templates").platformPath)
ASSERT:C1129($o.exists)

$o:=path .scripts()
ASSERT:C1129($o.platformPath=COMPONENT_Pathname ("scripts").platformPath)
ASSERT:C1129($o.exists)

$o:=path .tableIcons()
ASSERT:C1129($o.platformPath=COMPONENT_Pathname ("tableIcons").platformPath)
ASSERT:C1129($o.exists)

$o:=path .fieldIcons()
ASSERT:C1129($o.platformPath=COMPONENT_Pathname ("fieldIcons").platformPath)
ASSERT:C1129($o.exists)

$o:=path .actionIcons()
ASSERT:C1129($o.platformPath=COMPONENT_Pathname ("actionIcons").platformPath)
ASSERT:C1129($o.exists)

$o:=path .forms()
ASSERT:C1129($o.platformPath=COMPONENT_Pathname ("forms").platformPath)
ASSERT:C1129($o.exists)

$o:=path .listForms()
ASSERT:C1129($o.platformPath=COMPONENT_Pathname ("listForms").platformPath)
ASSERT:C1129($o.exists)

$o:=path .detailForms()
ASSERT:C1129($o.platformPath=COMPONENT_Pathname ("detailForms").platformPath)
ASSERT:C1129($o.exists)

$o:=path .navigationForms()
ASSERT:C1129($o.platformPath=COMPONENT_Pathname ("navigationForms").platformPath)
ASSERT:C1129($o.exists)

  //================================
  // HOST DATABASE PATHNAMES
  //================================

$o:=path .databasePreferences()
ASSERT:C1129($o.platformPath=COMPONENT_Pathname ("databasePreferences").platformPath)
ASSERT:C1129($o.exists)

$o:=path .key()
ASSERT:C1129($o.platformPath=COMPONENT_Pathname ("key").platformPath)

$o:=path .host()
ASSERT:C1129($o.platformPath=COMPONENT_Pathname ("host").platformPath)

$o:=path .hostForms()
ASSERT:C1129($o.platformPath=COMPONENT_Pathname ("host_forms").platformPath)

$o:=path .hostlistForms()
ASSERT:C1129($o.platformPath=COMPONENT_Pathname ("host_listForms").platformPath)

$o:=path .hostdetailForms()
ASSERT:C1129($o.platformPath=COMPONENT_Pathname ("host_detailForms").platformPath)

$o:=path .hostActionIcons()
ASSERT:C1129($o.platformPath=COMPONENT_Pathname ("host_actionIcons").platformPath)

$o:=path .hostFieldIcons()
ASSERT:C1129($o.platformPath=COMPONENT_Pathname ("host_fieldIcons").platformPath)

$o:=path .hostTableIcons()
ASSERT:C1129($o.platformPath=COMPONENT_Pathname ("host_tableIcons").platformPath)

$o:=path .hostFormatters()
ASSERT:C1129($o.platformPath=COMPONENT_Pathname ("host_formatters").platformPath)

/*

Class path

*/

$o:=cs:C1710.path.new()
ASSERT:C1129($o.projects().platformPath=COMPONENT_Pathname ("projects").platformPath)

ASSERT:C1129($o.products().platformPath=COMPONENT_Pathname ("products").platformPath)

$oo:=$o.sdk()
ASSERT:C1129($oo.platformPath=COMPONENT_Pathname ("sdk").platformPath)
ASSERT:C1129($oo.exists)

$o:=cs:C1710.path.new("sdk")
ASSERT:C1129($o.exists)

$oo:=$o.project()
ASSERT:C1129($oo.platformPath=COMPONENT_Pathname ("project").platformPath)
ASSERT:C1129($oo.exists)

$oo:=$o.templates()
ASSERT:C1129($oo.platformPath=COMPONENT_Pathname ("templates").platformPath)
ASSERT:C1129($oo.exists)

$oo:=$o.scripts()
ASSERT:C1129($oo.platformPath=COMPONENT_Pathname ("scripts").platformPath)
ASSERT:C1129($oo.exists)

$oo:=$o.tableIcons()
ASSERT:C1129($oo.platformPath=COMPONENT_Pathname ("tableIcons").platformPath)
ASSERT:C1129($oo.exists)

$oo:=$o.fieldIcons()
ASSERT:C1129($oo.platformPath=COMPONENT_Pathname ("fieldIcons").platformPath)
ASSERT:C1129($oo.exists)

$oo:=$o.actionIcons()
ASSERT:C1129($oo.platformPath=COMPONENT_Pathname ("actionIcons").platformPath)
ASSERT:C1129($oo.exists)

$oo:=$o.forms()
ASSERT:C1129($oo.platformPath=COMPONENT_Pathname ("forms").platformPath)
ASSERT:C1129($oo.exists)

$o:=cs:C1710.path.new("forms")
ASSERT:C1129($o.target.platformPath=COMPONENT_Pathname ("forms").platformPath)

$oo:=$o.listForms()
ASSERT:C1129($oo.platformPath=COMPONENT_Pathname ("listForms").platformPath)
ASSERT:C1129($oo.exists)

$oo:=$o.detailForms()
ASSERT:C1129($oo.platformPath=COMPONENT_Pathname ("detailForms").platformPath)
ASSERT:C1129($oo.exists)

$oo:=$o.navigationForms()
ASSERT:C1129($oo.platformPath=COMPONENT_Pathname ("navigationForms").platformPath)
ASSERT:C1129($oo.exists)

$oo:=$o.loginForms()
ASSERT:C1129($oo.exists)

$oo:=$o.databasePreferences()
ASSERT:C1129($oo.exists)

  // ASSERT(_o_env_userPath ("home")=env_userPathname ("home").platformPath)
  // ASSERT(_o_env_userPath ("home";True)=env_userPathname ("home").path)
  // ASSERT(_o_env_userPath ("library")=env_userPathname ("library").platformPath)
  // ASSERT(_o_env_userPath ("library";True)=env_userPathname ("library").path)
  // ASSERT(_o_env_userPath ("preferences")=env_userPathname ("preferences").platformPath)
  // ASSERT(_o_env_userPath ("preferences";True)=env_userPathname ("preferences").path)
  // ASSERT(_o_env_userPath ("caches")=env_userPathname ("caches").platformPath)
  // ASSERT(_o_env_userPath ("caches";True)=env_userPathname ("caches").path)
  // ASSERT(_o_env_userPath ("cache")=env_userPathname ("cache").platformPath)
  // ASSERT(_o_env_userPath ("cache";True)=env_userPathname ("cache").path)
  // ASSERT(_o_env_userPath ("logs")=env_userPathname ("logs").platformPath)
  // ASSERT(_o_env_userPath ("logs";True)=env_userPathname ("logs").path)
  // ASSERT(_o_env_userPath ("applicationSupport")=env_userPathname ("applicationSupport").platformPath)
  // ASSERT(_o_env_userPath ("applicationSupport";True)=env_userPathname ("applicationSupport").path)
  // ASSERT(_o_env_userPath ("simulators")=env_userPathname ("simulators").platformPath)
  // ASSERT(_o_env_userPath ("simulators";True)=env_userPathname ("simulators").path)
  // ASSERT(_o_env_userPath ("derivedData")=env_userPathname ("derivedData").platformPath)
  // ASSERT(_o_env_userPath ("derivedData";True)=env_userPathname ("derivedData").path)
  // ASSERT(_o_env_userPath ("archives")=env_userPathname ("archives").platformPath)
  // ASSERT(_o_env_userPath ("archives";True)=env_userPathname ("archives").path)

  // COMPONENT_INIT
  //$t:=_o_env_userPath ("cache")+".sdk"+Folder separator+commonValues.thirdParty
  //$tt:=env_userPathname ("cache").file(".sdk/"+commonValues.thirdParty).platformPath
  //ASSERT($t=$tt)
  //$t:=_o_env_userPath ("preferences")+"com.apple.iphonesimulator.plist"
  //$tt:=env_userPathname ("preferences").file("com.apple.iphonesimulator.plist").platformPath
  //ASSERT($t=$tt)

FINALLY 