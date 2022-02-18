
//EDITOR.doCancelableProgress(New object("title"; "dataSetGeneration"; "cancelMessage"; "Z'ETES CERTAINS?"))

var $o : Object
$o:=New object:C1471(\
"action"; "show"; \
"type"; "confirm"; \
"title"; "someStructuralAdjustmentsAreNeeded"; \
"additional"; cs:C1710.tools.new().localized("doYouAllow4dToModifyStructure"); \
"ok"; "allow"; \
"option"; New object:C1471("title"; "rememberMyChoice"; "value"; False:C215); \
"target"; Current form window:C827)

POST_MESSAGE($o)