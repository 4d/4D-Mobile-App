//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : svg
  // Database: 4D Mobile App
  // ID[07DA99DA1D1D483E928AFCA550B20BA2]
  // Created #11-6-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //  Manipulate SVG as objects
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_BLOB:C604($x)
C_PICTURE:C286($p)
C_REAL:C285($Num_height;$Num_width)
C_TEXT:C284($Dom_target;$t)
C_OBJECT:C1216($o;$oo)

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
		"group";Formula:C1597(svg ("new";New object:C1471("what";"group";"properties";$1)));\
		"rect";Formula:C1597(svg ("new";New object:C1471("what";"rect";"x";Num:C11($1);"y";Num:C11($2);"width";Num:C11($3);"height";Num:C11($4);"properties";$5)));\
		"embeddedimage";Formula:C1597(svg ("new";New object:C1471("what";"embedded-image";"image";$1;"ref";String:C10($2))));\
		"dimensions";Formula:C1597(svg ("set";New object:C1471("what";"dimensions";"width";Num:C11($1);"height";Num:C11($2);"unit";String:C10($3))));\
		"textRendering";Formula:C1597(svg ("set";New object:C1471("what";"text-rendering";"value";String:C10($1);"ref";String:C10($2))));\
		"opacity";Formula:C1597(svg ("set";New object:C1471("what";"opacity";"properties";$1)));\
		"get";Formula:C1597(svg ("get";New object:C1471("what";String:C10($1);"options";$2))[Choose:C955($1="picture";"picture";"xml")])\
		)
	
	$t:=DOM Create XML Ref:C861("svg";"http://www.w3.org/2000/svg")
	
	If (Bool:C1537(OK))
		
		$o.root:=$t
		
		DOM SET XML DECLARATION:C859($o.root;"UTF-8";True:C214)
		XML SET OPTIONS:C1090($o.root;XML indentation:K45:34;XML with indentation:K45:35)
		
	End if 
	
	$o.success:=($o.root#Null:C1517)
	
	If ($o.success)
		
		  //
		
	Else 
		
		$o.errors.push("Failed to create SVG object")
		
	End if 
	
Else 
	
	$o:=This:C1470
	
	$oo:=$2.properties
	
	If (Length:C16(String:C10($oo.holder))>0)
		
		$Dom_target:=$oo.holder
		
	Else 
		
		  // Use root
		$Dom_target:=$o.root
		
	End if 
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //=================================================================
		: ($1="get")
			
			If ($o.root#Null:C1517)
				
				Case of 
						
						  //______________________________________________________
					: ($2.what="picture")
						
						SVG EXPORT TO PICTURE:C1017($o.root;$p;Choose:C955($2.options.exportType#Null:C1517;Num:C11($2.options.exportType);Copy XML data source:K45:17))
						$o.picture:=$p
						
						  //______________________________________________________
					: ($2.what="xml")
						
						DOM EXPORT TO VAR:C863($o.root;$t)
						$o.xml:=$t
						
						  //______________________________________________________
					Else 
						
						  // A "Case of" statement should never omit "Else"
						
						  //______________________________________________________
				End case 
				
			End if 
			
			  //=================================================================
		: ($1="close")
			
			If ($o.root#Null:C1517)
				
				DOM CLOSE XML:C722($o.root)
				$o.root:=Null:C1517
				
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
					
					  // A "Case of" statement should never omit "Else"
					
					  //______________________________________________________
			End case 
			
			  //=================================================================
		: ($1="new")
			
			Case of 
					
					  //______________________________________________________
				: ($2.what="group")
					
					If ($oo.url#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($o.root;\
							"xmlns:xlink";"http://www.w3.org/1999/xlink")
						
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
				: ($2.what="rect")
					
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
				: ($2.what="embedded-image")
					
					If (Picture size:C356($2.image)>0)
						
						PICTURE PROPERTIES:C457($2.image;$Num_width;$Num_height)
						
						  // Encode in base64 {
						PICTURE TO BLOB:C692($2.image;$x;Choose:C955($2.codec#Null:C1517;$2.codec;".png"))
						$o.success:=Bool:C1537(OK)
						
						If ($o.success)
							
							BASE64 ENCODE:C895($x;$t)
							$o.success:=Bool:C1537(OK)
							SET BLOB SIZE:C606($x;0)  // Warning: SET BLOB SIZE set OK
							
							If ($o.success)
								
								  // Add the xmlns:link
								DOM SET XML ATTRIBUTE:C866($o.root;\
									"xmlns:xlink";"http://www.w3.org/1999/xlink")
								
								  // Put the encoded image
								$o.lastCreatedObject:=DOM Create XML element:C865($Dom_target;"image";\
									"xlink:href";"data:;base64,"+$t;\
									"x";Num:C11($2.xCoord);\
									"y";Num:C11($2.yCoord);\
									"width";$Num_width;\
									"height";$Num_height)
								
							End if 
						End if 
					End if 
					
					  //______________________________________________________
				: (False:C215)
					
					  //______________________________________________________
				Else 
					
					  // A "Case of" statement should never omit "Else"
					
					  //______________________________________________________
			End case 
			
			  // Common
			If ($oo.id#Null:C1517)
				
				DOM SET XML ATTRIBUTE:C866($o.lastCreatedObject;\
					"id";String:C10($oo.id))
				
			End if 
			
			If ($oo.stroke#Null:C1517)
				
				DOM SET XML ATTRIBUTE:C866($o.lastCreatedObject;\
					"stroke";String:C10($oo.stroke))
				
			End if 
			
			If ($oo["stroke-opacity"]#Null:C1517)
				
				DOM SET XML ATTRIBUTE:C866($o.lastCreatedObject;\
					"stroke-opacity";Num:C11($oo["stroke-opacity"]))
				
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
					"fill-opacity";Num:C11($oo["fill-opacity"]))
				
			End if 
			
			  //=================================================================
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
			
			  //=================================================================
	End case 
	
	If ($o.success)
		
		  //
		
	Else 
		
		$o.errors.push($1+" "+$2.what+" failed")
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End