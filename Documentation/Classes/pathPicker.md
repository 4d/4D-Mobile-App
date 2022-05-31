# pathPicker
The pathPicker widget is attented to display and select a file or folder path

## Installation

The complete pathPicker form, code and ressources are:

* A form nammed `PATH PICKER`
* A method `PATH_PICKER` (form method)
* A class `pathPicker`
* This documentation file `Documentation/Classes/pathPicker.md`
* A `Resources/pathPicker` folder for the medias
* A `pathPicker.xlf` file for each of the 7 managed languages:

	* `cs.lproj`
	* `de.lproj`
	* `en.lproj`
	* `es.lproj`
	* `fr.lproj`
	* `ja.lproj`
	* `pt.lproj`

## cs.pathPicker.new()

> **cs**.pathPicker.new() : cs.pathPicker    
> **cs**.pathPicker.new( target : `File` | `Folder` | `Text` ) : cs.pathPicker    
> **cs**.pathPicker.new( target : `File` | `Folder` | `Text` ; options : `Object`) : cs.pathPicker

The class constructor cs.pathPicker.new() creates a new class instance.

The optional `target` parameter could be a `File`, a `Folder`, a `Platform path` or a `POSIX path` of the target. 

> If the `target` parameter is omitted or if it is an empty string, the widget will displays the placeholder if it exists.

The optional `options` parameter is an object where you can set all the properties of the widget at once:

```4d
myPicker:=cs.pathPicker.new(""; New object(\	"fileTypes"; ".jpg"; \	"directory"; 8858; \	"copyPath"; False; \	"openItem"; True; \	"message"; "Select a picture"; \	"placeHolder"; "Select a picture…"))
```
> If `options` parameter is omitted the default options will be used

## .type
.type : `Integer` - default _`Is a document`_

The `.type` property is the type of the target which can be a folder or a file. 

The accepted values are the 4D constants _`Is a document`_ or _`Is a folder`_. 

## .target
.type : `4D.File` | `4D.Folder`| `Text` - default `Null`

The `.target` property is the targeted File or folder. If the target property is assigned as text, it can be a platform path name or a POSIX path.

Assignement can use :
>A 4D.File

```4d
myPicker.target := File(User settings file) 
```
>A 4D.Folder

```4d
myPicker.target := Folder(fk resources folder) 
```
> A Platform path

```4d
myPicker.target := Structure file
```
> • *Windows*

```4d
myPicker.target := "C:/Users/franc/OneDrive/Bureau/test.apk" 
```
> • *macOS*

```4d
myPicker.target := "Macintosh HD:Users:vdl:Desktop:class diagram.md"
```
>A POSIX path

```4d
myPicker.target := "/Users/vdl/Library/Application Support/4D/4D Mobile App/preferences.4DPreferences"
```

In any case, when read back the `.target` property, the return is a `4D.File` or a `4D.Folder`:

```4d
var $file:4D.File
$file := myPicker.target
```
```4d
var $folder:4D.Folder
$folder := myPicker.target
```
## .fileTypes
.fileTypes : `Text` | `Collection` - default **`"*"`**

The `.fileTypes ` property defines the type(s) of file(s) that can be selected in the open file dialog, as described for the command **[Select document](https://doc.4d.com/4Dv19/4D/19.1/Select-document.301-5654273.en.html)**, if the target is a file. 

```4d
myPicker.fileTypes := "*"
```
>An empty value is equivalent to "*"

```4d
myPicker.fileTypes := ".jpeg;.tiff"
```
```4d
myPicker.fileTypes := New collection (".jpeg";".tiff")
```
When read back the `.fileTypes ` property, the result could be **`"*"`** or a collection

>This property is ignored if the target is a folder.

## .directory
.directory : `Text` | `Integer` - default is empty

The `.directory` property is the directory access path to display by default or a number to memorize the access path as described for the command **[Select document](https://doc.4d.com/4Dv19/4D/19.1/Select-document.301-5654273.en.html)**.

```4d
myPicker.directory := 8858
```
```4d
myPicker.directory := Folder(fk documents folder).platformPath
```

## .options
.options : `Integer` - default _`Package selection`_ + _`Use sheet window`_

The `.options` property allows you to specify advanced functions that are allowed in the open file dialog box as described for the command **[Select document](https://doc.4d.com/4Dv19/4D/19.1/Select-document.301-5654273.en.html)**. 

## .message
.message : `Text` - default ""

The `.message` property allows to set the title of the selection dialog box as described for the command **[Select document](https://doc.4d.com/4Dv19/4D/19.1/Select-document.301-5654273.en.html)**. 

## .browse
.browse : `Boolean` - default `True`

If the `.browse` property is `True`, a "Browse…" button is dsplayed. 

## .copyPath
.copyPath : `Boolean` - default `True`

If the `.copyPath` property is `True`, a "Copy path" item is appended to the widget menu. 

## .showOnDisk
.showOnDisk : `Boolean` - default `True`

If the `.showOnDisk` property is `True`, a "Show on disk…" item is appended to the widget menu. 

## .openItem
.openItem : `Boolean` - default `True`

If the `.openItem` property is `True`, selecting any item in the widget menu triggers a display of the selected item on disk. 

## .placeHolder
.placeHolder : `Text` - default ""

The `.placeHolder` property defines the text displayed if the target is not defined. 

## .callback
.callback : `4D.Fonction` - default `Null`

The `.callback` property allow to defines a formula to be called when the target is modified. 

The formula will receive as parameter the targetted `4D.File` or `4D.Folder`

```4d
myPicker.callback := Formula(myCallback($1))
```
***myCallback*** method :

```4d
#DECLARE ($target : Object)
If( $target # Null)
    // Do something
Else
    // Do something else
End if
```

If the `.callback` property is not set, the widget triggers an _`On Data change`_ event for its container.







