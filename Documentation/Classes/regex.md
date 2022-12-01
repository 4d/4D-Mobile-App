# [reg]ULAR [ex]PRESSION
This class allows to perform, on string data, testing for a pattern match (match), searching for a pattern match (extract), and replacing matched text (substitute).

## Summary
This class use the **[Match regex](https://doc.4d.com/4Dv19/4D/19.1/Match-regex.301-5653300.en.html)** 4D Command based on ICU ([International Components for Unicode](https://icu.unicode.org)) library. 

> 📌 The regular expression patterns and behavior are based on Perl’s regular expressions.

### Properties

|Properties|Type|Description|Initial value|Read only|
|---------|:----:|------|:------:|:------:|
|**target**|Text|The string data|Empty string|
|**pattern**|Text|The pattern to use for future operations|Empty string|
|**success**|Boolean|The status of the last operation|**True**|
|**lastError**|Object|The last error encountered during operation|**Null**|✔️
|**errors**|Collection|The list of all errors since class inititialisation|Empty collection|
|**matches**|Collection|The match list of the extracted segments during the last operation (see below)|**Null**|✔️

> 📌 The "setXXX" functions returns the original `cs.regex` object, so you can include one call after another (See [substitute ()](#substitute) example).

### Functions

|Function|Action|
|--------|------|  
|.**setTarget** (target : `Text` \| `4D.File` \| `Blob`) → `cs.regex`|Defines the string on which the next operations will be performed.<br/>Can be a text, a blob or a disk file.
|.**setPattern** (pattern : `Text`) → `cs.regex`|Defines the pattern to use for future operations.
|.**[match](#match)** () → `Boolean`<br/>.**[match](#match)** ({start : `Integer`} {;} {all : `Boolean`}) → `Boolean`|Returns True if the pattern matches the string.
|.**[extract](#extract)** ( {group : `Text` \| `Integer` \| `Collection`} ) → `Collection`|Returns the list of texts extracted based on the pattern definition
|.**[substitute](#substitute)** ( {replacement : `Text`} ) → `Text`|Returns the result of the replacement in the target string

> 📌 The `match()`, `extract()` & `substitute()` functions populates the `matches` property. The first element of the collection contain the whole pattern match, and the others matched subpatterns. Each element is described in an object with its order number ("index"), its value ("data"), its position ("pos") and its length ("len").

## 🔸 cs.regex.new()

The class constructor `cs.regex.new()` can be called without parameters to create an empty regex object.
>`cs.regex.new()`

The constructor of the class also accepts two optional parameters, which allows you to create a regex object and fill in the target and pattern in one operation.
>`cs.regex.new("hello world")` // Fills the target   
>`cs.regex.new("hello world"; "[Hh]ello")` // Fills the target and the pattern

The target parameter can be a text value or a 4D.File. In the second case, the contents of the file are loaded from disk and used to fill the target property.

## 🔹<a name="match">match ()</a>

Matches a regular expression against the target text and returns True if the pattern matches the target text.

It is possible to pass `start` to specify the position where the search will start and/or `all = True` to obtain all hits.

```4d
$regex:=cs.regex.new("Hello world, the world is wonderful but the world is in danger"; "world")
If ($regex.match())	// Test first occurrence	ASSERT($regex.matches.length=1)	ASSERT($regex.matches[0].data="world")	ASSERT($regex.matches[0].position=7)	ASSERT($regex.matches[0].length=5)	End if 
If ($regex.match(10))	// Starts search at 10th character	ASSERT($regex.matches.length=1)	ASSERT($regex.matches[0].data="world")	ASSERT($regex.matches[0].position=18)	ASSERT($regex.matches[0].length=5)	End if If ($regex.match(True))	 // Retrieves all occurrences	ASSERT($regex.matches.length=3)	ASSERT($regex.matches[0].data="world")	ASSERT($regex.matches[0].position=7)	ASSERT($regex.matches[0].length=5)		ASSERT($regex.matches[1].data="world")	ASSERT($regex.matches[1].position=18)	ASSERT($regex.matches[1].length=5)		ASSERT($regex.matches[2].data="world")	ASSERT($regex.matches[2].position=45)	ASSERT($regex.matches[2].length=5)	End if If ($regex.match(10; True))	// Starts search at 10th character & retrieves all next occurences	ASSERT($regex.matches.length=2)	ASSERT($regex.matches[0].data="world")	ASSERT($regex.matches[0].position=18)	ASSERT($regex.matches[0].length=5)		ASSERT($regex.matches[1].data="world")	ASSERT($regex.matches[1].position=45)	ASSERT($regex.matches[1].length=5)	End if 
```
## 🔹<a name="extract">extract ()</a>

Extracts all matches of a regular expression against the target text and returns the pattern matches values.

Parameter `group` specifies the group(s) to be extracted, it can be a text, an integer or a collection.

* If it is not specified, the whole pattern matches is extracted first (element 0) then all the sub-pattern matches if the pattern contains grouping parentheses.  
* If the pattern contains grouping parentheses, the `group` parameter can be a list of group numbers to be extracted.  
* Accepted types for `groups` can be text (text separated by spaces if there is more than one group), a collection of texts or a collection of integers. 
   
> For example, by specifing "1 2", all matches of the first and second sub-pattern will be extracted (order is ignored).  

```4d
$regex:=cs.regex.new("hello world"; "(?m-si)([[:alnum:]]*)\\s([[:alnum:]]*)")$result:=$regex.extract()   // → ["hello world"; "hello"; "world"]$result:=$regex.extract("0")   // → ["hello world"]$result:=$regex.extract(0)   // → ["hello world"]$result:=$regex.extract(1)   // → ["hello"]$result:=$regex.extract(2)   // → ["world"]$result:=$regex.extract("1 2")   // → ["hello"; "world"]$result:=$regex.extract(New collection(1; 2))   // → ["hello"; "world"]
```  

## 🔹<a name="substitute">substitute ()</a>

Substitutes all matches of a regular expression in the target text with a replacement string.

* The replacement string may contain group references in the \digit form. Each backref is substituted by the corresponding sub-pattern match (\0 is the whole pattern match, \1 the first group, \2 the second etc.).
* If the replacement string is omitted (or is an empty string), the matches values are deleted.   
* Other special character sequences can be used in the replacement string: See [ICU User Guide](https://unicode-org.github.io/icu/userguide/)

```4d
$regex:=cs.regex.new()\
   .setTarget("123helloWorld")\
   .setPattern("(?mi-s)^[^[:alpha:]]*([^$]*)$")\
   .substitute("\\1") // → "helloWorld" 
```

