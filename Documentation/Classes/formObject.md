# formObject

The `formObject` class is the parent class of all form objects classes<img src="static.png">

> 📌 The `group` class can also refer to this class even if it's not inheritance
	
## Properties

|Properties|Description|Type||Read only|
|----------|-----------|:--:|-------|:--:|
|**.name** | The name of the form object| `Text` ||✔️|
|**.type** | The type of the form object| `Integer` | Use the [**Form object Types**](https://doc.4d.com/4Dv18R6/4D/18-R6/Form-Object-Types.302-5199153.en.html) constant theme |✔️|
|**.title** | The title of the object when it is relevant | `Text` |You can pass a resname to use the localized string||
|**.width** | The width of the object\* | `Integer` |||
|**.height** | The height of the object\* | `Integer` |||
|**.dimensions** | The dimensions of the form object\*| `Object` |{`width`,<br>`height`} ||
|**.coordinates** | The coordinates of the form object in the form| `Object` |{`left`,<br>`top`,<br>`right`,<br>`bottom`}| ✔️|
|**.windowCoordinates** | The coordinates of the form object in the current window| `Object` |{`left`,<br>`top`,<br>`right`,<br>`bottom`} |✔️|
|**.colors** | The color of the object | `Object` |{`foreground`,<br>`background`,<br>`altBackground`}||
|**.foregroundColor** | The foreground color of the object | `Variant` |Accepts the color formats managed by [**OBJECT SET RGB COLORS**](https://doc.4d.com/4Dv19/4D/19.1/OBJECT-SET-RGB-COLORS.301-5653493.en.html) ||
|**.backgroundColor** | The background color of the object | `Variant` |Accepts the color formats managed by [**OBJECT SET RGB COLORS**](https://doc.4d.com/4Dv19/4D/19.1/OBJECT-SET-RGB-COLORS.301-5653493.en.html) ||
|**.altBackgroundColor** | The alternating color of the rows for a listbox | `Variant` |Accepts the color formats managed by [**OBJECT SET RGB COLORS**](https://doc.4d.com/4Dv19/4D/19.1/OBJECT-SET-RGB-COLORS.301-5653493.en.html) ||
|**.visible** | The visibility status of the object | `Boolean` |||
|**.hidden** | The hidden status of the object | `Boolean` |||
|**.enabled** | The enabled status of the object | `Boolean` |||
|**.disabled** | The disabled status of the object | `Boolean` |||
|**.horizontalAlignment** | The type of the horizontal alignment of the object | `Integer` |Use the [**Form Objects (Properties)**](https://doc.4d.com/4Dv19/4D/19.1/Form-Objects-Properties.302-5654316.en.html) constants||
|**.verticalAlignment** | The type of the vertical alignment of the object | `Integer` |Use the [**Form Objects (Properties)**](https://doc.4d.com/4Dv19/4D/19.1/Form-Objects-Properties.302-5654316.en.html) constants||
|**.font** | The font of the object | `Text` |||
|**.fontStyle** | The font style used by the object | `Integer` |Use the [**Font Styles**](https://doc.4d.com/4Dv19/4D/19.1/Font-Styles.302-5654394.en.html) constant theme ||
|**.fontSize** | The font size (in point) used by the object | `Integer` |||

\* When assigned, automatically updates the `coordinates`, `dimensions` and `windowCoordinates` properties. 

## 🔸 cs.formObject.new()

The class constructor `cs.formObject.new({formObjectName})` creates a new class instance.

If the `formObjectName` parameter is ommited, the constructor use the result of **[OBJECT Get name](https://doc.4d.com/4Dv19/4D/19/OBJECT-Get-name.301-5392401.en.html)** (_Object current_ )
> 📌 Omitting the object name can only be used if the constructor is called from the object method.

## Summary

> 📌 All functions that return `cs.formObject` may include one call after another. 

| Function | Action |
| -------- | ------ |  
|.**show** ({state`:Boolean`}) →`cs.formObject` | To make the object visible (no parameter) or invisible (`state` = **False**) | 
|.**hide** () →`cs.formObject` | To hide the object |
|.**enable** ({state`:Boolean`}) →`cs.formObject` | To enable (no parameter) or disable (`state` = **False**) the object |
|.**disable** () →`cs.formObject` | To disable the object |
|.**setCoordinates** (left`:Integer `; top`:Integer`; {right`:Integer`; bottom`:Integer`}}) →`cs.formObject` | To modifies the coordinates and, optionally, the size of the object \* |
|.**setCoordinates** (coordinates`:Object`) →`cs.formObject` | "left", "top"{, "right", "bottom"}\*|
|.**getCoordinates** () →`Object` | Returns the updated coordinates object\* |
|.**bestSize** (alignement`:Integer`{ ; minWidth`:Integer`{ ; maxWidth`:Integer`}}) →`cs.formObject` | Set the size of the object to its best size according to its content (e.g. a localized string) \* |
|.**bestSize** ({options`:Object`}) →`cs.formObject` |{"alignement"}{, "minWidth"}{, "maxWidth"}\*  |
|.**moveHorizontally** (offset`:Integer`) →`cs.formObject` | To move the object horizontally \*  |
|.**moveVertically** (offset`:Integer`) →`cs.formObject` | To move the object vertically \*  |
|.**resizeHorizontally** (offset`:Integer`) →`cs.formObject` | To resize the object horizontally \*  |
|.**resizeVertically** (offset`:Integer`) →`cs.formObject` | To resize the object vertically \*  |
|.**moveAndResizeHorizontally** (offset`:Integer`;resize`:Integer`) →`cs.formObject` | To move and resize the object horizontally \*  |
|.**moveAndResizeVertically** (offset`:Integer`;resize`:Integer`) →`cs.formObject` | To move and resize the object vertically \*  |
|.**setDimension** (width`:Integer` ;{ height`:Integer`}) →`cs.formObject` | To modify the object width & height \*  |
|.**setHeight** (height`:Integer`) →`cs.formObject` | To modify the object height \*  |
|.**setWidth** (width`:Integer` ) →`cs.formObject` | To modify the object width \*  |
|.**setTitle** (title`:Text`) →`cs.formObject` | To change the title of the object (if the title is a `resname`, the localization is performed) \** |
|.**setFont** (fontName`:Text`}) →`cs.formObject` | To set the font|
|.**setFontStyle** ({style`:Integer`}) →`cs.formObject` | To set the style of the title (use the 4D constants _Bold_, _Italic_, _Plain_, _Underline_) Default = _Plain_ \** |
|.**setColors** (foreground{; background{; altBackground }}) →`cs.formObject` | To set the object color(s)  |
|.**updateCoordinates** (left`:Integer`; top`:Integer`; right`:Integer`; bottom`:Integer`)   →`cs.formObject` | To force update `coordinates`, `dimensions` and `windowCoordinates` properties |
|.**addToGroup** (group : cs.group) →`cs.formObject` | Adds the current widget to a [**`group`**](group.md) |
    
\* Automatically update the `coordinates`, `dimensions` and `windowCoordinates` properties.    
\** Can be applied to a static text and will be avalaible for the inherited classes (buttons, check boxes, radio buttons, …)
