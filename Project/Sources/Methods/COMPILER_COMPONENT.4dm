//%attributes = {"invisible":true,"preemptive":"capable"}

// SYSTEM VARIABLES
var Logger : cs:C1710.logger  // General journal
var Env : cs:C1710.env  // System environment

var Feature : cs:C1710.feature  // Feature flags

var SHARED : Object  // Common values
var _o_UI : Object  // UI constants

var PROJECT : cs:C1710.project
var DATABASE : cs:C1710.database

var UI : cs:C1710.EDITOR

If (False:C215)
	
	// ----------------------------------------------------
	C_TEXT:C284(COMPONENT_Infos; $0)
	C_TEXT:C284(COMPONENT_Infos; $1)
	
	// ----------------------------------------------------
	C_LONGINT:C283(FEATURE_FLAGS; $1)
	C_OBJECT:C1216(FEATURE_FLAGS; $2)
	
	// ----------------------------------------------------
End if 

// INITIALIZATION
COMPONENT_INIT

// Editor
//COMPILER_editor
//COMPILER_project

// Panels
//COMPILER_STRUCTURES

//COMPILER_tables
//COMPILER_fields

//COMPILER_views

// Language
//COMPILER_ob
//COMPILER_col
//COMPILER_let

// Widgets
//COMPILER_message
//COMPILER_search

// Tools
//COMPILER_backend
//COMPILER_ob_error
//COMPILER_macOS
//COMPILER_mobile

//COMPILER_err



