//%attributes = {}
C_TEXT:C284($t;$Txt_out;$Txt_pattern;$Txt_var)
C_OBJECT:C1216($o)
C_COLLECTION:C1488($c)

GET MACRO PARAMETER:C997(Highlighted method text:K5:18;$t)

$c:=Split string:C1554($t;"\r")

$Txt_pattern:="(?m-si)^(.*):=(New object)\\s*$"

$o:=Rgx_match (New object:C1471("target";$c[0];"pattern";$Txt_pattern))

If ($o.success)
	
	$Txt_var:=$o.match[1].data+"."
	$Txt_out:=$o.match[0].data+"("
	
	For each ($t;$c;2)
		
		$t:=Replace string:C233($t;$Txt_var;"")
		$Txt_out:=$Txt_out+"\""+Split string:C1554($t;":=")[0]+"\";"+Split string:C1554($t;":=")[1]+";"
		
	End for each 
	
	$Txt_out:=Delete string:C232($Txt_out;Length:C16($Txt_out);1)
	$Txt_out:=$Txt_out+")"
	
	SET MACRO PARAMETER:C998(Highlighted method text:K5:18;$Txt_out)
	
End if 