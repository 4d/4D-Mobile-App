Class constructor($title : Text)
	
	This:C1470.title:=""
	This:C1470.message:=""
	This:C1470.stopTitle:=""
	This:C1470.isForeground:=True:C214
	This:C1470.icon:=Null:C1517
	This:C1470.progress:=0
	This:C1470.stopEnabled:=False:C215
	This:C1470.stopped:=False:C215
	This:C1470.delay:=0
	This:C1470.start:=Tickcount:C458
	This:C1470.isVisible:=True:C214
	
	// Unfortunately there is no way to create an invisible progress
	var $id : Integer
	EXECUTE METHOD:C1007("Progress New"; $id)
	This:C1470.id:=$id
	
	If (Count parameters:C259>=1)
		
		This:C1470.setTitle($title)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function setDelay($tiks : Integer) : cs:C1710.progress
	
	This:C1470.hide()
	
	This:C1470.delay:=$tiks
	This:C1470.start:=Tickcount:C458
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function update()
	
	If (Not:C34(This:C1470.isVisible))\
		 && ((Tickcount:C458-This:C1470.start)>This:C1470.delay)
		
		This:C1470.show()
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function show($visible : Boolean; $foreground : Boolean) : cs:C1710.progress
	
	This:C1470.isVisible:=Count parameters:C259>=1 ? $visible : True:C214
	This:C1470.isForeground:=Count parameters:C259>=2 ? $foreground : This:C1470.isForeground
	
	EXECUTE METHOD:C1007("Progress SET WINDOW VISIBLE"; Null:C1517; This:C1470.isVisible; -1; -1; This:C1470.isForeground)
	
	This:C1470.isStopped()
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function bringToFront() : cs:C1710.progress
	
	This:C1470.isForeground:=True:C214
	This:C1470.visible:=True:C214
	
	EXECUTE METHOD:C1007("Progress SET WINDOW VISIBLE"; Null:C1517; This:C1470.visible; -1; -1; This:C1470.isForeground)
	
	This:C1470.isStopped()
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function hide() : cs:C1710.progress
	
	This:C1470.show(False:C215)
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function close()
	
	EXECUTE METHOD:C1007("Progress QUIT"; Null:C1517; This:C1470.id)
	
	// === === === === === === === === === === === === === === === === === === ===
Function setTitle($title : Text) : cs:C1710.progress
	
	This:C1470.title:=This:C1470._localize($title)
	EXECUTE METHOD:C1007("Progress SET TITLE"; Null:C1517; This:C1470.id; This:C1470.title)
	
	This:C1470.isStopped()
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function setMessage($message : Text; $foreground : Boolean) : cs:C1710.progress
	
	This:C1470.message:=This:C1470._localize($message)
	This:C1470.isForeground:=Count parameters:C259>=2 ? $foreground : This:C1470.isForeground
	
	EXECUTE METHOD:C1007("Progress SET MESSAGE"; Null:C1517; This:C1470.id; This:C1470.message; This:C1470.isForeground)
	
	This:C1470.isStopped()
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function _localize($message : Text) : Text
	
	var $localized : Text
	
	//%W-533.1
	If (Length:C16($message)=0)\
		 || (Length:C16($message)>255)\
		 || ($message[[1]]=Char:C90(1))
		
		return $message
		
	End if 
	//%W+533.1
	
	$localized:=Get localized string:C991($message)
	return Length:C16($localized)>0 ? $localized : $message  // Revert if no localization
	
	// === === === === === === === === === === === === === === === === === === ===
