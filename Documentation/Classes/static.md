# static

The `static` class is the parent class of all form objects classes<img src="static.png">

> 📌 The `group` class can also refer to this class even if it's not inheritance
	
## Properties

|Properties|Description|Type||
|----------|-----------|:--:|-------|
|**.name** | The name of the form object| `Text`
|**.type** | The type of the form object| `Integer` | Use the [Form object Types](https://doc.4d.com/4Dv18R6/4D/18-R6/Form-Object-Types.302-5199153.en.html) constant theme
|**.coordinates** | The coordinates of the form object in the form| `Object` | {`left`,`top`,`right`,`bottom`} |
|**.dimensions** | The dimensions of the form object| `Object` | {`width`,`height`} |
|**.windowCoordinates** | The coordinates of the form object in the current window| `Object` | {`left`,`top`,`right`,`bottom`} |

## 🔸 cs.static.new()

The class constructor `cs.static.new({formObjectName})` creates a new class instance.

If the `formObjectName` parameter is ommited, the constructor use the result of **[OBJECT Get name](https://doc.4d.com/4Dv18R6/4D/18-R6/OBJECT-Get-name.301-5198296.en.html)** ( _Object current_ )
> 📌 Omitting the object name can only be used if the constructor is called from the object method.

## Summary

> 📌 All functions that return `cs.static` may include one call after another. 

| Function | Action |
| -------- | ------ |  
|.**hide** ()  → `cs.static` | To hide the object |
|.**show** ( {state :`Boolean` } )  → `cs.static` | To make the object visible (no parameter) or invisible (`state` = **False**) | 
|.**getVisible** ()  → `Boolean` | Returns **True** if the object has the visible attribute and **False** otherwise |
|.**enable** ( {state :`Boolean` } )  → `cs.static` | To enable (no parameter) or disable (`state` = **False**) the object |
|.**disable** ()  → `cs.static` | To disable the object |
|.**setCoordinates** ( left :`Integer ` ; top :`Integer` ; { right :`Integer` ; bottom :`Integer` }})  → `cs.static` | To modifies the coordinates and, optionally, the size of the object \* |
|.**setCoordinates** ( coordinates :`Object`)  → `cs.static` | "left", "top" {, "right", "bottom"} \*|
|.**getCoordinates** ()  → `Object` | Returns the updated coordinates object\* |
|.**bestSize** ( alignement :`Integer` { ; minWidth :`Integer` { ; maxWidth :`Integer`}} )  → `cs.static` | Set the coordinates of the object to its best size according to its content (e.g. a localized string) \* |
|.**bestSize** ({options : `Object`})  → `cs.static` | {"alignement"} {, "minWidth"}  {, "maxWidth"} \*  |
|.**moveHorizontally** ( offset : `Integer`)  → `cs.static` | To move the object horizontally \*  |
|.**moveVertically** ( offset : `Integer`)  → `cs.static` | To move the object vertically \*  |
|.**resizeHorizontally** ( offset : `Integer`)  → `cs.static` | To resize the object horizontally \*  |
|.**resizeVertically** ( offset : `Integer`)  → `cs.static` | To resize the object vertically \*  |
|.**setDimension** ( width : `Integer` ; { height : `Integer`})  → `cs.static` | To modify the object dimensions \*  |
|.**setTitle** ( title : `Text`)  → `cs.static` | To change the title of the object (if the title is a `resname`, the localization is performed) \** |
|.**getTitle** ( )  → `Text` | Returns the title of the object \** |
|.**fontStyle** ( {style : `Integer`})  → `cs.static` | To set the style of the title (use the 4D constants _Bold_, _Italic_, _Plain_, _Underline_) Default = _Plain_ \** |
    
\* Automatically update the `coordinates`, `dimensions` and `windowCoordinates` properties.    
\** Can be applied to a static text and will be avalaible for the inherited classes (buttons, check boxes, radio buttons, …)