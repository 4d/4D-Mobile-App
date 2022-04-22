//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216(\
errors; \
errStack; \
lastError\
)

If (False:C215)
	
	//___________________________________
	C_OBJECT:C1216(err_COMBINE; $1)
	C_OBJECT:C1216(err_COMBINE; $2)
	C_LONGINT:C283(err_COMBINE; $3)
	
	//___________________________________
	C_OBJECT:C1216(err_PUSH; $1)
	C_TEXT:C284(err_PUSH; $2)
	C_LONGINT:C283(err_PUSH; $3)
	
	//___________________________________
End if 

If (False:C215)
	
	//___________________________________
	C_OBJECT:C1216(_o_err; $0)
	C_TEXT:C284(_o_err; $1)
	C_OBJECT:C1216(_o_err; $2)
	
	//___________________________________
	C_COLLECTION:C1488(err_CATCH; $1)
	
	//___________________________________
	C_BOOLEAN:C305(err_Continue; $0)
	
	//___________________________________
	C_TEXT:C284(err_FINALLY; $1)
	
	//___________________________________
	C_OBJECT:C1216(err_THROW; $1)
	
	//___________________________________
	C_TEXT:C284(err_TRY; $1)
	
	//___________________________________
End if 