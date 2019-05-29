//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : ui_isES
  // Database: 4D Mobile App
  // ID[6EFB59D3FBE54A3D86C077D7582997C8]
  // Created #27-9-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Definition of UI Classes
  // ----------------------------------------------------
  // Declarations

  // ----------------------------------------------------
  // Initialisations

  // ••••••••••• OBSOLETE OR NOT IN THE RIGHT PLACE •••••••••••
ui.pointer:=Formula:C1597(OBJECT Get pointer:C1124(Object named:K67:5;$1))
ui.enable:=Formula:C1597(OBJECT SET ENABLED:C1123(*;$1;Bool:C1537($2)))
ui.refresh:=Formula:C1597(SET TIMER:C645(-1))

  // ••••••••••••••••• NOT IN THE RIGHT PLACE •••••••••••••••••
ui.saveProject:=Formula:C1597(CALL FORM:C1391(Current form window:C827;"project_SAVE"))  // should be project.save()

  // =========================== HELP TIPS ===========================
ui.tips:=New object:C1471(\
"enabled";(Get database parameter:C643(Tips enabled:K37:79)=1);\
"delay";Get database parameter:C643(Tips delay:K37:80);\
"duration";Get database parameter:C643(Tips duration:K37:81);\
"enable";Formula:C1597(SET DATABASE PARAMETER:C642(Tips enabled:K37:79;1));\
"disable";Formula:C1597(SET DATABASE PARAMETER:C642(Tips enabled:K37:79;0));\
"instantly";Formula:C1597(SET DATABASE PARAMETER:C642(Tips delay:K37:80;1));\
"setDuration";Formula:C1597(SET DATABASE PARAMETER:C642(Tips duration:K37:81;$1));\
"defaultDelay";Formula:C1597(SET DATABASE PARAMETER:C642(Tips delay:K37:80;45));\
"defaultDuration";Formula:C1597(SET DATABASE PARAMETER:C642(Tips duration:K37:81;720))\
)

  // ============================= WINDOW =============================
ui.window:=New object:C1471(\
"reference";Current form window:C827;\
"process";Window process:C446(This:C1470.reference);\
"title";Null:C1517;\
"type";Null:C1517;\
"frontmost";Null:C1517;\
"next";Null:C1517;\
"coordinates";Null:C1517;\
"screen";Null:C1517;\
"get";Formula:C1597(ui_window );\
"isFrontmost";Formula:C1597(Frontmost window:C447=This:C1470.reference);\
"getType";Formula:C1597(Window kind:C445(This:C1470.reference));\
"getTitle";Formula:C1597(Get window title:C450(This:C1470.reference));\
"getNext";Formula:C1597(Next window:C448(This:C1470.reference));\
"getCoordinates";Formula:C1597(ui_window ("coordinates"));\
"setTitle";Formula:C1597(SET WINDOW TITLE:C213($1;This:C1470.reference))\
)

  // ============================= FORMS =============================
ui.form:=Formula:C1597(New object:C1471(\
"_is";"form";\
"callback";$1;\
"name";Current form name:C1298;\
"window";Current form window:C827;\
"event";Null:C1517;\
"currentWidget";Null:C1517;\
"focusedWidget";Null:C1517;\
"refresh";Formula:C1597(SET TIMER:C645(-1));\
"call";Formula:C1597(ui_form ("call";Choose:C955(Value type:C1509($1)=Is object:K8:27;$1;New object:C1471("parameters";$1))));\
"get";Formula:C1597(ui_form );\
"getEvent";Formula:C1597(ui_form ("event"));\
"getCurrentWidget";Formula:C1597(ui_form ("current"));\
"getFocusedWidget";Formula:C1597(ui_form ("focused"))\
))

  // Typing a checkbox dynamic as a boolean
ui.boolean:=Formula from string:C1601("C_BOOLEAN:C305((OBJECT Get pointer:C1124(Object named:K67:5;$1))->)")

  // ============================ MENU =============================
