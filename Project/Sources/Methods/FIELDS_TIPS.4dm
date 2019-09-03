//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : FIELDS_TIPS
  // ID[D1FB57AAFDE04F1FA85A6B77F85F026F]
  // Created 3-9-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_TEXT:C284($t)
C_OBJECT:C1216($o;$Obj_form;$Obj_widget)

If (False:C215)
	C_OBJECT:C1216(FIELDS_TIPS ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
ASSERT:C1129($1.target#Null:C1517)
ASSERT:C1129($1.form#Null:C1517)

$Obj_form:=$1.form
$Obj_widget:=$Obj_form.fieldList
$Obj_widget.cellPosition()

$o:=str ()  // init class

  // ----------------------------------------------------
If ($Obj_widget.row#0)
	
	Case of 
			
			  //………………………………………………………………………………
		: (Length:C16(Get edited text:C655)#0)  // Edition mode
			
			Case of 
					
					  //……………………………………………………………………………………………
				: ($Obj_widget.column=$Obj_widget.columns[$Obj_form.titles].number)
					
					$t:=$o.setText("youCanInsertFieldNamesSurroundedByTheCharacter").localized()
					
					  //……………………………………………………………………………………………
				Else 
					
					  //
					
					  //……………………………………………………………………………………………
			End case 
			
			  //………………………………………………………………………………
		: ($Obj_widget.row=0)  // Nothing
			
			  //………………………………………………………………………………
		: ($Obj_widget.column=$Obj_widget.columns[$Obj_form.icons].number)
			
			$t:=$o.setText("clickToSet").localized()
			
			  //………………………………………………………………………………
		: ($Obj_widget.column=$Obj_widget.columns[$Obj_form.shortLabels].number)
			
			$t:=$o.setText("doubleClickToEdit").localized()+"\r - "+$o.setText("shouldBe10CharOrLess").localized()
			
			  //………………………………………………………………………………
		: ($Obj_widget.column=$Obj_widget.columns[$Obj_form.labels].number)
			
			$t:=$o.setText("doubleClickToEdit").localized()+"\r - "+$o.setText("shouldBe25CharOrLess").localized()
			
			  //………………………………………………………………………………
		: ($Obj_widget.column=$Obj_widget.columns[$Obj_form.titles].number)
			
			$t:=$o.setText("doubleClickToEdit").localized()
			
			  //………………………………………………………………………………
	End case 
	
Else 
	
	  // NO ITEM HOVERED
	
End if 

OBJECT SET HELP TIP:C1181(*;$1.target;$t)

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End