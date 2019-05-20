//%attributes = {"invisible":true}
/*
out := ***project_Check_param*** ( in )
 -> in (Object)
 <- out (Object)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : project_Check_param
  // Database: 4D Mobile Express
  // ID[79BFA3C24536452A892A486A32EC7437]
  // Created #28-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_OBJECT:C1216($o;$Obj_in;$Obj_out)

If (False:C215)
	C_OBJECT:C1216(project_Check_param ;$0)
	C_OBJECT:C1216(project_Check_param ;$1)
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
	
	$o:=$Obj_in.project
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  // CHECK IF THE PROJECT COULD BE CREATE
Case of 
		
		  //______________________________________________________
	: ((Length:C16(String:C10($o.product.name))=0))  // Empty App name
		
		$o:=New object:C1471(\
			"page";"general";\
			"panel";"PRODUCT";\
			"object";"10_name")
		
		DO_MESSAGE (New object:C1471(\
			"action";"show";\
			"type";"alert";\
			"title";"theProductNameIsMandatory";\
			"additional";"pleaseGiveNameToYourProduct";\
			"okFormula";New formula:C1597(CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"goToPage";$o))))
		
		  //______________________________________________________
	: (OB Get:C1224($o;"dataModel";Is object:K8:27)=Null:C1517)\
		 | OB Is empty:C1297(OB Get:C1224($o;"dataModel";Is object:K8:27))  // No published structure
		
		$o:=New object:C1471(\
			"page";"structure")
		
		DO_MESSAGE (New object:C1471(\
			"action";"show";\
			"type";"alert";\
			"title";"noPublishedTable";\
			"additional";"youMustPublishAtLeastOneFieldToBeAbleToBuildYourApplication";\
			"okFormula";New formula:C1597(CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"goToPage";$o))))
		
		  //______________________________________________________
	: ($o.main.order=Null:C1517)\
		 | ($o.main.order.length=0)  // No table in the main menu
		
		$o:=New object:C1471(\
			"page";"main")
		
		DO_MESSAGE (New object:C1471(\
			"action";"show";\
			"type";"alert";\
			"title";"noTableDefinedInTheMainMenu";\
			"additional";"youMustSetAtLeastOneTableIntoTheMainMenu";\
			"okFormula";New formula:C1597(CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"goToPage";$o))))
		
		  //______________________________________________________
	Else 
		
		$Obj_out.success:=True:C214  // no error
		
		  //______________________________________________________
End case 

If ($Obj_out.success & Bool:C1537($Obj_in.build))
	
	  // CHECK IF THE PROJECT COULD BE BUILD
	
End if 

If ($Obj_out.success & Bool:C1537($Obj_in.run))
	
	  // CHECK IF THE PROJECT COULD BE RUN
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End