ui.menu:=Formula:C1597(New object:C1471(\
"_is";"menu";\
"ref";Create menu:C408;\
"choice";"";\
"append";Formula:C1597(ui_menu ("append";New object:C1471("item";String:C10($1);"param";String:C10($2);"mark";Bool:C1537($3))));\
"line";Formula:C1597(APPEND MENU ITEM:C411(This:C1470.ref;"-"));\
"clear";Formula:C1597(RELEASE MENU:C978(This:C1470.ref));\
"count";Formula:C1597(Count menu items:C405(This:C1470.ref));\
"disable";Formula:C1597(DISABLE MENU ITEM:C150(This:C1470.ref;Choose:C955(Count parameters:C259=1;$1;-1)));\
"delete";Formula:C1597(DELETE MENU ITEM:C413(This:C1470.ref;Choose:C955(Count parameters:C259=1;$1;-1)));\
"popup";Formula:C1597(ui_menu ("popup";New object:C1471("default";$1;"x";$2;"y";$3)))\
))

  // ============================ STATIC ============================
ui.static:=Formula:C1597(New object:C1471(\
"_is";"static";\
"name";$1;\
"coordinates";Null:C1517;\
"windowCoordinates";Null:C1517;\
"visible";Formula:C1597(OBJECT Get visible:C1075(*;This:C1470.name));\
"hide";Formula:C1597(OBJECT SET VISIBLE:C603(*;This:C1470.name;False:C215));\
"show";Formula:C1597(OBJECT SET VISIBLE:C603(*;This:C1470.name;True:C214));\
"setVisible";Formula:C1597(OBJECT SET VISIBLE:C603(*;This:C1470.name;Bool:C1537($1)));\
"title";Formula:C1597(OBJECT Get title:C1068(*;This:C1470.name));\
"setTitle";Formula:C1597(OBJECT SET TITLE:C194(*;This:C1470.name;String:C10($1)));\
"getCoordinates";Formula:C1597(ui_widget ("coordinates"));\
"bestSize";Formula:C1597(ui_widget ("alignOnBestSize";New object:C1471("alignment";$1)));\
"setCoordinates";Formula:C1597(ui_widget ("setCoordinates";New object:C1471("left";$1;"top";$2;"right";$3;"bottom";$4)))\
))

  // ============================ GROUP ============================
ui.group:=Formula:C1597(New object:C1471(\
"_is";"group";\
"name";$1;\
"visible";Formula:C1597(OBJECT Get visible:C1075(*;This:C1470.name));\
"hide";Formula:C1597(ui_widget ("hide"));\
"show";Formula:C1597(ui_widget ("show"));\
"setVisible";Formula:C1597(ui_widget ("setVisible";New object:C1471("visible";Bool:C1537($1))))\
))

  // ============================ WIDGETS ============================
ui.widget:=Formula:C1597(New object:C1471(\
"_is";"widget";\
"name";$1;\
"coordinates";Null:C1517;\
"windowCoordinates";Null:C1517;\
"visible";Formula:C1597(OBJECT Get visible:C1075(*;This:C1470.name));\
"hide";Formula:C1597(OBJECT SET VISIBLE:C603(*;This:C1470.name;False:C215));\
"show";Formula:C1597(OBJECT SET VISIBLE:C603(*;This:C1470.name;True:C214));\
"setVisible";Formula:C1597(OBJECT SET VISIBLE:C603(*;This:C1470.name;Bool:C1537($1)));\
"enabled";Formula:C1597(OBJECT Get enabled:C1079(*;This:C1470.name));\
"enable";Formula:C1597(OBJECT SET ENABLED:C1123(*;This:C1470.name;True:C214));\
"disable";Formula:C1597(OBJECT SET ENABLED:C1123(*;This:C1470.name;False:C215));\
"setEnabled";Formula:C1597(OBJECT SET ENABLED:C1123(*;This:C1470.name;Bool:C1537($1)));\
"focused";Formula:C1597(This:C1470.name=OBJECT Get name:C1087(Object with focus:K67:3));\
"focus";Formula:C1597(GOTO OBJECT:C206(*;This:C1470.name));\
"pointer";Formula:C1597(OBJECT Get pointer:C1124(Object named:K67:5;This:C1470.name));\
"value";Formula:C1597((This:C1470.pointer())->);\
"clear";Formula:C1597(CLEAR VARIABLE:C89((This:C1470.pointer())->));\
"enterable";Formula:C1597(OBJECT Get enterable:C1067(*;This:C1470.name));\
"setEnterable";Formula:C1597(OBJECT SET ENTERABLE:C238(*;This:C1470.name;Bool:C1537($1)));\
"getCoordinates";Formula:C1597(ui_widget ("coordinates"));\
"bestSize";Formula:C1597(ui_widget ("alignOnBestSize";New object:C1471("alignment";$1)));\
"setCoordinates";Formula:C1597(ui_widget ("setCoordinates";New object:C1471("left";$1;"top";$2;"right";$3;"bottom";$4)))\
))

  // ============================ BUTTONS ============================
