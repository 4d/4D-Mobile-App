//%attributes = {}
var $project : cs:C1710.project
var $str : cs:C1710.str

COMPONENT_INIT

err_TRY

$project:=cs:C1710.project.new()
$str:=cs:C1710.str.new()

//mark:-.formatFieldName()
ASSERT:C1129($str.setText($project.formatFieldName("First Name")).equal("firstName"))
ASSERT:C1129($str.setText($project.formatFieldName("First_name")).equal("firstName"))
ASSERT:C1129($str.setText($project.formatFieldName("first__name")).equal("firstName"))
ASSERT:C1129($str.setText($project.formatFieldName("__firstName")).equal("firstName"))
ASSERT:C1129($str.setText($project.formatFieldName("FirstName")).equal("firstName"))
ASSERT:C1129($str.setText($project.formatFieldName("firstName")).equal("firstName"))
ASSERT:C1129($str.setText($project.formatFieldName("first name")).equal("firstName"))
ASSERT:C1129($str.setText($project.formatFieldName("first  name")).equal("firstName"))
ASSERT:C1129($str.setText($project.formatFieldName("First NAME")).equal("firstName"))
ASSERT:C1129($str.setText($project.formatFieldName("FIRST NAME")).equal("firstName"))

ASSERT:C1129($str.setText($project.formatFieldName("prénom")).equal("prenom"))

ASSERT:C1129($str.setText($project.formatFieldName("description")).equal("description_"))
ASSERT:C1129($str.setText($project.formatFieldName("DESCRIPTION")).equal("description_"))

err_FINALLY

BEEP:C151