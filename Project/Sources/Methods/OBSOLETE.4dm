//%attributes = {}
// Define classes & methods
_o_UI:=New object:C1471

// =========================== HELP TIPS ===========================
//_o_UI.tips:=_o_tips

// ============================= FORMS =============================
_o_UI.form:=Formula:C1597(_o_currentForm($1))

// ============================= WIDGETS =============================
_o_UI.static:=Formula:C1597(_o_static($1))

//_o_UI.group:=Formula(group($1))

_o_UI.button:=Formula:C1597(_o_button($1))

_o_UI.widget:=Formula:C1597(_o_widget($1))

_o_UI.listbox:=Formula:C1597(_o_listbox($1))

_o_UI.picture:=Formula:C1597(_o_picture($1))

_o_UI.thermometer:=Formula:C1597(_o_thermometer($1))