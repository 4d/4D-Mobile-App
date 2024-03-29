//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($oIN : Object)->$oOUT : Object
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

var $bAppend : Boolean
var $i : Integer
var $t; $tFieldID; $tTable : Text
var $archive; $folder; $o; $oField; $oFormatter : Object
var $oResources; $oResult : Object
var $c : Collection
var $error : cs:C1710.error
var $tmp : 4D:C1709.Folder

If (False:C215)
	C_OBJECT:C1216(formatters; $0)
	C_OBJECT:C1216(formatters; $1)
End if 

// ----------------------------------------------------
// Initialisations
ASSERT:C1129(Count parameters:C259=1; "Missing parameter")

$oOUT:=New object:C1471(\
"success"; False:C215)

// ----------------------------------------------------

Case of 
		
		//______________________________________________________
	: (Length:C16(String:C10($oIN.action))=0)
		
		$oOUT.errors:=New collection:C1472("No action provided when processing formatters")
		ASSERT:C1129(dev_Matrix; "No action provided when processing formatters")
		
		// MARK:- getByName
	: ($oIN.action="getByName")
		
		$oResources:=SHARED.resources
		
		// Formatter definitions
		$oOUT.formatters:=$oResources.definitions
		
		For each ($t; $oOUT.formatters)
			
			If (Value type:C1509($oOUT.formatters[$t])=Is collection:K8:32)
				
				For each ($oFormatter; $oOUT.formatters[$t])
					
					If (Length:C16(String:C10($oFormatter.name))>0)\
						 & (String:C10($oFormatter.name)#"-")
						
						$oOUT.formatters[String:C10($oFormatter.name)]:=$oFormatter
						
					End if 
				End for each 
				
				OB REMOVE:C1226($oOUT.formatters; $t)
				
			End if 
		End for each 
		
		// Others formatter
		For each ($c; $oResources.fieldBindingTypes.filter(Formula:C1597(col_formula).source; "$1.result:=(Value type:C1509($1.value)=42)"); 1)
			
			// Keep only formats with defined name
			$c:=$c.filter(Formula:C1597(col_formula).source; "$1.result:=($1.value.name#Null:C1517)&(String:C10($1.value.name)#\"-\")")
			
			For each ($oFormatter; $c)
				
				$t:=String:C10($oFormatter.name)
				
				If (Length:C16($t)>0)\
					 & ($t#"-")
					
					$oOUT.formatters[$t]:=$oFormatter
					
				End if 
			End for each 
		End for each 
		
		// Host formatters
		$oResources:=cs:C1710.path.new().hostFormatters()
		
		If ($oResources.exists)
			
			For each ($o; $oResources.folders())
				
				var $manifest : Object
				$manifest:=$o.file("manifest.json")
				
				If (False:C215)  // FEATURE.with("formatMarketPlace")  // Support zip when listing
					
					If ($o.extension=SHARED.archiveExtension)
						
/* START HIDING ERRORS */$error:=cs:C1710.error.new("hide")
						$archive:=ZIP Read archive:C1637($o)
/* STOP HIDING ERRORS */$error.release()
						
						If ($archive#Null:C1517)
							
							$manifest:=$archive.root
							
						End if 
					End if 
				End if 
				
				$oFormatter:=ob_parseFile($manifest)
				
				If ($oFormatter.success)
					
					$oFormatter:=$oFormatter.value
					$oFormatter.isHost:=True:C214
					$oFormatter.path:=$o.platformPath
					$oFormatter.folder:=$o
					$oOUT.formatters["/"+$o.name]:=$oFormatter
					
				End if 
			End for each 
		End if 
		
		// MARK:- getByType
	: ($oIN.action="getByType")
		
		If (Bool:C1537($oIN.host))
			
			$oOUT.formatters:=New collection:C1472
			
			$oResources:=cs:C1710.path.new().hostFormatters()
			
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
				
				For each ($oFormatter; $oResources.folders())
					
					If ($oFormatter.file("manifest.json").exists)
						
						$o:=JSON Parse:C1218($oFormatter.file("manifest.json").getText())
						
						If ($o.type#Null:C1517)
							
							If (Value type:C1509($o.type)=Is collection:K8:32)
								
								If ($o.type.indexOf($c[$oIN.type])#-1)
									
									$oOUT.formatters.push(New object:C1471(\
										"name"; $oFormatter.name))
									
								End if 
								
							Else 
								
								If ($o.type=$c[$oIN.type])
									
									$oOUT.formatters.push(New object:C1471(\
										"name"; $oFormatter.name))
									
								End if 
							End if 
						End if 
					End if 
				End for each 
				
/* START HIDING ERRORS */$error:=cs:C1710.error.new("hide")
				
				For each ($oFormatter; $oResources.files().query("extension = :1"; SHARED.archiveExtension))
					
					$archive:=ZIP Read archive:C1637($oFormatter)
					
					$o:=JSON Parse:C1218($archive.root.file("manifest.json").getText())
					
					If ($o.type#Null:C1517)
						
						If (Value type:C1509($o.type)=Is collection:K8:32)
							
							If ($o.type.indexOf($c[$oIN.type])#-1)
								
								$oOUT.formatters.push(New object:C1471(\
									"name"; $oFormatter.name))
								
							End if 
							
						Else 
							
							If ($o.type=$c[$oIN.type])
								
								$oOUT.formatters.push(New object:C1471(\
									"name"; $oFormatter.name))
								
							End if 
						End if 
					End if 
				End for each 
				
/* STOP HIDING ERRORS */$error.release()
				
			End if 
			
		Else 
			
			$oResources:=SHARED.resources
			$oOUT.formatters:=$oResources.fieldBindingTypes[$oIN.type]
			
		End if 
		
		// MARK:- isValid
	: ($oIN.action="isValid")
		
		If ($oIN.format#Null:C1517)
			
			If (Not:C34($oIN.format.exists))\
				 | (Not:C34($oIN.format.file("manifest.json").exists))
				
				ob_error_add($oOUT; "Formatter missing or invalid")  // Missing or invalid
				
			End if 
			
		Else 
			
			If (Not:C34(File:C1566($oIN.path+"manifest.json"; fk platform path:K87:2).exists))
				
				ob_error_add($oOUT; "Formatter missing or invalid")  // Missing or invalid
				
			End if 
		End if 
		
		// MARK:- _doExtract
	: ($oIN.action="_doExtract")
		
		If ($oIN.result=Null:C1517)
			$oOUT.formatters:=New collection:C1472()
		Else 
			$oOUT.formatters:=$oIN.result  // & input pass result to cumulate
		End if 
		
		For each ($tFieldID; $oIN.data)
			Case of 
				: (Length:C16($tFieldID)=0)
					
					// Ignore metadata
					
				: (Match regex:C1019("(?m-si)^\\d+$"; $tFieldID; 1; *))  // PROJECT.isField($oIN.data[$tFieldID])
					
					$oResult:=formatters(New object:C1471(\
						"action"; "_doExtractOnField"; \
						"formatters"; $oIN.formatters; \
						"dataModel"; $oIN.dataModel; \
						"data"; $oIN.data[$tFieldID]; \
						"result"; $oOUT.formatters))
					
					ob_error_combine($oOUT; $oResult)
					
				: ((Value type:C1509($oIN.data[$tFieldID])#Is object:K8:27))
					
					// ignore
					
				: ((PROJECT.isComputedAttribute($oIN.data[$tFieldID])) || (PROJECT.isAlias($oIN.data[$tFieldID])))
					
					$oResult:=formatters(New object:C1471(\
						"action"; "_doExtractOnField"; \
						"formatters"; $oIN.formatters; \
						"dataModel"; $oIN.dataModel; \
						"data"; $oIN.data[$tFieldID]; \
						"result"; $oOUT.formatters))
					
					ob_error_combine($oOUT; $oResult)
					
				Else 
					// recursion (maybe relation, here we could check if necessary)
					
					$oResult:=formatters(New object:C1471(\
						"action"; "_doExtract"; \
						"formatters"; $oIN.formatters; \
						"dataModel"; $oIN.dataModel; \
						"data"; $oIN.data[$tFieldID]; \
						"result"; $oOUT.formatters))
					
					ob_error_combine($oOUT; $oResult)
					
			End case 
		End for each 
		
		// MARK:- _doExtractOnField
	: ($oIn.action="_doExtractOnField")
		
		$oField:=$oIN.data
		
		If ($oIN.result=Null:C1517)
			$oOUT.formatters:=New collection:C1472()
		Else 
			$oOUT.formatters:=$oIN.result  // & input pass result to cumulate
		End if 
		
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
						
						ob_error_add($oOUT; "Unknown data formatter '"+$oField.format+"'")
						
					End if 
					
				Else 
					
					ob_error_add($oOUT; "No list of formatters provided to resolve '"+$oField.format+"'")
					
				End if 
				
				//………………………………………………………………………………………………………
			: ($oField.format=Null:C1517)
				
				// Ignore if not set
				
				//………………………………………………………………………………………………………
			Else 
				
				ob_error_add($oOUT; "Wrong format type defined by field: "+JSON Stringify:C1217($oField))
				
				//………………………………………………………………………………………………………
		End case 
		
		// MARK:- extract
	: ($oIN.action="extract")  // Extract format from data model
		
		$oOUT.formatters:=New collection:C1472()
		
		For each ($tTable; $oIN.dataModel)
			
			$oResult:=formatters(New object:C1471(\
				"action"; "_doExtract"; \
				"formatters"; $oIN.formatters; \
				"dataModel"; $oIN.dataModel; \
				"data"; $oIN.dataModel[$tTable]; \
				"result"; $oOUT.formatters))
			
			ob_error_combine($oOUT; $oResult)
			
		End for each 
		
		// MARK:- generate
	: ($oIN.action="generate")
		
		If (Asserted:C1132(Value type:C1509($oIN.formatters)=Is collection:K8:32))
			
			$bAppend:=False:C215  // Force create
			
			$oOUT.sources:=New collection:C1472()  // keep a trace of generated sources files, to not make duplicate job
			$oOUT.localized:=New collection:C1472()  // keep a trace of generated localized string, to not make duplicate job
			$oOUT.imageNamed:=New collection:C1472()  // keep a trace of generated image named to not make duplicate job
			
			$oOUT.children:=New collection:C1472()
			
			$oResources:=cs:C1710.path.new().hostFormatters()
			
			// Generate project files according to formats
			For each ($oFormatter; $oIN.formatters)
				
				If (Length:C16(String:C10($oFormatter.name))#0)
					
					If ($oOUT.sources.indexOf($oFormatter.name)<0)
						
						$oOUT.sources.push($oFormatter.name)
						
						If (Bool:C1537($oFormatter.isHost))  // CHECK IF host formatter before, no source in ours formatters
							
							For each ($t; New collection:C1472("Sources"; "Resources"))  // Only Sources and "Resources" folder are imported
								
								If ($oFormatter.folder=Null:C1517)
									$folder:=$oResources.folder($oFormatter.name)  // code could failed if name in manifest not equal to directory it's just in case of
								Else 
									$folder:=$oFormatter.folder
								End if 
								If ($folder.folder("ios").exists)
									$folder:=$folder.folder("ios")
								End if 
								$folder:=$folder.folder($t)
								
								If ($folder.exists)
									
									
									If ((Feature.with("inputControlArchive")) && OB Instance of:C1731($folder; 4D:C1709.ZipFolder))
										
										// solution 1: create a new TEMPLATE method that support Folder/ZipFolder etc...
										// solution 2: (tmp) unzip to a temp dir to copy then remove
										
										$tmp:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).folder(Generate UUID:C1066)
										$tmp.create()
										$folder.copyTo($tmp)
										
										$oResult:=TEMPLATE(New object:C1471(\
											"source"; $tmp.folder($folder.name).platformPath; \
											"tags"; $oIN.tags; \
											"target"; $oIN.target+$t+Folder separator:K24:12; \
											"exclude"; JSON Stringify:C1217(SHARED.template.exclude)\
											))
										
										$tmp.delete(fk recursive:K87:7)
										
									Else 
										
										$oResult:=TEMPLATE(New object:C1471(\
											"source"; $folder.platformPath; \
											"tags"; $oIN.tags; \
											"target"; $oIN.target+$t+Folder separator:K24:12; \
											"exclude"; JSON Stringify:C1217(SHARED.template.exclude)\
											))
										
									End if 
									
									// to inject in project file
									$oOUT.children.push($oResult)
									
								End if 
							End for each 
						End if 
					End if 
					
					Case of 
							
						: (Length:C16(String:C10($oFormatter.binding))=0)  // Case of simple format, which defined only binding type
							
							$oFormatter.binding:=$oFormatter.name  // must an attribute of UI component
							
							//………………………………………………………………………………………………………
						: ($oFormatter.binding="localizedText")  // a text with a choice list
							
							If ($oOUT.localized.indexOf($oFormatter.name)<0)
								
								$oResult:=xloc(New object:C1471(\
									"action"; "create"; \
									"formatter"; $oFormatter; \
									"append"; $bAppend; \
									"file"; "Formatters"; \
									"target"; $oIN.target+"Resources"+Folder separator:K24:12))
								
								$bAppend:=True:C214  // append next
								
								ob_error_combine($oOUT; $oResult)
								
								$oOUT.localized.push($oFormatter.name)
								
								$oOUT.children.push(New object:C1471(\
									"target"; $oResult.target; \
									"types"; New collection:C1472("strings")))
								
							Else 
								
								// Already managed
								
							End if 
							
							//………………………………………………………………………………………………………
						: ($oFormatter.binding="imageNamed")  // a list of image asset
							
							If ($oOUT.imageNamed.indexOf($oFormatter.name)<0)
								
								$oResult:=asset(New object:C1471(\
									"action"; "formatter"; \
									"formatter"; $oFormatter; \
									"target"; $oIN.target+"Resources"+Folder separator:K24:12+"Assets.xcassets"+Folder separator:K24:12+"Formatters"+Folder separator:K24:12))  // XXX path from? template?
								
								ob_error_combine($oOUT; $oResult)
								
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
					
					ob_error_add($oOUT; "No name for format: "+JSON Stringify:C1217($oFormatter))
					
				End if 
			End for each 
		End if 
		
		// MARK:- objectify
	: ($oIN.action="objectify")
		
		$i:=0  // First index
		
		Case of 
				
				//........................................
			: ($oIN.value=Null:C1517)
				
				$oOUT.value:=Null:C1517
				ob_error_add($oOUT; "No value provided: "+JSON Stringify:C1217($oFormatter))
				
				//........................................
			: (Value type:C1509($oIN.value)=Is object:K8:27)
				
				$oOUT.value:=$oIN.value
				
				//........................................
			: (Value type:C1509($oIN.value)=Is collection:K8:32)  // expected collection of text XXX add a check?
				
				$oOUT.value:=New object:C1471(\
					)
				
				// indexes collection like in php
				For each ($t; $oIN.value)
					
					$oOUT.value[String:C10($i)]:=$t
					$i:=$i+1
					
				End for each 
				
				//........................................
			: (Value type:C1509($oIN.value)=Is text:K8:3)
				
				$oOUT.value:=New object:C1471(\
					String:C10($i); $oIN.value)
				
				//........................................
			Else 
				
				$oOUT.value:=New object:C1471(\
					String:C10($i); String:C10($oIN.value))
				
				// XXX warning, unknown type for value
				
				//........................................
		End case 
		
		//----------------------------------------
End case 

$oOUT.success:=Not:C34(ob_error_has($oOUT))
