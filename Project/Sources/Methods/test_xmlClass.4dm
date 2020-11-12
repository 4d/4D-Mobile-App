//%attributes = {}
var $node; $t : Text
var $o : Object
var $c : Collection

var $xml : cs:C1710.xml

TRY

//======================================================================================
// Create from scratch
$xml:=cs:C1710.xml.new()
$xml.new()
ASSERT:C1129($xml.success; ".new()")

// Export to an internal variable
$t:=$xml.content()  // Must autoclose
ASSERT:C1129($xml.success; ".content()")
ASSERT:C1129($t="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\" ?>\r<root/>\r")

// Must failed
$xml.close()
ASSERT:C1129(Not:C34($xml.success); ".close()")

//======================================================================================
// Create by parsing
$t:="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\" ?>\n<repertoire>\n  "\
+"<!-- John DOE -->\n  <personne sexe=\"masculin\">\n    <nom>DOE</nom>\n    "\
+"<prenom>John</prenom>\n    <adresse>\n      <numero>7</numero>\n      <voie "\
+"type=\"impasse\">impasse du chemin</voie>\n      "\
+"<codePostal>75015</codePostal>\n      <ville>PARIS</ville>\n      "\
+"<pays>FRANCE</pays>\n    </adresse>\n    <telephones>\n      <telephone "\
+"type=\"fixe\">01 02 03 04 05</telephone>\n      <telephone type=\"portable\">06 "\
+"07 08 09 10</telephone>\n    </telephones>\n    <emails>\n      <email "\
+"type=\"personnel\">john.doe@wanadoo.fr</email>\n      <email "\
+"type=\"professionnel\">john.doe@societe.com</email>\n    </emails>\n  "\
+"</personne>\n</repertoire>"

$xml:=cs:C1710.xml.new($t)

// Childs of the root
$c:=$xml.childrens()
ASSERT:C1129($c.length=1)

// Descendants of the root
$c:=$xml.descendants()
ASSERT:C1129($c.length=15)

$node:=$xml.findByXPath("/repertoire/personne")

// Childs of the node
$c:=$xml.childrens($node)

If (Asserted:C1132($c.length=5))
	
	ASSERT:C1129($xml.getValue($c[0])="DOE")
	ASSERT:C1129($xml.getValue($c[1])="John")
	
End if 

// Descendants of the node
$c:=$xml.descendants($node)

If (Asserted:C1132($c.length=14))
	
	ASSERT:C1129($xml.getValue($c[3])=7)
	ASSERT:C1129($xml.getValue($c[5])=75015)
	
End if 

$c:=$xml.findByAttribute("type")
ASSERT:C1129($c.length=5)

$c:=$xml.findByAttribute("type"; "impasse")

If (Asserted:C1132($c.length=1))
	
	ASSERT:C1129($xml.getValue($c[0])="impasse du chemin")
	
End if 

$c:=$xml.findByAttribute("email"; "type"; "personnel")

If (Asserted:C1132($c.length=1))
	
	ASSERT:C1129($xml.getValue($c[0])="john.doe@wanadoo.fr")
	
End if 

$c:=$xml.findByName("telephones")

If (Asserted:C1132($c.length=1))
	
	$c:=$xml.childrens($c[0])
	
	If (Asserted:C1132($c.length=2))
		
		$c:=$xml.findByAttribute($c[0]; "type"; "portable")
		
		If (Asserted:C1132($xml.success))
			
			ASSERT:C1129($xml.getValue($c[0])="06 07 08 09 10")
			
		End if 
	End if 
End if 

$node:=$xml.findByXPath("/repertoire/personne/telephones")
ASSERT:C1129($xml.findByName($node; "telephone").length=2)

$node:=$xml.findOrCreate("anniversary")

If (Asserted:C1132($xml.success))
	
	$c:=$xml.findByName("anniversary")
	
	If (Asserted:C1132($c.length=1))
		
		ASSERT:C1129($node=$c[0])
		
	End if 
End if 

$node:=$xml.findByXPath("/repertoire/personne/telephones")
$node:=$xml.findOrCreate($node; "anniversary")

If (Asserted:C1132($xml.success))
	
	$c:=$xml.findByName("anniversary")
	ASSERT:C1129($c.length=2)
	
End if 

$xml.close()

//======================================================================================
// Create from file
$o:=Folder:C1567(fk resources folder:K87:11).file("templates/form/list/Simple Table/Sources/Forms/Tables/___TABLE___/___TABLE___ListForm.storyboard")
$xml:=cs:C1710.xml.new($o)
ASSERT:C1129($xml.success; ".new(File)")

// Elements of the tree with the attribute "id"
$c:=$xml.findByAttribute("id")
ASSERT:C1129($c.length=35; ".findByAttribute()")

// Elements of the tree with the attribute "id=39w-Zo-jTU"
$c:=$xml.findByAttribute("id"; "39w-Zo-jTU")
ASSERT:C1129($c.length=1; ".findByAttribute()")
ASSERT:C1129($c[0]=$xml.findById("39w-Zo-jTU"); ".findByAttribute(\"id\";\"39w-Zo-jTU\")")

$node:=$xml.findByXPath("/document/scenes/scene/objects/tableViewController/tableView/prototypes/tableViewCell/tableViewCellContentView/subviews/view/subviews")
ASSERT:C1129($xml.success; ".findByXPath()")
ASSERT:C1129($xml.getName($node)="subviews")
ASSERT:C1129($xml.getName($xml.parent($node))="view")

