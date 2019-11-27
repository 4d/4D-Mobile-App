//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : xml
  // Created 06-8-2019 by Marchand Eric
  // ----------------------------------------------------
  // Description:
  // Manipulate XML element as objects
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

If (False:C215)
	C_OBJECT:C1216(xml ;$0)
	C_TEXT:C284(xml ;$1)
	C_OBJECT:C1216(xml ;$2)
End if 

C_OBJECT:C1216($o)
C_BLOB:C604($x)
C_TEXT:C284($t;$tt)

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)  // Constructor
	
	$o:=New object:C1471(\
		"";"xml";\
		"root";Formula:C1597(xml ("root"));\
		"create";Formula:C1597(xml ("create";New object:C1471("name";$1)));\
		"parent";Formula:C1597(xml ("parent"));\
		"firstChild";Formula:C1597(xml ("firstChild"));\
		"lastChild";Formula:C1597(xml ("lastChild"));\
		"children";Formula:C1597(xml ("children";New object:C1471("recursive";$1)));\
		"nextSibling";Formula:C1597(xml ("nextSibling"));\
		"previousSibling";Formula:C1597(xml ("previousSibling"));\
		"findByXPath";Formula:C1597(xml ("findByXPath";New object:C1471("xpath";$1)));\
		"findOrCreate";Formula:C1597(xml ("findOrCreate";New object:C1471("element";$1)));\
		"findMany";Formula:C1597(xml ("findMany";New object:C1471("xpath";$1)));\
		"findById";Formula:C1597(xml ("findById";New object:C1471("id";$1)));\
		"findByName";Formula:C1597(xml ("findByName";New object:C1471("name";$1)));\
		"append";Formula:C1597(xml ("append";New object:C1471("element";$1)));\
		"insertAt";Formula:C1597(xml ("insertAt";New object:C1471("element";$1;"childIndex";$2)));\
		"insertFirst";Formula:C1597(xml ("insertAt";New object:C1471("element";$1;"childIndex";1)));\
		"attributes";Formula:C1597(xml ("attributes"));\
		"getAttribute";Formula:C1597(xml ("getAttribute";New object:C1471("name";$1)));\
		"setAttribute";Formula:C1597(xml ("setAttribute";New object:C1471("name";$1;"value";$2)));\
		"setAttributes";Formula:C1597(xml ("setAttributes";$1));\
		"removeAttribute";Formula:C1597(xml ("removeAttribute";New object:C1471("attribName";$1)));\
		"getValue";Formula:C1597(xml ("getValue"));\
		"setValue";Formula:C1597(xml ("setValue";New object:C1471("value";$1)));\
		"setOption";Formula:C1597(xml ("setOption";New object:C1471("selector";$1;"value";$2)));\
		"toObject";Formula:C1597(xml ("toObject"));\
		"setName";Formula:C1597(xml ("setName";New object:C1471("name";$1)));\
		"getName";Formula:C1597(xml ("getName"));\
		"remove";Formula:C1597(xml ("remove"));\
		"export";Formula:C1597(xml ("export"));\
		"save";Formula:C1597(xml ("save";$1));\
		"close";Formula:C1597(xml ("close"))\
		)
	
	Case of 
			
			  //=================================================================
		: ($1="create")
			
			If (Length:C16(String:C10($2.root))>0)
				
				If (Length:C16(String:C10($2.namespace))>0)
					
					$t:=DOM Create XML Ref:C861($2.root;$2.namespace)
					
				Else 
					
					$t:=DOM Create XML Ref:C861($2.root)
					
				End if 
				
				$o.elementRef:=$t
				
			Else 
				
				$o.errors:=New collection:C1472("No valid root name definied to create.")
				
			End if 
			
			  //=================================================================
		: ($1="load")
			
			If (Bool:C1537($2.exists))
				
				$t:=DOM Parse XML source:C719($2.platformPath)
				
				If (Bool:C1537(OK))
					
					$o.elementRef:=$t
					
					$o.file:=$2  // keep for save
					
				End if 
				
			Else 
				
				$o.errors:=New collection:C1472("No valid file to load: "+String:C10($2.path))
				
			End if 
			
			  //=================================================================
		: ($1="parse")
			
			If ($2.variable#Null:C1517)
				
				  // TRY (
				C_TEXT:C284($Txt_methodOnError)
				$Txt_methodOnError:=Method called on error:C704
				xml_ERROR:=0
				ON ERR CALL:C155("xml_NO_ERROR")
				
				If (Value type:C1509($2.variable)=Is BLOB:K8:12)
					
					$x:=$2.variable
					$t:=DOM Parse XML variable:C720($x)
					
				Else 
					
					$tt:=String:C10($2.variable)
					$t:=DOM Parse XML variable:C720($tt)
					
				End if 
				
				If (Bool:C1537(OK))
					
					$o.elementRef:=$t
					
				End if 
				
				  // } CATCH {
				If (xml_ERROR#0)
					$o.errors:=New collection:C1472("Failed to parse XML: "+String:C10(xml_ERROR))
				End if 
				ON ERR CALL:C155($Txt_methodOnError)
				  // }
				
				$o.variable:=$2.variable
				
			Else 
				
				$o.errors:=New collection:C1472("No valid variable to parse.")
				
			End if 
			
			  //________________________________________
		Else 
			
			$t:=$1  // we pass the element ref as first value?
			
			Case of 
					
					  //----------------------------------------
				: (Length:C16($t)#32)
					
					$o.errors:=New collection:C1472("Invalid length for xml element reference: "+$t)
					
					  //----------------------------------------
				: ($t="00000000000000000000000000000000")
					
					$o.errors:=New collection:C1472("Invalid XML element.")
					
					  //----------------------------------------
				Else 
					
					$o.elementRef:=$t
					
					  //----------------------------------------
			End case 
			
			  //________________________________________
	End case 
	
	$o.success:=($o.elementRef#Null:C1517)
	
Else 
	
	$o:=This:C1470
	
	If (Asserted:C1132($o#Null:C1517;"OOPS, this method must be called from a member method"))
		
		If ($o.elementRef=Null:C1517)
			
			$o.success:=False:C215
			$o.errors:=New collection:C1472("The DOM tree is not valid.")
			
		Else 
			
			$o.success:=True:C214
			$t:=""
			
			Case of 
					
					  //=================================================================
				: ($1="close")  /// Close the current XML element
					
					DOM CLOSE XML:C722($o.elementRef)
					$o.elementRef:=Null:C1517
					
					  //=================================================================
				: ($1="save")  /// Save the current XML element to a `File`
					
					Case of 
							
							  //----------------------------------------
						: (Value type:C1509($2)=Is object:K8:27)  // suppose file
							
							DOM EXPORT TO FILE:C862($o.elementRef;$2.platformPath)
							
							  //----------------------------------------
						: ($o.file#Null:C1517)  // use file from "load"
							
							DOM EXPORT TO FILE:C862($o.elementRef;$o.file.platformPath)
							
							  //----------------------------------------
						Else 
							
							$o.success:=False:C215
							
							  //----------------------------------------
					End case 
					
					  //=================================================================
				: ($1="remove")
					
					DOM REMOVE XML ELEMENT:C869($o.elementRef)
					$o.success:=Bool:C1537(OK)
					
					  //=================================================================
				: ($1="removeAttribute")
					
					DOM REMOVE XML ATTRIBUTE:C1084($o.elementRef;$2.attribName)
					$o.success:=Bool:C1537(OK)
					
					  //=================================================================
				: ($1="setName")
					
					DOM SET XML ELEMENT NAME:C867($o.elementRef;$2.name)
					$o.success:=Bool:C1537(OK)
					
					  //=================================================================
				: ($1="getName")
					
					DOM GET XML ELEMENT NAME:C730($o.elementRef;$tt)
					$o.name:=$tt
					$o.success:=Bool:C1537(OK)
					
					  //=================================================================
				: ($1="setAttribute")
					
					DOM SET XML ATTRIBUTE:C866($o.elementRef;\
						$2.name;$2.value)
					$o:=New object:C1471(\
						"success";Bool:C1537(OK))
					
					  //=================================================================
				: ($1="setAttributes")
					
					For each ($tt;$2)
						
						DOM SET XML ATTRIBUTE:C866($o.elementRef;\
							$tt;$2[$tt])
						
					End for each 
					
					$o:=New object:C1471(\
						"success";Bool:C1537(OK))
					
					  //=================================================================
				: ($1="getAttribute")
					
					  // TRY (
					C_TEXT:C284($Txt_methodOnError)
					$Txt_methodOnError:=Method called on error:C704
					xml_ERROR:=0
					ON ERR CALL:C155("xml_NO_ERROR")
					  //) {
					
					DOM GET XML ATTRIBUTE BY NAME:C728($o.elementRef;$2.name;$tt)
					
					$o:=New object:C1471(\
						"value";$tt;\
						"success";Bool:C1537(OK))
					
					
					  // } CATCH {
					If (xml_ERROR#0)
						$t:="00000000000000000000000000000000"  // we want to return a success false node, maybe use another... like blank
					End if 
					ON ERR CALL:C155($Txt_methodOnError)
					  // }
					
					  //=================================================================
				: ($1="attributes")
					
					$o:=New object:C1471(\
						"attributes";xml_attributes ($o.elementRef);\
						"success";True:C214)
					
					  // use a level because could have an attribute named success...
					
					  //=================================================================
				: ($1="getValue")
					
					DOM GET XML ELEMENT VALUE:C731($o.elementRef;$tt)  // HERE only text, variant will be better
					$o:=New object:C1471(\
						"success";Bool:C1537(OK);\
						"value";$tt)
					
					  //=================================================================
				: ($1="setValue")
					
					DOM SET XML ELEMENT VALUE:C868($o.elementRef;$2.value)
					$o:=New object:C1471(\
						"success";Bool:C1537(OK))
					
					  //=================================================================
				: ($1="setOption")
					
					XML SET OPTIONS:C1090($o.elementRef;$2.selector;$2.value)
					
					$o:=New object:C1471(\
						"success";True:C214)
					
					  //=================================================================
				: ($1="export")
					
					DOM EXPORT TO VAR:C863($o.elementRef;$tt)
					$o.success:=Bool:C1537(OK)
					$o.variable:=$tt
					
					  // alternative new object
					  //$o:=New object("variable";$tt;"success";Bool(OK))
					
					  //=================================================================
				: ($1="toObject")
					
					$o:=xml_elementToObject ($o.elementRef)
					
					  //=================================================================
				: ($1="findById")
					
					$t:=DOM Find XML element by ID:C1010($o.elementRef;$2.id)
					
					  //=================================================================
				: ($1="findByXPath")
					
					$t:=xml_findElement ($o.elementRef;$2.xpath).reference
					
					  //=================================================================
				: ($1="findOrCreate")
					
					$t:=$o.elementRef
					DOM GET XML ELEMENT NAME:C730($t;$tt)
					
					$o:=xml_findElement ($t;$tt+"/"+$2.element)  // a new $o will be created after, $t filled
					If ($o.success)
						
						$t:=$o.reference
						
					Else 
						
						$t:=DOM Create XML element:C865($t;$2.element)  // Will work only with simple xpath ie. subnode name
						
					End if 
					
					  //=================================================================
				: ($1="findMany")
					
					ARRAY TEXT:C222($tDom_dicts;0x0000)
					$tDom_dicts{0}:=DOM Find XML element:C864($o.elementRef;$2.xpath;$tDom_dicts)
					
					$o:=New object:C1471(\
						"elements";New collection:C1472;\
						"success";Bool:C1537(OK))
					
					This:C1470[""]:=Null:C1517
					C_LONGINT:C283($Lon_ii)
					
					For ($Lon_ii;1;Size of array:C274($tDom_dicts);1)
						
						$o.elements.push(xml ($tDom_dicts{$Lon_ii}))
						
					End for 
					
					This:C1470[""]:="_xml"
					
					  //=================================================================
				: ($1="findByName")
					
					$o:=New object:C1471(\
						"elements";New collection:C1472;\
						"parent";$o;\
						"success";True:C214)
					
					This:C1470[""]:=Null:C1517
					
					For each ($tt;xml_findByName ($o.parent.elementRef;$2.name))
						
						$o.elements.push(xml ($tt))
						
					End for each 
					
					This:C1470[""]:="_xml"
					
					  //=================================================================
				: ($1="create")
					
					$t:=DOM Create XML element:C865($o.elementRef;$2.name)
					
					  //=================================================================
				: ($1="parent")
					
					$t:=DOM Get parent XML element:C923($o.elementRef)  // parentElementName, ...
					
					  //=================================================================
				: ($1="firstChild")
					
					$t:=DOM Get first child XML element:C723($o.elementRef)
					
					  //=================================================================
				: ($1="lastChild")
					
					$t:=DOM Get last child XML element:C925($o.elementRef)
					  //=================================================================
				: ($1="children")
					
					ARRAY LONGINT:C221($tLon_types;0x0000)
					ARRAY TEXT:C222($tTxt_refs;0x0000)
					
					DOM GET XML CHILD NODES:C1081($o.elementRef;$tLon_types;$tTxt_refs)
					$t:=""
					$o.elements:=New collection:C1472()
					
					C_LONGINT:C283($i)
					For ($i;1;Size of array:C274($tLon_types);1)
						If ($tLon_types{$i}=11)
							
							This:C1470[""]:=Null:C1517
							C_OBJECT:C1216($Obj_child)
							$Obj_child:=xml ($tTxt_refs{$i})
							$o.elements.push($Obj_child)
							This:C1470[""]:="_xml"
							
							If (Bool:C1537($2.recursive))
								$o.elements.combine($Obj_child.children(True:C214).elements)  // XXX manage errors?
							End if 
							
						End if 
					End for 
					
					  //=================================================================
				: ($1="nextSibling")
					
					$t:=DOM Get next sibling XML element:C724($o.elementRef)
					
					  //=================================================================
				: ($1="previousSibling")
					
					$t:=DOM Get previous sibling XML element:C924($o.elementRef)
					
					  //=================================================================
				: ($1="root")
					
					$t:=DOM Get root XML element:C1053($o.elementRef)
					
					  //=================================================================
				: ($1="append")
					
					  // TRY (
					C_TEXT:C284($Txt_methodOnError)
					$Txt_methodOnError:=Method called on error:C704
					xml_ERROR:=0
					ON ERR CALL:C155("xml_NO_ERROR")
					
					Case of 
							
							  //----------------------------------------
						: (Value type:C1509($2.element)=Is object:K8:27)
							
							Case of 
									
									  //........................................
								: ($2.element.elementRef#Null:C1517)  // could check also _is xml
									
									$t:=DOM Append XML element:C1082($o.elementRef;$2.element.elementRef)
									
									  //........................................
								: ((Bool:C1537($2.element.isFile))\
									 & ($2.element.platformPath#Null:C1517))  // is file?
									
									$t:=DOM Append XML element:C1082($o.elementRef;DOM Parse XML source:C719($2.element.platformPath))
									
									  //........................................
								Else 
									
									$o.errors:=New collection:C1472("Invalid object reference passed")
									
									  //........................................
							End case 
							
							  //----------------------------------------
						: (Value type:C1509($2.element)=Is text:K8:3)
							
							$tt:=$2.element
							$t:=DOM Append XML element:C1082($o.elementRef;DOM Parse XML variable:C720($tt))
							
							  //----------------------------------------
						: (Value type:C1509($2.element)=Is BLOB:K8:12)
							
							$x:=$2.element
							$t:=DOM Append XML element:C1082($o.elementRef;DOM Parse XML variable:C720($x))
							
							  //----------------------------------------
						Else 
							
							$o.errors:=New collection:C1472("Invalid element reference passed")
							
							  //----------------------------------------
					End case 
					
					  // } CATCH {
					If (xml_ERROR#0)
						$t:="00000000000000000000000000000000"  // we want to return a success false node, maybe use another... like blank
					End if 
					ON ERR CALL:C155($Txt_methodOnError)
					  // }
					
					  //=================================================================
				: ($1="insertAt")
					
					  // TRY (
					C_TEXT:C284($Txt_methodOnError)
					$Txt_methodOnError:=Method called on error:C704
					xml_ERROR:=0
					ON ERR CALL:C155("xml_NO_ERROR")
					
					Case of 
							
							  //----------------------------------------
						: (Value type:C1509($2.element)=Is object:K8:27)
							
							Case of 
									
									  //........................................
								: ($2.element.elementRef#Null:C1517)  // could check also _is xml
									
									$t:=DOM Insert XML element:C1083($o.elementRef;$2.element.elementRef;$2.childIndex)
									
									  //........................................
								: ((Bool:C1537($2.element.isFile))\
									 & ($2.element.platformPath#Null:C1517))  // is file?
									
									$t:=DOM Insert XML element:C1083($o.elementRef;DOM Parse XML source:C719($2.element.platformPath);$2.childIndex)
									
									  //........................................
								Else 
									
									$o.errors:=New collection:C1472("Invalid object reference passed")
									
									  //........................................
							End case 
							
							  //----------------------------------------
						: (Value type:C1509($2.element)=Is text:K8:3)
							
							$tt:=$2.element
							$t:=DOM Insert XML element:C1083($o.elementRef;DOM Parse XML variable:C720($tt);$2.childIndex)
							
							  //----------------------------------------
						: (Value type:C1509($2.element)=Is BLOB:K8:12)
							
							$x:=$2.element
							$t:=DOM Insert XML element:C1083($o.elementRef;DOM Parse XML variable:C720($x);$2.childIndex)
							
							  //----------------------------------------
						Else 
							
							$o.errors:=New collection:C1472("Invalid element reference passed")
							
							  //----------------------------------------
					End case 
					
					  // } CATCH {
					If (xml_ERROR#0)
						$t:="00000000000000000000000000000000"  // we want to return a success false node, maybe use another... like blank
					End if 
					ON ERR CALL:C155($Txt_methodOnError)
					  // }
					
					  //=================================================================
				Else 
					
					ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
					
					  //=================================================================
			End case 
			
			If (Length:C16($t)>0)  // Result in a new node
				
				This:C1470[""]:=Null:C1517
				$o:=xml ($t)
				This:C1470[""]:="_xml"
				
			End if 
		End if 
	End if 
	
	If (Not:C34($o.success))
		
		If ($o.errors=Null:C1517)
			
			$o.errors:=New collection:C1472()
			
		End if 
		
		If (xml_ERROR#0)
			  // } CATCH {
			$o.errors:=New collection:C1472("Failed to parse XML: "+String:C10(xml_ERROR))
			If ($2.element#Null:C1517)  // append/insert
				$o.variable:=$2.element
			End if 
			  // }
		Else 
			$o.errors.push(String:C10($1)+" failed")
		End if 
	End if 
End if 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End