//%attributes = {}
var $Num_; $r : Real
var $Dir_root; $node; $pattern; $root; $t; $tt; $Txt_in; $Txt_ormula; $Txt_result : Text
var $b; $Boo_reset; $ok : Boolean
var $i; $index; $l; $Lon_build; $Lon_error; $Lon_result; $Lon_type; $Lon_value; $Lon_x; $w : Integer
var $Gmt_timeGMT : Time
var $null : Variant
var $file; $folder; $o; $o1; $o2; $Obj_formula; $Obj_new; $result; $Obj_target; $Obj_template : Object
var $svg; $zip : Object
var $c; $c1; $Col_2; $cUserdCommands : Collection

ARRAY TEXT:C222($tTxt_; 0)

If (False:C215)
	SHOW ON DISK:C922(Folder:C1567(Temporary folder:C486; fk platform path:K87:2).platformPath)
End if 

COMPILER_COMPONENT

If (Is macOS:C1572)
	$o:=Folder:C1567("/")
	
	
Else 
	
End if 


Case of 
		
		
		//________________________________________
	: (True:C214)
		
		$o:=cs:C1710.avd.new()
		
		//$t:=$o.listAvds()
		//ARRAY LONGINT($pos; 0; 0)
		//ARRAY LONGINT($length; 0; 0)
		//$start:=1
		//While (Match regex("(?m-si)Name:\\s(\\V*)\\s*Path:\\s(\\V*)"; $t; $start; $pos; $length))
		//$name:=Substring($t; $pos{1}; $length{1})
		//$path:=Substring($t; $pos{2}; $length{2})
		//$start:=$pos{2}+$length{2}+1
		//End while 
		
		$c:=$o._o_devices()
		
		
		//________________________________________
	: (True:C214)
		
		$o:=cs:C1710.androidProcess.new()
		$folder:=$o.androidSDKFolder()
		SHOW ON DISK:C922($folder.platformPath)
		
		
		//________________________________________
	: (True:C214)
		
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
		
		
		
		
		//________________________________________
	: (True:C214)
		
		var $svg : cs:C1710.svg
		$svg:=cs:C1710.svg.new()
		$svg.group("main").stroke(4).translate(10; 10).scale(2)
		$svg.rect(40; 60).position(2; 144).fill("midnightblue")
		$svg.rect(120; 142).position(42; 2).fill("red")
		$svg.textArea("Inspired by Piet Mondrian - 1930,\rComposition II in Red, Blue, and Yellow").position(0; 210).fontSize(8).alignment(Align center:K42:3)
		$svg.group().fill("white")
		$svg.rect(40; 40).position(2; 2)
		$svg.rect(40; 100).position(2; 45)
		$svg.rect(95; 60).position(42; 144)
		$svg.rect(25; 25).position(137; 144)
		$svg.rect(25; 35).position(137; 169).fill("yellow")
		$svg.preview()
		
		//________________________________________
	: (True:C214)
		
		var $form; $ƒorm : Object
		$ƒorm:=New object:C1471("hello"; "world")
		$form:=New object:C1471("hello"; "monde")
		
		ALERT:C41($ƒorm.hello+" "+$form.hello)
		
		//________________________________________
	: (True:C214)
		
		$o:=cs:C1710.env.new().startupDisk()
		
		$t:=Convert path POSIX to system:C1107("/users/"+Get system info:C1571.userName+"/")
		
		//________________________________________
	: (False:C215)
		
		var $o : cs:C1710.lep
		$o:=cs:C1710.lep.new()
		
		$o.asynchronous().launch("open"; "/Applications/Pages.app")
		
		If (False:C215)
			
			$o.launch("kill"; String:C10($o.pid))
			
		Else 
			
			$o.launch("osascript -e"; "'quit app \"Calculator.app\"'")
			
		End if 
		
		$o.sync()
		$o.launch("/bin/ls -l"; "/Users")
		$c:=Split string:C1554(String:C10($o.outputStream); "\n")
		
		
		$o.reset()
		$o.launch("ioreg -n IODisplayWrangler |grep -i IOPowerManagement")
		$t:=$o.outputStream
		
		
		
		//________________________________________
	: (True:C214)
		
		var $svg : cs:C1710.svg
		
		$svg:=cs:C1710.svg.new()
		
		$svg.group("background")
		$svg.group("foreground"; "root")
		
		$svg.square(100).position(10; 10).color("blue").stroke(New object:C1471("color"; "black"; "width"; 4)).push("original")
		
		$svg.clone("original").position(111; 10).fill("red").dimensions(100; 201)
		
		$svg.clone("original").fill("yellow").moveVertically(101).attachTo("foreground")
		
		$svg.circle(100).color("blue").translate(201; 201).fill(False:C215).stroke(4).attachTo("background")
		
		$svg.preview()
		
		//________________________________________
	: (True:C214)
		
		$t:=Folder:C1567(fk desktop folder:K87:19).folder("DEV").platformPath
		
		$o:=New object:C1471
		
		$o.sdk:=sdk(New object:C1471(\
			"action"; "install"; \
			"file"; path.sdk().platformPath+"1.0.zip"; \
			"target"; "Macintosh HD:Users:vdl:Sources_4D:depot:4eDimension:main:4DComponents:Internal User Components:4D Mobile App - Mobile:My App:"))
		
		//;"cache"; sdk(New object("action"; "cacheFolder")).platformPath
		
		
		If ($o.sdk.success)
			
			
			
			
		End if 
		
		
		//________________________________________
	: (True:C214)
		
		$o:=cs:C1710.error.new("capture")
		
		Formula from string:C1601("$b:=true").call()
		
		If ($o.noError())
			
			
			
		Else 
			
			BEEP:C151
			
			$o1:=$o.lastError()
			
		End if 
		
		
		$o.release()
		
		//________________________________________
	: (True:C214)
		
		$o:=simulator(New object:C1471(\
			"action"; "open"; \
			"editorToFront"; False:C215; \
			"bringToFront"; True:C214))
		
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
		
		// Test code rewriting
		If (False:C215)
			
			$o:=cs:C1710.source.new()
			$Obj_template:=Rest(New object:C1471(\
				"action"; "url"))
			ASSERT:C1129($o.url=$Obj_template.url)
			
			$o:=cs:C1710.source.new("localhost")
			$Obj_template:=Rest(New object:C1471(\
				"action"; "url"; "url"; "localhost"))
			ASSERT:C1129($o.url=$Obj_template.url)
			
		End if 
		
		// Test response
		$o:=cs:C1710.source.new("localhost")
		
		$result:=$o.status()
		
		SET TEXT TO PASTEBOARD:C523(JSON Stringify:C1217($result; *))
		
		Case of 
				
				//______________________________________________________
			: ($result.success)
				
				// TVB
				
				//______________________________________________________
			: (Num:C11($result.httpError)=30)
				
				ALERT:C41(Get localized string:C991("theServerIsNotReady"))  // Server unavailable/Serveur inaccessible
				
				//______________________________________________________
			: ($result.code=401)
				
				$ok:=($result.errors.query("errCode=1907").pop()#Null:C1517)
				
				If ($ok)
					
					// The key.mobileapp file should be created
					If (WEB Get server info:C1531.started)  // Local
						
						// Get file
						$file:=Folder:C1567(fk mobileApps folder:K87:18).file("key.mobileapp")
						$ok:=$file.exists
						
						If ($ok)
							
							$o.url:="127.0.0.1:"+String:C10(WEB Get server info:C1531.options.webPortID)
							$o.headers.push(New object:C1471("Authorization"; "Bearer "+$file.getText()))
							$ok:=$o.status().success
							
							SET TEXT TO PASTEBOARD:C523(JSON Stringify:C1217($o.response; *))
							
						Else 
							
							ALERT:C41(Get localized string:C991("failedToGenerateAuthorizationKey"))
							
						End if 
						
					Else 
						
						// Server -> The user must select the file retrieved
						
						$file:=File:C1566("/Volumes/Transcend 2To/keyMobile/Data/MobileApps/key.mobileapp")
						$ok:=$file.exists
						
						If ($ok)
							
							$o.url:="127.0.0.1:"+String:C10(WEB Get server info:C1531.options.webPortID)
							$o.headers.push(New object:C1471("Authorization"; "Bearer "+$file.getText()))
							$ok:=$o.status().success
							
							SET TEXT TO PASTEBOARD:C523(JSON Stringify:C1217($o.response; *))
							
						Else 
							
							ALERT:C41(Get localized string:C991("locateTheKey"))
							
						End if 
						
					End if 
					
				Else 
					
					// ERROR
					
				End if 
				//______________________________________________________
			Else 
				
				// A "Case of" statement should never omit "Else"
				//______________________________________________________
		End case 
		
		//$t:=JSON Stringify($o;*)
		//SET TEXT TO PASTEBOARD($t)
		
		//http://127.0.0.1/mobileapp/
		//$Lon_error:=HTTP Request(HTTP GET method;Rest (New object("action";"devurl";"handler";"mobileapp")).url;"";$Txt_result)
		
		//________________________________________
	: (True:C214)
		
		$root:=DOM Create XML Ref:C861("root")
		
		If (False:C215)
			
			$t:=DOM Create XML element:C865($root; "element_1"; "id"; 1)
			$t:=DOM Create XML element:C865($root; "element_2"; "id"; 2)
			$t:=DOM Create XML element:C865($root; "element_3"; "id"; 3)
			
		Else 
			
			//ACI0100854 - DOM Create XML element - Creates elements in inverse order
			
			$t:=DOM Create XML element:C865($root; "rect"; "id"; 1)
			$t:=DOM Create XML element:C865($root; "rect"; "id"; 2)
			$t:=DOM Create XML element:C865($root; "rect"; "id"; 3)
			
		End if 
		
		DOM EXPORT TO VAR:C863($root; $t)
		DOM CLOSE XML:C722($root)
		
		SET TEXT TO PASTEBOARD:C523($t)
		
		//________________________________________
	: (True:C214)
		
		$c:=New collection:C1472(\
			New object:C1471("name"; "Dupont"); \
			New object:C1471("name"; "Durant"); \
			New object:C1471("name"; "Dupond"); \
			New object:C1471("name"; "Martin"))
		
		For each ($i; $c.indices("name = Dupon@").reverse())
			
			$c.remove($i)
			
		End for each 
		
		//________________________________________
	: (True:C214)
		
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
				
				For each ($tt; Split string:C1554(DOCUMENT; "\r"; sk trim spaces:K86:2).shift())
					
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
		
		$o:=Folder:C1567("/RESOURCES")
		
		$result:=OB Class:C1730($o)
		
		$b:=OB Instance of:C1731($o; $result)
		
		$o:=cs:C1710.static.new("toto")
		$result:=OB Class:C1730($o)
		$b:=OB Instance of:C1731($o; cs:C1710.static)
		
		//________________________________________
	: (True:C214)
		
		$Gmt_timeGMT:=Time:C179(Replace string:C233(Delete string:C232(String:C10(Current date:C33; ISO date GMT:K1:10; Current time:C178); 1; 11); "Z"; ""))
		
		//________________________________________
	: (True:C214)
		
		$root:=DOM Create XML Ref:C861("root")
		
		$node:=DOM Create XML element:C865($root; "element"; "class"; "test")
		$node:=DOM Create XML element:C865($root; "element"; "class"; "blank test")
		$node:=DOM Create XML element:C865($root; "element")
		$node:=DOM Create XML element:C865($root; "element"; "class"; "blank test dark")
		
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
		
		///Volumes/Passport 500/Perforce/vincent.delachaux_MBP/4eDimension/main/4DComponents/Internal User Components/4D Mobile App/Resources/templates/form/detail/Blank Form/template.svg
		
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
		
		//End for each
		
		//$o:=New object()
		//$o.files:=$c
		
		//$zip:=ZIP Create archive($o;$folder)
		
		//this command list all loaded component with path
		//$c:=WEB Servers list
		//________________________________________
	: (True:C214)
		
		$o:=_4D_Build Exposed Datastore:C1598["Commands"]
		
		$o1:=$o.getInfo()
		
		$c:=New collection:C1472
		For each ($t; $o)
			
			$c.push($o[$t])
			
		End for each 
		
		//________________________________________
	: (True:C214)
		
		$o:=_wip_Xcode
		
		$folder:=$o.defaultPath()
		
		$folder:=$o.toolsPath()
		
		$folder:=$o.path()
		
		//  $c:=$o.paths()
		
		//$o.openAppStore()
		
		//________________________________________
	: (False:C215)
		
		$t:=_o_str("").shuffle(5)
		$t:=_o_str("").shuffle(10)
		$t:=_o_str("").shuffle(15)
		$t:=_o_str("").shuffle(20)
		$t:=_o_str("").shuffle(30)
		$t:=_o_str("").shuffle(40)
		$t:=_o_str.setText("Hello world").shuffle(100)
		$t:=_o_str.setText("Note: if a value being appended is a collection, the elements of the collection will be appended.").shuffle(15)
		
		//________________________________________
	: (False:C215)  // Unsandbox
		
		$o:=Folder:C1567(fk database folder:K87:14)
		$o1:=Folder:C1567($o.platformPath; fk platform path:K87:2)
		
		$o2:=Folder:C1567(Folder:C1567(fk database folder:K87:14).platformPath; fk platform path:K87:2)
		
		//________________________________________
	: (True:C214)
		
		//$c:=New collection(1;2;3;4;5)
		//$cc:=$c.slice($c.length-1)
		
		$o:=new("str"; "test")
		$o1:=$o.constructor()
		
		$c:=$o.distinctLetters()
		$o.setText("hello world")
		$t:=$o.lowerCamelCase()
		
		$o:=new("svg"; "test")
		$o1:=$o.constructor()
		$o.close()
		
		$o:=new("str"; "test")
		$o1:=$o.constructor()
		
		$o.setText("Hello world")
		$t:=$o.insert(" great"; 6).value
		$o1:=$o.insert("Vincent"; 7; MAXLONG:K35:2)
		
		//________________________________________
	: (True:C214)
		
		$o:=db.exposedDatastore()
		$o:=db("object;blob").exposedDatastore()
		
		$o:=db("object;blob")
		
		$o1:=$o.table("Commands")
		$o1:=$o.table(5)
		$o1:=$o.table(55)
		$o1:=$o.table("hello")
		$o1:=$o.table("Table_1")
		$o1:=$o.table("Table_3")
		
		$o1:=$o.field("Commands"; 4)
		$o1:=$o.field("Commands"; "theme")
		//________________________________________
	: (True:C214)
		
		$c:=New collection:C1472(New object:C1471("min"; 5); "mandatory")
		
		$l:=$c.indexOf("mandatory")
		$l:=$c.countValues("mandatory")
		$b:=($c.countValues("mandatory")>0)
		
		$c1:=$c.extract("min")
		$b:=($c1.length>0)
		
		$l:=$c.count("min")
		$b:=($l>0)
		
		//________________________________________
	: (True:C214)
		
		$o:=New object:C1471("pointer"; $r)
		
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
		
		For each ($o; ds:C1482.Commands.all())
			
			$o2:=ds:C1482.Themes.query("Name = :1"; $o.themeName)
			
			If ($o2.length=0)
				
				$o1:=ds:C1482.Themes.new()
				$o1.Name:=$o.themeName
				$result:=$o1.save()
				
				$o.themeID:=$o1.ID
				
			Else 
				
				$o.themeID:=$o2[0].ID
				
			End if 
			
			$o.save()
			
		End for each 
		
		//________________________________________
	: (False:C215)
		
		$o1:=Folder:C1567(_o_env_System_path("caches"); fk platform path:K87:2).folder("com.4d.mobile").folder("sdk")
		$o:=sdk(New object:C1471("action"; "cacheFolder"))
		ASSERT:C1129($o1.platformPath=$o.platformPath)
		
		$t:=Convert path POSIX to system:C1107(_o_env_System_path("caches"; True:C214)+"com.4d.mobile/sdk/")
		$tt:=sdk(New object:C1471("action"; "cacheFolder")).platformPath
		ASSERT:C1129($t=$tt)
		
		//________________________________________
	: (False:C215)
		
		GET FIELD PROPERTIES:C258(5; 11; $Lon_type)
		ASSERT:C1129($Lon_type=_o_Is float:K8:26)
		
		//________________________________________
	: (False:C215)
		
		//$t:=Get 4D folder(Current resources folder)+"sdk"+Folder separator+"Versions"+Folder separator  // (unzip TRMosaicLayout.zip to test)
		//$File_:=$t+"Carthage:Checkouts:TRMosaicLayout:_Pods.xcodeproj"  // a broken symbolic link
		//$Boo_reset:=_o_doc_isAlias ($File_)
		
		$Boo_reset:=Folder:C1567(fk resources folder:K87:11).folder("sdk").folder("Versions").folder("Carthage").folder("Checkouts").folder("TRMosaicLayout").file("_Pods.xcodeproj").isAlias
		
		//________________________________________
	: (True:C214)
		
		$o:=mobileUnit("testSuites")
		
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
			
			$t:=Delete string:C232($t; Length:C16($t); 1)
			
		Else 
			
			$t:=Split string:C1554($t; Folder separator:K24:12)[0]
		End if 
		
		//________________________________________
	: (False:C215)
		
		$o:=Path to object:C1547(Get 4D folder:C485(Database folder:K5:14; *))
		
		$Dir_root:=Object to path:C1548(New object:C1471("name"; $o.name+" Project"; "isFolder"; True:C214; "parentFolder"; $o.parentFolder))
		
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
		
		$Lon_error:=HTTP Request:C1158(HTTP GET method:K71:1; Rest(New object:C1471("action"; "devurl"; "handler"; "mobileapp")).url; ""; $Txt_result)
		
		//________________________________________
	: (False:C215)
		
		$result:=Rest(New object:C1471("action"; "url"; "url"; "http:// Localhost"))
		$result:=Rest(New object:C1471("action"; "url"; "url"; "http://localhost/"))
		$result:=Rest(New object:C1471("action"; "url"; "url"; "http://localhost/rest"))
		$result:=Rest(New object:C1471("action"; "url"; "url"; "http://localhost/rest/"))
		
		//________________________________________
	: (True:C214)
		
		ASSERT:C1129(Xcode(New object:C1471("action"; "xbuild-version")).success)
		
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
		
		$Obj_new:=New object:C1471("f"; $Obj_formula)
		
		$Lon_result:=$Obj_new.f()  // returns 3
		
		$Lon_value:=10
		$Obj_new:=New object:C1471("f"; Formula:C1597($Lon_value))
		$Lon_value:=20
		
		$Lon_result:=$Obj_new.f()  // returns 10
		
		//$Obj_new:=New object("formula";New formula($1+$2))
		$Obj_new:=New object:C1471("f"; Formula from string:C1601("$1+$2"))
		$Lon_result:=$Obj_new.f(10; 20)  // returns 30
		
		$Txt_ormula:=Request:C163("Please type a formula")
		
		If (OK=1)
			
			$Obj_formula:=Formula from string:C1601($Txt_ormula)
			ALERT:C41("Result = "+String:C10($Obj_formula.call()))
			
		End if 
		
		//$Obj_formula:=New formula from string(Uppercase($1))
		$Obj_formula:=Formula from string:C1601("Uppercase:C13($1)")
		$Txt_result:=$Obj_formula.call(Null:C1517; "hello")  // returns "HELLO"
		
		$Obj_new:=New object:C1471("value"; 50)
		$Obj_formula:=Formula:C1597(This:C1470.value*2)
		$Lon_result:=$Obj_formula.call($Obj_new)  // returns 100
		
		//________________________________________
	: (True:C214)
		
		$o:=formatters(New object:C1471("action"; "getByName"))
		
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
		$Lon_build:=Num:C11(xml_fileToObject(Get 4D folder:C485(Database folder:K5:14)+"Info.plist").value.plist.dict.string[5].$)
		
		//________________________________________
	: (True:C214)
		
		$t:=Parse formula:C1576("CALL FORM($Obj_in.caller;\"project_BUILD\";$Obj_in)"; 4)
		
		$o1:=_4D_Build Exposed Datastore:C1598
		$o:=Formula:C1597(project_BUILD($o1))
		OB GET PROPERTY NAMES:C1232($o; $tTxt_)
		
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
		
		$Col_2:=New collection:C1472("manigest.json"; New object:C1471("Sources"; New collection:C1472("azeaze"; "azeazaze"; New object:C1471("Forms"; New collection:C1472()))))
		$c:=findFirstPathComponentInCatalog($Col_2)
		
		ALERT:C41(JSON Stringify:C1217($c))
		
		//________________________________________
	: (True:C214)
		
		$t:="Bundle 4 Dé ö aze äapp ?"
		
		Rgx_SubstituteText("[ÂÃÄÅ]"; "A"; ->$t; 0)
		Rgx_SubstituteText("[àáâãäå]"; "a"; ->$t; 0)
		Rgx_SubstituteText("[ÈÉÊË]"; "E"; ->$t; 0)
		Rgx_SubstituteText("[èéêë]"; "e"; ->$t; 0)
		Rgx_SubstituteText("[ÌÍÎÏ]"; "I"; ->$t; 0)
		Rgx_SubstituteText("[ìíîï]"; "i"; ->$t; 0)
		Rgx_SubstituteText("[ÒÓÔÕÖ]"; "O"; ->$t; 0)
		Rgx_SubstituteText("[ðñòóôõö]"; "o"; ->$t; 0)
		Rgx_SubstituteText("[ÙÚÛÜ]"; "U"; ->$t; 0)
		Rgx_SubstituteText("[ùúûü]"; "u"; ->$t; 0)
		
		$Lon_error:=Rgx_SubstituteText("[^a-zA-Z0-9]"; "-"; ->$t; 0)
		
		ALERT:C41($t)
		
		//________________________________________
End case 
