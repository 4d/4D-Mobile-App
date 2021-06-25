//%attributes = {"invisible":true}

// SYSTEM VARIABLES
var SHARED : Object  // Common values
var UI : Object  // UI constants

var FEATURE : Object  // Feature flags

var RECORD : Object  // General journal

var PROJECT : cs:C1710.project
var DATABASE : cs:C1710.database
var ENV : cs:C1710.env

var EDITOR : cs:C1710.EDITOR

// INITIALIZATION
COMPONENT_INIT

// Editor
COMPILER_editor
COMPILER_project

// Panels
COMPILER_PRODUCT
COMPILER_DEVELOPER

COMPILER_STRUCTURES

COMPILER_tables
COMPILER_fields

COMPILER_views

// Language
COMPILER_ob
COMPILER_col
COMPILER_let

// Widgets
COMPILER_message
COMPILER_search

// Tools
COMPILER_backend
COMPILER_ob_error
COMPILER_macOS
COMPILER_mobile

COMPILER_err

If (False:C215)
	
	// ----------------------------------------------------
	C_OBJECT:C1216(BUILD; $1)
	
	// ----------------------------------------------------
End if 

If (False:C215)
	
	// ----------------------------------------------------
	C_TEXT:C284(COMPONENT_Infos; $0)
	C_TEXT:C284(COMPONENT_Infos; $1)
	
	// ----------------------------------------------------
	C_OBJECT:C1216(COMPONENT_Pathname; $0)
	C_TEXT:C284(COMPONENT_Pathname; $1)
	
	// ----------------------------------------------------
End if 

If (False:C215)
	
	// ----------------------------------------------------
	C_LONGINT:C283(FEATURE_FLAGS; $1)
	C_OBJECT:C1216(FEATURE_FLAGS; $2)
	
	// ----------------------------------------------------
End if 