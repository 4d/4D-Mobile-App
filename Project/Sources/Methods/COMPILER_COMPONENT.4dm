//%attributes = {"invisible":true,"preemptive":"capable"}

// Mark:-System variables
var Motor : cs:C1710.motor
var Database : cs:C1710.database
var Logger : cs:C1710.logger
var Component : cs:C1710.component

var Feature : cs:C1710.Feature  // Feature flags

var SHARED : Object  // Common values

var PROJECT : cs:C1710.project

var UI : cs:C1710.EDITOR

// Mark:-OBSOLETES
var _o_UI : Object  // UI constants

If (False:C215)
	
	// ----------------------------------------------------
	C_LONGINT:C283(FEATURE_FLAGS; $1)
	C_OBJECT:C1216(FEATURE_FLAGS; $2)
	
	// ----------------------------------------------------
End if 

// Mark:-Initialization
COMPONENT_INIT
