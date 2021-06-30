//%attributes = {}
// Define classes & methods
_o_UI:=New object:C1471

// =========================== HELP TIPS ===========================
_o_UI.tips:=tips()

// ============================= FORMS =============================
_o_UI.form:=Formula:C1597(currentForm($1))

// ============================= WIDGETS =============================
_o_UI.static:=Formula:C1597(static($1))

_o_UI.group:=Formula:C1597(group($1))

_o_UI.button:=Formula:C1597(button($1))

_o_UI.widget:=Formula:C1597(widget($1))

_o_UI.listbox:=Formula:C1597(listbox($1))

_o_UI.picture:=Formula:C1597(picture($1))

_o_UI.thermometer:=Formula:C1597(thermometer($1))