ui.button:=Formula:C1597(New object:C1471(\
"_is";"button";\
"name";$1;\
"coordinates";Null:C1517;\
"windowCoordinates";Null:C1517;\
"visible";Formula:C1597(OBJECT Get visible:C1075(*;This:C1470.name));\
"hide";Formula:C1597(OBJECT SET VISIBLE:C603(*;This:C1470.name;False:C215));\
"show";Formula:C1597(OBJECT SET VISIBLE:C603(*;This:C1470.name;True:C214));\
"setVisible";Formula:C1597(OBJECT SET VISIBLE:C603(*;This:C1470.name;Bool:C1537($1)));\
"enabled";Formula:C1597(OBJECT Get enabled:C1079(*;This:C1470.name));\
"enable";Formula:C1597(OBJECT SET ENABLED:C1123(*;This:C1470.name;True:C214));\
"disable";Formula:C1597(OBJECT SET ENABLED:C1123(*;This:C1470.name;False:C215));\
"setEnabled";Formula:C1597(OBJECT SET ENABLED:C1123(*;This:C1470.name;Bool:C1537($1)));\
"focused";Formula:C1597(This:C1470.name=OBJECT Get name:C1087(Object with focus:K67:3));\
"focus";Formula:C1597(GOTO OBJECT:C206(*;This:C1470.name));\
"pointer";Formula:C1597(OBJECT Get pointer:C1124(Object named:K67:5;This:C1470.name));\
"value";Formula:C1597((This:C1470.pointer())->);\
"getCoordinates";Formula:C1597(ui_widget ("coordinates"));\
"bestSize";Formula:C1597(ui_widget ("alignOnBestSize";New object:C1471("alignment";$1)));\
"setCoordinates";Formula:C1597(ui_widget ("setCoordinates";New object:C1471("left";$1;"top";$2;"right";$3;"bottom";$4)));\
"title";Formula:C1597(OBJECT Get title:C1068(*;This:C1470.name));\
"setTitle";Formula:C1597(OBJECT SET TITLE:C194(*;This:C1470.name;String:C10($1)));\
"format";Formula:C1597(OBJECT Get format:C894(*;This:C1470.name));\
"setFormat";Formula:C1597(OBJECT SET FORMAT:C236(*;This:C1470.name;String:C10($1)));\
"helpTip";Formula:C1597(OBJECT Get help tip:C1182(*;This:C1470.name));\
"setHelpTip";Formula:C1597(OBJECT SET HELP TIP:C1181(*;This:C1470.name;String:C10($1)));\
"setColors";Formula:C1597(OBJECT SET RGB COLORS:C628(*;This:C1470.name;$1;$2));\
"boolean";Formula from string:C1601("C_BOOLEAN:C305((This:C1470.pointer())->")\
))

  // ========================== THERMOMETER ==========================
