//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : actions
  // ID[66E9AA75F234494E96C5C0514F05D6C4]
  // Created 7-3-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($l;$Lon_parameters)
C_PICTURE:C286($p)
C_TEXT:C284($File_noIcon;$t;$Txt_action;$Txt_type)
C_OBJECT:C1216($folder;$o;$Obj_context;$Obj_out;$oo)

If (False:C215)
	C_OBJECT:C1216(_w_actions ;$0)
	C_TEXT:C284(_w_actions ;$1)
	C_OBJECT:C1216(_w_actions ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_action:=$1
	
	  // Default values
	$File_noIcon:=Get 4D folder:C485(Current resources folder:K5:16)+"images"+Folder separator:K24:12+"noIcon.svg"
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		$Obj_context:=$2
		
	End if 
	
	$Obj_out:=New object:C1471
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Txt_action="getList")
		
		$Txt_type:=$Obj_context.typeForm()
		
		If ($Txt_type="detail")\
			 & (featuresFlags.with("withWidgetActions"))
			
			$Txt_type:=$Txt_type+"widget"
			
		End if 
		
		$Obj_out.actions:=New collection:C1472
		
		  //=======================
		  // Integarated actions //
		  //=======================
		$o:=doc_Folder (Get 4D folder:C485(Current resources folder:K5:16)+"actions"+Folder separator:K24:12)
		
		For each ($o;$o.folders)
			
			$oo:=JSON Parse:C1218(Document to text:C1236($o.parentFolder+$o.name+Folder separator:K24:12+"manifest.json"))
			
			If (Length:C16(String:C10($oo.target))=0)\
				 | (Position:C15(String:C10($oo.target);$Txt_type)>0)
				
				$oo.name:=$o.fullName  // The name of the folder
				
				If ($oo.icon#Null:C1517)
					
					$t:=Get 4D folder:C485(Current resources folder:K5:16)+"images"+Folder separator:K24:12+"actions"+Folder separator:K24:12+$oo.icon
					
					If (Test path name:C476($t)#Is a document:K24:1)
						
						$t:=$File_noIcon
						
					End if 
					
				Else 
					
					$t:=$File_noIcon
					
				End if 
				
				READ PICTURE FILE:C678($t;$p)
				CREATE THUMBNAIL:C679($p;$p;24;24)
				$oo.$icon:=$p
				
				$Obj_out.actions.push($oo)
				
			End if 
		End for each 
		
		If ($Obj_out.actions.length>0)
			
			$Obj_out.actions:=$Obj_out.actions.orderBy("name")
			
		End if 
		
		  //=======================
		  //     User actions    //
		  //=======================
		
		$folder:=COMPONENT_Pathname ("host_actions")
		
		If ($folder.exists)
			
			For each ($o;$folder.folders())
				
				If (_and (Formula:C1597($o.files().length>0);Formula:C1597($o.files().extract("fullname").indexOf("manifest.json")#-1)))
					
					$oo:=JSON Parse:C1218($o.file("manifest.json").getText())
					
					If (Length:C16(String:C10($oo.target))=0)\
						 | (Position:C15(String:C10($oo.target);$Txt_type)>0)
						
						$oo.name:=$o.fullName  // The name of the folder
						
						If ($oo.icon#Null:C1517)
							
							$oo.icon:="/"+$o.fullName+"/"+$oo.icon
							
							$t:=$o.parent.platformPath+$o.name+Folder separator:K24:12+$oo.icon
							
							If (Test path name:C476($t)#Is a document:K24:1)
								
								$t:=$File_noIcon
								
							End if 
							
						Else 
							
							$t:=$File_noIcon
							
						End if 
						
						READ PICTURE FILE:C678($t;$p)
						CREATE THUMBNAIL:C679($p;$p;24;24)
						$oo.$icon:=$p
						
						$l:=$Obj_out.actions.extract("name").indexOf($oo.name)
						
						If ($l=-1)
							
							$Obj_out.actions.push($oo)
							
						Else 
							
							$Obj_out.actions[$l]:=$oo  // The user action overloads the embedded action
							
						End if 
					End if 
				End if 
			End for each 
			
		Else 
			
			  // No user folder
			
		End if 
		
		If ($Obj_out.actions.length>0)
			
			$Obj_out.actions:=$Obj_out.actions.orderBy("name")
			
		End if 
		
		  //______________________________________________________
	: ($Txt_action="preview")
		
		  //$Svg_root:=SVG_New
		
		  //$Obj_target:=Form[$Obj_context.typeForm()][$Obj_context.tableNum()]
		
		  //If ($Obj_target.actions#Null)
		  //$Dir_actions:=_o_Pathname ("host_actions")
		
		  //For each ($o;$Obj_target.actions)
		
		  //If ($o.icon#Null)
		  //If (String($o.icon)[[1]]="/")  // User action
		  //$t:=$Dir_actions+Convert path POSIX to system(Delete string($o.icon;1;1))
		
		  //If (Test path name($t)#Is a document)
		  //$t:=$File_noIcon
		
		  // End if
		
		  //Else   // Embedded action
		
		  //$t:=Get 4D folder(Current resources folder)+"images"+Folder separator+"actions"+Folder separator+$o.icon
		
		  //If (Test path name($t)#Is a document)
		  //$t:=$File_noIcon
		
		  // End if
		  // End if
		
		  // Else
		
		  //$t:=$File_noIcon
		
		  // End if
		
		  //READ PICTURE FILE($t;$p)
		  //CREATE THUMBNAIL($p;$p;24;24)
		  //SVG_SET_ID (SVG_New_embedded_image ($Svg_root;$p;$l;0);String($o.name))
		
		  //$l:=$l+26
		
		  // End for each
		
		  // Else
		
		  //  // <NOTHING MORE TO DO>
		
		  // End if
		
		  //SVG EXPORT TO PICTURE($Svg_root;$p;Own XML data source)
		$Obj_out.pict:=$p
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Txt_action+"\"")
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End