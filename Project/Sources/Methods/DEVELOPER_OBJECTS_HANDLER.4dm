//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : DEVELOPER_OBJECTS_HANDLER
  // ID[9FD07CDE398243019D754AD0569D3546]
  // Created 21-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($bottom;$indx;$left;$right;$top)
C_OBJECT:C1216($e;$form;$menu;$o)

  // ----------------------------------------------------
  // Initialisations

  // NO PARAMETERS REQUIRED

$e:=FORM Event:C1606

$form:=DEVELOPER_Handler (New object:C1471(\
"action";"init"))

  // ----------------------------------------------------
Case of 
		
		  //==================================================
	: ($e.objectName=$form.team)
		
		Case of 
				
				  //______________________________________________________
			: ($e.code=On Data Change:K2:15)
				
				Form:C1466.organization.teamId:=Self:C308->
				
				  // Save project
				ui.saveProject()
				
				$indx:=$form.form.team.extract("id").indexOf(Self:C308->)
				
				If ($indx#-1)
					
					(OBJECT Get pointer:C1124(Object named:K67:5;$form.team))->:=$form.form.team[$indx].menu
					
				Else 
					
					  // Keep the user entry
					
				End if 
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$e.objectName+")")
				
				  //______________________________________________________
		End case 
		
		  // Update UI
		CALL FORM:C1391($form.window;"editor_CALLBACK";"updateRibbon")
		
		  //==================================================
	: ($e.objectName=$form.teamMenu)
		
		$menu:=cs:C1710.menu.new()\
			.append("none";"none").mark(Length:C16(String:C10(Form:C1466.organization.teamId))=0)
		
		If ($form.form.team.length>0)
			
			$menu.line()
			
			For each ($o;$form.form.team)
				
				$menu.append($o.menu;$o.id).mark(Form:C1466.organization.teamId=$o.id)
				
			End for each 
		End if 
		
		OBJECT GET COORDINATES:C663(*;$form.team+".border";$left;$top;$right;$bottom)
		CONVERT COORDINATES:C1365($left;$bottom;XY Current form:K27:5;XY Current window:K27:6)
		
		$menu.popup($left;$bottom)
		
		If ($menu.selected)
			
			Form:C1466.organization.teamId:=Choose:C955($menu.choice="none";"";$menu.choice)
			
			  // Save project
			ui.saveProject()
			
			  // UI
			$indx:=$form.form.team.extract("id").indexOf($menu.choice)
			
			If ($indx=-1)
				
				  // None
				(OBJECT Get pointer:C1124(Object named:K67:5;$form.team))->:=""
				
			Else 
				
				(OBJECT Get pointer:C1124(Object named:K67:5;$form.team))->:=$form.form.team[$indx].menu
				
			End if 
		End if 
		
		  // Update UI
		CALL FORM:C1391($form.window;"editor_CALLBACK";"updateRibbon")
		
		  //==================================================
	: ($e.objectName=($form.team+".help"))
		
		OPEN URL:C673(Get localized string:C991("doc_team");*)
		
		  //==================================================
	Else 
		
		ASSERT:C1129(False:C215;"Unknown object: \""+$e.objectName+"\"")
		
		  //==================================================
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End