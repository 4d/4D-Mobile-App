//%attributes = {}
var $formatted; $string : Text
var $project : cs:C1710.project
var $str : cs:C1710.str

COMPONENT_INIT

err_TRY

$project:=cs:C1710.project.new()
$str:=cs:C1710.str.new()

//mark:-.formatFieldName()
$string:="First Name"
$formatted:=$project.formatFieldName($string)
ASSERT:C1129($str.setText($formatted).equal("firstName"))
ASSERT:C1129($str.equal(formatString("field-name"; $string)))

$string:="first_name"
$formatted:=$project.formatFieldName($string)
ASSERT:C1129($str.setText($formatted).equal("first_name"))
ASSERT:C1129($str.equal(formatString("field-name"; $string)))

$string:="first__name"
$formatted:=$project.formatFieldName($string)
ASSERT:C1129($str.setText($formatted).equal("first__name"))
ASSERT:C1129($str.equal(formatString("field-name"; $string)))

$string:="__firstName"
$formatted:=$project.formatFieldName($string)
ASSERT:C1129($str.setText($formatted).equal("firstName"))
ASSERT:C1129($str.equal(formatString("field-name"; $string)))

$string:="FirstName"
$formatted:=$project.formatFieldName($string)
ASSERT:C1129($str.setText($formatted).equal("firstName"))
ASSERT:C1129($str.equal(formatString("field-name"; $string)))

$string:="firstName"
$formatted:=$project.formatFieldName($string)
ASSERT:C1129($str.setText($formatted).equal("firstName"))
ASSERT:C1129($str.equal(formatString("field-name"; $string)))

$string:="first name"
$formatted:=$project.formatFieldName($string)
ASSERT:C1129($str.setText($formatted).equal("firstName"))
ASSERT:C1129($str.equal(formatString("field-name"; $string)))

$string:="first  name"
$formatted:=$project.formatFieldName($string)
ASSERT:C1129($str.setText($formatted).equal("firstName"))
ASSERT:C1129($str.equal(formatString("field-name"; $string)))

$string:="First NAME"
$formatted:=$project.formatFieldName($string)
ASSERT:C1129($str.setText($formatted).equal("firstNAME"))
ASSERT:C1129($str.equal(formatString("field-name"; $string)))

$string:="FIRST NAME"
$formatted:=$project.formatFieldName($string)
ASSERT:C1129($str.setText($formatted).equal("fIRSTNAME"))
ASSERT:C1129($str.equal(formatString("field-name"; $string)))

$string:="prénom"
$formatted:=$project.formatFieldName($string)
ASSERT:C1129($str.setText($formatted).equal("prenom"))
ASSERT:C1129($str.equal(formatString("field-name"; $string)))

$string:="description"
$formatted:=$project.formatFieldName($string)
ASSERT:C1129($str.setText($formatted).equal("description_"))
ASSERT:C1129($str.equal(formatString("field-name"; $string)))

$string:="DESCRIPTION"
$formatted:=$project.formatFieldName($string)
ASSERT:C1129($str.setText($formatted).equal("dESCRIPTION_"))
ASSERT:C1129($str.equal(formatString("field-name"; $string)))

$string:="JSON_test"
$formatted:=$project.formatFieldName($string)
ASSERT:C1129($str.setText($formatted).equal("jSON_test"))
ASSERT:C1129($str.equal(formatString("field-name"; $string)))

//mark:-.formatTableName()
$string:="ALL_TYPES"
$formatted:=$project.formatTableName($string)
ASSERT:C1129($str.setText($formatted).equal("ALL_TYPES"))
ASSERT:C1129($str.equal(formatString("table-name"; $string)))

$string:="とてもとても長いフィールド"
$formatted:=$project.formatTableName($string)
ASSERT:C1129($str.setText($formatted).equal("とてもとても長いフィールド"))
ASSERT:C1129($str.equal(formatString("table-name"; $string)))

$string:="__DeletedRecords"
$formatted:=$project.formatTableName($string)
ASSERT:C1129($str.setText($formatted).equal("DeletedRecords"))
ASSERT:C1129($str.equal(formatString("table-name"; $string)))

$string:="__deletedRecords"
$formatted:=$project.formatTableName($string)
ASSERT:C1129($str.setText($formatted).equal("DeletedRecords"))
ASSERT:C1129($str.equal(formatString("table-name"; $string)))

$string:="Only primary key"
$formatted:=$project.formatTableName($string)
ASSERT:C1129($str.setText($formatted).equal("OnlyPrimaryKey"))
ASSERT:C1129($str.equal(formatString("table-name"; $string)))

$string:="Table_1"
$formatted:=$project.formatTableName($string)
ASSERT:C1129($str.setText($formatted).equal("Table_1"))
ASSERT:C1129($str.equal(formatString("table-name"; $string)))

$string:="Table 1"
$formatted:=$project.formatTableName($string)
ASSERT:C1129($str.setText($formatted).equal("Table1"))
ASSERT:C1129($str.equal(formatString("table-name"; $string)))

$string:="table 1"
$formatted:=$project.formatTableName($string)
ASSERT:C1129($str.setText($formatted).equal("Table1"))
ASSERT:C1129($str.equal(formatString("table-name"; $string)))

$string:="table 1_2"
$formatted:=$project.formatTableName($string)
ASSERT:C1129($str.setText($formatted).equal("Table1_2"))
ASSERT:C1129($str.equal(formatString("table-name"; $string)))

$string:="EmployesOffices"
$formatted:=$project.formatTableName($string)
ASSERT:C1129($str.setText($formatted).equal("EmployesOffices"))
ASSERT:C1129($str.equal(formatString("table-name"; $string)))

$string:="NO PRIMARY KEY"
$formatted:=$project.formatTableName($string)
ASSERT:C1129($str.setText($formatted).equal("NOPRIMARYKEY"))
ASSERT:C1129($str.equal(formatString("table-name"; $string)))

$string:="no primary key"
$formatted:=$project.formatTableName($string)
ASSERT:C1129($str.setText($formatted).equal("NoPrimaryKey"))
ASSERT:C1129($str.equal(formatString("table-name"; $string)))

err_FINALLY

BEEP:C151