Function setProgress($progress; $foreground : Boolean) : cs:C1710.progress
	
	If (Value type:C1509($progress)=Is text:K8:3)
		
		Case of 
				
				//______________________________________________________
			: ($progress="barber@")\
				 | ($progress="undefined")
				
				This:C1470.progress:=-1
				
				//______________________________________________________
			Else 
				
				This:C1470.progress:=Num:C11($progress)
				
				//______________________________________________________
		End case 
		
	Else 
		
		This:C1470.progress:=Num:C11($progress)
		
	End if 
	
	If (Count parameters:C259>=2)
		
		This:C1470.isForeground:=$foreground
		
	End if 
	
	EXECUTE METHOD:C1007("Progress SET PROGRESS"; Null:C1517; This:C1470.id; This:C1470.progress; This:C1470.message; This:C1470.isForeground)
	
	This:C1470.isStopped()
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function setIcon($icon : Picture; $foreground : Boolean) : cs:C1710.progress
	
	This:C1470.icon:=$icon
	
	If (Count parameters:C259>=2)
		
		EXECUTE METHOD:C1007("Progress SET ICON"; Null:C1517; This:C1470.id; This:C1470.icon; $foreground)
		
	Else 
		
		EXECUTE METHOD:C1007("Progress SET ICON"; Null:C1517; This:C1470.id; This:C1470.icon)
		
	End if 
	
	This:C1470.isStopped()
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function setPosition($x : Integer; $y : Integer; $foreground : Boolean) : cs:C1710.progress
	
	If (Count parameters:C259>=2)
		
		This:C1470.x:=$x
		This:C1470.y:=$y
		
		This:C1470.isForeground:=Count parameters:C259>=3 ? $foreground : This:C1470.isForeground
		
		EXECUTE METHOD:C1007("Progress SET WINDOW VISIBLE"; Null:C1517; This:C1470.visible; This:C1470.x; This:C1470.y; This:C1470.isForeground)
		
	Else 
		
		This:C1470.x:=$x
		EXECUTE METHOD:C1007("Progress SET WINDOW VISIBLE"; Null:C1517; This:C1470.visible; This:C1470.x; -1; This:C1470.isForeground)
		
	End if 
	
	This:C1470.isStopped()
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function showStop($show : Boolean) : cs:C1710.progress
	
	If (Count parameters:C259>=1)
		
		This:C1470.stopEnabled:=$show
		
	Else 
		
		// Default is True
		This:C1470.stopEnabled:=True:C214
		
	End if 
	
	EXECUTE METHOD:C1007("Progress SET BUTTON ENABLED"; Null:C1517; This:C1470.id; This:C1470.stopEnabled)
	
	This:C1470.isStopped()
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function hideStop() : cs:C1710.progress
	
	This:C1470.showStop(False:C215)
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function setStopTitle($title : Text) : cs:C1710.progress
	
	This:C1470.stopTitle:=$title || "Stop"
	EXECUTE METHOD:C1007("Progress SET BUTTON TITLE"; Null:C1517; This:C1470.id; This:C1470.stopTitle)
	
	This:C1470.isStopped()
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function isStopped() : Boolean
	var $stopped : Boolean
	EXECUTE METHOD:C1007("Progress Stopped"; $stopped; This:C1470.id)
	This:C1470.stopped:=$stopped
	return This:C1470.stopped
	
	// === === === === === === === === === === === === === === === === === === ===
Function forEach($target; $formula : Object; $keep : Boolean) : cs:C1710.progress
	
	var $i; $size : Integer
	var $v : Variant
	var $t : Text
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($target)=Is collection:K8:32)
			
			This:C1470.setProgress(0)
			$size:=$target.length
			
			//______________________________________________________
		: (Value type:C1509($target)=Is object:K8:27)
			
			This:C1470.setProgress(0)
			
			$size:=OB Entries:C1720($target).length
			
			//______________________________________________________
		Else 
			
			This:C1470.setProgress(-1)  // Barber shop
			
			//______________________________________________________
	End case 
	
	If (This:C1470.stopEnabled)  // The progress has a Stop button
		
		This:C1470.stopped:=False:C215
		
		// As long as progress is not stopped...
		For each ($v; $target) While (Not:C34(This:C1470.stopped))
			
			This:C1470.update()
			
			If (Not:C34(This:C1470.isStopped()))
				
				$i+=1
				$t:=String:C10($formula.call(Null:C1517; $v; $target; $i))
				
				If ($size#0)
					
					This:C1470.setProgress($i/$size)
					
				End if 
				
				If (Length:C16($t)>0)
					
					This:C1470.setMessage($t)
					
				End if 
				
			Else 
				
				// The user clicks on Stop
				This:C1470.hideStop()
				
			End if 
		End for each 
		
	Else 
		
		This:C1470.stopped:=False:C215
		
		For each ($v; $target)
			
			This:C1470.update()
			
			$i+=1
			$t:=String:C10($formula.call(Null:C1517; $v; $target; $i))
			
			If ($size#0)
				
				This:C1470.setProgress($i/$size)
				
			End if 
			
			If (Length:C16($t)>0)
				
				This:C1470.setMessage($t)
				
			End if 
		End for each 
		
	End if 
	
	If ($keep)
		
		This:C1470.setProgress(-1).setMessage("")
		
	Else 
		
		This:C1470.close()
		
	End if 
	
	return This:C1470