  //  // ----------------------------------------------------
  //  // Form method : APP_STORE - (4D Mobile Express)
  //  // ID[A63D06DA6DD14DA4AF0C5E1DC4D2DADC]
  //  // Created #12-5-2017 by Vincent de Lachaux
  //  // ----------------------------------------------------
  //  // Declarations
  //C_LONGINT($Lon_formEvent;$Lon_i;$Lon_x)
  //C_PICTURE($Pic_)
  //C_POINTER($Ptr_)
  //C_OBJECT($Obj_constraints;$Obj_resources)

  //  // ----------------------------------------------------
  //  // Initialisations
  //$Lon_formEvent:=panel_Form_common (On Load;On Resize)

  //  // ----------------------------------------------------
  //Case of 

  //  //______________________________________________________
  //: ($Lon_formEvent=On Load)

  //If (True)  //constraints definition

  //$Obj_constraints:=New object
  //$Obj_constraints.rules:=New collection

  //  //-------------------------------------
  //$Obj_constraints.rules.push(New object("object";"01_name";"type";"width";"value";1;"reference";"viewport"))

  //$Obj_constraints.rules.push(New object("object";"01_name";"type";"minimum-width";"value";100))

  //  //The length of the app name is limited to no longer than 50 characters.
  //$Obj_constraints.rules.push(New object("object";"01_name";"type";"maximum-width";"value";310))

  //  //-------------------------------------
  //$Obj_constraints.rules.push(New object("object";"10_decription";"type";"width";"value";1;"reference";"viewport"))

  //  //-------------------------------------
  //$Obj_constraints.rules.push(New object("object";"12_primaryCategory";"type";"right hook"))

  //$Obj_constraints.rules.push(New object("object";"12_primaryCategory";"type";"minimum-width";"value";100))

  //$Obj_constraints.rules.push(New object("object";"12_primaryCategory";"type";"maximum-width";"value";200))

  //  //-------------------------------------
  //$Obj_constraints.rules.push(New object("object";"13_secondaryCategory";"type";"right hook"))

  //$Obj_constraints.rules.push(New object("object";"13_secondaryCategory";"type";"minimum-width";"value";100))

  //$Obj_constraints.rules.push(New object("object";"13_secondaryCategory";"type";"maximum-width";"value";200))

  //  //-------------------------------------
  //$Obj_constraints.rules.push(New object("object";"50_screenshots";"type";"width";"value";1;"reference";"viewport"))

  //$Obj_constraints.rules.push(New object("object";"50_screenshots.border";"type";"width";"value";1;"reference";"viewport"))

  //  //-------------------------------------
  //panel_SET_CONSTRAINTS ($Obj_constraints)

  //End if 

  //  //Categories
  //$Obj_resources:=JSON Parse(Document to text(Get localized document path("resources.json")))

  //If (OB Is defined($Obj_resources))

  //$Ptr_:=OBJECT Get pointer(Object named;"12_primaryCategory")

  //OB GET ARRAY($Obj_resources;"iOSCategories";$Ptr_->)

  //$Lon_x:=Find in array($Ptr_->;Form.itune.primaryCategory)

  //If ($Lon_x>0)

  //$Ptr_->:=$Lon_x

  //End if 

  //$Ptr_:=OBJECT Get pointer(Object named;"13_secondaryCategory")

  //OB GET ARRAY($Obj_resources;"iOSCategories";$Ptr_->)

  //If (OB Is defined(Form.itune;"secondaryCategory"))

  //$Lon_x:=Find in array($Ptr_->;Form.itune.secondaryCategory)

  //If ($Lon_x>0)

  //$Ptr_->:=$Lon_x

  //End if 
  //End if 
  //End if 

  //  //Screenshots
  //  //For ($Lon_i;1;Form.itune.screenshots.length)
  //  //$Pic_:=$Pic_+Form.itune.screenshots[$Lon_i-1]
  //  //End for
  //ARRAY PICTURE($tPic_;0x0000)

  //OB GET ARRAY(Form.itune;"screenshots";$tPic_)

  //For ($Lon_i;1;Size of array($tPic_);1)

  //$Pic_:=$Pic_+$tPic_{$Lon_i}

  //End for 

  //(OBJECT Get pointer(Object named;"50_screenshots"))->:=$Pic_

  //  //______________________________________________________
  //End case 

  //If ($Lon_formEvent=On Load) | ($Lon_formEvent=On Resize)

  //ui_SET_GEOMETRY 

  //End if 