ui.thermometer:=Formula:C1597(New object:C1471(\
"_is";"thermometer";\
"name";$1;\
"coordinates";Null:C1517;\
"windowCoordinates";Null:C1517;\
"visible";Formula:C1597(OBJECT Get visible:C1075(*;This:C1470.name));\
"hide";Formula:C1597(OBJECT SET VISIBLE:C603(*;This:C1470.name;False:C215));\
"show";Formula:C1597(OBJECT SET VISIBLE:C603(*;This:C1470.name;True:C214));\
"setVisible";Formula:C1597(OBJECT SET VISIBLE:C603(*;This:C1470.name;Bool:C1537($1)));\
"enabled";Formula:C1597(OBJECT Get enabled:C1079(*;This:C1470.name));\
"enable";Formula:C1597(OBJECT SET ENABLED:C1123(*;This:C1470.name;True:C214));\
"disable";Formula:C1597(OBJECT SET ENABLED:C1123(*;This:C1470.name;False:C215));\
"setEnabled";Formula:C1597(OBJECT SET ENABLED:C1123(*;This:C1470.name;Bool:C1537($1)));\
"focused";Formula:C1597(This:C1470.name=OBJECT Get name:C1087(Object with focus:K67:3));\
"focus";Formula:C1597(GOTO OBJECT:C206(*;This:C1470.name));\
"pointer";Formula:C1597(OBJECT Get pointer:C1124(Object named:K67:5;This:C1470.name));\
"value";Formula:C1597((This:C1470.pointer())->);\
"getCoordinates";Formula:C1597(ui_widget ("coordinates"));\
"setCoordinates";Formula:C1597(ui_widget ("setCoordinates";New object:C1471("left";$1;"top";$2;"right";$3;"bottom";$4)));\
"enterable";Formula:C1597(OBJECT Get enterable:C1067(*;This:C1470.name));\
"setEnterable";Formula:C1597(OBJECT SET ENTERABLE:C238(*;This:C1470.name;Bool:C1537($1)));\
"indicatorType";Formula:C1597(OBJECT Get indicator type:C1247(*;This:C1470.name));\
"setIndicatorType";Formula:C1597(OBJECT SET INDICATOR TYPE:C1246(*;This:C1470.name;Num:C11($1)))\
))

  // ============================ PICTURES ============================
ui.picture:=Formula:C1597(New object:C1471(\
"_is";"picture";\
"name";$1;\
"coordinates";Null:C1517;\
"windowCoordinates";Null:C1517;\
"width";Null:C1517;\
"height";Null:C1517;\
"scroll";Null:C1517;\
"dimensions";Null:C1517;\
"visible";Formula:C1597(OBJECT Get visible:C1075(*;This:C1470.name));\
"hide";Formula:C1597(OBJECT SET VISIBLE:C603(*;This:C1470.name;False:C215));\
"show";Formula:C1597(OBJECT SET VISIBLE:C603(*;This:C1470.name;True:C214));\
"setVisible";Formula:C1597(OBJECT SET VISIBLE:C603(*;This:C1470.name;Bool:C1537($1)));\
"enabled";Formula:C1597(OBJECT Get enabled:C1079(*;This:C1470.name));\
"enable";Formula:C1597(OBJECT SET ENABLED:C1123(*;This:C1470.name;True:C214));\
"disable";Formula:C1597(OBJECT SET ENABLED:C1123(*;This:C1470.name;False:C215));\
"setEnabled";Formula:C1597(OBJECT SET ENABLED:C1123(*;This:C1470.name;Bool:C1537($1)));\
"focused";Formula:C1597(This:C1470.name=OBJECT Get name:C1087(Object with focus:K67:3));\
"focus";Formula:C1597(GOTO OBJECT:C206(*;This:C1470.name));\
"pointer";Formula:C1597(OBJECT Get pointer:C1124(Object named:K67:5;This:C1470.name));\
"value";Formula:C1597((This:C1470.pointer())->);\
"clear";Formula:C1597(CLEAR VARIABLE:C89((This:C1470.pointer())->));\
"enterable";Formula:C1597(OBJECT Get enterable:C1067(*;This:C1470.name));\
"setEnterable";Formula:C1597(OBJECT SET ENTERABLE:C238(*;This:C1470.name;Bool:C1537($1)));\
"get";Formula:C1597(ui_widget ("get"));\
"getCoordinates";Formula:C1597(ui_widget ("coordinates"));\
"setCoordinates";Formula:C1597(ui_widget ("setCoordinates";New object:C1471("left";$1;"top";$2;"right";$3;"bottom";$4)));\
"getScrollPosition";Formula:C1597(ui_widget ("scrollPosition"));\
"setScrollPosition";Formula:C1597(ui_widget ("setScrollPosition";New object:C1471("horizontal";$1;"vertical";$2)));\
"getDimensions";Formula:C1597(ui_widget ("dimensions"));\
"getAttribute";Formula:C1597(ui_widget ("getAttribute";New object:C1471("id";$1;"attribute";$2)))\
))

  // ============================ LISTBOXES ============================
