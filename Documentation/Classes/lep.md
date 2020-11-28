<!-- Type your summary here -->
## [l]AUNCH [e]XTERNAL [p]ROCESS

The `lep` class is designed to manage external process tasks performed with the 4D command [LAUNCH EXTERNAL PROCESS](https://doc.4d.com/4Dv18/4D/18/LAUNCH-EXTERNAL-PROCESS.301-4504924.en.html).

## Summary

|Properties|Type|Description|Initial value|
|---------|:----:|------|:------:|
|**.command**|Text|The last launched command line|**Null**|
|**.inputStream**|Text|Input stream (stdin)|**Null**|
|**.outputStream**|Text|Output stream (stdout)\*|**Null**|
|**.errorStream**|Text|Error stream (stderr)\*|**Null**|
|**.pid**|Integer|Unique identifier for external process\*|**0**|
|**.charSet**|Text|The charset used to convert the outputStream|**"UTF-8"**|
|**.outputType**|Integer|The type into which the outputStream value will be converted\*\*|**2**|
|**.environmentVariables**|Collection|The table of environment variables that will be used for each next .launch() call.|cf. *infra*|
|**.success**|Integer|The status of the last launched command|**Null**|
|**.errors**|Collection|The stack of errors encountered since the initialization of the class or the last `.reset()` call|**Null**|

\* These values are reset before each execution

\** Uses 4D constants [Field & variable types](https://doc.4d.com/4Dv18/4D/18/Field-and-Variable-Types.302-4504399.en.html) values: _Is text_, _Is object_, _Is boolean_, _Is longint_, _Is integer_, _Is real_, _Is BLOB_, _Is collection_ 


|Function\*|Action|If no parameter|
|--------|------|:-------------:|   
|.**asynchronous** ( {mode : `Boolean`} )  → `cs.lep` | Sets each next external process to be launched synchronously | **True**
|.**escape** ( string : `Text`)  → escaped : `Text` | Returns a string where the characters ``\ !"#$%&'()=~\|<>?;*`[]`` are escaped |
|.**getEnvironnementVariables** ()  → variables : `Object` | Returns an object containing all the environment variables | 
|.**getEnvironnementVariable** ( name : `Text` {; nonDiacritic : `Boolean`} )  → value : Text | Returns the value of an environment variable | 
|.**launch** ( script : `4D.File` \| command : `Text` {; arguments : `Text`} )  → `cs.lep` | launches an external process |
|.**reset** ()  → `cs.lep` | To restore the properties of the class to their default values |
|.**setCharSet** ( {charset : `Text`} )  → `cs.lep` | Sets the charset used to convert the outputStream | "utf-8" |
|.**setDirectory** ( folder : `4D.Folder` )  → `cs.lep` | Sets the current directory of the next external process to be launched | (none)
|.**setEnvironnementVariable** ( {variables: `Collection` \| `Object`} \| {name: `text` ; value: `text`} )  →  `cs.lep` | Returns an object containing all the environment variables | Reset to default values
|.**setOutputType** ( {outputType : `Integer`} )  → `cs.lep` | Sets the type of the outputStream | _Is text_
|.**singleQuoted** ( string : `Text` )  → quoted : Text | Enclose, if necessary, the string in single quotation marks |
|.**synchronous** ( {mode : `Boolean`} )  → `cs.lep` | Sets each next external process to be launched synchronously | **True**
|.**unlock**( cible : `4D.Folder` )  → `cs.lep` | Sets write access to a directory with all its subfolders and files 
|.**writable**( cible : `4D.Document` )  → `cs.lep` | Sets write access to a file or a directory with all its subfolders and files
 
\* All functions that return `cs.lep` may include one call after another.

## 🔸 cs.lep.new()

The class constructor `cs.lep.new()` creates a new class instance.
The 4D specific environment variables are defined with the following default values:

	"_4D_OPTION_CURRENT_DIRECTORY" = ""
	"_4D_OPTION_HIDE_CONSOLE" = "true"	"_4D_OPTION_BLOCKING_EXTERNAL_PROCESS" = "true"

## 🔹 .launch()

.**launch** ( script : **4D**.File {; arguments} )  → `cs.lep`   
.**launch** ( command : Text {; arguments} )  → `cs.lep`

The `.launch()` function launches an external process

* `script` is a File object, the `command` property will be set as the POSIX path of the file.    
The path is automatically escaped, if any.   
The file must contain a script and be defined as executable.

* `command` should be the text of the command to execute or a shortcut.   

The managed shortucts are:   

		"shell" for "/bin/sh"    
		"bat" for "cmd.exe /C start /B"

* The optional `arguments` parameter is the string to be added to the command.         
If any, the arguments are automatically escaped and a space will be automatically added between the command and the arguments.

    
> 📌 All the environmental variables contained in the `environmentVariables` property will be defined before execution.    
  
>📌 If the property `inputStream` is not null, it will be used as the *stdin* of the command.

✅ If the command is executed successfuly:
	
* `.success` is **True**.  
* `.outputStream` contains the *stdout* of the execution converted, if any, according to the `outputType` property.
* `.pid` is populated with the system level ID for the process created.
* `.errorStream` is **Null**

❌ If the command fails:

* `.success` is **False**.  
* `.outputStream` is **Null**.
* `.pid` is 0.
* `.errorStream` contains the *stderr* of the execution
* The *stderr* is added to the `.errors` collection

## 🔹 .setEnvironnementVariable()

.**setEnvironnementVariable** ( variables : `Object` | `Collection` )  →  `cs.lep`        
.**setEnvironnementVariable** ( name: `text` {; value: `text`} )  →  `cs.lep`

* If the first parameter is an object, an environment variable will be created with the name of each property and will have the value of the associated one.
* If the first parameter is a collection, it should be a collection of paired name/value objects
* If the first parameter is a text, it must be the name of the environment variable to be defined and possibly a second parameter for the value. If no value is given, the content of the variable is set to the empty string.
  
> 📌 The name of the variable accept shortcuts for the 4D specific environment variables:   
> - "*directory*" or "*currentDirectory*" for "*\_4D\_OPTION\_CURRENT\_DIRECTORY*"    
> - "*asynchronous*" or "*non-blocking*" for "*\_4D\_OPTION\_BLOCKING\_EXTERNAL\_PROCESS*"    
> - "*console*" or "*hideConsole*" for "*\_4D\_OPTION\_HIDE\_CONSOLE*"
    
> 📌 For the 4D specific environment variables, if the value is not passed, the value is reset to the empty string or "false" according to the variable type. 

## 🔹 .reset()
The `.reset()` function reinitializes all the properties of the class to their default values. The error stack is thus emptied. 4D-specific environment variables are also reinitialized and user environment variables are forgotten. 