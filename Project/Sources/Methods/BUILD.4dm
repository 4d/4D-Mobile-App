//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : BUILD
// ID[0E60C5F1D0B948B0BE313B5059F35010]
// Created 27-4-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Display the message immediately to be more responsive
// The real build process will autostart at the message is posted
// ----------------------------------------------------
// Declarations
#DECLARE($data : Object)

// ----------------------------------------------------
// * STOP REENTRANCE
UI.build:=True:C214

UI.postMessage(New object:C1471(\
"action"; "show"; \
"type"; "progress"; \
"title"; Get localized string:C991("product")+" - "+PROJECT.product.name+" ["+Choose:C955(PROJECT._buildTarget="android"; "Android"; "iOS")+"]"; \
"additional"; Get localized string:C991("preparations"); \
"autostart"; Formula:C1597(CALL FORM:C1391(UI.window; Formula:C1597(project_BUILD).source; $data))))