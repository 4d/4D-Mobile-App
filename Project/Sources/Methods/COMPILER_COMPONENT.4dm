//%attributes = {"invisible":true}

// SYSTEM VARIABLES
C_OBJECT:C1216(SHARED)// Common values
C_OBJECT:C1216(ui)// UI constants

C_OBJECT:C1216(feature)// Feature flags

C_OBJECT:C1216(RECORD)// General journal

C_OBJECT:C1216(_o_project)

C_OBJECT:C1216(project)

// INITIALIZATION
COMPONENT_INIT

// Editor
COMPILER_editor
COMPILER_project

// Panels
COMPILER_ORGANIZATION
COMPILER_PRODUCT
COMPILER_DEVELOPER

COMPILER_STRUCTURES

COMPILER_tables
COMPILER_fields

COMPILER_views

// Language
COMPILER_ob
COMPILER_col

// Widgets
COMPILER_message
COMPILER_search

// Tools
COMPILER_backend
COMPILER_ob_error
COMPILER_macOS
COMPILER_mobile

If (False:C215)
	
	// ----------------------------------------------------
	C_OBJECT:C1216(path;$0)
	C_TEXT:C284(path;$1)
	C_OBJECT:C1216(path;$2)
	
	// ----------------------------------------------------
	C_OBJECT:C1216(BUILD;$1)
	
	// ----------------------------------------------------
End if 

If (False:C215)
	
	// ----------------------------------------------------
	C_TEXT:C284(COMPONENT_Infos;$0)
	C_TEXT:C284(COMPONENT_Infos;$1)
	
	// ----------------------------------------------------
	C_OBJECT:C1216(COMPONENT_Pathname;$0)
	C_TEXT:C284(COMPONENT_Pathname;$1)
	
	// ----------------------------------------------------
End if 

If (False:C215)
	
	// ----------------------------------------------------
	C_LONGINT:C283(FEATURE_FLAGS;$1)
	C_OBJECT:C1216(FEATURE_FLAGS;$2)
	
	// ----------------------------------------------------
End if 