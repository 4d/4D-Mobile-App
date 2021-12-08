//%attributes = {"invisible":true}
// ----------------------------------------------------
// DATA pannel management
// ----------------------------------------------------
// Declarations
var $e; $ƒ : Object

// ----------------------------------------------------
// Initialisations
$ƒ:=panel_Load

// ----------------------------------------------------
If (FORM Event:C1606.objectName=Null:C1517)  // <== FORM METHOD
	
	$e:=panel_Common(On Load:K2:1; On Timer:K2:25)
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Load:K2:1)
			
			$ƒ.onLoad()
			
			//______________________________________________________
		: ($e.code=On Timer:K2:25)
			
			$ƒ.update()
			
			//______________________________________________________
	End case 
	
Else   // <== WIDGETS METHOD
	
	$e:=$ƒ.event
	
	Case of 
			
			//==============================================
		: ($ƒ.list.catch())
			
			Case of 
					
					//______________________________________________________
				: ($e.code=On Getting Focus:K2:7)
					
					//$context.listboxUI()
					
					//______________________________________________________
				: ($e.code=On Mouse Enter:K2:33)
					
					//______________________________________________________
				: ($e.code=On Losing Focus:K2:8)
					
					//$context.listboxUI()
					
					//$context.tables:=$context.tables
					
					//______________________________________________________
				: ($e.code=On Selection Change:K2:29)
					
					$ƒ.lastIndex:=$ƒ.index
					
					$ƒ.current:=$ƒ.tables[$ƒ.index-Num:C11($ƒ.index>0)]
					
					$ƒ.refresh()
					
					//______________________________________________________
				: ($e.code=On Mouse Enter:K2:33) & Not:C34(FEATURE.with("cancelableDatasetGeneration"))
					
					//_o_UI.tips.enable()
					//_o_UI.tips.instantly()
					
					//______________________________________________________
				: ($e.code=On Mouse Move:K2:35) & Not:C34(FEATURE.with("cancelableDatasetGeneration"))
					
					
					
					//______________________________________________________
				: ($e.code=On Mouse Leave:K2:34) & Not:C34(FEATURE.with("cancelableDatasetGeneration"))
					
					//_o_UI.tips.defaultDelay()
					
					//______________________________________________________
				: (PROJECT.isLocked())
					
					// NOTHING MORE TO DO
					
					//______________________________________________________
				: (FEATURE.with("cancelableDatasetGeneration"))
					
					
					//______________________________________________________
				Else 
					
					ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
					
					//______________________________________________________
			End case 
			
			//________________________________________
	End case 
End if 