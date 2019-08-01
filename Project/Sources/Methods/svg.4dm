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
C_TEXT:C284($Txt_URL;$Txt_volume)
C_OBJECT:C1216($file;$o;$oo)

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
		"success";False:C215;\
		"errors";New collection:C1472;\
		"lastCreatedObject";"";\
		"close";Formula:C1597(svg ("close"));\
		"group";Formula:C1597(svg ("new";New object:C1471("what";"group";"options";$1)));\
		"rect";Formula:C1597(svg ("new";New object:C1471("what";"rect";"x";Num:C11($1);"y";Num:C11($2);"width";Num:C11($3);"height";Num:C11($4);"options";$5)));\
		"image";Formula:C1597(svg ("new";New object:C1471("what";"image";"url";$1;"options";$2)));\
		"textArea";Formula:C1597(svg ("new";New object:C1471("what";"textArea";"text";$1;"x";Num:C11($2);"y";Num:C11($3);"options";$4)));\
		"imageEmbedded";Formula:C1597(svg ("new";New object:C1471("what";"imageEmbedded";"image";$1;"x";Num:C11($2);"y";Num:C11($3);"options";$4)));\
		"dimensions";Formula:C1597(svg ("set";New object:C1471("what";"dimensions";"width";Num:C11($1);"height";Num:C11($2);"unit";String:C10($3))));\
		"textRendering";Formula:C1597(svg ("set";New object:C1471("what";"text-rendering";"value";String:C10($1);"ref";String:C10($2))));\
		"opacity";Formula:C1597(svg ("set";New object:C1471("what";"opacity";"options";$1)));\
		"get";Formula:C1597(svg ("get";New object:C1471("what";String:C10($1);"options";$2))[$1])\
		)
	
	$t:=DOM Create XML Ref:C861("svg";"http://www.w3.org/2000/svg")
	
	If (Bool:C1537(OK))
		
		$o.root:=$t
		
		DOM SET XML ATTRIBUTE:C866($o.root;\
			"xmlns:xlink";"http://www.w3.org/1999/xlink")
		
		DOM SET XML DECLARATION:C859($o.root;"UTF-8";True:C214)
		XML SET OPTIONS:C1090($o.root;XML indentation:K45:34;Choose:C955(Is compiled mode:C492;XML no indentation:K45:36;XML with indentation:K45:35))
		
	End if 
	
	$o.success:=($o.root#Null:C1517)
	
	If ($o.success)
		
		  // Default values
		DOM SET XML ATTRIBUTE:C866($o.root;\
			"viewport-fill";"white";\
			"viewport-fill-opacity";1;\
			"fill";"white";\
			"font-family";"'lucida grande',sans-serif";\
			"font-size";12;\
			"text-rendering";"geometricPrecision";\
			"shape-rendering";"crispEdges")
		
		If (Count parameters:C259>=1)
			
			$oo:=JSON Parse:C1218($1)
			
			For each ($t;$oo)
				
				DOM SET XML ATTRIBUTE:C866($o.root;\
					$t;$oo[$t])
				
			End for each 
		End if 
		
	Else 
		
		$o.errors.push("Failed to create SVG tree.")
		
	End if 
	
Else 
	
	$o:=This:C1470
	
	$oo:=$2.options
	
	If (Length:C16(String:C10($oo.holder))>0)
		
		$Dom_target:=$oo.holder
		
	Else 
		
		  // Use root
		$Dom_target:=$o.root
		
	End if 
	
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
						
						  //Own XML data source
						SVG EXPORT TO PICTURE:C1017($Dom_target;$p;Choose:C955($oo.exportType#Null:C1517;Num:C11($oo.exportType);Copy XML data source:K45:17))
						$o.success:=(Picture size:C356($p)>0)
						
						If ($o.success)
							
							$o.picture:=$p
							
						Else 
							
							$o.picture:=Null:C1517
							$o.errors.push("Failed to convert SVG tree as picture.")
							
						End if 
						
						  //______________________________________________________
					: ($Txt_object="xml")
						
						DOM EXPORT TO VAR:C863($Dom_target;$t)
						$o.success:=Bool:C1537(OK)
						
						If ($o.success)
							
							$o.xml:=$t
							
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
			
			Case of 
					
					  //______________________________________________________
				: ($Txt_object="group")
					
					If ($oo.url#Null:C1517)
						
						$o.lastCreatedObject:=DOM Create XML element:C865($Dom_target;"a";\
							"xlink:href";String:C10($oo.url))
						
						If ($oo.target#Null:C1517)
							
							If (String:C10($oo.target)="new")
								
								DOM SET XML ATTRIBUTE:C866($o.lastCreatedObject;\
									"target";"_blank")
								
							Else 
								
								DOM SET XML ATTRIBUTE:C866($o.lastCreatedObject;\
									"target";String:C10($oo.target))
								
							End if 
						End if 
						
					Else 
						
						$o.lastCreatedObject:=DOM Create XML element:C865($Dom_target;"g")
						
					End if 
					
					  //______________________________________________________
				: ($Txt_object="rect")
					
					$o.lastCreatedObject:=DOM Create XML element:C865($Dom_target;"rect";\
						"x";$2.x;\
						"y";$2.y;\
						"width";$2.width;\
						"height";$2.height)
					
					If ($oo.rx#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($o.lastCreatedObject;\
							"rx";Num:C11($oo.rx))
						
					End if 
					
					If ($oo.ry#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($o.lastCreatedObject;\
							"ry";Num:C11($2.ry))
						
					End if 
					
					  //______________________________________________________
				: ($Txt_object="image")
					
					Case of 
							  //………………………………………………………………………………………
						: (Value type:C1509($2.url)=Is object:K8:27)  // File object
							
							$file:=$2.url
							$o.success:=$file.exists
							
							If ($o.success)
								
								$b:=True:C214
								
								  // Get width & height of the picture if any
								If ($oo.width=Null:C1517) | ($oo.height=Null:C1517)
									
									READ PICTURE FILE:C678($file.platformPath;$p)
									$o.success:=Bool:C1537(OK)
									
									If ($o.success)
										
										PICTURE PROPERTIES:C457($p;$Num_width;$Num_height)
										$p:=$p*0
										
										If ($oo.width=Null:C1517)
											
											$oo.width:=$Num_width
											
										End if 
										
										If ($oo.height=Null:C1517)
											
											$oo.height:=$Num_height
											
										End if 
									End if 
								End if 
								
								If ($o.success)
									
									$Txt_URL:="file:/"+"/"\
										+Choose:C955(Is Windows:C1573;"/";"")\
										+Replace string:C233($file.path;" ";"%20")
									
								End if 
								
							Else 
								
								$o.errors.push("File not found ("+$file.platformPath+").")
								
							End if 
							
							  //______________________________________________________
						: (Value type:C1509($2.url)=Is text:K8:3)
							
							$Txt_URL:=String:C10($2.url)
							
							If (Length:C16($Txt_URL)>0)
								
								Case of 
										
										  //…………………………………………………………………………………………………………………………
									: ($Txt_URL[[1]]="#")\
										 | ($Txt_URL="file://@")  // Absolute path (# is for resources' folder)
										
										$b:=True:C214  // Linked file
										
										If ($Txt_URL=("file:/"+"/@"))
											
											If (Is Windows:C1573)
												
												  //file:///C:\Users\vdelachaux\Desktop\bild.4dbase\resources\Pictures\XC-EG-i.png
												$Txt_URL:=Replace string:C233($Txt_URL;"file:///";"";1)
												
											Else 
												
												  //file:///Volumes/Macintosh HD/Images/banner.svg
												$Txt_URL:=Replace string:C233($Txt_URL;"file:/"+"/";"";1)
												
											End if 
											
											$Txt_path:=Replace string:C233(Replace string:C233($Txt_URL;"/Volumes/";"";1);"/";Folder separator:K24:12)
											
											If ($Txt_path[[1]]=Folder separator:K24:12)  //"file:///Users/banner.svg" -> :Users:banner.svg
												
												  // Get the boot volume
												$Txt_volume:=System folder:C487  // "Macintosh_HD:System:"
												
												For ($i;1;Length:C16($Txt_volume);1)
													
													If ($Txt_volume[[$i]]=":")
														
														$Txt_volume:=Substring:C12($Txt_volume;1;$i-1)
														$i:=MAXLONG:K35:2-1
														
													End if 
												End for 
												
												$Txt_path:=$Txt_volume+$Txt_path  // -> Macintosh_HD:Users:banner.svg
												
											End if 
											
										Else 
											
											$Txt_URL:=Delete string:C232($Txt_URL;1;1)
											
											$Txt_path:=Get 4D folder:C485(Current resources folder:K5:16;*)\
												+Replace string:C233($Txt_URL;"/";Folder separator:K24:12)
											
										End if 
										
										$file:=File:C1566($Txt_path;fk platform path:K87:2)
										$o.success:=$file.exists
										
										  // Get width & height of the picture
										If ($o.success)\
											 & (($oo.width=Null:C1517) | ($oo.height=Null:C1517))
											
											READ PICTURE FILE:C678($Txt_path;$p)
											$o.success:=Bool:C1537(OK)
											
											If ($o.success)
												
												PICTURE PROPERTIES:C457($p;$Num_width;$Num_height)
												$p:=$p*0
												
												If ($oo.width=Null:C1517)
													
													$oo.width:=$Num_width
													
												End if 
												
												If ($oo.height=Null:C1517)
													
													$oo.height:=$Num_height
													
												End if 
											End if 
										End if 
										
										If ($o.success)
											
											$Txt_URL:="file:/"+"/"\
												+Choose:C955(Is Windows:C1573;"/";"")\
												+Replace string:C233($file.path;" ";"%20")
											
										End if 
										
										  //…………………………………………………………………………………………………………………………
									: ($Txt_URL="http@")
										
										$b:=True:C214  // URL
										
										  //…………………………………………………………………………………………………………………………
									Else   // Relative path
										
										  //#TO_BE_DONE
										$o.success:=False:C215
										$o.errors.push("Relative path are not yet managed")
										
										  //…………………………………………………………………………………………………………………………
								End case 
								
							Else 
								
								$o.errors.push("Missing image url.")
								
							End if 
							
							  //______________________________________________________
						Else 
							
							$o.errors.push("Missing valid image url.")
							
							  //______________________________________________________
					End case 
					
					If ($o.success)
						
						If ($b)  // Linked file
							
							$o.lastCreatedObject:=DOM Create XML element:C865($Dom_target;"image";\
								"xlink:href";$Txt_URL;\
								"x";Num:C11($oo.left);\
								"y";Num:C11($oo.top);\
								"width";Num:C11($oo.width);\
								"height";Num:C11($oo.height))
							
						Else   // Embedded image
							
							PICTURE PROPERTIES:C457($p;$Num_width;$Num_height)
							
							  // Encode in base64{
							PICTURE TO BLOB:C692($p;$x;".png")
							$o.success:=Bool:C1537(OK)
							
							If ($o.success)
								
								BASE64 ENCODE:C895($x;$t)
								$o.success:=Bool:C1537(OK)
								
							End if   //}
							
							If ($o.success)
								
								$o.lastCreatedObject:=DOM Create XML element:C865($Dom_target;"image";\
									"xlink:href";"data:;base64,"+$t;\
									"x";Num:C11($oo.left);\
									"y";Num:C11($oo.top);\
									"width";Num:C11($oo.width);\
									"height";Num:C11($oo.height))
								
							End if 
						End if 
					End if 
					
					  //______________________________________________________
				: ($Txt_object="imageEmbedded")
					
					$p:=$2.image
					
					If (Picture size:C356($p)>0)
						
						PICTURE PROPERTIES:C457($p;$Num_width;$Num_height)
						
						  // Encode in base64
						PICTURE TO BLOB:C692($p;$x;Choose:C955($oo.codec#Null:C1517;String:C10($oo.codec);".png"))
						$o.success:=Bool:C1537(OK)
						
						If ($o.success)
							
							BASE64 ENCODE:C895($x;$t)
							$o.success:=Bool:C1537(OK)
							SET BLOB SIZE:C606($x;0)  // Warning: SET BLOB SIZE set OK
							
							If ($o.success)
								
								  // Put the encoded image
								$o.lastCreatedObject:=DOM Create XML element:C865($Dom_target;"image";\
									"xlink:href";"data:;base64,"+$t;\
									"x";$2.x;\
									"y";$2.y;\
									"width";$Num_width;\
									"height";$Num_height)
								
							End if 
						End if 
					End if 
					
					  //______________________________________________________
				: ($Txt_object="textArea")
					
					$t:=Replace string:C233(String:C10($2.text);"\r\n";"\r")
					
					$o.lastCreatedObject:=DOM Create XML element:C865($Dom_target;"textArea";\
						"x";$2.x;\
						"y";$2.y;\
						"width";Choose:C955($oo.width=Null:C1517;"auto";Num:C11($oo.width));\
						"height";Choose:C955($oo.height=Null:C1517;"auto";Num:C11($oo.height)))
					
					$o.success:=Bool:C1537(OK)
					
					If ($o.success)\
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
						
						$o.success:=Bool:C1537(OK)
						
					End if 
					
					  //______________________________________________________
				Else 
					
					$o.errors.push("Unknown object: \""+$Txt_object+"\"")
					
					  //______________________________________________________
			End case 
			
			If ($o.success)  // Optional attributes
				
				If ($oo.id#Null:C1517)
					
					DOM SET XML ATTRIBUTE:C866($o.lastCreatedObject;\
						"id";String:C10($oo.id))
					
				End if 
				
				If ($oo.style#Null:C1517)
					
					DOM SET XML ATTRIBUTE:C866($o.lastCreatedObject;\
						"style";String:C10($oo.style))
					
				End if 
				
				If ($oo.stroke#Null:C1517)
					
					DOM SET XML ATTRIBUTE:C866($o.lastCreatedObject;\
						"stroke";String:C10($oo.stroke))
					
				End if 
				
				If ($oo["stroke-opacity"]#Null:C1517)
					
					DOM SET XML ATTRIBUTE:C866($o.lastCreatedObject;\
						"stroke-opacity";Num:C11($oo["stroke-opacity"])/100)
					
				End if 
				
				If ($oo["stroke-width"]#Null:C1517)
					
					DOM SET XML ATTRIBUTE:C866($o.lastCreatedObject;\
						"stroke-width";Num:C11($oo["stroke-width"]))
					
				End if 
				
				If ($oo.fill#Null:C1517)
					
					DOM SET XML ATTRIBUTE:C866($o.lastCreatedObject;\
						"fill";String:C10($oo.fill))
					
				End if 
				
				If ($oo["fill-opacity"]#Null:C1517)
					
					DOM SET XML ATTRIBUTE:C866($o.lastCreatedObject;\
						"fill-opacity";Num:C11($oo["fill-opacity"])/100)
					
				End if 
				
				If (New collection:C1472("group";"text";"textArea").indexOf($Txt_object)#-1)
					
					If ($oo["font-family"]#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($o.lastCreatedObject;\
							"font-family";String:C10($oo["font-family"]))
						
					End if 
					
					If ($oo["font-size"]#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($o.lastCreatedObject;\
							"font-size";Num:C11($oo["font-size"]))
						
					End if 
					
					If ($oo["font-style"]#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($o.lastCreatedObject;\
							"font-style";String:C10($oo["font-style"]))
						
					End if 
					
					If ($oo["font-weight"]#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($o.lastCreatedObject;\
							"font-weight";String:C10($oo["font-weight"]))
						
					End if 
					
					If ($oo["text-align"]#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($o.lastCreatedObject;\
							"text-align";String:C10($oo["text-align"]))
						
					End if 
					
					If ($oo["text-decoration"]#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($o.lastCreatedObject;\
							"text-decoration";String:C10($oo["text-decoration"]))
						
					End if 
				End if 
				
				  //if($oo#null)
				  //For each ($t;$oo)
				
				  //DOM SET XML ATTRIBUTE($o.lastCreatedObject;\
															$t;$oo[$t])
				
				  //End for each 
				  //end if
			End if 
			
			  //=================================================================
		: ($1="set")
			
			Case of 
					
					  //______________________________________________________
				: ($2.what="opacity")
					
					If ($Dom_target=$o.root)
						
						If ($oo.fill#Null:C1517)
							
							DOM SET XML ATTRIBUTE:C866($Dom_target;\
								"viewport-fill-opacity";Num:C11($oo.fill)/100)
							
						Else 
							
							  // #REMOVE_ATTRIBUTE_?
							DOM SET XML ATTRIBUTE:C866($Dom_target;\
								"viewport-fill-opacity";1)
							
						End if 
						
					Else 
						
						If ($oo.fill#Null:C1517)
							
							DOM SET XML ATTRIBUTE:C866($Dom_target;\
								"fill-opacity";Num:C11($oo.fill)/100)
							
							If ($oo.stroke#Null:C1517)
								
								DOM SET XML ATTRIBUTE:C866($Dom_target;\
									"stroke-opacity";Num:C11($oo.stroke)/100)
								
							Else 
								
								DOM SET XML ATTRIBUTE:C866($Dom_target;\
									"stroke-opacity";Num:C11($oo.fill)/100)
								
							End if 
							
						Else 
							
							  // #REMOVE_ATTRIBUTE_?
							DOM SET XML ATTRIBUTE:C866($Dom_target;\
								"fill-opacity";1)
							
							DOM SET XML ATTRIBUTE:C866($Dom_target;\
								"stroke-opacity";1)
							
						End if 
					End if 
					
					  //______________________________________________________
				: ($2.what="dimensions")
					
					If ($2.width#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($Dom_target;\
							"width";String:C10($2.width;"&xml")+$2.unit)
						
						$o.success:=Bool:C1537(OK)
						
					Else 
						
						$o.success:=True:C214
						
					End if 
					
					If ($2.height#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($Dom_target;\
							"height";String:C10($2.height;"&xml")+$2.unit)
						
						$o.success:=$o.success & Bool:C1537(OK)
						
					End if 
					
					  //______________________________________________________
				: ($2.what="text-rendering")
					
					If (Length:C16($2.value)>0)
						
						DOM SET XML ATTRIBUTE:C866($Dom_target;\
							"text-rendering";$2.value)
						
					Else 
						
						DOM REMOVE XML ATTRIBUTE:C1084($Dom_target;"text-rendering")
						
					End if 
					
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