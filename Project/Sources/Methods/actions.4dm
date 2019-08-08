//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : actions
  // Database: 4D Mobile App
  // ID[66E9AA75F234494E96C5C0514F05D6C4]
  // Created 7-3-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($t;$Txt_action)
C_OBJECT:C1216($o;$Obj_action;$Obj_in;$Obj_out)

If (False:C215)
	C_OBJECT:C1216(actions ;$0)
	C_TEXT:C284(actions ;$1)
	C_OBJECT:C1216(actions ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_action:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		$Obj_in:=$2
		
	End if 
	
	$Obj_out:=New object:C1471(\
		"success";False:C215)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Txt_action="form")
		
		$Obj_out.success:=True:C214
		
		$Obj_out.actions:=actions ("filter";$Obj_in).actions
		
		For each ($Obj_action;$Obj_out.actions)
			
			For each ($t;$Obj_action)
				
				If ($t[[1]]="$")
					
					OB REMOVE:C1226($Obj_action;$t)
					
				End if 
			End for each 
			
			If (Length:C16(String:C10($Obj_action.icon))>0)
				
				$Obj_action.icon:="action_"+$Obj_action.name
				
			End if 
			
			If ($Obj_action.label=Null:C1517)
				
				$Obj_action.label:=$Obj_action.name
				
			End if 
		End for each 
		
		  //______________________________________________________
	: ($Txt_action="filter")
		
		If ($Obj_in.project#Null:C1517)  // Could be not(null) for test
			
			$Obj_in.actions:=$Obj_in.project.actions
			
		End if 
		
		$Obj_out.actions:=New collection:C1472()
		
		If ($Obj_in.actions#Null:C1517)
			
			If (Value type:C1509($Obj_in.actions)=Is collection:K8:32)
				
				$Obj_out.actions:=$Obj_in.actions.copy()
				
				  // Filter empty names
				$Obj_out.actions:=$Obj_out.actions.query("name !=''")
				
				If (Num:C11($Obj_in.tableNumber)#0)  // Filter according to the tableNumber
					
					$Obj_out.actions:=$Obj_out.actions.query("tableNumber = :1";Num:C11($Obj_in.tableNumber))
					
				End if 
				
				If (Length:C16($Obj_in.scope)>0)  // Filter according to the scope
					
					$Obj_out.actions:=$Obj_out.actions.query("scope = :1";$Obj_in.scope)
					
				End if 
			End if 
		End if 
		
		  //______________________________________________________
	: ($Txt_action="assets")
		
		Case of 
				
				  //……………………………………………………………………………………………………………
			: ($Obj_in.target=Null:C1517)
				
				ASSERT:C1129(dev_Matrix ;"target must be defined for action assets files")
				
				  //……………………………………………………………………………………………………………
			Else 
				
				If ($Obj_in.project#Null:C1517)
					
					$Obj_in.actions:=$Obj_in.project.actions
					
				End if 
				
				If (Value type:C1509($Obj_in.actions)=Is collection:K8:32)
					
					$Obj_out.results:=New object:C1471
					
					$Obj_out.path:=asset (New object:C1471("action";"path";"path";$Obj_in.target)).path+"Actions"+Folder separator:K24:12
					
					For each ($Obj_action;$Obj_in.actions)
						
						$o:=actions ("iconPath";New object:C1471(\
							"action";$Obj_action))
						
						Case of 
								
								  //……………………………………………………
							: (Bool:C1537($o.exists))
								
								$Obj_out.results[$Obj_action.name]:=asset (New object:C1471(\
									"action";"create";\
									"type";"imageset";\
									"source";$o.platformPath;\
									"tags";New object:C1471("name";"action_"+$Obj_action.name);\
									"target";$Obj_out.path;\
									"size";32))
								
								ob_error_combine ($Obj_out;$Obj_out.results[$Obj_action.name])
								
								  //……………………………………………………
							: ($o.success)
								
								  // No icon
								
								  //……………………………………………………
							Else 
								
								  // Icon file is missing
								ob_warning_add ($Obj_out;"Missing action icon file: "+String:C10($Obj_in.action.icon))
								
								  //……………………………………………………
						End case 
					End for each 
					
					$Obj_out.success:=Not:C34(ob_error_has ($Obj_out))
					
				End if 
				
				  //……………………………………………………………………………………………………………
		End case 
		
		  //______________________________________________________
	: ($Txt_action="iconPath")  // RECURSIVE CALL
		
		Case of 
				
				  //……………………………………………………………………………………………………………
			: ($Obj_in.action=Null:C1517)
				
				ASSERT:C1129(dev_Matrix ;"action must be defined to get icon path")
				
				  //……………………………………………………………………………………………………………
			: (Length:C16(String:C10($Obj_in.action.icon))=0)
				
				$Obj_out.success:=True:C214  // No icon but success
				
				  //……………………………………………………………………………………………………………
			: (String:C10($Obj_in.action.icon)[[1]]="/")  // host icons
				
				$Obj_out:=COMPONENT_Pathname ("host_actionIcons").file(Delete string:C232($Obj_in.action.icon;1;1))
				
				  //……………………………………………………………………………………………………………
			Else 
				
				$Obj_out:=COMPONENT_Pathname ("actionIcons").file($Obj_in.action.icon)
				
				  //……………………………………………………………………………………………………………
		End case 
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Txt_action+"\"")
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End