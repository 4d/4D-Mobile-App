# listbox

The `listbox` class is intended to handle listbox widget.  

> #### 📌 This class inherit from the [`scrollable`](scrollable.md) class

## Properties

|Properties|Description|
|----------|-----------|
|**.name** | [*inherited*](formObject.md) |
|**.type** | [*inherited*](formObject.md) |
|**.coordinates** | [*inherited*](formObject.md) |
|**.dimensions** | [*inherited*](formObject.md) |
|**.windowCoordinates** | [*inherited*](formObject.md) |
|**.scrollbars** | [*inherited*](scrollable.md) |
|**.scroll** | [*inherited*](scrollable.md) |
|**.isCollection** | **True** if the listbox datasource is a collection or an entity slecetion
|**.isArray** | **True** if the listbox datasources are arrays
|**.item** | Ready to be used as a current element of the data source.
|**.itemPosition** | Ready to be used as a current item position of the data source.
|**.items** | Ready to be used as selected items of the data source.
|**.cellBox** | Last updated cell coordinates as coordinate's object.
|**.definition** | `object` containing the [listbox definition](#listboxDefinition)
|**.properties** | `object` containing the [listbox properties](#property)

## 🔸 cs.listbox.new()

The class constructor `cs.listbox.new({formObjectName})` creates a new class instance.

If the `formObjectName` parameter is ommited, the constructor use the result of **[OBJECT Get name](https://doc.4d.com/4Dv18R6/4D/18-R6/OBJECT-Get-name.301-5198296.en.html)** ( _Object current_ )

> 📌 Omitting the object name can only be used if the constructor is called from the object method.

## Summary

> 📌 All functions that return `cs.listbox` may include one call after another. 

### Definition
| Function | Action |
| -------- | ------ | 
|.**columnNumber** ()  →`:Integer` | Returns the number of columns |
|.**columnPtr** ()  →`:Pointer` | Giving a `column`, a `header` or a `footer` name, returns the corresponding column pointer |
|.**rowNumber** ()  →`:Integer` | Returns the number of lines |
|.**rowCoordinates** (row`:Integer`) →`:Object` | Returns a row [coordinates object](#coordinates) |
|.**cellPosition** ({event`:Object`})  →`:Object` | Returns, as [cell object](#cell) of the given event (works also on Mouse Enter/Move/Leave!).<br/>*Uses the  row & column of the current form event if no parameter.*|
|.**cellCoordinates** ({column`:Integer`;row`:Integer`}) →`:Object` | Returns, as a [coordinates object](#coordinates), the designated cell coordinate & update the cellBox property.<br/>*Uses the  row & column of the current form event if no parameter.*|

### Selection
| Function | Action |
| -------- | ------ |  
|.**selected** ()  →`:Integer` | Gives the number of selected lines |
|.**select** ({row `:Integer`}) →`:cs.listbox` | Selects a line or all lines if no parameter is passed.|
|.**selectAll** ( ) →`:cs.listbox` | Selects all lines |
|.**unselect** ({row `:Integer`}) →`:cs.listbox` | Unselects a line or all lines if no parameter is passed.|
|.**selectFirstRow** () →`:cs.listbox` | Selects the first line of the list.|
|.**selectLastRow** () →`:cs.listbox` | Selects the last line of the list.|
|.**autoSelect** () →`:cs.listbox` | Selects the last touched line (last mouse click, last selection made via the keyboard or last drop).|
|.**doSafeSelect** (row `:Integer`) →`:cs.listbox` | Selects the given line if possible, else the most appropiate one. <br/>*Useful to maintain a selection after a deletion, for example*|

### Properties
| Function | Action |
| -------- | ------ | 
|.**highlight** ({enable`:Boolean`})  →`:cs.listbox`| |
|.**noHighlight** ()  →`:cs.listbox`| |
|.**movableLines** ({enable `:Boolean`})  →`:cs.listbox`| |
|.**nonMovableLines** ()  →`:cs.listbox`| |
|.**selectable** ({enable `:Boolean`})  →`:cs.listbox`| |
|.**notSelectable** ()  →`:cs.listbox`| |
|.**singleSelectable** ()  →`:cs.listbox`| |
|.**multipleSelectable** ()  →`:cs.listbox`| |
|.**sortable** ({enable `:Boolean`})  →`:cs.listbox`| |
|.**notSortable** ()  →`:cs.listbox`| |
|.**getColumnProperties** (column`:Integer`)  →`:Object`| |
|.**getProperty** (property`:Integer` {; column`:Integer`}) →`:Variant`| Returns a column or listbox (if column is ommited) property value|

### Miscellaneous
| Function | Action |
| -------- | ------ | 
|.**edit** ()<br/>.**edit** (event `:Object` {; item `:Integer`})<br/>.**edit** (target `:Text` {; item `:Integer`}) | To edit a listbox item |
|.**reveal** (row `:Integer`)  → `:cs.listbox` | Selects ans reveal the passed row number |
|.**popup** (menu`:cs.menu` {;default`:Text`})  →`:cs.menu` | Displays a [`cs.menu`](menu.md) at the bottom left of the current cell
|.**showColumn** (column`:Integer` {; visible`:Boolean`})| |
|.**hideColumn** (column`:Integer`)| |
|.**clear** ()  →`:cs.listbox`| |
|.**deleteRows** (row`:Integer`)  →`:cs.listbox`| |

#### <a name="cell">Cell object</a>
```json
{
	"column": Integer,
	"row": Integer
}
```
#### <a name="coordinates">Coordinates object</a>
```json
{
	"left": Integer,
	"top": Integer,
	"right": Integer,
	"bottom": Integer
}
```
#### <a name="listboxDefinition">Listbox definition object</a>
```json
{
	"definition": [
		column 1 : Column definition object,
		column 2 : Column definition object,
		…
		column N definition object
	],
	"columns": {
		"column1Name" : Column decription object,
		"column2Name" : Column decription object,
		—
		"columnNName" : Column decription object
	}
}
```
#### <a name="columnDef">Column definition object</a>
```json
{
	"number": Integer,
	"enterable": Boolean,
	"visible": Boolean,
	"height": Integer (row height),
	"wordwrap": 0 | 1,
	"autoRowHeight": 0 | 1,
	"maxWidth": integer,
	"minWidth": integer,
	"resizable": 0 | 1,
	"displayType": 0 | 1,
	"fontColorExpression": text,
	"fontStyleExpression": text,
	"multiStyle": 0 | 1,
	"truncate": 0 | 1,
	"pointer": pointer
}
```
#### <a name="columnDesc">Column decription object</a>
```json
{ 
	"name" : column name, 
	"header" : header name, 
	"footer" : footer name
}
```
#### <a name="property">Property object</a>
```json
{
	"enterable": Boolean,
	"allowWordwrap": 0 | 1,
	"autoRowHeight": 0 | 1,
	"displayFooter": 0 | 1,
	"displayHeader": 0 | 1,
	"doubleClickOnRow": 0 | 1 | 2,
	"extraRows": 0 | 1,
	"footerHeight": integer,
	"headerHeight": integer,
	"hideSelectionHighlight": 0 | 1,
	"highlightSet": text,
	"metaExpression": text,
	"movableRows": 0 | 1,
	"resizingMode": 0 | 1,
	"rowHeight": integer,
	"rowHeightUnit": 0 | 1,
	"rowMaxHeight": integer,
	"rowMinHeight": integer,
	"selectionMode": 0 | 1 | 2,
	"singleClickEdit": 0 | 1,
	"sortable": 0 | 1,
	"truncate": 0 | 1,
	…
}
```
