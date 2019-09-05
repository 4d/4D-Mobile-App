//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : PRODUCT_Handler
  // ID[253AACE0D441405796E02B46390100DD]
  // Created 11-9-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_formEvent;$Lon_height;$Lon_length;$Lon_parameters;$Lon_px;$Lon_width;$Lon_x)
C_PICTURE:C286($Pic_blanck;$Pic_buffer;$Pic_icon)
C_REAL:C285($Num_size)
C_TEXT:C284($File_;$Txt_buffer;$Txt_decimalSeparator)
C_OBJECT:C1216($Obj_;$Obj_content;$Obj_form;$Obj_in;$Obj_out)
C_COLLECTION:C1488($Col_)

If (False:C215)
	C_OBJECT:C1216(PRODUCT_Handler ;$0)
	C_OBJECT:C1216(PRODUCT_Handler ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Obj_in:=$1
		
	End if 
	
	$Obj_form:=New object:C1471(\
		"window";Current form window:C827;\
		"form";editor_INIT ;\
		"productName";"10_name";\
		"productNameAlert";"name.alert";\
		"productVersion";"11_version";\
		"productID";"id";\
		"productCopyright";"30_copyright";\
		"icon";"icon";\
		"iconAlert";"icon.alert")
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //=========================================================
	: ($Obj_in=Null:C1517)  // Form method
		
		$Lon_formEvent:=panel_Form_common (On Load:K2:1;On Timer:K2:25;On Bound Variable Change:K2:52)
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Load:K2:1)
				
				  // Constraints definition
				$Obj_form.form.constraints:=New object:C1471
				
				  //______________________________________________________
			: ($Lon_formEvent=On Timer:K2:25)
				
				PRODUCT_Handler (New object:C1471(\
					"action";"checkName";\
					"value";Form:C1466.product.name))
				
				PRODUCT_Handler (New object:C1471(\
					"action";"loadIcon"))
				
				  //______________________________________________________
			: ($Lon_formEvent=On Bound Variable Change:K2:52)
				
				SET TIMER:C645(-1)
				
				  //______________________________________________________
		End case 
		
		  //=========================================================
	: ($Obj_in.action=Null:C1517)
		
		ASSERT:C1129(False:C215;"Missing parameter \"action\"")
		
		  //=========================================================
	: ($Obj_in.action="init")  // Return the form objects definition
		
		$Obj_out:=$Obj_form
		
		  //=========================================================
	: ($Obj_in.action="loadIcon")  // Load the appiconset contents
		
		If ($Obj_form.form.assets=Null:C1517)
			
			$Obj_form.form.assets:=New object:C1471(\
				"root";Form:C1466.$project.root+Convert path POSIX to system:C1107("Assets.xcassets/AppIcon.appiconset/"))
			
			CREATE FOLDER:C475($Obj_form.form.assets.root;*)
			
		End if 
		
		If ($Obj_form.form.assets.icons=Null:C1517)
			
			  // Path is relative to the project file
			If (Asserted:C1132(Test path name:C476($Obj_form.form.assets.root+"Contents.json")=Is a document:K24:1))
				
				$Obj_form.form.assets.icons:=JSON Parse:C1218(Document to text:C1236($Obj_form.form.assets.root+"Contents.json"))
				
			End if 
		End if 
		
		PRODUCT_Handler (New object:C1471(\
			"action";"displayIcon"))
		
		  //=========================================================
	: ($Obj_in.action="displayIcon")  // Display the selected icon
		
		CLEAR VARIABLE:C89((ui.pointer($Obj_form.icon))->)
		
		$Col_:=$Obj_form.form.assets.icons.images.indices("idiom = :1";"ios-marketing")
		
		If ($Col_.length>0)
			
			$Txt_buffer:=$Obj_form.form.assets.root+$Obj_form.form.assets.icons.images[$Col_[0]].filename
			
			If (Test path name:C476($Txt_buffer)=Is a document:K24:1)
				
				READ PICTURE FILE:C678($Txt_buffer;(ui.pointer($Obj_form.icon))->)
				
				  //(UI.pointer($Obj_form.icon))->:=$Pic_icon
				
			End if 
			
			project_UI_ALERT (New object:C1471(\
				"target";$Obj_form.iconAlert;\
				"reset";True:C214))
			
		Else 
			
			project_UI_ALERT (New object:C1471(\
				"target";$Obj_form.iconAlert;\
				"type";"alert";\
				"tips";".The icon is mandatory."))  //#MARK_LOCALIZE
			
		End if 
		
		  //=========================================================
	: ($Obj_in.action="browseIcon")  // Choose an icon file
		
		  // Select an image file
		$Txt_buffer:=Select document:C905(8858;"public.image;.app";".Select a picture or an application";Use sheet window:K24:11)  //#MARK_LOCALIZE
		
		If (OK=1)
			
			PRODUCT_Handler (New object:C1471(\
				"action";"getIcon";\
				"path";DOCUMENT))
			
		End if 
		
		  //=========================================================
	: ($Obj_in.action="getIcon")  // Retrieve icon from a drop
		
		  //#96614 - Allow an application for setting the product icon
		If (Test path name:C476($Obj_in.path)=Is a document:K24:1)
			
			READ PICTURE FILE:C678($Obj_in.path;$Pic_icon)
			
		Else 
			
			$Obj_in.path:=Object to path:C1548(New object:C1471(\
				"parentFolder";$Obj_in.path;\
				"name";"Contents";\
				"isFolder";True:C214))
			
			If (Test path name:C476($Obj_in.path)=Is a folder:K24:2)
				
				$File_:=Object to path:C1548(New object:C1471(\
					"parentFolder";$Obj_in.path;\
					"name";"Info";\
					"isFolder";False:C215;\
					"extension";".plist"))
				
				If (Test path name:C476($File_)=Is a document:K24:1)
					
					$Obj_in.path:=Object to path:C1548(New object:C1471(\
						"parentFolder";$Obj_in.path;\
						"name";"Resources";\
						"isFolder";True:C214))
					
					If (Test path name:C476($Obj_in.path)=Is a folder:K24:2)
						
						$Txt_buffer:=String:C10(plist_toObject (Document to text:C1236($File_)).CFBundleIconFile.string)  // xxxxxx.icns
						
						If (Length:C16($Txt_buffer)>0)
							
							$Obj_in.path:=$Obj_in.path+$Txt_buffer
							
							If (Test path name:C476($Obj_in.path)#Is a document:K24:1)
								
								  // CFBundleIconFile could be without extension (default is icns)
								$Obj_:=Path to object:C1547($Obj_in.path)
								
								If (Length:C16($Obj_.extension)=0)
									
									$Obj_.extension:="icns"
									
									$Obj_in.path:=Object to path:C1548($Obj_)
									
								End if 
							End if 
							
							If (Test path name:C476($Obj_in.path)=Is a document:K24:1)
								
								READ PICTURE FILE:C678($Obj_in.path;$Pic_icon)
								CONVERT PICTURE:C1002($Pic_icon;".png")
								
							End if 
						End if 
					End if 
				End if 
			End if 
		End if 
		
		If (Picture size:C356($Pic_icon)>0)
			
			PRODUCT_Handler (New object:C1471(\
				"action";"setIcon";\
				"image";$Pic_icon))
			
		End if 
		
		  //=========================================================
	: ($Obj_in.action="setIcon")  // Update asset & the form object
		
		$Pic_buffer:=$Obj_in.image
		
		  // Check size {
		PICTURE PROPERTIES:C457($Pic_buffer;$Lon_width;$Lon_height)
		
		If ($Lon_width>1024)\
			 | ($Lon_height>1024)
			
			CREATE THUMBNAIL:C679($Pic_buffer;$Pic_buffer;1024;1024;Scaled to fit prop centered:K6:6)
			PICTURE PROPERTIES:C457($Pic_buffer;$Lon_width;$Lon_height)
			
		End if 
		  //}
		
		  //#96701 - Add a blank background {
		READ PICTURE FILE:C678(Get 4D folder:C485(Current resources folder:K5:16)+"images"+Folder separator:K24:12+"blanck.png";$Pic_blanck)
		COMBINE PICTURES:C987($Pic_buffer;$Pic_blanck;Superimposition:K61:10;$Pic_buffer;(1024-$Lon_width)\2;(1024-$Lon_height)\2)
		  //}
		
		  // Create all sizes of icons & Update contents.json {
		If (Test path name:C476($Obj_form.form.assets.root+"Contents.json")#Is a document:K24:1)
			
			If (Test path name:C476($Obj_form.form.assets.root)#Is a folder:K24:2)
				
				CREATE FOLDER:C475($Obj_form.form.assets.root;*)
				
			End if 
			
			COPY DOCUMENT:C541(_o_Pathname ("project⁩")+"Assets.xcassets"+Folder separator:K24:12+"AppIcon.appiconset"+Folder separator:K24:12+"Contents.json";$Obj_form.form.assets.root+"Contents.json")
			
		End if 
		
		$Obj_content:=JSON Parse:C1218(Document to text:C1236($Obj_form.form.assets.root+"Contents.json"))
		
		GET SYSTEM FORMAT:C994(Decimal separator:K60:1;$Txt_decimalSeparator)
		
		For each ($Obj_;$Obj_content.images)
			
			$Txt_buffer:=$Obj_.size
			$Lon_x:=Position:C15("x";$Obj_.size)
			
			If ($Lon_x>0)
				
				$Num_size:=Num:C11(Replace string:C233(Substring:C12($Txt_buffer;1;$Lon_x-1);".";$Txt_decimalSeparator))
				$Lon_px:=$Num_size*Num:C11($Obj_.scale)
				
				CREATE THUMBNAIL:C679($Pic_buffer;$Pic_icon;$Lon_px;$Lon_px;Scaled to fit prop centered:K6:6)
				
				$Txt_buffer:=$Obj_.idiom+Replace string:C233(String:C10($Num_size);$Txt_decimalSeparator;"")
				
				If ($Obj_.scale#"1x")
					
					  //%W-533.1
					$Txt_buffer:=$Txt_buffer+"@"+$Obj_.scale[[1]]
					  //%W+533.1
					
				End if 
				
				$Txt_buffer:=$Txt_buffer+".png"
				
				WRITE PICTURE FILE:C680($Obj_form.form.assets.root+$Txt_buffer;$Pic_icon;".png")
				
			End if 
		End for each 
		
		$Obj_form.form.assets.icons.images:=$Obj_content.images
		
		TEXT TO DOCUMENT:C1237($Obj_form.form.assets.root+"Contents.json";JSON Stringify:C1217($Obj_content;*))
		  //}
		
		  // Update form picture
		(ui.pointer($Obj_form.icon))->:=$Pic_buffer
		
		PRODUCT_Handler (New object:C1471(\
			"action";"displayIcon"))
		
		  //=========================================================
	: ($Obj_in.action="openIconFolder")  // Open the product icons foledr
		
		SHOW ON DISK:C922($Obj_form.form.assets.root)
		
		  //=========================================================
	: ($Obj_in.action="checkName")  // Check the product name constraints
		
		$Lon_length:=Length:C16($Obj_in.value)
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_length=0)\
				 & ($Lon_formEvent=On After Edit:K2:43)
				
				  // NOTHING MORE TO DO
				
				  //______________________________________________________
			: ($Lon_length=0)
				
				project_UI_ALERT (New object:C1471(\
					"target";$Obj_form.productNameAlert;\
					"type";"alert";\
					"tips";".Product Name cannot be empty"))  //#MARK_LOCALIZE
				
				  //%W-533.1
				  //______________________________________________________
			: (Position:C15($Obj_in.value[[1]];"\\!@#$%^&*-+=123456789")>0)
				  //%W+533.1
				
				project_UI_ALERT (New object:C1471(\
					"target";$Obj_form.productNameAlert;\
					"type";"alert";\
					"tips";".Avoid Special Character or Numbers on the first Letter (!@#$%^&*-+=123456789)"))  //#MARK_LOCALIZE
				
				  //______________________________________________________
			: ($Lon_length<2)\
				 & ($Lon_formEvent=On After Edit:K2:43)
				
				  // NOTHING MORE TO DO
				
				  //______________________________________________________
			: ($Lon_length<2)
				
				project_UI_ALERT (New object:C1471(\
					"target";$Obj_form.productNameAlert;\
					"type";"alert";\
					"tips";".Product Name cannot be fewer than 2 Characters."))  //#MARK_LOCALIZE
				
				  //______________________________________________________
			: ($Lon_length>50)
				
				project_UI_ALERT (New object:C1471(\
					"target";$Obj_form.productNameAlert;\
					"type";"alert";\
					"tips";".Product Name cannot exceed 50 Characters."))  //#MARK_LOCALIZE
				
				  //______________________________________________________
			: ($Lon_length>23)
				
				project_UI_ALERT (New object:C1471(\
					"target";$Obj_form.productNameAlert;\
					"type";"warning";\
					"tips";".Product Name should be around 23 Characters or less."))  //#MARK_LOCALIZE
				
				  //______________________________________________________
			Else 
				
				project_UI_ALERT (New object:C1471(\
					"target";$Obj_form.productNameAlert;\
					"reset";True:C214))
				
				  //______________________________________________________
		End case 
		
		  //=========================================================
		
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Obj_in.action+"\"")
		
		  //=========================================================
End case 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End