//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($Obj_in : Object)->$Obj_out : Object
// ----------------------------------------------------
// Project method : asset
// Created 2017 by Eric Marchand
// ----------------------------------------------------
// Description: Create, Edit Xcode asset
// ----------------------------------------------------
// Declarations
var $Boo_ : Boolean
var $Lon_height; $Lon_i; $Lon_parameters; $Lon_scale; $Lon_width : Integer
var $Pic_buffer; $Pic_icon : Picture
var $Dir_source; $File_source; $Txt_buffer; $Txt_name; $Txt_value : Text
var $Obj_; $Obj_buffer; $Obj_file; $Obj_formatter; $Obj_image; $Obj_in : Object
var $Obj_out; $Obj_path; $Obj_template : Object
var $Folder_buffer : Object
var $target; $path; $source : 4D:C1709.Folder
var $contentsFile : 4D:C1709.File

If (False:C215)
	C_OBJECT:C1216(asset; $0)
	C_OBJECT:C1216(asset; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	// Optional parameters
	If ($Lon_parameters>=2)
		
		// <NONE>
		
	End if 
	
	$Obj_out:=New object:C1471(\
		"success"; False:C215)
	
Else 
	
	ABORT:C156
	
End if 

If (($Obj_in.path=Null:C1517)\
 & ($Obj_in.posix#Null:C1517))
	
	$Obj_in.path:=Folder:C1567($Obj_in.posix; fk posix path:K87:1)
	
End if 

// ----------------------------------------------------
If (Asserted:C1132($Obj_in.action#Null:C1517; "Missing the tag \"action\""))
	
	Case of 
			
			// MARK:- path
		: ($Obj_in.action="path")
			
			Case of 
					
					//----------------------------------------
				: ($Obj_in.path=Null:C1517)
					
					If (Bool:C1537($Obj_in.posixForce))  // to use if possible by caller
						$Obj_out.path:="Resources/Assets.xcassets"
					Else 
						$Obj_out.path:="Resources"+Folder separator:K24:12+"Assets.xcassets"+Folder separator:K24:12
					End if 
					//ASSERT(Not(dev_Matrix); "no path provided by asset?")
					
					//----------------------------------------
				: ((Value type:C1509($Obj_in.path)=Is text:K8:3) && (Length:C16(String:C10($Obj_in.path))=0))
					
					$Obj_out.path:="Resources"+Folder separator:K24:12+"Assets.xcassets"+Folder separator:K24:12
					ASSERT:C1129(Not:C34(dev_Matrix); "empty path provided by asset?")
					
					//----------------------------------------
				: ((Value type:C1509($Obj_in.path)=Is text:K8:3))
					
					$Obj_out.path:=Folder:C1567($Obj_in.path; fk platform path:K87:2).folder("Resources/Assets.xcassets")
					
					//----------------------------------------
				Else   // expect object 4D.folder
					ASSERT:C1129(OB Instance of:C1731($Obj_in.path; 4D:C1709.Folder); "asset path not a 4D.Folder")
					
					$Obj_out.path:=$Obj_in.path.folder("Resources/Assets.xcassets")
					
					//----------------------------------------
			End case 
			
			$Obj_out.success:=True:C214
			
			// MARK:- formatter
		: ($Obj_in.action="formatter") | ($Obj_in.action="input")
			
			// Check errors
			Case of 
					
					//----------------------------------------
				: (Value type:C1509($Obj_in.formatter)#Is object:K8:27)
					
					$Obj_out.errors:=New collection:C1472("No formatter defined to create an xcode files")
					
					//----------------------------------------
				: (Length:C16(String:C10($Obj_in.formatter.name))=0)
					
					$Obj_out.errors:=New collection:C1472("No formatter name defined."+JSON Stringify:C1217($Obj_in.formatter))
					
					//----------------------------------------
				: ($Obj_in.target=Null:C1517)
					
					$Obj_out.errors:=New collection:C1472("No target defined when creating formatter asset.")
					
					//----------------------------------------
				: (Value type:C1509($Obj_in.target)=Is text:K8:3 && (Length:C16(String:C10($Obj_in.target))=0))
					
					$Obj_out.errors:=New collection:C1472("No target defined when creating formatter asset (empty defined).")
					
					//----------------------------------------
				: ((Value type:C1509($Obj_in.target)=Is object:K8:27) && (Not:C34(OB Instance of:C1731($Obj_in.target; 4D:C1709.Folder))))
					
					$Obj_out.errors:=New collection:C1472("No target defined as 4D.Folder but in other type of object.")
					
					//----------------------------------------
				: (Not:C34((Value type:C1509($Obj_in.target)=Is text:K8:3) || (Value type:C1509($Obj_in.target)=Is object:K8:27)))
					
					$Obj_out.errors:=New collection:C1472("No target defined with good types."+String:C10(Value type:C1509($Obj_in.target)))
					
					//----------------------------------------
				Else 
					// no errors, go on
					
					Case of 
						: (Value type:C1509($Obj_in.target)=Is text:K8:3)
							$target:=Folder:C1567($Obj_in.target+$Obj_in.formatter.name; fk platform path:K87:2)
							// $target:=Folder($Obj_in.target; fk platform path).folder($Obj_in.formatter.name) // TO CHECK if has separator or not
						: (Value type:C1509($Obj_in.target)=Is object:K8:27)
							$target:=$Obj_in.target.folder($Obj_in.formatter.name)
					End case 
					
					
					If (Not:C34($target.exists))
						
						asset(New object:C1471(\
							"action"; "create"; \
							"type"; "folder"; \
							"target"; $target))
						
					End if 
					
					$Obj_formatter:=$Obj_in.formatter
					
					// Get path for formatter assets
					Case of 
							
							//........................................
						: (Length:C16(String:C10($Obj_in.source))>0)
							
							$source:=Folder:C1567($Obj_in.source; fk platform path:K87:2)  // specify the path as argument (useful for testing)
							
							//........................................
						: (Length:C16(String:C10($Obj_in.assets.source))>0)
							
							$source:=Folder:C1567($Obj_in.assets.source; fk platform path:K87:2)  // specify the source in formatter
							
							//........................................
						: (Bool:C1537($Obj_formatter.isHost))
							
							$source:=Choose:C955(Length:C16(String:C10($Obj_formatter.path))>0; Folder:C1567($Obj_formatter.path; fk platform path:K87:2); cs:C1710.path.new().hostFormatters().folder($Obj_formatter.name))
							
							$source:=$source.folder("images")
							
							//........................................
						Else 
							
							$source:=cs:C1710.path.new().actionIcons()
							
							//........................................
					End case 
					
					$Dir_source:=$source.platformPath
					
					// Could create a choice list from pattern and file on disk
					If ($Obj_formatter.choiceList=Null:C1517)
						
						If (Value type:C1509($Obj_formatter.choicePattern)=Is text:K8:3)
							
							$Obj_formatter.choiceList:=New object:C1471
							
							var $file : 4D:C1709.File
							For each ($file; $source.files())
								
								var $c : Collection
								$c:=cs:C1710.regex.new($file.fullName; $Obj_formatter.choicePattern).extract("1")
								
								If ($c.length>0)
									
									$Obj_formatter.choiceList[$c[0]]:=$file.fullName
									
								End if 
							End for each 
						End if 
					End if 
					
					// Create an image asset for each values
					$Obj_buffer:=formatters(New object:C1471(\
						"action"; "objectify"; \
						"value"; $Obj_formatter.choiceList))
					
					If ($Obj_buffer.success)
						
						$Obj_:=$Obj_buffer.value
						
						For each ($Txt_buffer; $Obj_)
							
							If ($Obj_in.action="input")
								$Txt_value:="input_"+$Obj_formatter.name+"_"+$Txt_buffer
							Else 
								$Txt_value:=$Obj_formatter.name+"_"+$Txt_buffer
							End if 
							
							$File_source:=$Dir_source+$Obj_[$Txt_buffer]
							
							
							var $isTemplate : Boolean
							$isTemplate:=False:C215
							Case of 
								: (Value type:C1509($Obj_formatter.assets.tintable)=Is boolean:K8:9)
									$isTemplate:=Bool:C1537($Obj_formatter.assets.tintable)
								: (Value type:C1509($Obj_formatter.assets.tintables)=Is collection:K8:32)
									$isTemplate:=$Obj_formatter.assets.tintables.indexOf(String:C10($Txt_value))>-1
							End case 
							
							$Obj_buffer:=asset(New object:C1471(\
								"action"; "create"; \
								"type"; "imageset"; \
								"source"; $File_source; \
								"tags"; New object:C1471("name"; $Txt_value); \
								"target"; $target.folder($Obj_formatter.name); \
								"format"; $Obj_formatter.assets.format; \
								"template"; $isTemplate; \
								"size"; $Obj_formatter.assets.size))
							
							ob_error_combine($Obj_out; $Obj_buffer)
							
						End for each 
						
						$Obj_out.success:=Not:C34(ob_error_has($Obj_out))
						
					Else 
						
						ob_error_combine($Obj_out; $Obj_buffer; "No choice list in formatter:"+JSON Stringify:C1217($Obj_in.formatter))
						
					End if 
					
					//----------------------------------------
			End case 
			
			// MARK:- create
		: ($Obj_in.action="create")
			
			If (($Obj_in.tags=Null:C1517)\
				 & ($Obj_in.name#Null:C1517))
				
				$Obj_in.tags:=New object:C1471(\
					"name"; $Obj_in.name)
				
			End if 
			
			Case of 
					
					//…………………………………………………………………………………………………………………
				: ($Obj_in.type=Null:C1517)
					
					$Obj_out.errors:=New collection:C1472("type must be defined when creating asset")
					
					//…………………………………………………………………………………………………………………
				: ($Obj_in.target=Null:C1517)
					
					$Obj_out.errors:=New collection:C1472("target must be defined when creating asset")
					
					//…………………………………………………………………………………………………………………
				: ($Obj_in.tags=Null:C1517)
					
					$Obj_out.errors:=New collection:C1472("tags must be defined when creating asset")
					
					//…………………………………………………………………………………………………………………
				Else 
					
					Case of 
							
							//........................................
						: (($Obj_in.type="imageset")\
							 | ($Obj_in.type="background"))
							
							If ($Obj_in.format=Null:C1517)
								
								$Obj_in.format:="png"
								
							End if 
							
							$Folder_buffer:=cs:C1710.path.new().templates().folder("asset").folder($Obj_in.type).folder($Obj_in.format)
							$Txt_buffer:=$Folder_buffer.platformPath
							$Obj_out.success:=$Folder_buffer.exists
							
							//........................................
						: ($Obj_in.type="colorset")
							
							If ($Obj_in.space#Null:C1517)
								
								$Folder_buffer:=cs:C1710.path.new().templates().folder("asset").folder($Obj_in.type).folder($Obj_in.space)
								$Txt_buffer:=$Folder_buffer.platformPath
								
								If ($Obj_in.tags.alpha=Null:C1517)
									
									$Obj_in.tags.alpha:=255  // alpha could also be defined using float 1.000 (.0 is mandatory)
									
								End if 
								
								$Obj_out.success:=$Folder_buffer.exists
								
							Else 
								
								// Or maybe latter according to tag find the color space
								$Obj_out.errors:=New collection:C1472("space must be defined for colorset: srgb, or gray")
								
							End if 
							
							//........................................
						: ($Obj_in.type="dataset")
							
							$Folder_buffer:=cs:C1710.path.new().templates().folder("asset").folder($Obj_in.type)
							$Txt_buffer:=$Folder_buffer.platformPath
							$Obj_out.success:=$Folder_buffer.exists
							
							If ($Obj_in.tags.filename=Null:C1517)
								
								$Obj_in.tags.filename:=$Obj_in.name
								
							End if 
							
							//........................................
						: ($Obj_in.type="folder")
							
							$Folder_buffer:=cs:C1710.path.new().templates().folder("asset").folder($Obj_in.type)
							$Txt_buffer:=$Folder_buffer.platformPath
							$Obj_out.success:=$Folder_buffer.exists
							
							//........................................
						Else 
							
							$Obj_out.errors:=New collection:C1472("Unknown type "+String:C10($Obj_in.type))
							$Obj_out.success:=False:C215
							
							//........................................
					End case 
					
					//$Obj_buffer:=Path to object($Txt_buffer)
					//$Obj_buffer.isFolder:=True
					//$Txt_buffer:=Object to path($Obj_buffer)
					
					If ($Obj_out.success)
						
						Case of 
							: (Value type:C1509($Obj_in.target)=Is text:K8:3)
								$target:=Folder:C1567($Obj_in.target; fk platform path:K87:2)
							: (Value type:C1509($Obj_in.target)=Is object:K8:27)
								$target:=$Obj_in.target
						End case 
						
						If (Not:C34($target.exists))
							
							// Create intermediate asset folder if necessary
							var $directories : Collection
							$directories:=New collection:C1472
							
							var $directory : 4D:C1709.Folder
							$directory:=$target
							
							While (Not:C34($directory.exists))
								
								$directories.push($directory)
								$directory:=$directory.parent
								
							End while 
							
							For each ($directory; $directories.reverse())
								
								asset(New object:C1471(\
									"action"; "create"; \
									"type"; "folder"; \
									"target"; $directory.parent; \
									"tags"; New object:C1471(\
									"name"; $directory.name+$directory.extension)))
								
							End for each 
						End if 
						
						$Obj_out.template:=TEMPLATE(New object:C1471(\
							"source"; $Txt_buffer; \
							"target"; $target.platformPath; \
							"tags"; $Obj_in.tags; \
							"catalog"; _o_doc_catalog($Txt_buffer)))
						
						$Obj_template:=ob_parseFile(File:C1566($Txt_buffer+"manifest.json"; fk platform path:K87:2)).value
						
						If (String:C10($Obj_template.contents)#"")
							
							$Txt_buffer:=Process_tags($Obj_template.contents; $Obj_in.tags; New collection:C1472("filename"))
							
							$contentsFile:=$target.folder($Txt_buffer).file("Contents.json")
							$Obj_:=ob_parseFile($contentsFile).value
							
							If (Bool:C1537($Obj_in.template))
								If ($Obj_.properties=Null:C1517)
									$Obj_.properties:=New object:C1471()
								End if 
								$Obj_.properties["template-rendering-intent"]:="template"
							End if 
							
							Case of 
									
									//........................................
								: ($Obj_.images#Null:C1517)
									
									$Obj_out.errors:=New collection:C1472
									
									// Read source file (XXX here source is String; later could have object or collection if image is already scaled)
									var $sourceFile : 4D:C1709.File
									Case of 
										: (Value type:C1509($Obj_in.source)=Is text:K8:3)
											$sourceFile:=File:C1566($Obj_in.source; fk platform path:K87:2)
										Else 
											$sourceFile:=$Obj_in.source
									End case 
									
									If ($sourceFile.exists)
										
										READ PICTURE FILE:C678($sourceFile.platformPath; $Pic_buffer)
										
										If ($Obj_in.size=Null:C1517)  // if no size, take from picture
											
											PICTURE PROPERTIES:C457($Pic_buffer; $Lon_width; $Lon_height)
											
											$Obj_in.size:=New object:C1471(\
												"width"; $Lon_width; \
												"height"; $Lon_height)
											
										End if 
										
										If (OK=1)
											
											// Create file for each defined file
											For each ($Obj_image; $Obj_.images)
												
												$Obj_image.filename:=cs:C1710.str.new($Obj_image.filename).unaccented()  // ACI0101846
												
												$Lon_scale:=1
												
												// Read potential scale factor
												If (Length:C16(String:C10($Obj_image.scale))#0)
													
													$Lon_scale:=Num:C11(String:C10($Obj_image.scale))
													
												End if 
												
												If (Value type:C1509($Obj_in.size)=Is object:K8:27)
													
													$Lon_width:=$Obj_in.size.width
													$Lon_height:=$Obj_in.size.height
													
												Else   // suppose single num
													
													$Lon_width:=$Obj_in.size
													$Lon_height:=$Obj_in.size
													
												End if 
												
												// Check if there is specific size for idiom, subtype of scale
												Case of 
														
														//…………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………
													: (Value type:C1509($Obj_in.sizes[$Obj_image.idiom+String:C10($Obj_image.subtype)+$Obj_image.scale])=Is object:K8:27)
														
														$Lon_width:=$Obj_in.sizes[$Obj_image.idiom+String:C10($Obj_image.subtype)+$Obj_image.scale].width
														$Lon_height:=$Obj_in.sizes[$Obj_image.idiom+String:C10($Obj_image.subtype)+$Obj_image.scale].height
														
														//…………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………
													: (Value type:C1509($Obj_in.sizes[$Obj_image.idiom])=Is object:K8:27)
														
														$Lon_width:=$Obj_in.sizes[$Obj_image.idiom].width*$Lon_scale
														$Lon_height:=$Obj_in.sizes[$Obj_image.idiom].height*$Lon_scale
														
														//…………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………
													Else 
														
														$Lon_width:=$Lon_width*$Lon_scale
														$Lon_height:=$Lon_height*$Lon_scale
														
														//…………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………
												End case 
												
												CREATE THUMBNAIL:C679($Pic_buffer; $Pic_icon; $Lon_width; $Lon_height; Scaled to fit:K6:2)  // XXX Scaled to fit prop centered?
												
												If (OK=1)
													
													WRITE PICTURE FILE:C680($Obj_in.target+$Txt_buffer+Folder separator:K24:12+$Obj_image.filename; $Pic_icon; "."+$Obj_in.format)
													
													If (OK=0)
														
														$Obj_out.errors.push("Failed to write picture "+$Obj_in.target+$Txt_buffer+Folder separator:K24:12+$Obj_image.filename+", created from "+$Obj_in.source+" with format ."+$Obj_in.format)
														
													End if 
													
												Else 
													
													$Obj_out.errors.push("Failed to create thumbnail for "+$Obj_in.source+" with size "+JSON Stringify:C1217($Obj_in.size)+" and scale "+$Lon_scale)
													
												End if 
											End for each 
											
										Else 
											
											$Obj_out.errors.push("Failed to read picture "+$Obj_in.source)
											
										End if 
										
									Else 
										
										$Obj_out.errors.push("No source file to read picture "+String:C10($Obj_in.source))
										
									End if 
									
									// dark ?
									$sourceFile:=File:C1566(Replace string:C233($sourceFile.path; $sourceFile.extension; "_dark"+$sourceFile.extension); fk platform path:K87:2)
									
									If ($sourceFile.exists)
										
										READ PICTURE FILE:C678($sourceFile.platformPath; $Pic_buffer)
										
										If ($Obj_in.size=Null:C1517)  // if no size, take from picture
											
											PICTURE PROPERTIES:C457($Pic_buffer; $Lon_width; $Lon_height)
											
											$Obj_in.size:=New object:C1471(\
												"width"; $Lon_width; \
												"height"; $Lon_height)
											
										End if 
										
										If (OK=1)
											
											// Create file for each defined file
											For each ($Obj_image; $Obj_.images)
												$Obj_image:=OB Copy:C1225($Obj_image)
												$Obj_image.filename:=cs:C1710.str.new($Obj_image.filename).unaccented()
												$Obj_image.filename:=Replace string:C233($Obj_image.filename; "."+$Obj_in.format; "_dark."+$Obj_in.format)
												$Obj_image.appearances:=New collection:C1472(New object:C1471("appearance"; "luminosity"; "value"; "dark"))
												
												$Obj_.images.push($Obj_image)
												
												$Lon_scale:=1
												
												// Read potential scale factor
												If (Length:C16(String:C10($Obj_image.scale))#0)
													
													$Lon_scale:=Num:C11(String:C10($Obj_image.scale))
													
												End if 
												
												If (Value type:C1509($Obj_in.size)=Is object:K8:27)
													
													$Lon_width:=$Obj_in.size.width
													$Lon_height:=$Obj_in.size.height
													
												Else   // suppose single num
													
													$Lon_width:=$Obj_in.size
													$Lon_height:=$Obj_in.size
													
												End if 
												
												// Check if there is specific size for idiom, subtype of scale
												Case of 
														
														//…………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………
													: (Value type:C1509($Obj_in.sizes[$Obj_image.idiom+String:C10($Obj_image.subtype)+$Obj_image.scale])=Is object:K8:27)
														
														$Lon_width:=$Obj_in.sizes[$Obj_image.idiom+String:C10($Obj_image.subtype)+$Obj_image.scale].width
														$Lon_height:=$Obj_in.sizes[$Obj_image.idiom+String:C10($Obj_image.subtype)+$Obj_image.scale].height
														
														//…………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………
													: (Value type:C1509($Obj_in.sizes[$Obj_image.idiom])=Is object:K8:27)
														
														$Lon_width:=$Obj_in.sizes[$Obj_image.idiom].width*$Lon_scale
														$Lon_height:=$Obj_in.sizes[$Obj_image.idiom].height*$Lon_scale
														
														//…………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………
													Else 
														
														$Lon_width:=$Lon_width*$Lon_scale
														$Lon_height:=$Lon_height*$Lon_scale
														
														//…………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………
												End case 
												
												CREATE THUMBNAIL:C679($Pic_buffer; $Pic_icon; $Lon_width; $Lon_height; Scaled to fit:K6:2)  // XXX Scaled to fit prop centered?
												
												If (OK=1)
													
													WRITE PICTURE FILE:C680($Obj_in.target+$Txt_buffer+Folder separator:K24:12+$Obj_image.filename; $Pic_icon; "."+$Obj_in.format)
													
													If (OK=0)
														
														$Obj_out.errors.push("Failed to write picture "+$Obj_in.target+$Txt_buffer+Folder separator:K24:12+$Obj_image.filename+", created from "+$Obj_in.source+" with format ."+$Obj_in.format)
														
													End if 
													
												Else 
													
													$Obj_out.errors.push("Failed to create thumbnail for "+$Obj_in.source+" with size "+JSON Stringify:C1217($Obj_in.size)+" and scale "+$Lon_scale)
													
												End if 
											End for each 
											
										Else 
											
											$Obj_out.errors.push("Failed to read picture "+$Obj_in.source)
											
										End if 
										
									End if 
									
									// reset errors if no error
									If ($Obj_out.errors.length=0)
										
										$Obj_out.errors:=Null:C1517
										
									Else 
										
										$Obj_out.success:=False:C215
										
									End if 
									
									$contentsFile.setText(JSON Stringify:C1217($Obj_; *); "UTF-8"; Document with LF:K24:22)
									
									//………………………………………………………………………
								: ($Obj_.colors#Null:C1517)
									
									// Check all tags defined
									For ($Lon_i; 1; $Obj_template.tags.length; 1)
										
										If ($Obj_in.tags[$Obj_template.tags[$Lon_i-1]]=Null:C1517)
											
											If ($Obj_out.errors=Null:C1517)
												
												$Obj_out.errors:=New collection:C1472
												
											End if 
											
											$Obj_out.errors.push("missing tag "+$Obj_template.tags[$Lon_i-1])
											
										End if 
									End for 
									
									$Obj_out.success:=$Obj_out.errors=Null:C1517
									
									//………………………………………………………………………
							End case 
						End if 
					End if 
					
					//…………………………………………………………………………………………………………………
			End case 
			
			// MARK:- read
		: ($Obj_in.action="read")
			
			If ($Obj_in.path#Null:C1517)
				
				Case of 
					: (Value type:C1509($Obj_in.path)=Is text:K8:3)
						$path:=Folder:C1567($Obj_in.path; fk platform path:K87:2)
					Else 
						$path:=$Obj_in.path
				End case 
				
				$contentsFile:=$path.file("Contents.json")
				If ($contentsFile.exists)
					
					$Obj_out.value:=ob_parseFile($contentsFile).value
					$Obj_out.success:=True:C214
					
				Else 
					
					$Obj_out.errors:=New collection:C1472("missing asset file Contents.json under path "+$Obj_in.path)
					
				End if 
				
			Else 
				
				$Obj_out.errors:=New collection:C1472("path must be defined")
				
			End if 
			
			// MARK:- list
		: ($Obj_in.action="list")
			
			If ($Obj_in.path#Null:C1517)
				
				Case of 
					: (Value type:C1509($Obj_in.path)=Is text:K8:3)
						$path:=Folder:C1567($Obj_in.path; fk platform path:K87:2)
					Else 
						$path:=$Obj_in.path
				End case 
				
				
				If ($path.exists)
					
					$Obj_out.children:=New collection:C1472
					
					If (Bool:C1537($Obj_in.contents))
						
						$contentsFile:=$path.file("Contents.json")
						If ($contentsFile.exists)
							
							$Obj_out.contents:=ob_parseFile($contentsFile).value
							
							// Else error
							
						End if 
					End if 
					
					var $folder : 4D:C1709.Folder
					For each ($folder; $path.folders())
						
						If (Length:C16($folder.extension)=0)
							
							// No extension
							$Txt_name:=$folder.name
							$Txt_buffer:=""
							
						Else 
							
							// Get short name if extension
							$Txt_name:=$folder.name
							$Txt_buffer:=Substring:C12($folder.extension; 2)
							
						End if 
						
						$Obj_:=New object:C1471(\
							"name"; $Txt_name; \
							"type"; $Txt_buffer; \
							"folder"; $folder; \
							"path"; $folder.platformPath)
						
						$Boo_:=True:C214
						
						If ($Obj_in.filter#Null:C1517)
							
							// ex: imageset; appiconset; empty string for folder
							$Boo_:=$Obj_in.filter=$Obj_.type
							
						End if 
						
						If ($Boo_)
							
							If (Bool:C1537($Obj_in.contents))
								
								$contentsFile:=$folder.file("Contents.json")
								If ($contentsFile.exists)
									
									$Obj_.contents:=ob_parseFile($contentsFile).value
									
									// Else errors?
									
								End if 
							End if 
						End if 
						
						If (Bool:C1537($Obj_in.recursive)\
							 & (Length:C16($Obj_.type)=0))
							
							$Obj_.children:=asset(New object:C1471(\
								"action"; "list"; \
								"path"; $Obj_.folder; \
								"contents"; $Obj_in.contents; \
								"recursive"; $Obj_in.recursive; \
								"filter"; $Obj_in.filter))
							ob_error_combine($Obj_out; $Obj_.children)
							
							If (Bool:C1537($Obj_.children.success))
								
								If (Value type:C1509($Obj_.children.children)=Is collection:K8:32)
									
									$Boo_:=$Boo_ | ($Obj_.children.children.length>0)
									$Obj_.children:=$Obj_.children.children
									
								End if 
							End if 
						End if 
						
						If ($Boo_)
							
							$Obj_out.children.push($Obj_)
							
						End if 
					End for each 
					
					$Obj_out.success:=True:C214
					
				Else 
					
					$Obj_out.errors:=New collection:C1472("path must be a folder")
					
				End if 
				
			Else 
				
				$Obj_out.errors:=New collection:C1472("path must be defined")
				
			End if 
			
			//________________________________________
		Else 
			
			$Obj_out.errors:=New collection:C1472("Unknown action "+$Obj_in.action)
			
			//________________________________________
	End case 
End if 