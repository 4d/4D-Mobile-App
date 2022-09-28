<!-- Type your summary here -->
# feature

This class is dedicated to managing the activation/deactivation of features in 4D code.

## Definitions

* **version** `integer` is the version number expressed as 4D does (for example 1980 for 19R8 or 1904 for 19.4).
* **feature** `Text` is the name of the flag (you can also use an `Integer` to reference a redmine or azure feature number)

## 🔸 Constructor

> **cs**.feature.new (version : `Integer` {; file : `4D.File`})

* The class constructor must be called with at least a `version` parameter who is the current branch version number.

```4dvar Feature : cs.FeatureFeature:=cs.Feature.new(1980)```

* The second optional parameter is a `file` that contains local directives to enable/disable one or more features for development or testing purposes.

```4d
var Feature : cs.FeatureFeature:=cs.Feature.new(1980; Folder(fk user preferences folder).file("4d.mobile"))
```

## <a name="define">Defining a feature flag</a>

|Function|Action|
|--------|------|   
|.**unstable** ( `feature` ) | Store a feature as unstable
|.**delivered** ( `feature` ; `version` ) | Store a feature as delivered for the given version
|.**debug** ( `feature` ) | Store a feature as debug (only available in dev mode)
|.**wip** ( `feature` ) | Alias of **debug**
|.**main** ( `feature` ) | Store a feature as only available in main branch
|.**pending** ( `feature` ) | Store a feature as pending (not available)
|.**dev** ( `feature` ; user : `Text` \| `Collection` ) | Store a feature as only available for a particular sytem user
|.**alias** ( name : `Text` ; `feature` ) | Store an alias name for a feature

## <a name="testing">Testing a feature flag</a>

|Function|Action|
|--------|------|   
|.**with** ( `feature` ) | Return True if the feature is activated
|.**enabled** ( `feature` ) | Alias of **with**
|.**disabled** ( `feature` ) | Returns True if the feature is NOT activated

## <a name="tools">Tools</a>

|Function|Action|
|--------|------|   
|.**loadLocal** () | Override features activation with local preferences, if any. [cf. below](#localPreferences)
|.**log** ( logger : `4D.Function`) | Logs the status (enabled/disabled) of all declared features<br>using the database logging system passed as a formula.

## <a name="localPreferences">Format of the local preferences file</a>

The preference file is a JSON file to allow to force the activation or inactivation of a feature or to activate it under certain conditions.

* To enable feature:

```json
{"theFeature":True}
```

* To disable a feature:

```json
{"theFeature":False}
```

* To enable a feature under certain condition
 
|key|Value|Action|
|--------|------|------|   
| **os** | 1 = Windows, 2 = macOS | Activation only on the designated OS
| **matrix** | Regardless of value | Activation if the code is executed into the matrix database of a component
| **debug** | True \| False | The feature is activated in interpreted mode if **True**, in Compiled mode if **False** 
| **bitness** | 32 \| 64 | The feature is activated if 32 or 64bit version 
| **version** | `version` | The feature is enabled if the current 4D version is ≥ `version`
| **type** | `Integer` | The feature is enabled if the Application type = the value

You can define more than one key for a feature:

```json
{
  "theFeature": {
    "version": 1520,
    "bitness": 64,
    "os": 2
  }
}
```
*In this case, the fearure "theFeature" will be activated if the 4D version is 15R2 or more only on macOS and in 64-bit*

## Examples

### Declaration des flags

```4d
Feature:=cs.Feature.new(1980; Folder(fk user preferences folder).file("4d.mobile"))

// Mark:R6Feature.delivered("alias"; 1960)  // [MOBILE] Use aliasesFeature.delivered("androidDataSet"; 1960)  // [ANDROID] Data set

// Mark:R7
Feature.unstable("openURLAction")  // azure:3625 [MOBILE] Execute an action that open web area

// Mark:-🚧 MAINFeature.main("inputControlArchive")  // azure:5424 The mobile project shall support a zip format for input control with Android and iOS.

// Mark:-🚧 WIP
Feature.wip("DataSourceClass")  // Work with DataSource class class to test the data source

// Mark:-👴🏻 VincentFeature.dev("vdl"; $New collection("vdelachaux"; "Vincent de LACHAUX"))

// Mark:-⛔ PENDINGFeature.pending(129953)  // [MOBILE] Handle Many-one-Many relations

// Mark:-→ Local preferencesFeature.loadLocal()

// Mark:-→ AliasFeature.alias("many-one-many"; 129953)
```

### Usage in the code

```4d
Function showFormatOnDisk		If (Feature.with("inputControlArchive"))  //🚧				var $format : Text		var $item : Object		var $file : 4D.File		var $folder : 4D.Folder				$format:=Delete string(This.current.format; 1; 1)		$folder:=This.path.hostInputControls()				For each ($item; $folder.folders().combine($folder.files().query("extension = :1"; SHARED.archiveExtension)))						$folder:=This._source($item)			$file:=$folder.file("manifest.json")						If ($file.exists)								If (JSON Parse($file.getText()).name=$format)										SHOW ON DISK($item.platformPath)					break									End if 			End if 		End for each 			Else 				SHOW ON DISK(This.sourceFolder(Delete string(This.current.format; 1; 1)).platformPath)			End if
```

