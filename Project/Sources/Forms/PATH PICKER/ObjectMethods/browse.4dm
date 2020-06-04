  // ----------------------------------------------------
  // Object method : PATH PICKER.browse
  // ID[FBCDFA41F1B94F72901526D840F4C608]
  // Created #10-9-2014 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($0)

C_BOOLEAN:C305($success)
C_LONGINT:C283($Lon_event)
C_TEXT:C284($t)

  // ----------------------------------------------------
  // Initialisations
$Lon_event:=Form event code:C388

$0:=-1

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Lon_event=On Clicked:K2:4)
		
		Case of 
				
				  //………………………………………………………………
			: (Form:C1466.type=Is a document:K24:1)\
				 | (Is macOS:C1572 & (Position:C15(".app";String:C10(Form:C1466.fileTypes))>0))
				
				If (Value type:C1509(Form:C1466.directory)=Is text:K8:3)
					
					$t:=Select document:C905(String:C10(Form:C1466.directory);String:C10(Form:C1466.fileTypes);String:C10(Form:C1466.message);Num:C11(Form:C1466.options))
					
				Else 
					
					  // Use a memorized access path
					$t:=Select document:C905(Num:C11(Form:C1466.directory);String:C10(Form:C1466.fileTypes);String:C10(Form:C1466.message);Num:C11(Form:C1466.options))
					
				End if 
				
				$success:=Bool:C1537(OK)
				
				If ($success)
					
					$t:=DOCUMENT
					
				End if 
				
				  //………………………………………………………………
			: (Form:C1466.type=Is a folder:K24:2)
				
				If (Value type:C1509(Form:C1466.directory)=Is text:K8:3)
					
					$t:=Select folder:C670(String:C10(Form:C1466.message);String:C10(Form:C1466.directory);Num:C11(Form:C1466.options))
					
				Else 
					
					  // Use a memorized access path
					$t:=Select folder:C670(String:C10(Form:C1466.message);Num:C11(Form:C1466.directory);Num:C11(Form:C1466.options))
					
				End if 
				
				$success:=Bool:C1537(OK)
				
				  //………………………………………………………………
			Else 
				
				  // NOTHING MORE TO DO
				
				  //………………………………………………………………
		End case 
		
		  //______________________________________________________
	: ($Lon_event=On Drag Over:K2:13)
		
		$0:=-1+Num:C11(Test path name:C476(Get file from pasteboard:C976(1))=Num:C11(Form:C1466.type))
		
		  //______________________________________________________
	: ($Lon_event=On Drop:K2:12)
		
		$t:=Get file from pasteboard:C976(1)
		$success:=(Test path name:C476($t)=Num:C11(Form:C1466.type))
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessary ("+String:C10($Lon_event)+")")
		
		  //______________________________________________________
End case 

If ($success)
	
	Form:C1466.platformPath:=$t
	Form:C1466.updateLabel($t)
	
	If (Path to object:C1547($t).isFolder)
		
		Form:C1466._target:=Folder:C1567($t;fk platform path:K87:2)
		
	Else 
		
		Form:C1466._target:=File:C1566($t;fk platform path:K87:2)
		
	End if 
	
	If (Form:C1466.callback#Null:C1517)
		
		Form:C1466.callback.call(Form:C1466._target)
		
	Else 
		
		CALL SUBFORM CONTAINER:C1086(On Data Change:K2:15)
		
	End if 
End if 