$node:=$xml.findByXPath("/document/scenes")
ASSERT:C1129($xml.success; ".findByXPath(\"/document/scenes\")")
ASSERT:C1129($node#("0"*32))

If (False:C215)  //BUG?
	
	// Elements of the node with the attribute "id"
	$c:=$xml.findByAttribute($node; "id")
	ASSERT:C1129($c.length=34; ".findByAttribute($node;\"id\")")
	
End if 

$c:=$xml.findByAttribute($node; "id"; "39w-Zo-jTU")
ASSERT:C1129($c.length=1; ".findByAttribute($node;\"id\";\"39w-Zo-jTU\")")
ASSERT:C1129($c[0]=$xml.findById("39w-Zo-jTU"); ".findByAttribute()")

// All elements with the attribute "userLabel"
$c:=$xml.findByAttribute($node; "userLabel")
ASSERT:C1129($c.length=5; ".findByAttribute()")

// All elements with the attribute "userLabel='List Form'"
$c:=$xml.findByAttribute($node; "userLabel"; "List Form")
ASSERT:C1129($c.length=1; ".findByAttribute()")

$c:=$xml.findByAttribute($node; "key"; "backgroundColor")
ASSERT:C1129($c.length=5; ".findByAttribute()")

// All "color" elements with the attribute "key='backgroundColor'"
$c:=$xml.findByAttribute($node; "color"; "key"; "backgroundColor")
ASSERT:C1129($c.length=5; ".findByAttribute()")

$c:=$xml.findByAttribute($node; "value")
ASSERT:C1129($c.length=9; ".findByAttribute()")

$c:=$xml.findByAttribute($node; "value"; "___SEARCHABLE_FIELD___")
ASSERT:C1129($c.length=1; ".findByAttribute()")

$c:=$xml.findByAttribute($node; "value"; "hello")
ASSERT:C1129($c.length=0; ".findByAttribute()")
ASSERT:C1129(Not:C34($xml.success); ".findByAttribute()")

$c:=$xml.childrens($node)
ASSERT:C1129($c.length=3; ".child($node)")

$c:=$xml.descendants($node)
ASSERT:C1129($c.length=107; ".descendant($node)")

$node:=$xml.findById("Dxc-Bl-At2")
ASSERT:C1129($xml.success; ".findById()")

$c:=$xml.findByName("scene")
ASSERT:C1129($xml.success; ".findByName()")
ASSERT:C1129($c.length=3; ".findByName()")

$xml.close()

//======================================================================================
$xml:=cs:C1710.xml.new().new()
ASSERT:C1129($xml.success; ".new()")

$node:=DOM Create XML element:C865($xml.root; "document"; \
"title"; "hello world"; \
"author"; "me"; \
"year"; 1958; \
"published"; True:C214; \
"date"; !1958-08-08!)

$o:=$xml.getAttributes($node)
ASSERT:C1129($o#Null:C1517; ".getAttributes()")
ASSERT:C1129($o.title#Null:C1517; ".getAttributes()")
ASSERT:C1129($o.title="hello world"; ".getAttributes()")
ASSERT:C1129($o.author#Null:C1517; ".getAttributes()")
ASSERT:C1129($o.author="me"; ".getAttributes()")
ASSERT:C1129($o.year#Null:C1517; ".getAttributes()")
ASSERT:C1129($o.year=1958; ".getAttributes()")
ASSERT:C1129($o.published#Null:C1517; ".getAttributes()")
ASSERT:C1129($o.published=True:C214; ".getAttributes()")
ASSERT:C1129($o.date#Null:C1517; ".getAttributes()")
ASSERT:C1129($o.date=!1958-08-08!; ".getAttributes()")

$c:=$xml.getAttributesCollection($node)
ASSERT:C1129($c.length=5; ".attributesToCollection()")
$o:=$c.query("key=title").pop()
ASSERT:C1129($o#Null:C1517; ".attributesToCollection()")
ASSERT:C1129($o.value="hello world"; ".attributesToCollection()")
$o:=$c.query("key=author").pop()
ASSERT:C1129($o#Null:C1517; ".attributesToCollection()")
ASSERT:C1129($o.value="me"; ".attributesToCollection()")
$o:=$c.query("key=year").pop()
ASSERT:C1129($o#Null:C1517; ".attributesToCollection()")
ASSERT:C1129($o.value=1958; ".attributesToCollection()")
$o:=$c.query("key=published").pop()
ASSERT:C1129($o#Null:C1517; ".attributesToCollection()")
ASSERT:C1129($o.value=True:C214; ".attributesToCollection()")
$o:=$c.query("key=date").pop()
ASSERT:C1129($o#Null:C1517; ".attributesToCollection()")
ASSERT:C1129($o.value=!1958-08-08!; ".attributesToCollection()")

ASSERT:C1129($xml.getAttribute($node; "title")="hello world"; ".getAttribute()")
ASSERT:C1129($xml.getAttribute($node; "author")="me"; ".getAttribute()")
ASSERT:C1129($xml.getAttribute($node; "date")=!1958-08-08!; ".getAttribute()")

// Must failed
$t:=$xml.getAttribute($node; "unknown")
ASSERT:C1129(Not:C34($xml.success); "getAttribute()")

$xml.setAttribute($node; "author"; "him")
ASSERT:C1129($xml.success; ".setAttribute()")
$c:=$xml.getAttributesCollection($node)
ASSERT:C1129($c.length=5; ".attributesToCollection()")
$o:=$c.query("key=author").pop()
ASSERT:C1129($o#Null:C1517; ".attributesToCollection()")
ASSERT:C1129($o.value="him"; ".attributesToCollection()")
$t:=$xml.getAttribute($node; "author")
ASSERT:C1129($xml.success; ".setAttribute()")
ASSERT:C1129($t="him"; ".getAttribute()")

FINALLY

BEEP:C151