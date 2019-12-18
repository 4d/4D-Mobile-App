//%attributes = {}
  // ----------------------------------------------------
  // Project method: 00_OPEN
  // ID[2A0199468FC24025903500DE13DD6E63]
  // Created 11-5-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)

C_BOOLEAN:C305($Boo_debuglog)
C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($File_project;$t;$Txt_entryPoint;$Txt_methodName;$Txt_projectName)
C_OBJECT:C1216($o)

If (False:C215)
	C_TEXT:C284(00_OPEN ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If ($Lon_parameters>=1)
	
	$Txt_entryPoint:=$1
	
End if 

$Boo_debuglog:=True:C214  // Activate or not debug log for performance tests

  // ----------------------------------------------------
Case of 
		
		  //___________________________________________________________
	: (Length:C16($Txt_entryPoint)=0)
		
		$Txt_methodName:=Current method name:C684
		
		Case of 
				
				  //……………………………………………………………………
			: (Method called on error:C704=$Txt_methodName)
				
				  // Error handling manager
				
				  //……………………………………………………………………
				  //: (Method called on event=$Txt_methodName)
				
				  // Event manager - disabled for a component method
				
				  //……………………………………………………………………
			Else 
				
				  // This method must be executed in a unique new process
				BRING TO FRONT:C326(New process:C317($Txt_methodName;0;"$dev_"+$Txt_methodName;"_run";*))
				
				  //……………………………………………………………………
		End case 
		
		  //___________________________________________________________
	: ($Txt_entryPoint="_run")
		
		  // First launch of this method executed in a new process
		00_OPEN ("_declarations")
		00_OPEN ("_init")
		
		If (Shift down:C543)  // Select project
			
			$Txt_entryPoint:=Select document:C905(Get 4D folder:C485(Database folder:K5:14)+"Mobile Projects"+Folder separator:K24:12;".4dmobileapp";"";Package open:K24:8+Alias selection:K24:10)
			
			If (Bool:C1537(OK))
				
				$File_project:=DOCUMENT
				RESOLVE ALIAS:C695($File_project;$File_project)
				
			End if 
			
		Else   // Open project created by 00_New
			
			$Txt_projectName:=Choose:C955(Macintosh option down:C545;"test";"New Project")
			
			$File_project:=Get 4D folder:C485(Database folder:K5:14)+Convert path POSIX to system:C1107("Mobile Projects/"+$Txt_projectName+"/project.4dmobileapp")
			
		End if 
		
		If (Length:C16($File_project)>0)
			
			If ($Boo_debuglog)
				
				For each ($t;Folder:C1567(Logs folder:K5:19).files().query("name = '4DDebugLog_@'").extract("platformPath"))
					
					DELETE DOCUMENT:C159($t)
					
				End for each 
				
				SET DATABASE PARAMETER:C642(Log command list:K37:70;"")
				SET DATABASE PARAMETER:C642(Debug log recording:K37:34;4+8)
				
			End if 
			
			C_OPEN_MOBILE_PROJECT ($File_project)
			
			If ($Boo_debuglog)
				
				SET DATABASE PARAMETER:C642(Debug log recording:K37:34;0)
				
			End if 
		End if 
		
		00_OPEN ("_deinit")
		
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