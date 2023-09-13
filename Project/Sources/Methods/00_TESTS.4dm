//%attributes = {}
var $Num_; $r : Real
var $node; $pattern; $root; $t; $tt; $Txt_in; $Txt_ormula; $Txt_result : Text
var $b; $Boo_reset : Boolean
var $i; $index; $l; $Lon_error; $Lon_result; $Lon_type; $Lon_value; $Lon_x : Integer
var $Gmt_timeGMT : Time
var $null : Variant
var $file; $folder; $o; $o1; $o2; $Obj_formula; $Obj_new; $result; $Obj_target; $Obj_template : Object
var $zip : Object
var $c; $c1; $Col_2; $cUserdCommands : Collection
var $error : cs:C1710.error

ARRAY TEXT:C222($tTxt_; 0)

If (False:C215)
	SHOW ON DISK:C922(Folder:C1567(Temporary folder:C486; fk platform path:K87:2).platformPath)
End if 

COMPILER_COMPONENT

Case of 
		
		//________________________________________
	: (True:C214)
		
		var $regex : cs:C1710.regex
		
		$regex:=cs:C1710.regex.new("Bundle 4 Dé ö aze äapp ?")
		$t:=$regex.setPattern("[ÂÃÄÅ]").substitute("A")
		$t:=$regex.setTarget($t).setPattern("[àáâãäå]").substitute("a")
		$t:=$regex.setTarget($t).setPattern("[ÈÉÊË]").substitute("E")
		$t:=$regex.setTarget($t).setPattern("[èéêë]").substitute("e")
		$t:=$regex.setTarget($t).setPattern("[ÌÍÎÏ]").substitute("I")
		$t:=$regex.setTarget($t).setPattern("[ìíîï]").substitute("i")
		$t:=$regex.setTarget($t).setPattern("[ÒÓÔÕÖ]").substitute("O")
		$t:=$regex.setTarget($t).setPattern("[ðñòóôõö]").substitute("o")
		$t:=$regex.setTarget($t).setPattern("[ÙÚÛÜ]").substitute("U")
		$t:=$regex.setTarget($t).setPattern("[ùúûü]").substitute("u")
		$t:=$regex.setTarget($t).setPattern("[^a-zA-Z0-9]").substitute("-")
		
		//________________________________________
	: (True:C214)
		
		$t:=Select document:C905(Get 4D folder:C485(MobileApps folder:K5:47; *); "mobileapp"; Get localized string:C991("selectTheKeyFile"); Use sheet window:K24:11+Package open:K24:8)
		
		If (Bool:C1537(OK))
			
			DOCUMENT:=cs:C1710.doc.new(File:C1566(DOCUMENT; fk platform path:K87:2)).sandBoxed
			
		End if 
		
		//________________________________________
	: (True:C214)
		
		var $dateTime : cs:C1710.dateTime
		$dateTime:=cs:C1710.dateTime.new()
		
		//%W-550.2
		$t:=$dateTime.stamp()
		$t:=$dateTime.stamp(!1958-08-08!)
		$t:=$dateTime.stamp(!1958-08-08!; ?12:10:30?)
		
		//%W+550.2
		
		//________________________________________
	: (True:C214)
		
		var $status : Object
		var $web : 4D:C1709.WebServer
		
		$web:=WEB Server:C1674(Web server host database:K73:31)
		
		If (Not:C34($web.isRunning))
			
/* START TRAPPING ERRORS */$error:=cs:C1710.error.new("capture")
			$status:=$web.start()
