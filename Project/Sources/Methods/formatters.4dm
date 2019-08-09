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

C_BOOLEAN:C305($Boo_append)
C_LONGINT:C283($Lon_i;$Lon_index;$Lon_parameters)
C_TEXT:C284($Txt_buffer;$Txt_fieldID;$Txt_tableID)
C_OBJECT:C1216($Dir_;$o;$Obj_field;$Obj_formatter;$Obj_in;$Obj_out;$Obj_resources;$Obj_resource;$Obj_result)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(formatters ;$0)
	C_OBJECT:C1216(formatters ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Obj_out:=New object:C1471(\
		"success";False:C215)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------

Case of 
		
		  //______________________________________________________
	: (Length:C16(String:C10($Obj_in.action))=0)
		
		$Obj_out.errors:=New collection:C1472("No action provided when processing formatters")
		ASSERT:C1129(dev_Matrix ;"No action provided when processing formatters")
		
		  //______________________________________________________
	: ($Obj_in.action="getByName")
		
		$Obj_resources:=ob_parseFile (Folder:C1567(fk resources folder:K87:11).file("resources.json")).value
		
		  // Formatter definitions
		$Obj_out.formatters:=$Obj_resources.definitions
		
		For each ($Txt_buffer;$Obj_out.formatters)
			
			If (Value type:C1509($Obj_out.formatters[$Txt_buffer])=Is collection:K8:32)
				
				For each ($Obj_formatter;$Obj_out.formatters[$Txt_buffer])
					
					If (Length:C16(String:C10($Obj_formatter.name))>0)\
						 & (String:C10($Obj_formatter.name)#"-")
						
						$Obj_out.formatters[String:C10($Obj_formatter.name)]:=$Obj_formatter
						
					End if 
				End for each 
				
				OB REMOVE:C1226($Obj_out.formatters;$Txt_buffer)
				
			End if 
		End for each 
		
		  // Others formatter
		For each ($c;$Obj_resources.fieldBindingTypes.filter("col_formula";"$1.result:=(Value type:C1509($1.value)=42)");1)
			
			  // Keep only formats with defined name
			$c:=$c.filter("col_formula";"$1.result:=($1.value.name#Null:C1517)&(String:C10($1.value.name)#\"-\")")
			
			For each ($Obj_formatter;$c)
				
				$Txt_buffer:=String:C10($Obj_formatter.name)
				
				If (Length:C16($Txt_buffer)>0)\
					 & ($Txt_buffer#"-")
					
					$Obj_out.formatters[$Txt_buffer]:=$Obj_formatter
					
				End if 
			End for each 
		End for each 
		
		  // Host formatters
		$Obj_resources:=COMPONENT_Pathname ("host_formatters")
		
		For each ($Obj_resource;$Obj_resources.folders())
			
			$Obj_formatter:=ob_parseFile ($Obj_resource.file("manifest.json"))
			
			If ($Obj_formatter.success)
				
				$Obj_formatter:=$Obj_formatter.value
				$Obj_formatter.isHost:=True:C214
				$Obj_formatter.path:=$Obj_resource.platformPath
				$Obj_formatter.folder:=$Obj_resource
				$Obj_out.formatters["/"+$Obj_resource.name]:=$Obj_formatter
				
			End if 
		End for each 
		
		  //______________________________________________________
	: ($Obj_in.action="getByType")
		
		If (Bool:C1537($Obj_in.host))
			
			$Obj_out.formatters:=New collection:C1472
			
			$Obj_resources:=COMPONENT_Pathname ("host_formatters")
			
			If ($Obj_resources.exists)
				
				$c:=New collection:C1472
				
				$c[Is alpha field:K8:1]:="text"
				$c[Is boolean:K8:9]:="boolean"
				$c[Is integer:K8:5]:="integer"
				$c[Is longint:K8:6]:="integer"
				$c[Is integer 64 bits:K8:25]:="integer"
				$c[Is real:K8:4]:="real"
				$c[Is float:K8:26]:="float"
				$c[Is date:K8:7]:="date"
				$c[Is time:K8:8]:="time"
				$c[Is text:K8:3]:="text"
				$c[Is picture:K8:10]:="picture"
				
				For each ($Obj_formatter;$Obj_resources.folders())
					
					If ($Obj_formatter.file("manifest.json").exists)
						
						$o:=JSON Parse:C1218($Obj_formatter.file("manifest.json").getText())
						
						If ($o.type#Null:C1517)
							
							If (Value type:C1509($o.type)=Is collection:K8:32)
								
								If ($o.type.indexOf($c[$Obj_in.type])#-1)
									
									$Obj_out.formatters.push(New object:C1471("name";$Obj_formatter.name))
									
								End if 
								
							Else 
								
								If ($o.type=$c[$Obj_in.type])
									
									$Obj_out.formatters.push(New object:C1471("name";$Obj_formatter.name))
									
								End if 
								
							End if 
						End if 
					End if 
				End for each 
			End if 
			
		Else 
			
			$Obj_resources:=JSON Parse:C1218(Document to text:C1236(Get 4D folder:C485(Current resources folder:K5:16)+"resources.json"))
			$Obj_resources:=JSON Resolve pointers:C1478($Obj_resources).value
			
			$Obj_out.formatters:=$Obj_resources.fieldBindingTypes[$Obj_in.type]
			
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="isValid")
		
		If (Test path name:C476($Obj_in.path)#Is a folder:K24:2)\
			 | (Test path name:C476($Obj_in.path+"manifest.json")#Is a document:K24:1)
			
			ob_error_add ($Obj_out;"Formatter missing or invalid")  // Missing or invalid
			
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="extract")
		
		  // Extract format from data model
		$Obj_out.formatters:=New collection:C1472()
		
		For each ($Txt_tableID;$Obj_in.dataModel)
			
			For each ($Txt_fieldID;$Obj_in.dataModel[$Txt_tableID])
				
				If (Match regex:C1019("(?m-si)^\\d+$";$Txt_fieldID;1;*))
					
					$Obj_field:=$Obj_in.dataModel[$Txt_tableID][$Txt_fieldID]
					
					Case of 
							
							  //………………………………………………………………………………………………………
						: (Value type:C1509($Obj_field.format)=Is object:K8:27)
							
							$Obj_out.formatters.push($Obj_field)
							
							  //………………………………………………………………………………………………………
						: (Value type:C1509($Obj_field.format)=Is text:K8:3)
							
							If (Value type:C1509($Obj_in.formatters)=Is object:K8:27)
								
								If (Value type:C1509($Obj_in.formatters[$Obj_field.format])=Is object:K8:27)
									
									$Obj_out.formatters.push($Obj_in.formatters[$Obj_field.format])
									
								Else 
									
									ob_error_add ($Obj_out;"Unknown data formatter '"+$Obj_field.format+"'")
									
								End if 
								
							Else 
								
								ob_error_add ($Obj_out;"No list of formatters provided to resolve '"+$Obj_field.format+"'")
								
							End if 
							
							  //………………………………………………………………………………………………………
						: ($Obj_field.format=Null:C1517)
							
							  // Ignore if not set
							
							  //………………………………………………………………………………………………………
						Else 
							
							ob_error_add ($Obj_out;"Wrong format type defined by field: "+JSON Stringify:C1217($Obj_field))
							
							  //………………………………………………………………………………………………………
					End case 
				End if 
			End for each 
		End for each 
		
		  //______________________________________________________
	: ($Obj_in.action="generate")
		
		If (Asserted:C1132(Value type:C1509($Obj_in.formatters)=Is collection:K8:32))
			
			$Boo_append:=False:C215  // Force create
			
			$Obj_out.sources:=New collection:C1472()  // keep a trace of generated sources files, to not make duplicate job
			$Obj_out.localized:=New collection:C1472()  // keep a trace of generated localized string, to not make duplicate job
			$Obj_out.imageNamed:=New collection:C1472()  // keep a trace of generated image named to not make duplicate job
			
			$Obj_out.children:=New collection:C1472()
			
			  // Generate project files according to formats
			For each ($Obj_formatter;$Obj_in.formatters)
				
				If (Length:C16(String:C10($Obj_formatter.name))#0)
					
					  //If (Bool(featuresFlags._100990))
					If ($Obj_out.sources.indexOf($Obj_formatter.name)<0)
						
						$Obj_out.sources.push($Obj_formatter.name)
						
						If (Bool:C1537($Obj_formatter.isHost))  // CHECK IF host formatter before, no source in ours formatters
							
							For each ($Txt_buffer;New collection:C1472("Sources";"Resources"))  // Only Sources and "Resources" folder are imported
								
								$Dir_:=COMPONENT_Pathname ("host_formatters").folder($Obj_formatter.name).folder($Txt_buffer)
								
								If ($Dir_.exists)
									
									$Obj_result:=TEMPLATE (New object:C1471(\
										"source";$Dir_.platformPath;\
										"tags";$Obj_in.tags;\
										"target";$Obj_in.target+$Txt_buffer+Folder separator:K24:12))
									
									  // to inject in project file
									$Obj_out.children.push($Obj_result)
									
								End if 
								
							End for each 
							
						End if 
						
					End if 
					
					  //End if 
					
					Case of 
							
						: (Length:C16(String:C10($Obj_formatter.binding))=0)  // Case of simple format, which defined only binding type
							
							$Obj_formatter.binding:=$Obj_formatter.name  // must an attribute of UI component
							
							  //………………………………………………………………………………………………………
						: ($Obj_formatter.binding="localizedText")  // a text with a choice list
							
							If ($Obj_out.localized.indexOf($Obj_formatter.name)<0)
								
								$Obj_result:=xloc (New object:C1471("action";"create";\
									"formatter";$Obj_formatter;\
									"append";$Boo_append;\
									"file";"Formatters";\
									"target";$Obj_in.target+"Resources"+Folder separator:K24:12))
								
								$Boo_append:=True:C214  // append next
								
								ob_error_combine ($Obj_out;$Obj_result)
								
								$Obj_out.localized.push($Obj_formatter.name)
								
								  //If (Bool(featuresFlags._100990))
								
								$Obj_out.children.push(New object:C1471(\
									"target";$Obj_result.target;\
									"types";New collection:C1472("strings")))
								
								  //Else 
								  //$Obj_out.target:=$Obj_result.target  // XXX if multiple files replace by a collection
								  //End if 
								
							Else 
								
								  // Already managed
								
							End if 
							
							  //………………………………………………………………………………………………………
						: ($Obj_formatter.binding="imageNamed")  // a list of image asset
							
							If ($Obj_out.imageNamed.indexOf($Obj_formatter.name)<0)
								
								$Obj_result:=asset (New object:C1471("action";"formatter";\
									"formatter";$Obj_formatter;\
									"target";$Obj_in.target+"Resources"+Folder separator:K24:12+\
									"Assets.xcassets"+Folder separator:K24:12+"Formatters"+Folder separator:K24:12))  // XXX path from? template?
								
								ob_error_combine ($Obj_out;$Obj_result)
								
								$Obj_out.imageNamed.push($Obj_formatter.name)
								
								  // Else already managed
								
							End if 
							
							  //………………………………………………………………………………………………………
						Else 
							
							  // nothing?
							
							  //………………………………………………………………………………………………………
					End case 
					
					  //________________________________________
				Else 
					
					ob_error_add ($Obj_out;"No name for format: "+JSON Stringify:C1217($Obj_formatter))
					
				End if 
			End for each 
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="objectify")
		
		$Lon_i:=0  // First index
		
		Case of 
				
				  //........................................
			: ($Obj_in.value=Null:C1517)
				
				$Obj_out.value:=Null:C1517
				ob_error_add ($Obj_out;"No value provided: "+JSON Stringify:C1217($Obj_formatter))
				
				  //........................................
			: (Value type:C1509($Obj_in.value)=Is object:K8:27)
				
				$Obj_out.value:=$Obj_in.value
				
				  //........................................
			: (Value type:C1509($Obj_in.value)=Is collection:K8:32)  // expected collection of text XXX add a check?
				
				$Obj_out.value:=New object:C1471()
				
				  // indexes collection like in php
				For each ($Txt_buffer;$Obj_in.value)
					
					$Obj_out.value[String:C10($Lon_i)]:=$Txt_buffer
					$Lon_i:=$Lon_i+1
					
				End for each 
				
				  //........................................
			: (Value type:C1509($Obj_in.value)=Is text:K8:3)
				
				$Obj_out.value:=New object:C1471(String:C10($Lon_i);$Obj_in.value)
				
				  //........................................
			Else 
				
				$Obj_out.value:=New object:C1471(String:C10($Lon_i);String:C10($Obj_in.value))
				
				  // XXX warning, unknown type for value
				
				  //........................................
		End case 
		
		  //----------------------------------------
End case 

$Obj_out.success:=Not:C34(ob_error_has ($Obj_out))

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End