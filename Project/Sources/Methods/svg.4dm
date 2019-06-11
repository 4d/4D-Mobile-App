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
C_BOOLEAN:C305($b)
C_REAL:C285($Num_height;$Num_width)
C_TEXT:C284($Dom_target;$t)
C_OBJECT:C1216($o)

If (False:C215)
	C_OBJECT:C1216(svg ;$0)
	C_TEXT:C284(svg ;$1)
	C_OBJECT:C1216(svg ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470=Null:C1517)
	
	$o:=New object:C1471(\
		"root";Null:C1517;\
		"success";False:C215;\
		"errors";New collection:C1472;\
		"lastCreatedObject";"";\
		"setDimensions";Formula:C1597(svg ("set";New object:C1471("what";"dimensions";"width";Num:C11($1);"height";Num:C11($2))));\
		"setTextRendering";Formula:C1597(svg ("set";New object:C1471("what";"text-rendering";"value";String:C10($1);"ref";String:C10($2))));\
		"embeddedimage";Formula:C1597(svg ("new";New object:C1471("what";"embedded-image";"image";$1;"ref";String:C10($2))))\
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
	
	If (Length:C16(String:C10($2.ref))>0)
		
		$Dom_target:=$2.ref
		
	Else 
		
		  // Use root
		$Dom_target:=$o.root
		
	End if 
	
	Case of 
			
			  //=================================================================
		: ($1="set")
			
			Case of 
					
					  //______________________________________________________
				: ($2.what="dimensions")
					
					DOM SET XML ATTRIBUTE:C866($Dom_target;\
						"width";String:C10($2.width;"&xml"))
					
					$o.success:=Bool:C1537(OK)
					
					If ($2.height#0)
						
						DOM SET XML ATTRIBUTE:C866($Dom_target;\
							"height";String:C10($2.height;"&xml"))
						
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
				: (False:C215)
					
					  //______________________________________________________
				Else 
					
					  // A "Case of" statement should never omit "Else"
					  //______________________________________________________
			End case 
			
			  //=================================================================
		: ($1="new")
			
			Case of 
					
					  //______________________________________________________
				: ($2.what="embedded-image")
					
					If (Picture size:C356($2.image)>0)
						
						PICTURE PROPERTIES:C457($2.image;$Num_width;$Num_height)
						
						  // Encode in base64 {
						PICTURE TO BLOB:C692($2.image;$x;Choose:C955($2.codec#Null:C1517;$2.codec;".png"))
						$b:=Bool:C1537(OK)
						
						If ($b)
							
							BASE64 ENCODE:C895($x;$t)
							$b:=Bool:C1537(OK)
							SET BLOB SIZE:C606($x;0)
							
							If ($b)
								
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