/* STOP TRAPPING ERRORS */$error.release()
			
		Else 
			
			// Already started
			$status:=New object:C1471(\
				"success"; True:C214)
			
		End if 
		
		If ($status.success)
			
			// 👍
			
		Else 
			
			var $errorMessage : Text
			$errorMessage:=$status.errors[0].message
			
		End if 
		
		//________________________________________
	: (True:C214)
		
		$o:=ds:C1482.str("hello world")
		
		//________________________________________
	: (True:C214)
		
		$folder:=Folder:C1567(Application file:C491; fk platform path:K87:2)
		
		If (Is macOS:C1572)
			
			$folder:=$folder.folder("Contents")
			
		End if 
		
		$file:=$folder.file("Resources/gram.4dsyntax")
		
		$c:=Split string:C1554($file.getText(); "\r"; sk trim spaces:K86:2)
		
		$o:=New object:C1471
		
		For ($i; 1; $c.length; 1)
			
			$t:=Command name:C538($i)
			
			If (Length:C16($t)#0)\
				 & ($t#"_4D")
				
				$o[String:C10($i)]:=New object:C1471(\
					"name"; $t; \
					"count"; 0)
				
			End if 
		End for 
		
		METHOD GET PATHS:C1163(Path all objects:K72:16; $tTxt_)
		$pattern:="(([[:letter:][_]][[:letter:][:number:][. _]]+(?<![. ])):C(\\d{1,4}))"
		$cUserdCommands:=New collection:C1472
		
		For ($i; 1; Size of array:C274($tTxt_); 1)
			
			If (Current method path:C1201#$tTxt_{$i})
				
				METHOD GET CODE:C1190($tTxt_{$i}; DOCUMENT; Code with tokens:K72:18)
				
				//For each ($tt; Split string(DOCUMENT; "\r"; sk trim spaces).shift())
				
				For each ($tt; Split string:C1554(DOCUMENT; "\r"; sk trim spaces:K86:2))  // .shift())
					
					Case of 
							
							//________________________________________
						: (Match regex:C1019("\\s*"; $tt))
							
							//________________________________________
						: (Match regex:C1019("^//.*"; $tt))
							
							//________________________________________
						Else 
							
							ARRAY LONGINT:C221($tLon_position; 0x0000)
							ARRAY LONGINT:C221($tLon_length; 0x0000)
							$index:=1
							
							While (Match regex:C1019($pattern; $tt; $index; $tLon_position; $tLon_length))
								
								$t:=Substring:C12($tt; $tLon_position{3}; $tLon_length{3})
								
								If ($o[$t]#Null:C1517)
									
									If ($o[$t].name=Substring:C12($tt; $tLon_position{2}; $tLon_length{2}))
										
										If ($o[$t].count=0)
											
											$cUserdCommands.push($o[$t])
											
										End if 
										
										$o[$t].count:=$o[$t].count+1
										
									End if 
								End if 
								
								$index:=$tLon_position{1}+$tLon_length{1}
								
							End while 
							
							//________________________________________
					End case 
				End for each 
			End if 
		End for 
		
		$cUserdCommands:=$cUserdCommands.orderBy("count desc")
		
		$c:=New collection:C1472
		
		For each ($o; $cUserdCommands)
			
			//$ratio:=""  //"\t"+string(100*$o.count/$total)
			$c.push($o.name+"\t"+String:C10($o.count))  //+$ratio)
			
		End for each 
		
		SET TEXT TO PASTEBOARD:C523($c.join("\r"))
		
		//________________________________________
	: (True:C214)
		
		$o:=cs:C1710.color.new("rgb(212,143,69)").rgb
		
		//________________________________________
	: (True:C214)
		
		$error:=cs:C1710.error.new("capture")
		
		Formula from string:C1601("$b:=true").call()
		
		If ($error.noError())
			
			// <NOTHING MORE TO DO>
			
		Else 
			
			BEEP:C151
			
			$o1:=$error.lastError()
			
		End if 
		
		$error.release()
		
		//________________________________________
	: (True:C214)
		
		$o:=Get system info:C1571
		
		//________________________________________
	: (True:C214)
		
		var $studio : cs:C1710.studio
		$studio:=cs:C1710.studio.new()
		$studio.installHAXM()
		
		//________________________________________
	: (True:C214)
		
		//%W-550.2
		$file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file("Uninstall.txt")
		$file.delete()
		
		$o:=cs:C1710.lep.new()
		$o.launch("reg export HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall "+$file.platformPath)
		
		If ($o.success)
			
			$t:=$file.getText()
			$file.delete()
			
			ARRAY LONGINT:C221($pos; 0)
			ARRAY LONGINT:C221($len; 0)
			
			If (Match regex:C1019("(?m-si)\"DisplayName\"=\"Android Studio\"\\r\\n\"DisplayVersion\"=\"(4.1)\"(?:\\r\\n\"[^\"]*\"=\"[^\"]*\")*\\r\\n\"Displ"+\
				"ayIcon\"=\"([^\"]*)\""; $t; 1; $pos; $len))
				
				var $version; $path : Text
				$version:=Substring:C12($t; $pos{1}; $len{1})
				$path:=Substring:C12($t; $pos{2}; $len{2})
				
			End if 
		End if 
		
		//%W+550.2
		
		//________________________________________
	: (True:C214)
		
		$o:=cs:C1710.env.new().startupDisk()
		$t:=Convert path POSIX to system:C1107("/users/"+Get system info:C1571.userName+"/")
		
		//________________________________________
	: (False:C215)
		
		var $lep : cs:C1710.lep
		$lep:=cs:C1710.lep.new()
		
		$lep.asynchronous().launch("open"; "/Applications/Pages.app")
		
		If (False:C215)
			
			$lep.launch("kill"; String:C10($lep.pid))
			
		Else 
			
			$lep.launch("osascript -e"; "'quit app \"Calculator.app\"'")
			
		End if 
		
		$lep.launch("/bin/ls -l"; "/Users")
		$c:=Split string:C1554(String:C10($lep.outputStream); "\n")
		
		$lep.reset()
		$lep.launch("ioreg -n IODisplayWrangler |grep -i IOPowerManagement")
		$t:=$lep.outputStream
		
		//________________________________________
	: (True:C214)
		
		$c:=New collection:C1472("target"; "left"; "top"; "width"; "height"; "codec")
		$c1:=New collection:C1472("target"; "left"; "top"; "width"; "height"; "codec"; "hello"; "world")
		
		For each ($t; $c)
			
			If ($c1.indexOf($t)#-1)
				
				$c1:=$c1.remove($c1.indexOf($t))
				
			End if 
		End for each 
		
		//________________________________________
	: (True:C214)
		
		$o:=Folder:C1567("/RESOURCES")
		
		$result:=OB Class:C1730($o)
		
		$b:=OB Instance of:C1731($o; $result)
		
		$o:=cs:C1710.formObject.new("toto")
		$result:=OB Class:C1730($o)
		$b:=OB Instance of:C1731($o; cs:C1710.formObject)
		
		//________________________________________
	: (True:C214)
		
		$Gmt_timeGMT:=Time:C179(Replace string:C233(Delete string:C232(String:C10(Current date:C33; ISO date GMT:K1:10; Current time:C178); 1; 11); "Z"; ""))
		
		//________________________________________
	: (True:C214)
		
		$root:=DOM Create XML Ref:C861("root")
		
		$node:=DOM Create XML element:C865($root; "element"; \
			"class"; "test")
		$node:=DOM Create XML element:C865($root; "element"; \
			"class"; "blank test")
		$node:=DOM Create XML element:C865($root; "element")
		$node:=DOM Create XML element:C865($root; "element"; \
			"class"; "blank test dark")
		
		// Select elements with attribute "class" strictly equal to "test"
		$tTxt_{0}:=DOM Find XML element:C864($root; "element[@class='test']"; $tTxt_)
		
		// Select elements with the attribute "class" whatever its content
		$tTxt_{0}:=DOM Find XML element:C864($root; "element[@class]"; $tTxt_)
		
		// Select all first level elements
		$tTxt_{0}:=DOM Find XML element:C864($root; "*"; $tTxt_)
		
		DOM EXPORT TO VAR:C863($root; $t)
		DOM CLOSE XML:C722($root)
		
		Folder:C1567(fk desktop folder:K87:19).file("DEV/test.xml").setText($t)
		
		//________________________________________
	: (False:C215)
		
		$o:=cs:C1710.tmpl.new("Blank form"; "detail")
		
		$file:=Folder:C1567(fk desktop folder:K87:19).file("DEV/test.xml")
		
		//________________________________________
	: (True:C214)
		
		$root:=DOM Create XML Ref:C861("root")
		
		$t:=DOM Create XML element:C865($root; "g")
		
		$node:=DOM Create XML element:C865($t; "element1")
		$node:=DOM Create XML element:C865($t; "element2")
		$node:=DOM Create XML element:C865($t; "element3")
		$node:=DOM Create XML element:C865($t; "element4")
		
		DOM EXPORT TO VAR:C863($root; $t)
		DOM CLOSE XML:C722($root)
		
		Folder:C1567(fk desktop folder:K87:19).file("DEV/test.xml").setText($t)
		
		//________________________________________
	: (True:C214)
		
		/// Volumes/Passport 500/Perforce/vincent.delachaux_MBP/4eDimension/main/4DComponents/Internal User Components/4D Mobile App/Resources/templates/form/detail/Blank Form/template.svg
		
		$file:=File:C1566("/RESOURCES/templates/form/detail/Blank Form/template.svg")
		PROCESS 4D TAGS:C816($file.getText(); $t)
		$root:=DOM Parse XML variable:C720($t)
		
		If (OK=1)
			
			$node:=DOM Find XML element:C864($root; "//g[@class='background']")
			
			DOM CLOSE XML:C722($root)
			
		End if 
		
		//________________________________________
	: (True:C214)
		
		$Txt_in:=formatString("label"; "t_Copy_of_commands_2")
		$Txt_in:=formatString("label"; "デフォルトのアイコンを使用してプロジェクトを修復しますか?")
		$Txt_in:=formatString("label"; "CopyOfCommandsT")
		$Txt_in:=formatString("label"; "theDescription_t")
		
		//________________________________________
	: (True:C214)
		
		$o:=New object:C1471
		
		If ($null=Null:C1517)
			
			$o:=$null
			
		End if 
		
		//________________________________________
	: (False:C215)
		
		$file:=Folder:C1567(fk desktop folder:K87:19).file("load.html")
		$folder:=Folder:C1567(fk desktop folder:K87:19).file("DEV/test.zip")
		$zip:=ZIP Create archive:C1640($file; $folder)
		
		//$zip:=ZIP Read archive($folder)
		
		//$c:=New collection
		//For each ($o;$zip.root.files())
		
		//$c.push($o)
		
		// End for each
		
		//$o:=New object()
		//$o.files:=$c
		
		//$zip:=ZIP Create archive($o;$folder)
		
		// This command list all loaded component with path
		//$c:=WEB Servers list
		
		//________________________________________
	: (False:C215)  // Unsandbox
		
		$o:=Folder:C1567(fk database folder:K87:14)
		$o1:=Folder:C1567($o.platformPath; fk platform path:K87:2)
		
		$o2:=Folder:C1567(Folder:C1567(fk database folder:K87:14).platformPath; fk platform path:K87:2)
		
		//________________________________________
	: (True:C214)
		
		$c:=New collection:C1472(New object:C1471(\
			"min"; 5); \
			"mandatory")
		
		$l:=$c.indexOf("mandatory")
		$l:=$c.countValues("mandatory")
		$b:=($c.countValues("mandatory")>0)
		
		$c1:=$c.extract("min")
		$b:=($c1.length>0)
		
		$l:=$c.count("min")
		$b:=($l>0)
		
		//________________________________________
	: (True:C214)
		
		$o:=New object:C1471(\
			"pointer"; $r)
		
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
		
		For each ($o; ds:C1482["Commands"].all())
			
			$o2:=ds:C1482["Themes"].query("Name = :1"; $o.themeName)
			
			If ($o2.length=0)
				
				$o1:=ds:C1482["Themes"].new()
				$o1.Name:=$o.themeName
				$result:=$o1.save()
				
				$o.themeID:=$o1.ID
				
			Else 
				
				$o.themeID:=$o2[0].ID
				
			End if 
			
		End for each 
		
		//________________________________________
	: (False:C215)
		
		GET FIELD PROPERTIES:C258(5; 11; $Lon_type)
		ASSERT:C1129($Lon_type=_o_Is float:K8:26)
		
		//________________________________________
	: (False:C215)
		
		//$t:=Get 4D folder(Current resources folder)+"sdk"+Folder separator+"Versions"+Folder separator  // (unzip TRMosaicLayout.zip to test)
		//$File_:=$t+"Carthage:Checkouts:TRMosaicLayout:_Pods.xcodeproj"  // A broken symbolic link
		//$Boo_reset:=_o_doc_isAlias ($File_)
		
		$Boo_reset:=Folder:C1567(fk resources folder:K87:11).file("sdk/Versions/Carthage/Checkouts/TRMosaicLayout/_Pods.xcodeproj").isAlias
		
		//________________________________________
	: (True:C214)
		
		$o:=mobileUnit("testSuites")
		
		//________________________________________
	: (True:C214)  // Volume from path
		
		$t:=Get 4D folder:C485(Current resources folder:K5:16)+"images"+Folder separator:K24:12+"action.png"
		
		$t:="Z:\\Bases_Bugs\\Andrei\\ACI0094320"
		
		If (False:C215)
			
			Repeat 
				
				$t:=Path to object:C1547($t).parentFolder
				
				If (Length:C16($t)>0)
					
					$t:=$t
					
				End if 
			Until (Length:C16($t)=0)
			
			$t:=Delete string:C232($t; Length:C16($t); 1)
			
		Else 
			
			$t:=Split string:C1554($t; Folder separator:K24:12)[0]
		End if 
		
		//________________________________________
	: (False:C215)
		
		APPEND TO ARRAY:C911($tTxt_; "method1")
		APPEND TO ARRAY:C911($tTxt_; "Unit_test")
		
		If (True:C214)
			
			$c:=New collection:C1472
			ARRAY TO COLLECTION:C1563($c; $tTxt_; "name")
			
			$c:=$c.query("name != 'unit_@'")
			
			COLLECTION TO ARRAY:C1562($c; $tTxt_)
			
		Else 
			
			Repeat 
				
				$Lon_x:=Find in array:C230($tTxt_; "unit_@")
				
				If ($Lon_x>0)
					
					DELETE FROM ARRAY:C228($tTxt_; $lon_x)
					
				End if 
			Until ($Lon_x=-1)
		End if 
		
		//________________________________________
	: (False:C215)  //"mobileapp/$catalog/"
		
		$Lon_error:=HTTP Request:C1158(HTTP GET method:K71:1; Rest(New object:C1471(\
			"action"; "devurl"; \
			"handler"; "mobileapp")).url; \
			""; $Txt_result)
		
		//________________________________________
	: (False:C215)
		
		$result:=Rest(New object:C1471(\
			"action"; "url"; \
			"url"; "http:// Localhost"))
		$result:=Rest(New object:C1471(\
			"action"; "url"; \
			"url"; "http://localhost/"))
		$result:=Rest(New object:C1471(\
			"action"; "url"; \
			"url"; "http://localhost/rest"))
		$result:=Rest(New object:C1471(\
			"action"; "url"; \
			"url"; "http://localhost/rest/"))
		
		//________________________________________
	: (True:C214)
		
		$o:=New object:C1471
		$Lon_type:=Value type:C1509($o.target)
		ASSERT:C1129($Lon_type=Is undefined:K8:13)
		
		//________________________________________
	: (True:C214)
		
		$t:=JSON Parse:C1218("\"toto\"")  // ;Is text)
		$Num_:=JSON Parse:C1218(String:C10(Pi:K30:1; "&xml"); Is real:K8:4)
		
		//________________________________________
	: (True:C214)
		
		$Obj_formula:=Formula:C1597(1+2)
		
		$Obj_new:=New object:C1471(\
			"f"; $Obj_formula)
		
		$Lon_result:=$Obj_new.f()  // Returns 3
		
		$Lon_value:=10
		$Obj_new:=New object:C1471(\
			"f"; Formula:C1597($Lon_value))
		$Lon_value:=20
		
		$Lon_result:=$Obj_new.f()  // Returns 10
		
		//$Obj_new:=New object("formula";New formula($1+$2))
		$Obj_new:=New object:C1471(\
			"f"; Formula from string:C1601("$1+$2"))
		$Lon_result:=$Obj_new.f(10; 20)  // Returns 30
		
		$Txt_ormula:=Request:C163("Please type a formula")
		
		If (OK=1)
			
			$Obj_formula:=Formula from string:C1601($Txt_ormula)
			ALERT:C41("Result = "+String:C10($Obj_formula.call()))
			
		End if 
		
		//$Obj_formula:=New formula from string(Uppercase($1))
		$Obj_formula:=Formula from string:C1601("Uppercase:C13($1)")
		$Txt_result:=$Obj_formula.call(Null:C1517; "hello")  // returns "HELLO"
		
		$Obj_new:=New object:C1471(\
			"value"; 50)
		$Obj_formula:=Formula:C1597(This:C1470.value*2)
		$Lon_result:=$Obj_formula.call($Obj_new)  // Returns 100
		
		//________________________________________
	: (True:C214)
		
		$o:=formatters(New object:C1471(\
			"action"; "getByName"))
		
		//________________________________________
	: (True:C214)
		
		$t:="Hello .world"
		
		$Boo_reset:=$t%"world"  // True
		$Boo_reset:=$t%"Hello"  // True
		$Boo_reset:=$t%".world"  // False
		$Boo_reset:=$t%"@.world"  // False
		
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
		
		ob_MERGE($Obj_target; $Obj_template)
		
		//$Obj_template:=New object
		//$Obj_template.server:=New object
		//$Obj_template.server.authentication:=New object
		//$Obj_template.server.urls:=New object
		//$Obj_template.server.urls.production:=""
		
		$o:=New object:C1471
		$o.server:=New object:C1471
		$o.server.urls:=New object:C1471
		$o.server.urls.test:="localhost"
		
		$Obj_new:=ob_deepMerge($Obj_template; $o)
		
		//________________________________________
	: (True:C214)
		
		$Col_2:=New collection:C1472("manigest.json"; New object:C1471(\
			"Sources"; New collection:C1472("azeaze"; \
			"azeazaze"; New object:C1471("Forms"; New collection:C1472()))))
		$c:=findFirstPathComponentInCatalog($Col_2)
		
		ALERT:C41(JSON Stringify:C1217($c))
		
		//________________________________________
End case 