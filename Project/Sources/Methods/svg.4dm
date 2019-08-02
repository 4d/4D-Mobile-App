//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : svg
  // Created #11-6-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Manipulate SVG as objects
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_BLOB:C604($x)
C_BOOLEAN:C305($b)
C_LONGINT:C283($i)
C_PICTURE:C286($p)
C_REAL:C285($Num_height;$Num_width)
C_TEXT:C284($Dom_;$Dom_target;$t;$tt;$Txt_object;$Txt_path)
C_TEXT:C284($t;$Txt_volume)
C_OBJECT:C1216($file;$o;$oo)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(svg ;$0)
	C_TEXT:C284(svg ;$1)
	C_OBJECT:C1216(svg ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470._is=Null:C1517)
	
	$o:=New object:C1471(\
		"_is";"svg";\
		"root";Null:C1517;\
		"lastCreatedObject";Null:C1517;\
		"autoClose";True:C214;\
		"success";False:C215;\
		"close";Formula:C1597(svg ("close"));\
		"group";Formula:C1597(svg ("new";New object:C1471("what";"group";"id";$1;"options";$2)));\
		"rect";Formula:C1597(svg ("new";Choose:C955(Count parameters:C259=3;New object:C1471("what";"rect";"x";$1;"y";$2;"options";$3);New object:C1471("what";"rect";"x";$1;"y";$2;"width";$3;"height";$4;"options";$5))));\
		"image";Formula:C1597(svg ("new";New object:C1471("what";"image";"url";$1;"options";$2)));\
		"textArea";Formula:C1597(svg ("new";New object:C1471("what";"textArea";"text";$1;"x";Num:C11($2);"y";Num:C11($3);"options";$4)));\
		"embedPicture";Formula:C1597(svg ("new";New object:C1471("what";"embedPicture";"image";$1;"x";Num:C11($2);"y";Num:C11($3);"options";$4)));\
		"position";Formula:C1597(svg ("set";New object:C1471("what";"position";"x";$1;"y";$2;"unit";$3)));\
		"dimensions";Formula:C1597(svg ("set";New object:C1471("what";"dimensions";"width";$1;"height";$2;"unit";$3)));\
		"fill";Formula:C1597(svg ("set";New object:C1471("what";"fill";"color";$1;"opacity";$2)));\
		"stroke";Formula:C1597(svg ("set";New object:C1471("what";"stroke";"color";$1;"opacity";$2)));\
		"font";Formula:C1597(svg ("set";New object:C1471("what";"font";"font";$1;"size";$2)));\
		"attributes";Formula:C1597(svg ("set";New object:C1471("what";"attributes";"options";$1)));\
		"get";Formula:C1597(svg ("get";New object:C1471("what";String:C10($1);"options";$2))[$1]);\
		"errors";New collection:C1472\
		)
	
	$t:=DOM Create XML Ref:C861("svg";"http://www.w3.org/2000/svg")
	
	If (Bool:C1537(OK))
		
		$o.root:=$t
		
		DOM SET XML ATTRIBUTE:C866($t;\
			"xmlns:xlink";"http://www.w3.org/1999/xlink")
		
		DOM SET XML DECLARATION:C859($t;"UTF-8";True:C214)
		XML SET OPTIONS:C1090($t;XML indentation:K45:34;Choose:C955(Is compiled mode:C492;XML no indentation:K45:36;XML with indentation:K45:35))
		
		$t:=DOM Create XML element:C865($o.root;"def")
		
	End if 
	
	$o.success:=($o.root#Null:C1517)
	
	If ($o.success)
		
		  // Default values
		DOM SET XML ATTRIBUTE:C866($o.root;\
			"viewport-fill";"none";\
			"fill";"none";\
			"stroke";"black";\
			"font-family";"'lucida grande',sans-serif";\
			"font-size";12;\
			"text-rendering";"geometricPrecision";\
			"shape-rendering";"crispEdges";\
			"preserveAspectRatio";"none")
		
		If (Count parameters:C259>=1)
			
			$c:=Split string:C1554($1;";")
			
			For each ($t;$c)
				
				Case of 
						
						  //______________________________________________________
					: ($t="{@}")
						
						$oo:=JSON Parse:C1218($t)
						
						For each ($tt;$oo)
							
							DOM SET XML ATTRIBUTE:C866($o.root;\
								$tt;$oo[$tt])
							
						End for each 
						
						  //______________________________________________________
					: ($t="keepReference")
						
						$o.autoClose:=False:C215
						
						  //______________________________________________________
					: ($t="solid@")
						
						If (Split string:C1554($t;":").length>1)
							
							DOM SET XML ATTRIBUTE:C866($o.root;\
								"viewport-fill";Split string:C1554($t;":")[1];\
								"viewport-fill-opacity";1)
							
						Else 
							
							DOM SET XML ATTRIBUTE:C866($o.root;\
								"viewport-fill";"white";\
								"viewport-fill-opacity";1)
							
						End if 
						
						  //______________________________________________________
					Else 
						
						  // A "Case of" statement should never omit "Else"
						  //______________________________________________________
				End case 
			End for each 
		End if 
		
	Else 
		
		$o.errors.push("Failed to create SVG tree.")
		
	End if 
	
Else 
	
	$o:=This:C1470
	
	$oo:=$2.options
	
	$Txt_object:=String:C10($2.what)
	
	Case of 
			
			  //=================================================================
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //=================================================================
		: ($1="get")
			
			$o.success:=($o.root#Null:C1517)
			
			If ($o.success)
				
				Case of 
						
						  //______________________________________________________
					: ($Txt_object="picture")
						
						  // Own XML data source
						SVG EXPORT TO PICTURE:C1017($o.root;$p;Choose:C955($oo.exportType#Null:C1517;Num:C11($oo.exportType);Copy XML data source:K45:17))
						$o.success:=(Picture size:C356($p)>0)
						
						If ($o.success)
							
							$o.picture:=$p
							
							If ($o.autoClose)
								
								DOM CLOSE XML:C722($o.root)
								$o.root:=Null:C1517
								
							End if 
							
						Else 
							
							$o.picture:=Null:C1517
							$o.errors.push("Failed to convert SVG tree as picture.")
							
						End if 
						
						  //______________________________________________________
					: ($Txt_object="xml")
						
						DOM EXPORT TO VAR:C863($o.root;$t)
						$o.success:=Bool:C1537(OK)
						
						If ($o.success)
							
							$o.xml:=$t
							
							If ($o.autoClose)
								
								DOM CLOSE XML:C722($o.root)
								$o.root:=Null:C1517
								
							End if 
							
						Else 
							
							$o.xml:=Null:C1517
							$o.errors.push("Failed to export SVG tree as XML.")
							
						End if 
						
						  //______________________________________________________
					Else 
						
						$o.errors.push("Unknown type for get() method ("+$Txt_object+").")
						$o.success:=False:C215
						
						  //______________________________________________________
				End case 
			End if 
			
			  //=================================================================
		: ($1="close")
			
			$o.success:=($o.root#Null:C1517)
			
			If ($o.success)
				
				DOM CLOSE XML:C722($o.root)
				$o.root:=Null:C1517
				
			Else 
				
				$o.errors.push("The SVG tree is not valid.")
				
			End if 
			
			  //=================================================================
		: ($1="new")
			
			$Dom_target:=Choose:C955($oo.target#Null:C1517;String:C10($oo.target);$o.root)
			
			OK:=0
			
			Case of 
					
					  //______________________________________________________
				: ($Txt_object="group")
					
					$o.lastCreatedObject:=DOM Create XML element:C865($Dom_target;"g")
					
					If (OK=1)\
						 & ($2.id#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($o.lastCreatedObject;\
							"id";String:C10($2.id))
						
					End if 
					
					  //______________________________________________________
				: ($Txt_object="rect")
					
					$o.lastCreatedObject:=DOM Create XML element:C865($Dom_target;"rect";\
						"x";Num:C11($2.x);\
						"y";Num:C11($2.y);\
						"width";Num:C11($2.width);\
						"height";Num:C11($2.height))
					
					If (OK=1)\
						 & ($oo.rx#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($o.lastCreatedObject;\
							"rx";Num:C11($oo.rx))
						
					End if 
					
					If (OK=1)\
						 & ($oo.ry#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($o.lastCreatedObject;\
							"ry";Num:C11($oo.ry))
						
					End if 
					
					  //______________________________________________________
				: ($Txt_object="image")
					
					OK:=Num:C11(Value type:C1509($2.url)=Is object:K8:27)  // File object
					
					If (OK=1)
						
						$file:=$2.url
						
						OK:=Num:C11($file.exists)
						
						If (OK=1)
							
							  // Get width & height of the picture if any
							If ($oo.width=Null:C1517)\
								 | ($oo.height=Null:C1517)
								
								READ PICTURE FILE:C678($file.platformPath;$p)
								
								If (OK=1)
									
									PICTURE PROPERTIES:C457($p;$Num_width;$Num_height)
									CLEAR VARIABLE:C89($p)
									
									If ($oo.width=Null:C1517)
										
										$oo.width:=$Num_width
										
									End if 
									
									If ($oo.height=Null:C1517)
										
										$oo.height:=$Num_height
										
									End if 
								End if 
							End if 
							
							If (OK=1)
								
								$t:="file:/"+"/"\
									+Choose:C955(Is Windows:C1573;"/";"")\
									+Replace string:C233($file.path;" ";"%20")
								
								$o.lastCreatedObject:=DOM Create XML element:C865($Dom_target;"image";\
									"xlink:href";$t;\
									"x";Num:C11($oo.left);\
									"y";Num:C11($oo.top);\
									"width";Num:C11($oo.width);\
									"height";Num:C11($oo.height))
								
							End if 
							
						Else 
							
							$o.errors.push("File not found ("+$file.platformPath+").")
							
						End if 
						
					Else 
						
						$o.errors.push("Missing valid image file.")
						
					End if 
					
					  //______________________________________________________
				: ($Txt_object="embedPicture")
					
					$p:=$2.image
					
					If (Picture size:C356($p)>0)
						
						  // Encode in base64
						PICTURE TO BLOB:C692($p;$x;Choose:C955($oo.codec#Null:C1517;String:C10($oo.codec);".png"))
						
						If (OK=1)
							
							BASE64 ENCODE:C895($x;$t)
							CLEAR VARIABLE:C89($x)
							
							If (OK=1)
								
								  // Put the encoded image
								PICTURE PROPERTIES:C457($p;$Num_width;$Num_height)
								
								$o.lastCreatedObject:=DOM Create XML element:C865($Dom_target;"image";\
									"xlink:href";"data:;base64,"+$t;\
									"x";$2.x;\
									"y";$2.y;\
									"width";$Num_width;\
									"height";$Num_height)
								
							End if 
						End if 
						
					Else 
						
						$o.errors.push("Given picture is empty")
						
					End if 
					
					  //______________________________________________________
				: ($Txt_object="textArea")
					
					$t:=Replace string:C233(String:C10($2.text);"\r\n";"\r")
					
					$o.lastCreatedObject:=DOM Create XML element:C865($Dom_target;"textArea";\
						"x";$2.x;\
						"y";$2.y;\
						"width";Choose:C955($oo.width=Null:C1517;"auto";Num:C11($oo.width));\
						"height";Choose:C955($oo.height=Null:C1517;"auto";Num:C11($oo.height)))
					
					If (OK=1)\
						 & (Length:C16($t)>0)
						
						Repeat 
							
							$i:=Position:C15("\r";$t)
							
							If ($i=0)
								
								$i:=Position:C15("\n";$t)
								
							End if 
							
							If ($i>0)
								
								$tt:=Substring:C12($t;1;$i-1)
								
								If (Length:C16($tt)>0)
									
									$Dom_:=DOM Append XML child node:C1080($o.lastCreatedObject;XML DATA:K45:12;$tt)
									
								End if 
								
								$Dom_:=DOM Append XML child node:C1080($o.lastCreatedObject;XML ELEMENT:K45:20;"tbreak")
								
								$t:=Delete string:C232($t;1;Length:C16($tt)+1)
								
							Else 
								
								If (Length:C16($t)>0)
									
									$Dom_:=DOM Append XML child node:C1080($o.lastCreatedObject;XML DATA:K45:12;$t)
									
								End if 
							End if 
						Until ($i=0)\
							 | (OK=0)
						
					End if 
					
					  //______________________________________________________
				Else 
					
					$o.errors.push("Unknown object: \""+$Txt_object+"\"")
					
					  //______________________________________________________
			End case 
			
			$o.success:=Bool:C1537(OK)
			
			If ($o.success)  // Additional attributes
				
				If ($oo#Null:C1517)
					
					$c:=New collection:C1472("target";"rx";"ryx";"left";"top";"width";"height";"codec")
					
					For each ($t;$oo)
						
						If ($c.indexOf($t)=-1)
							
							DOM SET XML ATTRIBUTE:C866($o.lastCreatedObject;\
								$t;$oo[$t])
							
						End if 
					End for each 
				End if 
			End if 
			
			  //=================================================================
		: ($1="set")
			
			If ($oo.target=Null:C1517)
				
				If ($o.lastCreatedObject=Null:C1517)
					
					  // Target is the canvas
					$Dom_target:=$o.root
					
				Else 
					
					$Dom_target:=$o.lastCreatedObject
					
				End if 
				
			Else 
				
				$Dom_target:=$oo.target
				
			End if 
			
			Case of 
					
					  //______________________________________________________
				: ($2.what="position")
					
					If ($Dom_target=$o.root)
						
						$o.success:=False:C215
						$o.errors.push("You can't set position for the canvas!")
						
					Else 
						
						OK:=1
						
						If ($2.x#Null:C1517)
							
							DOM SET XML ATTRIBUTE:C866($Dom_target;\
								"x";String:C10($2.x;"&xml")+String:C10($2.unit))
							
							If (OK=1)
								
								If ($2.y#Null:C1517)
									
									DOM SET XML ATTRIBUTE:C866($Dom_target;\
										"y";String:C10($2.y;"&xml")+String:C10($2.unit))
									
								Else 
									
									DOM SET XML ATTRIBUTE:C866($Dom_target;\
										"y";String:C10($2.x;"&xml")+String:C10($2.unit))
									
								End if 
							End if 
						End if 
						
						$o.success:=Bool:C1537(OK)
						
					End if 
					
					  //______________________________________________________
				: ($2.what="dimensions")
					
					OK:=1
					
					If ($2.width#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($Dom_target;\
							"width";String:C10($2.width;"&xml")+String:C10($2.unit))
						
						If (OK=1)
							
							If ($2.height#Null:C1517)
								
								DOM SET XML ATTRIBUTE:C866($Dom_target;\
									"height";String:C10($2.height;"&xml")+String:C10($2.unit))
								
							Else 
								
								DOM SET XML ATTRIBUTE:C866($Dom_target;\
									"height";String:C10($2.width;"&xml")+String:C10($2.unit))
								
							End if 
						End if 
					End if 
					
					$o.success:=Bool:C1537(OK)
					
					  //______________________________________________________
				: ($2.what="attributes")
					
					For each ($t;$oo) Until (OK=0)
						
						If ($t#"holder")
							
							DOM SET XML ATTRIBUTE:C866($Dom_target;\
								$t;$oo[$t])
							
							  // If (OK=0)
							  //$o.errors.push("Set atributes \""+$t+"\" with value \""+String($oo[$t])+"\"")
							  // End if
							
						End if 
					End for each 
					
					$o.success:=Bool:C1537(OK)
					
					  //______________________________________________________
				: ($2.what="fill")
					
					If ($Dom_target=$o.root)
						
						If ($2.color#Null:C1517)
							
							DOM SET XML ATTRIBUTE:C866($Dom_target;\
								"viewport-fill";String:C10($2.color))
							
						End if 
						
						If (OK=1)\
							 & ($2.opacity#Null:C1517)
							
							DOM SET XML ATTRIBUTE:C866($Dom_target;\
								"viewport-fill-opacity";Num:C11($2.opacity)/100)
							
						End if 
						
					Else 
						
						If ($2.color#Null:C1517)
							
							DOM SET XML ATTRIBUTE:C866($Dom_target;\
								"fill";String:C10($2.color))
							
						End if 
						
						If (OK=1)\
							 & ($2.opacity#Null:C1517)
							
							DOM SET XML ATTRIBUTE:C866($Dom_target;\
								"fill-opacity";Num:C11($2.opacity)/100)
							
						End if 
					End if 
					
					$o.success:=Bool:C1537(OK)
					
					  //______________________________________________________
				: ($2.what="stroke")
					
					If ($2.color#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($Dom_target;\
							"stroke";String:C10($2.color))
						
					End if 
					
					If (OK=1)\
						 & ($2.opacity#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($Dom_target;\
							"stroke-opacity";Num:C11($2.opacity)/100)
						
					End if 
					
					$o.success:=Bool:C1537(OK)
					
					  //______________________________________________________
				: ($2.what="font")
					
					If ($2.font#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($Dom_target;\
							"font-family";String:C10($2.font))
						
					End if 
					
					If (OK=1)\
						 & ($2.size#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($Dom_target;\
							"font-size";Num:C11($2.size))
						
					End if 
					
					$o.success:=Bool:C1537(OK)
					
					  //______________________________________________________
				Else 
					
					TRACE:C157
					
					  // A "Case of" statement should never omit "Else"
					  //______________________________________________________
			End case 
			
			  //=================================================================
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
			
			  //=================================================================
	End case 
	
	If ($o.success)
		
		  //
		
	Else 
		
		$o.errors.push($1+" "+String:C10($2.what)+" failed")
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End