//%attributes = {}
  // ----------------------------------------------------
  // Project method: 00_NEW
  // ID[2A0199468FC24025903500DE13DD6E63]
  // Created 11-5-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters;$Win_hdl)
C_TEXT:C284($t;$Txt_entryPoint;$Txt_projectName;$Txt_worker)
C_OBJECT:C1216($o;$Obj_form;$Obj_root)

If (False:C215)
	C_TEXT:C284(00_NEW ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If ($Lon_parameters>=1)
	
	$Txt_entryPoint:=$1
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //___________________________________________________________
	: (Length:C16($Txt_entryPoint)=0)
		
		$t:=Current method name:C684
		
		Case of 
				
				  //……………………………………………………………………
			: (Method called on error:C704=$t)
				
				  // Error handling manager
				
				  //……………………………………………………………………
			Else 
				
				  // This method must be executed in a unique new process
				BRING TO FRONT:C326(New process:C317($t;0;"$"+$t;"_run";*))
				
				  //……………………………………………………………………
		End case 
		
		  //___________________________________________________________
	: ($Txt_entryPoint="_run")
		
		  // First launch of this method executed in a new process
		00_NEW ("_declarations")
		00_NEW ("_init")
		
		If (False:C215)
			C_NEW_MOBILE_PROJECT 
			
		Else 
			
			$Obj_root:=Folder:C1567("/PACKAGE/Mobile Projects")
			$Obj_root.create()
			
			If (Shift down:C543)
				
				$Txt_projectName:=Request:C163(Get localized string:C991("mess_nameoftheproject");\
					"test";\
					Get localized string:C991("mess_create"))
				
				$Txt_projectName:=Choose:C955(Length:C16($Txt_projectName)=0;"test";$Txt_projectName)
				
			Else 
				
				$Txt_projectName:="test"
				
			End if 
			
			  // Create the project {
			$o:=Folder:C1567("/RESOURCES/default project").copyTo($Obj_root;$Txt_projectName;fk overwrite:K87:5).file("project.4dmobileapp")
			$t:=$o.getText()
			PROCESS 4D TAGS:C816($t;$t)
			$o.setText($t)
			
			  // Open the project editor
			$Win_hdl:=Open form window:C675("EDITOR";Plain form window:K39:10;*)
			
			$Txt_worker:="4D Mobile ("+String:C10($Win_hdl)+")"
			CALL WORKER:C1389($Txt_worker;"COMPILER_COMPONENT")
			
			$Obj_form:=New object:C1471(\
				"$worker";$Txt_worker;\
				"project";$o.platformPath;\
				"file";$o)
			
			If (Storage:C1525.database.isMatrix)
				
				DIALOG:C40("EDITOR";$Obj_form)
				
				CLOSE WINDOW:C154($Win_hdl)
				
			Else 
				
				DIALOG:C40("EDITOR";$Obj_form;*)
				
			End if 
		End if 
		
		00_NEW ("_deinit")
		
		  //___________________________________________________________
	: ($Txt_entryPoint="_declarations")
		
		COMPILER_COMPONENT 
		
		  //___________________________________________________________
	: ($Txt_entryPoint="_init")
		
		$o:=menu \
			.append(":xliff:CommonMenuFile";menu .file())\
			.append(":xliff:CommonMenuEdit";menu .edit())
		
		If (Storage:C1525.database.isMatrix)
			
			file_Menu ($o.ref)
			dev_Menu ($o.ref)
			
		End if 
		
		$o.setBar()
		
		  //___________________________________________________________
	: ($Txt_entryPoint="_deinit")
		
		  //
		
		  //___________________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point ("+$Txt_entryPoint+")")
		
		  //___________________________________________________________
End case 