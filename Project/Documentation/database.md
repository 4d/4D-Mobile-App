# database

This class allow to get in one time all permanent informations about the current host database and give some usual methods.

## Syntax

`$database [object] := database ()`

## Properties

 Properties     | Contains       | Comments 
:------------   |:-------------  |:------------- 
*structure*     | [object]       |The structure file (null in remote mode)
*data*          | [object]       |The data file (null in remote mode)
*root*          | [object]       |The package folder (null in remote mode)
*isCompiled*    | [boolean]      |True if database is executed in compiled
*isInterpreted* | [boolean]      |True if database is executed in interperted
*locked*        | [boolean]      |True if the data is locked
*isDatabase*    | [boolean]      |True if the structure file is a binary file (database mode)
*isProject*     | [boolean]      |True if the structure file is a project file (project mode)
*isMatrix*      | [boolean]      |True if the structure file is the current database (component matrix database)
*isRemote*      | [boolean]      |True if the database is open in remote mode
*parameter*     | [object]<br/>[collection]<br/>[text] |The value of the user parameter given when opening the database
*components*    | [collection]   |The available components list
*plugins*       | [collection]   |The available plugins list

## Member methods

 Methods                       | Actions
 :-------------                |:-------------
`enableDebugLog()`             |Enable the debug log recording
`disableDebugLog()`            |Disable the debug log recording
`method("name")`               |Return True if the method is available
`componentAvailable("name")`   |Return True if the component is loaded
`pluginAvailable("name")`      |Return True if the plugin is loaded
`clearCompiledCode()`          |Clear the compiled code (in project mode)


