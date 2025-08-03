//%attributes = {"invisible":true}
var $branch; $head; $major; $version : Text
var $success : Boolean
var $c : Collection
var $file : 4D:C1709.File

ARRAY LONGINT:C221($len; 0)
ARRAY LONGINT:C221($pos; 0)

$file:=File:C1566("/PACKAGE/.git/HEAD")

If ($file.exists)
	
	$head:=$file.getText()
	
	If (Match regex:C1019("(?m-si)ref: refs/heads/(.*)$"; $head; 1; $pos; $len))
		
		$branch:=Substring:C12($head; $pos{1}; $len{1})
		
		$c:=Split string:C1554(Application version:C493; "")
		$major:=$c[0]+$c[1]
		
		If (Application version:C493(*)="A@")
			
			$version:="DEV ("+$major+"R"+$c[2]+")"
			$success:=($branch="main") || ($branch=($major+Choose:C955($c[2]="0"; "."+$c[3]; "R"+$c[2])))
			
		Else 
			
			$version:=$major+Choose:C955($c[2]="0"; ("."+$c[3]); ("R"+$c[2]))
			
			If ($c[2]#"0")
				
				$version:=$major+"R"+$c[2]  // FIXME: for 20RA=>20R10
				$success:=($branch=($version)) | ($branch=($major+"RX"))
				
			Else 
				
				$version:=$major+"."+$c[3]
				$success:=($branch=($version)) | ($branch=($major+".X"))
				
			End if 
		End if 
		
		If (Not:C34($success))
			
			ALERT:C41("WARNING:\n\nYou are editing the \""+$branch+"\" branch of \""+$file.parent.parent.name+"\" with a "+$version+" version of 4D.\n\n(Maintain Shift to try to switch branch)")
			
			If (Shift down:C543)
				
				var $param; $result : Object
				
				$branch:=$version
				If (Position:C15("DEV"; $branch)=1)
					$branch:="main"
				End if 
				$param:=New object:C1471("action"; "checkout "+$branch; "path"; Folder:C1567(Folder:C1567(fk database folder:K87:14).platformPath; fk platform path:K87:2))
				$result:=git($param)
				
				ALERT:C41(JSON Stringify:C1217($result))
				
			End if 
		End if 
	End if 
End if 