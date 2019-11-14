//%attributes = {"invisible":true,"preemptive":"incapable"}
  // Returns informations from the host database and useful methods
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($l)
C_TEXT:C284($t)
C_OBJECT:C1216($o)

If (False:C215)
	C_OBJECT:C1216(database ;$0)
	C_TEXT:C284(database ;$1)
	C_OBJECT:C1216(database ;$2)
End if 

If (This:C1470[""]=Null:C1517)  // Constructor
	
	$o:=New shared object:C1526(\
		"";"database";\
		"structure";File:C1566(Structure file:C489(*);fk platform path:K87:2);\
		"isCompiled";Is compiled mode:C492(*);\
		"isInterpreted";Not:C34(Is compiled mode:C492(*));\
		"data";File:C1566(Data file:C490;fk platform path:K87:2);\
		"locked";Is data file locked:C716;\
		"isDatabase";False:C215;\
		"isProject";False:C215;\
		"isMatrix";Structure file:C489=Structure file:C489(*);\
		"isRemote";Application type:C494=4D Remote mode:K5:5;\
		"parameters";Null:C1517;\
		"components";New shared collection:C1527;\
		"plugins";New shared collection:C1527;\
		"enableDebugLog";Formula:C1597(SET DATABASE PARAMETER:C642(Debug log recording:K37:34;1));\
		"disableDebugLog";Formula:C1597(SET DATABASE PARAMETER:C642(Debug log recording:K37:34;0));\
		"method";Formula:C1597(database ("methodExists";New object:C1471("method";$1)));\
		"clearCompiledCode";Formula:C1597(This:C1470.structure.parent.folder("DerivedData/CompiledCode").delete(Delete with contents:K24:24));\
		"componentAvailable";Formula:C1597(This:C1470.components.indexOf($1)#-1);\
		"pluginAvailable";Formula:C1597(This:C1470.plugins.indexOf($1)#-1)\
		)
	
	Use ($o)
		
		$o.isProject:=Bool:C1537(Get database parameter:C643(113))
		$o.isDatabase:=Not:C34($o.isProject)
		
		$l:=Get database parameter:C643(User param value:K37:94;$t)
		
		Case of 
				
				  //______________________________________________________
			: (Length:C16($t)=0)
				
				  // <NOTHING MORE TO DO>
				
				  //______________________________________________________
			: (Match regex:C1019("(?m-si)^\\{.*\\}$";$t;1))  // json object
				
				$o.parameters:=JSON Parse:C1218($t)
				
				  //______________________________________________________
			: (Match regex:C1019("(?m-si)^\\[.*\\]$";$t;1))  // json array
				
				ARRAY TEXT:C222($tTxt_values;0x0000)
				JSON PARSE ARRAY:C1219($t;$tTxt_values)
				$o.parameters:=New collection:C1472
				ARRAY TO COLLECTION:C1563(This:C1470.parameters;$tTxt_values)
				
				  //______________________________________________________
			Else 
				
				$o.parameters:=$t
				
				  //______________________________________________________
		End case 
		
		ARRAY TEXT:C222($tTxt_components;0x0000)
		COMPONENT LIST:C1001($tTxt_components)
		
		Use ($o.components)
			
			ARRAY TO COLLECTION:C1563($o.components;$tTxt_components)
			
		End use 
		
		ARRAY LONGINT:C221($tLon_number;0x0000)
		ARRAY TEXT:C222($tTxt_plugins;0x0000)
		PLUGIN LIST:C847($tLon_number;$tTxt_plugins)
		
		Use ($o.plugins)
			
			ARRAY TO COLLECTION:C1563($o.plugins;$tTxt_plugins)
			
		End use 
		
		If ($o.isProject)
			
			If ($o.structure.parent.name="Project")
				
				  // Up one level
				$o.root:=$o.structure.parent.parent
				
			Else 
				
				$o.root:=$o.structure.parent
				
			End if 
			
		Else 
			
			If (Not:C34($o.isRemote))
				
				$o.root:=$o.structure.parent
				
			End if 
		End if 
	End use 
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="methodExists")
			
			$o.exists:=False:C215
			
			If (Asserted:C1132($2.method#Null:C1517;"missing name"))
				
				ARRAY TEXT:C222($tTxt_methods;0x0000)
				METHOD GET NAMES:C1166($tTxt_methods;*)
				
				$o.exists:=(Find in array:C230($tTxt_methods;String:C10($2.method))>0)
				
			End if 
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
			
			  //______________________________________________________
	End case 
End if 

$0:=$o