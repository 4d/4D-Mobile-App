//%attributes = {"invisible":true}
If (False:C215)
	
	// ----------------------------------------------------
	C_OBJECT:C1216(DO_MESSAGE; $1)
	
	// ----------------------------------------------------
	C_OBJECT:C1216(POST_MESSAGE; $1)
	
	// ----------------------------------------------------
	C_OBJECT:C1216(WAIT_MESSAGE; $1)
	
	// ----------------------------------------------------
	C_OBJECT:C1216(await_MESSAGE; $0)  // Signal response
	C_OBJECT:C1216(await_MESSAGE; $1)  // Parameters as an object
	C_TEXT:C284(await_MESSAGE; $2)  // ID {optional}
	
	// ----------------------------------------------------
End if 