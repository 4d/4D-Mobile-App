//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : formatters
  // Created 2018 by Eric Marchand
  // ----------------------------------------------------
  // Description: Manage data formatters
  //  * action = extract: from data model get a list of formatters
  //  * action = generate: generate from a list of formatters project files
  //  * action = get: get indexed formatter info by name
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_BOOLEAN:C305($bAppend)
C_LONGINT:C283($i)
C_TEXT:C284($t;$tFieldID;$tTable)
C_OBJECT:C1216($archive;$errors;$folder;$o;$oField;$oFormatter)
C_OBJECT:C1216($oIN;$oOUT;$oResources;$oResult)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(formatters ;$0)
	C_OBJECT:C1216(formatters ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
If (Asserted:C1132(Count parameters:C259>=1;"Missing parameter"))
	
	  // Required parameters
	$oIN:=$1
	
	  // Optional parameters
	If (Count parameters:C259>=2)
		
		  // <NONE>
		
	End if 
	
	$oOUT:=New object:C1471(\
		"success";False:C215)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------

Case of 
		
		  //______________________________________________________
	: (Length:C16(String:C10($oIN.action))=0)
		
		$oOUT.errors:=New collection:C1472("No action provided when processing formatters")
		ASSERT:C1129(dev_Matrix ;"No action provided when processing formatters")
		
		  //______________________________________________________
	: ($oIN.action="getByName")
		
		$oResources:=SHARED.resources
		
		  // Formatter definitions
		$oOUT.formatters:=$oResources.definitions
		
		For each ($t;$oOUT.formatters)
			
			If (Value type:C1509($oOUT.formatters[$t])=Is collection:K8:32)
				
				For each ($oFormatter;$oOUT.formatters[$t])
					
					If (Length:C16(String:C10($oFormatter.name))>0)\
						 & (String:C10($oFormatter.name)#"-")
						
						$oOUT.formatters[String:C10($oFormatter.name)]:=$oFormatter
						
					End if 
				End for each 
				
				OB REMOVE:C1226($oOUT.formatters;$t)
				
			End if 
		End for each 
		
		  // Others formatter
		For each ($c;$oResources.fieldBindingTypes.filter("col_formula";"$1.result:=(Value type:C1509($1.value)=42)");1)
			
			  // Keep only formats with defined name
			$c:=$c.filter("col_formula";"$1.result:=($1.value.name#Null:C1517)&(String:C10($1.value.name)#\"-\")")
			
			For each ($oFormatter;$c)
				
				$t:=String:C10($oFormatter.name)
				
				If (Length:C16($t)>0)\
					 & ($t#"-")
					
					$oOUT.formatters[$t]:=$oFormatter
					
				End if 
			End for each 
		End for each 
		
		  // Host formatters
		$oResources:=COMPONENT_Pathname ("host_formatters")
		
		If ($oResources.exists)
			
			For each ($o;$oResources.folders())
				
				$oFormatter:=ob_parseFile ($o.file("manifest.json"))
				
				If ($oFormatter.success)
					
					$oFormatter:=$oFormatter.value
					$oFormatter.isHost:=True:C214
					$oFormatter.path:=$o.platformPath
					$oFormatter.folder:=$o
					$oOUT.formatters["/"+$o.name]:=$oFormatter
					
				End if 
			End for each 
		End if 
		
		  //______________________________________________________
	: ($oIN.action="getByType")
		
		If (Bool:C1537($oIN.host))
			
			$oOUT.formatters:=New collection:C1472
			
			$oResources:=COMPONENT_Pathname ("host_formatters")
			
			If ($oResources.exists)
				
				$c:=New collection:C1472
				
				$c[Is alpha field:K8:1]:="text"
				$c[Is boolean:K8:9]:="boolean"
				$c[Is integer:K8:5]:="integer"
				$c[Is longint:K8:6]:="integer"
				$c[Is integer 64 bits:K8:25]:="integer"
				$c[Is real:K8:4]:="real"
				$c[_o_Is float:K8:26]:="float"
				$c[Is date:K8:7]:="date"
				$c[Is time:K8:8]:="time"
				$c[Is text:K8:3]:="text"
				$c[Is picture:K8:10]:="picture"
				
				For each ($oFormatter;$oResources.folders())
					
					If ($oFormatter.file("manifest.json").exists)
						
						$o:=JSON Parse:C1218($oFormatter.file("manifest.json").getText())
						
						If ($o.type#Null:C1517)
							
							If (Value type:C1509($o.type)=Is collection:K8:32)
								
								If ($o.type.indexOf($c[$oIN.type])#-1)
									
									$oOUT.formatters.push(New object:C1471(\
										"name";$oFormatter.name))
									
								End if 
								
							Else 
								
								If ($o.type=$c[$oIN.type])
									
									$oOUT.formatters.push(New object:C1471(\
										"name";$oFormatter.name))
									
								End if 
							End if 
						End if 
					End if 
				End for each 
				
				If (feature.with("resourcesBrowser"))
					
					$errors:=err .hide()
					
					For each ($oFormatter;$oResources.files().query("extension = :1";SHARED.archiveExtension))
						
						$archive:=ZIP Read archive:C1637($oFormatter)
						
						$o:=JSON Parse:C1218($archive.root.file("manifest.json").getText())
						
						If ($o.type#Null:C1517)
							
							If (Value type:C1509($o.type)=Is collection:K8:32)
								
								If ($o.type.indexOf($c[$oIN.type])#-1)
									
									$oOUT.formatters.push(New object:C1471(\
										"name";$oFormatter.name))
									
								End if 
								
							Else 
								
								If ($o.type=$c[$oIN.type])
									
									$oOUT.formatters.push(New object:C1471(\
										"name";$oFormatter.name))
									
								End if 
							End if 
						End if 
					End for each 
					
					$errors.show()
					
				End if 
			End if 
			
		Else 
			
			$oResources:=SHARED.resources
			$oOUT.formatters:=$oResources.fieldBindingTypes[$oIN.type]
			
		End if 
		
		  //______________________________________________________
	: ($oIN.action="isValid")
		
		If ($oIN.format#Null:C1517)
			
			If (Not:C34($oIN.format.exists))\
				 | (Not:C34($oIN.format.file("manifest.json").exists))
				
				ob_error_add ($oOUT;"Formatter missing or invalid")  // Missing or invalid
				
			End if 
			
		Else 
			
			If (Test path name:C476($oIN.path)#Is a folder:K24:2)\
				 | (Test path name:C476($oIN.path+"manifest.json")#Is a document:K24:1)
				
				ob_error_add ($oOUT;"Formatter missing or invalid")  // Missing or invalid
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($oIN.action="extract")
		
		  // Extract format from data model
		$oOUT.formatters:=New collection:C1472()
		
		For each ($tTable;$oIN.dataModel)
			
			For each ($tFieldID;$oIN.dataModel[$tTable])
				
				If (Match regex:C1019("(?m-si)^\\d+$";$tFieldID;1;*))
					
					$oField:=$oIN.dataModel[$tTable][$tFieldID]
					
					Case of 
							
							  //………………………………………………………………………………………………………
						: (Value type:C1509($oField.format)=Is object:K8:27)
							
							$oOUT.formatters.push($oField)
							
							  //………………………………………………………………………………………………………
						: (Value type:C1509($oField.format)=Is text:K8:3)
							
							If (Value type:C1509($oIN.formatters)=Is object:K8:27)
								
								If (Value type:C1509($oIN.formatters[$oField.format])=Is object:K8:27)
									
									$oOUT.formatters.push($oIN.formatters[$oField.format])
									
								Else 
									
									ob_error_add ($oOUT;"Unknown data formatter '"+$oField.format+"'")
									
								End if 
								
							Else 
								
								ob_error_add ($oOUT;"No list of formatters provided to resolve '"+$oField.format+"'")
								
							End if 
							
							  //………………………………………………………………………………………………………
						: ($oField.format=Null:C1517)
							
							  // Ignore if not set
							
							  //………………………………………………………………………………………………………
						Else 
							
							ob_error_add ($oOUT;"Wrong format type defined by field: "+JSON Stringify:C1217($oField))
							
							  //………………………………………………………………………………………………………
					End case 
				End if 
			End for each 
		End for each 
		
		  //______________________________________________________
	: ($oIN.action="generate")
		
		If (Asserted:C1132(Value type:C1509($oIN.formatters)=Is collection:K8:32))
			
			$bAppend:=False:C215  // Force create
			
			$oOUT.sources:=New collection:C1472()  // keep a trace of generated sources files, to not make duplicate job
			$oOUT.localized:=New collection:C1472()  // keep a trace of generated localized string, to not make duplicate job
			$oOUT.imageNamed:=New collection:C1472()  // keep a trace of generated image named to not make duplicate job
			
			$oOUT.children:=New collection:C1472()
			
			  // Generate project files according to formats
			For each ($oFormatter;$oIN.formatters)
				
				If (Length:C16(String:C10($oFormatter.name))#0)
					
					  // If (Bool(featuresFlags._100990))
					If ($oOUT.sources.indexOf($oFormatter.name)<0)
						
						$oOUT.sources.push($oFormatter.name)
						
						If (Bool:C1537($oFormatter.isHost))  // CHECK IF host formatter before, no source in ours formatters
							
							For each ($t;New collection:C1472("Sources";"Resources"))  // Only Sources and "Resources" folder are imported
								
								$folder:=COMPONENT_Pathname ("host_formatters").folder($oFormatter.name).folder($t)
								
								If ($folder.exists)
									
									$oResult:=template (New object:C1471(\
										"source";$folder.platformPath;\
										"tags";$oIN.tags;\
										"target";$oIN.target+$t+Folder separator:K24:12))
									
									  // to inject in project file
									$oOUT.children.push($oResult)
									
								End if 
							End for each 
						End if 
					End if 
					
					  // End if
					
					Case of 
							
						: (Length:C16(String:C10($oFormatter.binding))=0)  // Case of simple format, which defined only binding type
							
							$oFormatter.binding:=$oFormatter.name  // must an attribute of UI component
							
							  //………………………………………………………………………………………………………
						: ($oFormatter.binding="localizedText")  // a text with a choice list
							
							If ($oOUT.localized.indexOf($oFormatter.name)<0)
								
								$oResult:=xloc (New object:C1471(\
									"action";"create";\
									"formatter";$oFormatter;\
									"append";$bAppend;\
									"file";"Formatters";\
									"target";$oIN.target+"Resources"+Folder separator:K24:12))
								
								$bAppend:=True:C214  // append next
								
								ob_error_combine ($oOUT;$oResult)
								
								$oOUT.localized.push($oFormatter.name)
								
								  // If (Bool(featuresFlags._100990))
								$oOUT.children.push(New object:C1471(\
									"target";$oResult.target;\
									"types";New collection:C1472("strings")))
								
								  // Else
								  //$Obj_out.target:=$Obj_result.target  // XXX if multiple files replace by a collection
								  // End if
								
							Else 
								
								  // Already managed
								
							End if 
							
							  //………………………………………………………………………………………………………
						: ($oFormatter.binding="imageNamed")  // a list of image asset
							
							If ($oOUT.imageNamed.indexOf($oFormatter.name)<0)
								
								$oResult:=asset (New object:C1471(\
									"action";"formatter";\
									"formatter";$oFormatter;\
									"target";$oIN.target+"Resources"+Folder separator:K24:12+"Assets.xcassets"+Folder separator:K24:12+"Formatters"+Folder separator:K24:12))  // XXX path from? template?
								
								ob_error_combine ($oOUT;$oResult)
								
								$oOUT.imageNamed.push($oFormatter.name)
								
								  // Else already managed
								
							End if 
							
							  //………………………………………………………………………………………………………
						Else 
							
							  // nothing?
							
							  //………………………………………………………………………………………………………
					End case 
					
					  //________________________________________
				Else 
					
					ob_error_add ($oOUT;"No name for format: "+JSON Stringify:C1217($oFormatter))
					
				End if 
			End for each 
		End if 
		
		  //______________________________________________________
	: ($oIN.action="objectify")
		
		$i:=0  // First index
		
		Case of 
				
				  //........................................
			: ($oIN.value=Null:C1517)
				
				$oOUT.value:=Null:C1517
				ob_error_add ($oOUT;"No value provided: "+JSON Stringify:C1217($oFormatter))
				
				  //........................................
			: (Value type:C1509($oIN.value)=Is object:K8:27)
				
				$oOUT.value:=$oIN.value
				
				  //........................................
			: (Value type:C1509($oIN.value)=Is collection:K8:32)  // expected collection of text XXX add a check?
				
				$oOUT.value:=New object:C1471(\
					)
				
				  // indexes collection like in php
				For each ($t;$oIN.value)
					
					$oOUT.value[String:C10($i)]:=$t
					$i:=$i+1
					
				End for each 
				
				  //........................................
			: (Value type:C1509($oIN.value)=Is text:K8:3)
				
				$oOUT.value:=New object:C1471(\
					String:C10($i);$oIN.value)
				
				  //........................................
			Else 
				
				$oOUT.value:=New object:C1471(\
					String:C10($i);String:C10($oIN.value))
				
				  // XXX warning, unknown type for value
				
				  //........................................
		End case 
		
		  //----------------------------------------
End case 

$oOUT.success:=Not:C34(ob_error_has ($oOUT))

  // ----------------------------------------------------
  // Return
$0:=$oOUT

  // ----------------------------------------------------
  // End