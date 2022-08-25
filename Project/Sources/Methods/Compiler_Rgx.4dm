//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Method : Compiler_Rgx
// Created 28/09/07 by Vincent de Lachaux
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------

C_LONGINT:C283(_o_rgx_Lon_Error)

If (False:C215)  // Object
	
	// ----------------------------------------------------
	//C_OBJECT(Rgx_match; $0)
	//C_OBJECT(Rgx_match; $1)
	
	// ----------------------------------------------------
End if 

If (False:C215)
	
	// Public ----------------------------
	C_LONGINT:C283(_o_Rgx_ExtractText; $0)
	C_TEXT:C284(_o_Rgx_ExtractText; $1)
	C_TEXT:C284(_o_Rgx_ExtractText; $2)
	C_TEXT:C284(_o_Rgx_ExtractText; $3)
	C_POINTER:C301(_o_Rgx_ExtractText; $4)
	C_LONGINT:C283(_o_Rgx_ExtractText; $5)
	
	C_TEXT:C284(_o_Rgx_Get_Pattern; $0)
	C_TEXT:C284(_o_Rgx_Get_Pattern; $1)
	C_TEXT:C284(_o_Rgx_Get_Pattern; $2)
	C_POINTER:C301(_o_Rgx_Get_Pattern; $3)
	
	C_LONGINT:C283(_o_Rgx_MatchText; $0)
	C_TEXT:C284(_o_Rgx_MatchText; $1)
	C_TEXT:C284(_o_Rgx_MatchText; $2)
	C_POINTER:C301(_o_Rgx_MatchText; $3)
	C_LONGINT:C283(_o_Rgx_MatchText; $4)
	
	C_LONGINT:C283(_o_Rgx_SplitText; $0)
	C_TEXT:C284(_o_Rgx_SplitText; $1)
	C_TEXT:C284(_o_Rgx_SplitText; $2)
	C_POINTER:C301(_o_Rgx_SplitText; $3)
	C_LONGINT:C283(_o_Rgx_SplitText; $4)
	
	C_LONGINT:C283(_o_Rgx_SubstituteText; $0)
	C_TEXT:C284(_o_Rgx_SubstituteText; $1)
	C_TEXT:C284(_o_Rgx_SubstituteText; $2)
	C_POINTER:C301(_o_Rgx_SubstituteText; $3)
	C_LONGINT:C283(_o_Rgx_SubstituteText; $4)
	
	// Private ----------------------------
	C_TEXT:C284(_o_rgx_Options; $0)
	C_LONGINT:C283(_o_rgx_Options; $1)
	
End if 