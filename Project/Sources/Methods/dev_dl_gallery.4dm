//%attributes = {}
var $data; $item; $path : Object
var $content : Object
var $status : Integer
var $topics; $topicFs; $tmp : Collection
$topics:=New collection:C1472("form-list"; "form-detail"; "form-login"; "formatter"; "input-control")
$topicFs:=New collection:C1472("listForms"; "detailForms"; "loginForms"; "Formatters"; "InputControls")

var $baseURL; $url; $topic : Text
$path:=cs:C1710.path.new()
$baseURL:="https://4d-go-mobile.github.io/gallery/Specs/"
var $topicFolder : 4D:C1709.Folder
var $file : 4D:C1709.File
For each ($topic; $topics)
	
	$url:=$baseURL+$topic+"/index.json"
	$status:=HTTP Request:C1158(HTTP GET method:K71:1; $url; ""; $data)
	
	$topicFolder:=$path["host"+$topicFs[$topics.indexOf($topic)]].call($path)
	
	For each ($item; $data.items)
		
		$url:=$item.download_url
		$tmp:=Split string:C1554($url; "/")
		$file:=$topicFolder.file($tmp[$tmp.length-1])
		If (Not:C34($file.exists))
			$status:=HTTP Request:C1158(HTTP GET method:K71:1; $url; ""; $content)
			$file.setContent($content)
		End if 
		
	End for each 
	
End for each 

SHOW ON DISK:C922($topicFolder.parent.platformPath)