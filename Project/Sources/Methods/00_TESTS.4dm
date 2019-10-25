//%attributes = {}
C_BOOLEAN:C305($b;$Boo_reset)
C_LONGINT:C283($l;$Lon_build;$Lon_error;$Lon_result;$Lon_type;$Lon_value)
C_LONGINT:C283($Lon_x)
C_REAL:C285($Num_;$r)
C_TEXT:C284($Dir_root;$t;$tt;$Txt_in;$Txt_ormula;$Txt_result)
C_OBJECT:C1216($file;$o;$Obj_formula;$Obj_new;$Obj_result;$Obj_target)
C_OBJECT:C1216($Obj_template;$oo;$ooo;$svg)
C_COLLECTION:C1488($c;$cc;$Col_2)

ARRAY TEXT:C222($tTxt_;0)

If (False:C215)
	SHOW ON DISK:C922(Folder:C1567(Temporary folder:C486;fk platform path:K87:2).platformPath)
End if 

COMPONENT_INIT 

Case of 
		
		  //________________________________________
	: (True:C214)
		
		$o:=_iw_Xcode 
		
		$file:=$o.defaultPath()
		$Obj_result:=$o.toolsPath()
		
		  //$o.openAppStore()
		
		  //________________________________________
	: (True:C214)
		
		$o:=class ("lep")
		$oo:=$o.constructor()
		
		$o:=lep ("blocking:false")
		$o.launch("open";"/Applications/Calculator.app")
		
		If (True:C214)
			
			$o.launch("kill";String:C10($o.pid))
			
		Else 
			
			$o.launch("osascript -e";"'quit app \"Calculator.app\"'")
			
		End if 
		
		$c:=Split string:C1554($o.launch("/bin/ls -l";"/Users").outputStream;"\n")
		
		$o.reset()
		$t:=$o.launch("ioreg -n IODisplayWrangler |grep -i IOPowerManagement").outputStream
		
		  //________________________________________
	: (True:C214)
		
		$t:=str ("").shuffle(5)
		$t:=str ("").shuffle(10)
		$t:=str ("").shuffle(15)
		$t:=str ("").shuffle(20)
		$t:=str ("").shuffle(30)
		$t:=str ("").shuffle(40)
		$t:=str .setText("Hello world").shuffle(100)
		$t:=str .setText("Note: if a value being appended is a collection, the elements of the collection will be appended.").shuffle(15)
		
		  //________________________________________
	: (True:C214)  // Unsandbox
		
		$o:=Folder:C1567(fk database folder:K87:14)
		$oo:=Folder:C1567($o.platformPath;fk platform path:K87:2)
		
		$ooo:=Folder:C1567(Folder:C1567(fk database folder:K87:14).platformPath;fk platform path:K87:2)
		
		  //________________________________________
	: (True:C214)
		
		$c:=New collection:C1472(1;2;3;4;5)
		$cc:=$c.slice($c.length-1)
		
		$o:=class ("str";"test")
		$oo:=$o.constructor()
		
		$c:=$o.distinctLetters()
		$o.setText("hello world")
		$t:=$o.lowerCamelCase()
		
		$o:=class ("svg";"test")
		$oo:=$o.constructor()
		$o.close()
		
		$o:=class ("str";"test")
		$oo:=$o.constructor()
		
		$o.setText("Hello world")
		$t:=$o.insert(" great";6).value
		$oo:=$o.insert("Vincent";7;MAXLONG:K35:2)
		
		  //________________________________________
	: (True:C214)
		
		$o:=menu .editMenu().popup()
		
		  //________________________________________
	: (True:C214)
		
		$svg:=svg ("load";File:C1566("/RESOURCES/templates/form/list/Vertical Cards/template.svg"))
		$svg.savePicture(Folder:C1567(fk desktop folder:K87:19).file("DEV/export.png"))
		
		  //________________________________________
	: (True:C214)
		
		$t:=File:C1566("/RESOURCES/queryWidget.svg").getText()
		
		PROCESS 4D TAGS:C816($t;$t;ui.selectedFillColor;Get localized string:C991("fields");Get localized string:C991("comparators");Get localized string:C991("operators");"⬇")
		
		$svg:=svg ("parse";New object:C1471(\
			"variable";$t))
		$svg.showInViewer()
		$svg.close()
		
		  //________________________________________
	: (True:C214)
		
		$svg:=svg ("load";File:C1566("/RESOURCES/templates/form/list/Vertical Cards/template.svg"))
		$t:=$svg.findById("cookery")
		$svg.showInViewer()
		$svg.close()
		
		  //________________________________________
	: (True:C214)
		
		$o:=db .exposedDatastore()
		$o:=db ("object;blob").exposedDatastore()
		
		$o:=db ("object;blob")
		
		$oo:=$o.table("Commands")
		$oo:=$o.table(5)
		$oo:=$o.table(55)
		$oo:=$o.table("hello")
		$oo:=$o.table("Table_1")
		$oo:=$o.table("Table_3")
		
		$oo:=$o.field("Commands";4)
		$oo:=$o.field("Commands";"theme")
		
		  //________________________________________
	: (True:C214)
		
		$c:=New collection:C1472(Get 4D folder:C485(Current resources folder:K5:16);Get 4D folder:C485(Database folder:K5:14))
		
		$c:=$c.map("col_formula";"$1.result:=Convert path system to POSIX:C1106($1.value)")
		
		$c:=New collection:C1472(Get 4D folder:C485(Current resources folder:K5:16);Get 4D folder:C485(Database folder:K5:14))
		$cc:=$c.map("col_method";Formula:C1597($1.result:=Convert path system to POSIX:C1106($1.value)))
		
		  //________________________________________
	: (True:C214)
		
		$c:=New collection:C1472(New object:C1471(\
			"min";5);\
			"mandatory")
		
		$l:=$c.indexOf("mandatory")
		$l:=$c.countValues("mandatory")
		$b:=($c.countValues("mandatory")>0)
		
		$cc:=$c.extract("min")
		$b:=($cc.length>0)
		
		$l:=$c.count("min")
		$b:=($l>0)
		
		  //________________________________________
	: (True:C214)
		
		$o:=New object:C1471(\
			"pointer";$r)
		
		If ($o.pointer#Null:C1517)
			
			If (Value type:C1509($o.pointer)=Is pointer:K8:14)
				
				ASSERT:C1129(Is nil pointer:C315($o.pointer))
				
			End if 
		End if 
		
		$o.pointer:=""
		
		If ($o.pointer#Null:C1517)
			
			If (Value type:C1509($o.pointer)=Is pointer:K8:14)
				
				ASSERT:C1129(Is nil pointer:C315($o.pointer))
				
			End if 
		End if 
		
		$o.pointer:=->$t
		
		If ($o.pointer#Null:C1517)
			
			If (Value type:C1509($o.pointer)=Is pointer:K8:14)
				
				ASSERT:C1129(Not:C34(Is nil pointer:C315($o.pointer)))
				
			End if 
		End if 
		
		  //________________________________________
	: (True:C214)
		
		If (False:C215)
			$o:=New object:C1471
			
			ASSERT:C1129(Not:C34(Bool:C1537($o.error)))  // False
			$o.error:="Hello world"
			ASSERT:C1129(Bool:C1537($o.error))  // False (should be True)
			
		Else 
			
			  //%W-518.7
			  //ASSERT(Undefined($o))
			ASSERT:C1129($o=Null:C1517)
			$o:=New object:C1471
			ASSERT:C1129(Not:C34(Undefined:C82($o)))
			
			ASSERT:C1129(Undefined:C82($o.error))  // True
			$o.error:="Hello world"
			ASSERT:C1129(Not:C34(Undefined:C82($o.error)))  // False
			  //%W+518.7
		End if 
		
		  //________________________________________
	: (False:C215)  // Create themes
		
		For each ($o;ds:C1482.Commands.all())
			
			$ooo:=ds:C1482.Themes.query("Name = :1";$o.themeName)
			
			If ($ooo.length=0)
				
				$oo:=ds:C1482.Themes.new()
				$oo.Name:=$o.themeName
				$Obj_result:=$oo.save()
				
				$o.themeID:=$oo.ID
				
			Else 
				
				$o.themeID:=$ooo[0].ID
				
			End if 
			
			$o.save()
			
		End for each 
		
		  //________________________________________
	: (False:C215)
		
		$oo:=Folder:C1567(_o_env_System_path ("caches");fk platform path:K87:2).folder("com.4d.mobile").folder("sdk")
		$o:=Folder:C1567("/Library/Caches/com.4d.mobile/sdk")
		ASSERT:C1129($oo.platformPath=$o.platformPath)
		
		$t:=Convert path POSIX to system:C1107(_o_env_System_path ("caches";True:C214)+"com.4d.mobile/sdk/")
		$tt:=Folder:C1567("/Library/Caches/com.4d.mobile/sdk").platformPath
		ASSERT:C1129($t=$tt)
		
		  //________________________________________
	: (False:C215)
		
		GET FIELD PROPERTIES:C258(5;11;$Lon_type)
		ASSERT:C1129($Lon_type=_o_Is float:K8:26)
		
		  //________________________________________
	: (False:C215)
		
		  //$t:=Get 4D folder(Current resources folder)+"sdk"+Folder separator+"Versions"+Folder separator  // (unzip TRMosaicLayout.zip to test)
		  //$File_:=$t+"Carthage:Checkouts:TRMosaicLayout:_Pods.xcodeproj"  // a broken symbolic link
		  //$Boo_reset:=_o_doc_isAlias ($File_)
		
		$Boo_reset:=Folder:C1567(fk resources folder:K87:11).folder("sdk").folder("Versions").folder("Carthage").folder("Checkouts").folder("TRMosaicLayout").file("_Pods.xcodeproj").isAlias
		
		  //________________________________________
	: (True:C214)
		
		$o:=mobileUnit ("testSuites")
		
		  //________________________________________
	: (True:C214)  // Volume from path
		
		$t:=Get 4D folder:C485(Current resources folder:K5:16)+"Images"+Folder separator:K24:12+"action.png"
		
		$t:="Z:\\Bases_Bugs\\Andrei\\ACI0094320"
		
		If (False:C215)
			
			Repeat 
				
				$t:=Path to object:C1547($t).parentFolder
				
				If (Length:C16($t)>0)
					
					$t:=$t
					
				End if 
			Until (Length:C16($t)=0)
			
			$t:=Delete string:C232($t;Length:C16($t);1)
			
		Else 
			
			$t:=Split string:C1554($t;Folder separator:K24:12)[0]
		End if 
		
		  //________________________________________
	: (False:C215)
		
		$o:=Path to object:C1547(Get 4D folder:C485(Database folder:K5:14;*))
		
		$Dir_root:=Object to path:C1548(New object:C1471(\
			"name";$o.name+" Project";\
			"isFolder";True:C214;\
			"parentFolder";$o.parentFolder))
		
		doc_EMPTY_FOLDER ($Dir_root;New collection:C1472(".git";".gitattributes";".DS_Store"))
		
		  //________________________________________
	: (False:C215)
		
		APPEND TO ARRAY:C911($tTxt_;"method1")
		APPEND TO ARRAY:C911($tTxt_;"Unit_test")
		
		If (True:C214)
			
			$c:=New collection:C1472
			ARRAY TO COLLECTION:C1563($c;$tTxt_;"name")
			
			$c:=$c.query("name != 'unit_@'")
			
			COLLECTION TO ARRAY:C1562($c;$tTxt_)
			
		Else 
			
			Repeat 
				
				$Lon_x:=Find in array:C230($tTxt_;"unit_@")
				
				If ($Lon_x>0)
					
					DELETE FROM ARRAY:C228($tTxt_;$lon_x)
					
				End if 
			Until ($Lon_x=-1)
		End if 
		
		  //________________________________________
	: (False:C215)  //"mobileapp/$catalog/"
		
		$Lon_error:=HTTP Request:C1158(HTTP GET method:K71:1;Rest (New object:C1471(\
			"action";"devurl";\
			"handler";"mobileapp")).url;\
			"";$Txt_result)
		
		  //________________________________________
	: (False:C215)
		
		$Obj_result:=Rest (New object:C1471(\
			"action";"url";\
			"url";"http:// Localhost"))
		$Obj_result:=Rest (New object:C1471(\
			"action";"url";\
			"url";"http://localhost/"))
		$Obj_result:=Rest (New object:C1471(\
			"action";"url";\
			"url";"http://localhost/rest"))
		$Obj_result:=Rest (New object:C1471(\
			"action";"url";\
			"url";"http://localhost/rest/"))
		
		  //________________________________________
	: (False:C215)
		
		$Obj_result:=net (New object:C1471(\
			"action";"resolve";\
			"url";"fr.wikipedia.org"))
		
		If ($Obj_result.success)
			
			$Obj_result.ping:=net (New object:C1471(\
				"action";"ping";\
				"url";$Obj_result.ip))
			
		End if 
		
		$Obj_result:=net (New object:C1471(\
			"action";"ping";\
			"url";"127.0.0.1:8880"))
		
		$Obj_result:=net (New object:C1471(\
			"action";"ping";\
			"url";"localhost"))
		$Obj_result:=net (New object:C1471(\
			"action";"resolve";\
			"url";"localhost"))
		
		  //$Obj_result.ping:=server (New object("action";"ping";"url";"www.fr.wikipedia.org"))
		  //$Obj_result.ping:=server (New object("action";"ping";"url";"http://www.fr.wikipedia.org:80/"))
		$Obj_result.ping:=net (New object:C1471(\
			"action";"ping";\
			"url";"testbugs.4d.fr"))
		
		  //________________________________________
	: (True:C214)
		
		ASSERT:C1129(Xcode (New object:C1471(\
			"action";"xbuild-version")).success)
		
		  //________________________________________
	: (True:C214)
		
		$o:=New object:C1471
		$Lon_type:=Value type:C1509($o.target)
		ASSERT:C1129($Lon_type=Is undefined:K8:13)
		
		  //________________________________________
	: (True:C214)
		
		$t:=JSON Parse:C1218("\"toto\"")  // ;Is text)
		$Num_:=JSON Parse:C1218(String:C10(Pi:K30:1;"&xml");Is real:K8:4)
		
		  //________________________________________
	: (True:C214)
		
		$Obj_formula:=Formula:C1597(1+2)
		
		$Obj_new:=New object:C1471(\
			"f";$Obj_formula)
		
		$Lon_result:=$Obj_new.f()  // returns 3
		
		$Lon_value:=10
		$Obj_new:=New object:C1471(\
			"f";Formula:C1597($Lon_value))
		$Lon_value:=20
		
		$Lon_result:=$Obj_new.f()  // returns 10
		
		  //$Obj_new:=New object("formula";New formula($1+$2))
		$Obj_new:=New object:C1471(\
			"f";Formula from string:C1601("$1+$2"))
		$Lon_result:=$Obj_new.f(10;20)  // returns 30
		
		$Txt_ormula:=Request:C163("Please type a formula")
		
		If (ok=1)
			
			$Obj_formula:=Formula from string:C1601($Txt_ormula)
			ALERT:C41("Result = "+String:C10($Obj_formula.call()))
			
		End if 
		
		  //$Obj_formula:=New formula from string(Uppercase($1))
		$Obj_formula:=Formula from string:C1601("Uppercase:C13($1)")
		$Txt_result:=$Obj_formula.call(Null:C1517;"hello")  // returns "HELLO"
		
		$Obj_new:=New object:C1471(\
			"value";50)
		$Obj_formula:=Formula:C1597(This:C1470.value*2)
		$Lon_result:=$Obj_formula.call($Obj_new)  // returns 100
		
		  //________________________________________
	: (True:C214)
		
		$o:=formatters (New object:C1471(\
			"action";"getByName"))
		
		  //________________________________________
	: (True:C214)
		
		$t:="Hello .world"
		
		$Boo_reset:=$t%"world"  // True
		$Boo_reset:=$t%"Hello"  // True
		$Boo_reset:=$t%".world"  // False
		$Boo_reset:=$t%"@.world"  // False
		
		  //________________________________________
	: (True:C214)
		
		  //$Obj_buffer:=xml_fileToObject (Get 4D folder(Database folder)+"Info.plist")
		$Lon_build:=Num:C11(xml_fileToObject (Get 4D folder:C485(Database folder:K5:14)+"Info.plist").value.plist.dict.string[5].$)
		
		  //________________________________________
	: (True:C214)
		
		$t:=Parse formula:C1576("CALL FORM($Obj_in.caller;\"project_BUILD\";$Obj_in)";4)
		
		$oo:=Build Exposed Datastore:C1598
		$o:=Formula:C1597(project_BUILD ($oo))
		OB GET PROPERTY NAMES:C1232($o;$tTxt_)
		
		  //________________________________________
	: (True:C214)
		
		$Obj_template:=New object:C1471
		$Obj_template.server:=New object:C1471
		$Obj_template.server.authentication:=New object:C1471
		$Obj_template.server.urls:=New object:C1471
		$Obj_template.server.urls.production:=""
		
		$Obj_target:=New object:C1471
		$Obj_target.server:=New object:C1471
		$Obj_target.server.urls:=New object:C1471
		$Obj_target.server.urls.test:="localhost"
		
		ob_MERGE ($Obj_target;$Obj_template)
		
		  //$Obj_template:=New object
		  //$Obj_template.server:=New object
		  //$Obj_template.server.authentication:=New object
		  //$Obj_template.server.urls:=New object
		  //$Obj_template.server.urls.production:=""
		
		$o:=New object:C1471
		$o.server:=New object:C1471
		$o.server.urls:=New object:C1471
		$o.server.urls.test:="localhost"
		
		$Obj_new:=ob_deepMerge ($Obj_template;$o)
		
		  //________________________________________
	: (True:C214)
		
		$Col_2:=New collection:C1472("manigest.json";New object:C1471(\
			"Sources";New collection:C1472("azeaze";\
			"azeazaze";New object:C1471("Forms";New collection:C1472()))))
		$c:=findFirstPathComponentInCatalog ($Col_2)
		
		ALERT:C41(JSON Stringify:C1217($c))
		
		  //________________________________________
	: (True:C214)
		
		$t:="Bundle 4 Dé ö aze äapp ?"
		
		Rgx_SubstituteText ("[ÂÃÄÅ]";"A";->$t;0)
		Rgx_SubstituteText ("[àáâãäå]";"a";->$t;0)
		Rgx_SubstituteText ("[ÈÉÊË]";"E";->$t;0)
		Rgx_SubstituteText ("[èéêë]";"e";->$t;0)
		Rgx_SubstituteText ("[ÌÍÎÏ]";"I";->$t;0)
		Rgx_SubstituteText ("[ìíîï]";"i";->$t;0)
		Rgx_SubstituteText ("[ÒÓÔÕÖ]";"O";->$t;0)
		Rgx_SubstituteText ("[ðñòóôõö]";"o";->$t;0)
		Rgx_SubstituteText ("[ÙÚÛÜ]";"U";->$t;0)
		Rgx_SubstituteText ("[ùúûü]";"u";->$t;0)
		
		$Lon_error:=Rgx_SubstituteText ("[^a-zA-Z0-9]";"-";->$t;0)
		
		ALERT:C41($t)
		
		  //________________________________________
	: (True:C214)
		
		$Txt_in:=formatString ("label";"Copy_of_commands")
		$Txt_in:=formatString ("label";"Copy of commands")
		$Txt_in:=formatString ("label";"CopyOfCommands")
		$Txt_in:=formatString ("label";"theDescription")
		
		  //________________________________________
End case 