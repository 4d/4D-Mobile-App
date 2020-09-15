//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : ui_CLASSES
// ID[6EFB59D3FBE54A3D86C077D7582997C8]
// Created 27-9-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Definition of UI Classes
// ----------------------------------------------------

// ••••••••••• OBSOLETE OR NOT IN THE RIGHT PLACE •••••••••••
UI.pointer:=Formula:C1597(OBJECT Get pointer:C1124(Object named:K67:5; $1))
UI.refresh:=Formula:C1597(SET TIMER:C645(-1))

// ••••••••••••••••• NOT IN THE RIGHT PLACE •••••••••••••••••
UI.saveProject:=Formula:C1597(CALL FORM:C1391(Current form window:C827; "project_SAVE"))  // should be project.save()

// =========================== HELP TIPS ===========================
UI.tips:=tips()

// ============================= FORMS =============================
UI.form:=Formula:C1597(currentForm($1))

// ============================= WIDGETS =============================
UI.static:=Formula:C1597(static($1))

UI.group:=Formula:C1597(group($1))

UI.button:=Formula:C1597(button($1))

UI.widget:=Formula:C1597(widget($1))

UI.listbox:=Formula:C1597(listbox($1))

UI.picture:=Formula:C1597(picture($1))

UI.thermometer:=Formula:C1597(thermometer($1))