ui.listbox:=Formula:C1597(New object:C1471(\
"_is";"listbox";\
"name";$1;\
"column";Null:C1517;\
"row";Null:C1517;\
"cellCoordinates";Null:C1517;\
"definition";Null:C1517;\
"columns";Null:C1517;\
"scrollbar";Null:C1517;\
"visible";Formula:C1597(OBJECT Get visible:C1075(*;This:C1470.name));\
"hide";Formula:C1597(OBJECT SET VISIBLE:C603(*;This:C1470.name;False:C215));\
"show";Formula:C1597(OBJECT SET VISIBLE:C603(*;This:C1470.name;True:C214));\
"setVisible";Formula:C1597(OBJECT SET VISIBLE:C603(*;This:C1470.name;Bool:C1537($1)));\
"enabled";Formula:C1597(OBJECT Get enabled:C1079(*;This:C1470.name));\
"enable";Formula:C1597(OBJECT SET ENABLED:C1123(*;This:C1470.name;True:C214));\
"disable";Formula:C1597(OBJECT SET ENABLED:C1123(*;This:C1470.name;False:C215));\
"setEnabled";Formula:C1597(OBJECT SET ENABLED:C1123(*;This:C1470.name;Bool:C1537($1)));\
"focused";Formula:C1597(This:C1470.name=OBJECT Get name:C1087(Object with focus:K67:3));\
"focus";Formula:C1597(GOTO OBJECT:C206(*;This:C1470.name));\
"pointer";Formula:C1597(OBJECT Get pointer:C1124(Object named:K67:5;This:C1470.name));\
"get";Formula:C1597(ui_widget ("get"));\
"getCoordinates";Formula:C1597(ui_widget ("coordinates"));\
"setCoordinates";Formula:C1597(ui_widget ("setCoordinates";New object:C1471("left";$1;"top";$2;"right";$3;"bottom";$4)));\
"getDefinition";Formula:C1597(ui_listbox );\
"getCell";Formula:C1597(ui_listbox ("cell"));\
"getCellPosition";Formula:C1597(ui_listbox ("cellPosition"));\
"getCellCoordinates";Formula:C1597(ui_listbox ("cellCoordinates"));\
"getScrollbar";Formula:C1597(ui_listbox ("scrollbar"));\
"setScrollbar";Formula:C1597(OBJECT SET SCROLLBAR:C843(*;This:C1470.name;Num:C11($1);Num:C11($2)));\
"getProperty";Formula:C1597(ui_listbox ("property";New object:C1471("property";$1)));\
"setProperty";Formula:C1597(LISTBOX SET PROPERTY:C1440(*;This:C1470.name;$1;$2));\
"rowsNumber";Formula:C1597(LISTBOX Get number of rows:C915(*;This:C1470.name));\
"deleteRow";Formula:C1597(LISTBOX DELETE ROWS:C914(*;This:C1470.name;$1;1));\
"deleteRows";Formula:C1597(LISTBOX DELETE ROWS:C914(*;This:C1470.name;$1;$2));\
"deleteAllRows";Formula:C1597(LISTBOX DELETE ROWS:C914(*;This:C1470.name;1;This:C1470.rowsNumber()));\
"selected";Formula:C1597(Count in array:C907((This:C1470.pointer())->;True:C214));\
"select";Formula:C1597(LISTBOX SELECT ROW:C912(*;This:C1470.name;Num:C11($1);lk replace selection:K53:1));\
"selectAll";Formula:C1597(LISTBOX SELECT ROW:C912(*;This:C1470.name;0;lk replace selection:K53:1));\
"deselect";Formula:C1597(LISTBOX SELECT ROW:C912(*;This:C1470.name;0;lk remove from selection:K53:3));\
"popup";Formula:C1597(ui_listbox ("popup";$1))\
))


  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End