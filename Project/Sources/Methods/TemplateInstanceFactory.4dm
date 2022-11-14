//%attributes = {}


C_OBJECT:C1216($0; $instance)
C_OBJECT:C1216($1; $input)
$input:=$1

// OPTI to optimise create a map(ie. object) of formula one time
C_TEXT:C284($type)
$type:=String:C10($input.template.type)
Case of 
	: ($type="main")
		$instance:=cs:C1710.MainTemplate.new($input)
	: ($type="ls")
		$instance:=cs:C1710.LaunchScreenTemplate.new($input)
	: ($type="choice")
		$instance:=cs:C1710.ChoiceTemplate.new($input)
	: ($type="folder")
		$instance:=cs:C1710.FolderTemplate.new($input)
	: ($type="navigation")
		$instance:=cs:C1710.NavigationTemplate.new($input)
	: ($type="detailform")
		$instance:=cs:C1710.DetailFormTemplate.new($input)
	: ($type="listform")
		$instance:=cs:C1710.ListFormTemplate.new($input)
	: ($type="tablesForms")
		$instance:=cs:C1710.TablesFormsTemplate.new($input)
	: ($type="actionsmenuform")
		$instance:=cs:C1710.ActionsMenuFormTemplate.new($input)
	: ($type="login")
		$instance:=cs:C1710.LoginTemplate.new($input)
	Else 
		// check if you need a special instance by settings type (no type currently: name = settings, pushnotif, ...)
		$instance:=cs:C1710.Template.new($input)
End case 

$0:=$instance