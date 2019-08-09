//%attributes = {"invisible":true,"shared":true}
  // ----------------------------------------------------
  // Project method : C_NEW_MOBILE_PROJECT
  // Database: 4D Mobile Express
  // ID[574C8C3337AE4A1098BE3B5ACA721C48]
  // Created 13-6-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations

C_BOOLEAN:C305($Boo_Repeat)

C_LONGINT:C283($Lon_index;$Lon_parameters;$Win_hdl)
C_TEXT:C284($t;$Txt_buffer;$Txt_onErrCallMethod;$Txt_projectName)
C_OBJECT:C1216($o;$Obj_form;$Obj_path;$Obj_project;$Obj_root)
C_COLLECTION:C1488($c)

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	COMPILER_COMPONENT 
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
	OK:=1
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------

Repeat 
	
	$Txt_projectName:=Request:C163(Get localized string:C991("mess_nameoftheproject");\
		Get localized string:C991("mess_newProject");\
		Get localized string:C991("mess_create"))
	
	$Boo_Repeat:=(Length:C16($Txt_projectName)=0) & Bool:C1537(OK)
	
	If ($Boo_Repeat)
		
		ALERT:C41(Get localized string:C991("theProjectNameCanNotBeEmpty"))
		
	End if 
	
Until (Not:C34($Boo_Repeat))

If (Bool:C1537(OK))
	
	$o:=Folder:C1567(Database folder:K5:14;*).file("._")
	
	  // Check if we can write
	$Txt_onErrCallMethod:=Method called on error:C704
	
	ON ERR CALL:C155("hideError")  //====================== [
	
	OK:=Num:C11($o.create())
	$o.delete()
	
	ON ERR CALL:C155($Txt_onErrCallMethod)  //============== ]
	
	If (Bool:C1537(OK))
		
		  // Get the mobile project folder pathname
		$Obj_root:=Folder:C1567(fk database folder:K87:14;*).folder("Mobile Projects")
		$Obj_root.create()
		
		$o:=$Obj_root.folder($Txt_projectName)
		
		If ($o.exists)
			
			CONFIRM:C162(Get localized string:C991("mess_thisProjectAlreadyExist"))
			
		End if 
		
	Else 
		
		ALERT:C41(".The directory is locked or the disk is full")
		
	End if 
End if 

If (Bool:C1537(OK))
	
	$Obj_form:=New object:C1471
	
	  // Create the project {
	$o:=Folder:C1567("/RESOURCES/default project").copyTo($Obj_root;$Txt_projectName;fk overwrite:K87:5)
	
	  // Init default values
	$c:=$o.files().query("name = 'project'")
	
	If ($c.length=1)
		
		$o:=$c[0]
		$t:=$o.getText()
		PROCESS 4D TAGS:C816($t;$t)
		
		$Obj_form.file:=$o
		
		$Obj_form.project:=$o.platformPath
		
		  // Unique application name [
		$Obj_project:=JSON Parse:C1218($t)
		
		If ($Obj_project.product.name#Null:C1517)
			
			$Txt_buffer:=$Obj_project.product.name
			
			$Obj_path:=New object:C1471(\
				"parentFolder";COMPONENT_Pathname ("products").platformPath;\
				"isFolder";True:C214;\
				"name";$Txt_buffer)
			
			While (Test path name:C476(Object to path:C1548($Obj_path))=Is a folder:K24:2)
				
				$Lon_index:=$Lon_index+1
				$Obj_path.name:=$Txt_buffer+String:C10($Lon_index;" #####0")
				
			End while 
			
			If ($Obj_path.name#$Obj_project.product.name)
				
				$Obj_project.product.name:=$Obj_path.name
				$t:=JSON Stringify:C1217($Obj_project;*)
				
			End if 
		End if 
		  //]
		
		$o.setText($t)
		  //}
		
		  // Open the project editor
		$Win_hdl:=Open form window:C675("EDITOR";Plain form window:K39:10;Horizontally centered:K39:1;At the top:K39:5;*)
		
		  // Launch the worker
		$Obj_form.$worker:="4D Mobile ("+String:C10($Win_hdl)+")"
		CALL WORKER:C1389(String:C10($Obj_form.$worker);"COMPILER_COMPONENT")
		
		If (Storage:C1525.database.isMatrix)
			
			DIALOG:C40("EDITOR";$Obj_form)
			CLOSE WINDOW:C154($Win_hdl)
			
		Else 
			
			DIALOG:C40("EDITOR";$Obj_form;*)
			
		End if 
		
	Else 
		
		ASSERT:C1129(dev_Matrix ;"The default project content is not the expected one")
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End