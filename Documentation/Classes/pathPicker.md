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

## Properties

|Properties|Description|Type|Default|
|----------|-----------|:--:|-------|
|**.type** | The type of the associated target (folder or document)  | `Integer` | _Is a document_ 
|**.options** | The selection options\* | `Integer` | _Package selection_ + _Use sheet window_
|**.browse** | Display a browse button | `Boolean` | **True**
|**.showOnDisk** | Add a "Show on disk…" item into the widget menu | `Boolean` | **True**
|**.copyPath** | Add a "Copy the path" item into the widget menu | `Boolean` | **True**
|**.directory** | Allow to display in the finder any menu item of the widget | `Boolean` | **True**
|**.openItem** | The directory access path to display by default or a number to memorize the access path\* | `Text` <br> `Integer` | ""
|**.fileTypes** | List of types of documents to filter, or "\*" to not filter documents\* | `Text` | ""
|**.message** | Title of the selection dialog box\* | `Text` | ""
|**.placeHolder** | Placeholder text associated with the widget | `Text` | ""
\* as described for the command **[Select document](https://doc.4d.com/4Dv19/4D/19.1/Select-document.301-5654273.en.html)**

## Functions

| Function | Action |
| -------- | ------ |  
| .**setType** (type`:Integer`) | Set the type of the associated target.<br>Value should be _Is a document_ or _Is a folder_
| .**setMessage** (message`:Text`) | Set the title of the selection dialog box
| .**setPlaceholder** (placeholder`:Text`) | Set the placeholder text associated with the widget
| .**setTarget** (target`:File` \| `Folder`)| Set the target associated with the widget
| .**setPlatformPath** (pathname`:Text`)| Define the target associated with the widget from a platform path.
| .**setPath** (path`:Text`)| Define the target associated with the widget from a POSIX path.

## 🔸 cs.pathPicker.new({target {; options }})

The class constructor cs.pathPicker.new() creates a new class instance.
The optional `target` parameter could be a `File`, a `Folder`, a `platform path` or a `POSIX path` of the target associated with the widget. If not passed or if it is an empty string, the widget displays the placeholder if it exists.
The optional `options` parameter is an object where you can set all the properties of the widget at once:

```4d
myPicker:=cs.pathPicker.new(""; New object(\	"options"; Package open+Use sheet window; \	"fileTypes"; ".jpg"; \	"directory"; 8858; \	"copyPath"; False; \	"openItem"; True; \	"message"; "Select a picture"; \	"placeHolder"; "Select a picture…"))
```


