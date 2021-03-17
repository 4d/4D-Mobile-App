//%attributes = {}
// Define classes & methods
UI:=New object:C1471

// ••••••••••• OBSOLETE OR NOT IN THE RIGHT PLACE •••••••••••
UI.pointer:=Formula:C1597(OBJECT Get pointer:C1124(Object named:K67:5; $1))
UI.refresh:=Formula:C1597(SET TIMER:C645(-1))

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