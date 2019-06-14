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

  // ============================= WIDGETS =============================
ui.static:=Formula:C1597(static ($1))

ui.group:=Formula:C1597(group ($1))

ui.button:=Formula:C1597(button ($1))

ui.widget:=Formula:C1597(widget ($1))

ui.listbox:=Formula:C1597(listbox ($1))

ui.picture:=Formula:C1597(picture ($1))

ui.thermometer:=Formula:C1597(thermometer ($1))

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End
