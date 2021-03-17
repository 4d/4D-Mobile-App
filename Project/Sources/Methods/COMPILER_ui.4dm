//%attributes = {"invisible":true}

If (False:C215)
	
	//______________________________________________________
	C_LONGINT:C283(ui_ALIGN_ON_BEST_SIZE; $1)
	C_TEXT:C284(ui_ALIGN_ON_BEST_SIZE; $2)
	C_TEXT:C284(ui_ALIGN_ON_BEST_SIZE; ${3})
	
	//______________________________________________________
	C_OBJECT:C1216(_o_ui_BEST_SIZE; $1)
	
	//______________________________________________________
	C_TEXT:C284(ui_MOVE; $1)
	C_TEXT:C284(ui_MOVE; $2)
	C_LONGINT:C283(ui_MOVE; $3)
	C_LONGINT:C283(ui_MOVE; $4)
	
	//______________________________________________________
	C_TEXT:C284(ui_SET_ENABLED; $1)
	C_BOOLEAN:C305(ui_SET_ENABLED; $2)
	
	//______________________________________________________
	C_OBJECT:C1216(ui_SET_GEOMETRY; $1)
	
	//______________________________________________________
	C_OBJECT:C1216(ui_TOOLBAR_ALIGN; $1)
	
	//______________________________________________________
	//C_OBJECT(ui_colorScheme; $0)
	
	//______________________________________________________
End if 