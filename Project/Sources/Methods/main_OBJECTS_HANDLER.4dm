//%attributes = {"invisible":true}
/*
Long Integer := ***main_OBJECTS_HANDLER***
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : main_OBJECTS_HANDLER
  // Database: 4D Mobile Express
  // ID[89D85B939E4A4648AB17C1EF13CC9B80]
  // Created #31-10-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($0)

C_BLOB:C604($x)
C_LONGINT:C283($i;$l;$Lon_column;$Lon_parameters;$Lon_row;$Lon_x)
C_LONGINT:C283($Lon_y)
C_POINTER:C301($Ptr_IDs;$Ptr_names)
C_OBJECT:C1216($o;$Obj_context;$Obj_form)

If (False:C215)
	C_LONGINT:C283(main_OBJECTS_HANDLER ;$0)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
	$0:=-1  // Reject drop
	
	$Obj_form:=main_Handler (New object:C1471(\
		"action";"init"))
	
	$Obj_context:=$Obj_form.ui
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //==================================================
	: ($Obj_form.me=$Obj_form.tables.name)
		
		LISTBOX GET CELL POSITION:C971(*;$Obj_form.me;$Lon_column;$Lon_row)
		
		Case of 
				
				  //______________________________________________________
			: ($Obj_form.event=On Clicked:K2:4)\
				 | ($Obj_form.event=On Selection Change:K2:29)
				
				main_Handler (New object:C1471(\
					"action";"buttons"))
				
				editor_ui_LISTBOX ($Obj_form.me)
				
				  //______________________________________________________
			: ($Obj_form.event=On Double Clicked:K2:5)
				
				If ($Lon_row>0)
					
					main_Handler (New object:C1471(\
						"action";"add";\
						"id";($Obj_form.tableNumbers.pointer())->{$Lon_row};\
						"name";($Obj_form.tableNames.pointer())->{$Lon_row}))
					
					  // Update table order
					$Obj_context.order()
					
				End if 
				
				editor_ui_LISTBOX ($Obj_form.me)
				
				  //______________________________________________________
			: ($Obj_form.event=On Begin Drag Over:K2:44)
				
				$o:=New object:C1471(\
					"name";($Obj_form.tableNames.pointer())->{$Lon_row};\
					"tableNumber";($Obj_form.tableNumbers.pointer())->{$Lon_row})
				
				VARIABLE TO BLOB:C532($o;$x)
				
				APPEND DATA TO PASTEBOARD:C403("com.4d.private.ios.table";$x)
				
				  //______________________________________________________
			: ($Obj_form.event=On Getting Focus:K2:7)
				
				editor_ui_LISTBOX ($Obj_form.me;True:C214)
				
				  //______________________________________________________
			: ($Obj_form.event=On Losing Focus:K2:8)
				
				editor_ui_LISTBOX ($Obj_form.me;False:C215)
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Obj_form.event)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($Obj_form.me=$Obj_form.mains.name)
		
		LISTBOX GET CELL POSITION:C971(*;$Obj_form.me;$Lon_column;$Lon_row)
		
		Case of 
				
				  //______________________________________________________
			: ($Obj_form.event=On Clicked:K2:4)\
				 | ($Obj_form.event=On Selection Change:K2:29)
				
				main_Handler (New object:C1471(\
					"action";"buttons"))
				
				editor_ui_LISTBOX ($Obj_form.me)
				
				  //______________________________________________________
			: ($Obj_form.event=On Row Moved:K2:32)
				
				If (editor_Locked )
					
					  // Unable to set "movable rows" to false, so redraw
					main_Handler (New object:C1471(\
						"action";"update"))
					
					BEEP:C151
					
				Else 
					
					  // Update table order
					$Obj_context.order()
					
				End if 
				
				  //______________________________________________________
			: ($Obj_form.event=On Drag Over:K2:13)
				
				GET PASTEBOARD DATA:C401("com.4d.private.ios.table";$x)
				
				If (Bool:C1537(OK))
					
					BLOB TO VARIABLE:C533($x;$o)
					
					If (Bool:C1537(OK))
						
						  //#MARK_TODO - Don(t allow if already present
						
						$0:=0
						
					End if 
					
					SET BLOB SIZE:C606($x;0)
					
				End if 
				
				  //______________________________________________________
			: ($Obj_form.event=On Drop:K2:12)
				
				GET PASTEBOARD DATA:C401("com.4d.private.ios.table";$x)
				
				If (Bool:C1537(OK))
					
					BLOB TO VARIABLE:C533($x;$o)
					
					If (Bool:C1537(OK))
						
						SET BLOB SIZE:C606($x;0)
						
						  //#MARK_TODO - Don(t allow if already present
						
						$l:=Drop position:C608
						
						If ($l>=0)
							
							$Obj_context.insert($o.tableNumber;$o.name;$l)
							
						Else 
							
							$Obj_context.append($o.tableNumber;$o.name;$l)
							
						End if 
						
						  // Update table order
						$Obj_context.order()
						
					End if 
				End if 
				
				editor_ui_LISTBOX ($Obj_form.me)
				
				  //______________________________________________________
			: ($Obj_form.event=On Getting Focus:K2:7)
				
				editor_ui_LISTBOX ($Obj_form.me;True:C214)
				
				  //______________________________________________________
			: ($Obj_form.event=On Losing Focus:K2:8)
				
				editor_ui_LISTBOX ($Obj_form.me;False:C215)
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Obj_form.event)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($Obj_form.me="b.add.@")
		
		$Ptr_names:=$Obj_form.tableNames.pointer()
		$Ptr_IDs:=$Obj_form.tableNumbers.pointer()
		
		If ($Obj_form.me=$obj_form.addOne.name)
			
			$Lon_x:=Find in array:C230(($Obj_form.tables.pointer())->;True:C214)
			
			If ($Lon_x>0)
				
				$Lon_y:=Find in array:C230(($Obj_form.mains.pointer())->;True:C214)
				
				If ($Lon_y>0)
					
					$Obj_context.insert($Ptr_IDs->{$Lon_x};$Ptr_names->{$Lon_x};$Lon_y)
					
				Else 
					
					$Obj_context.append($Ptr_IDs->{$Lon_x};$Ptr_names->{$Lon_x})
					
				End if 
			End if 
			
		Else 
			
			For ($i;1;Size of array:C274($Ptr_IDs->);1)
				
				$Obj_context.append($Ptr_IDs->{$i};$Ptr_names->{$i})
				
			End for 
		End if 
		
		  // Update table order
		$Obj_context.order()
		
		  //==================================================
	: ($Obj_form.me="b.remove.@")
		
		If ($Obj_form.me=$Obj_form.removeOne.name)
			
			$Lon_x:=Find in array:C230(($Obj_form.mains.pointer())->;True:C214)
			
			If ($Lon_x>0)
				
				$Obj_form.mains.deleteRow($Lon_x)
				
			End if 
			
		Else 
			
			$Obj_form.mains.deleteAllRows()
			
		End if 
		
		  // Update table order
		$Obj_context.order()
		
		  //==================================================
	Else 
		
		ASSERT:C1129(False:C215;"Unknown object: \""+$Obj_form.me+"\"")
		
		  //==================================================
End case 

If (Bool:C1537(featuresFlags._8858))
	
	ui.saveProject()
	
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End