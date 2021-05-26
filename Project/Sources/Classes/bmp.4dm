Class constructor($picture : Picture)
	
	This:C1470.data:=Null:C1517
	This:C1470.header:=Null:C1517
	This:C1470.success:=False:C215
	This:C1470.error:=""
	
	This:C1470.codec:="com.microsoft.bmp"
	
	If (Count parameters:C259>=1)
		
		This:C1470.setPicture($picture)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setPicture($picture : Picture)
	
	var $data : Blob
	
	// Remove white
	TRANSFORM PICTURE:C988($picture; Transparency:K61:11; 0x00FFFFFF)
	
	// Remove black
	TRANSFORM PICTURE:C988($picture; Transparency:K61:11; 0x0000)
	
	CREATE THUMBNAIL:C679($picture; $picture; 128; 128)  // Could be 32x32
	
	// Transform as bitmap
	PICTURE TO BLOB:C692($picture; $data; This:C1470.codec)
	
	This:C1470.success:=Bool:C1537(OK)
	
	If (This:C1470.success)
		
		This:C1470.data:=$data
		This:C1470.header:=This:C1470.getHeader()
		
	Else 
		
		This:C1470.error:="The converter for \""+This:C1470.codec+"\" is not available"
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getMediumColor()->$color : Integer
	
	var $i; $pixels : Integer
	var $hsl; $map; $rgb : Object
	var $ƒ : cs:C1710.color
	
	$map:=This:C1470.getBitmap()
	
	If ($map#Null:C1517)
		
		$rgb:=New object:C1471(\
			"red"; 0; \
			"green"; 0; \
			"blue"; 0)
		
		$pixels:=$map.red.length
		
		//%R-
		For ($i; 0; $pixels-1; 1)
			
			If (Num:C11($map.alpha[$i])=255)
				
				$rgb.red:=$rgb.red+$map.red[$i]
				$rgb.green:=$rgb.green+$map.green[$i]
				$rgb.blue:=$rgb.blue+$map.blue[$i]
				
			End if 
		End for 
		//%R+
		
		$rgb.red:=$rgb.red\$pixels
		$rgb.green:=$rgb.green\$pixels
		$rgb.blue:=$rgb.blue\$pixels
		
		$ƒ:=cs:C1710.color.new()
		
		$hsl:=$ƒ.rgbToHSL($rgb)
		
		If ($hsl.hue#0)\
			 | ($hsl.saturation#0)
			
			Case of 
					
					//…………………………………………………………
				: ($hsl.hue=0)
					
					If ($hsl.lightness>70)
						
						$hsl.lightness:=70
						
					End if 
					
					//…………………………………………………………
				: ($hsl.saturation<40)
					
					$hsl.saturation:=40
					
					//…………………………………………………………
				Else 
					
					//…………………………………………………………
			End case 
			
			If ($hsl.lightness>80)
				
				$hsl.lightness:=80
				
			End if 
		End if 
		
		If ($hsl.saturation<40)
			
			$hsl.saturation:=40
			
		End if 
		
		$color:=$ƒ.hslToColor($hsl)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getDominantColor($accuracy : Integer)->$color : Integer
	
	var $_accuracy; $i; $pixels : Integer
	var $hsl; $map; $rgb : Object
	var $c : Collection
	var $ƒ : cs:C1710.color
	
	$_accuracy:=4  // Look at 1 pixel out of 4
	
	If (Count parameters:C259>=1)
		
		$_accuracy:=$accuracy
		
	End if 
	
	$map:=This:C1470.getBitmap()
	
	If ($map#Null:C1517)
		
		$rgb:=New object:C1471(\
			"red"; 0; \
			"green"; 0; \
			"blue"; 0)
		
		$pixels:=$map.red.length
		$c:=New collection:C1472.resize($pixels)
		
		//%R-
		For ($i; 0; $pixels-1; $_accuracy)
			
			If (Num:C11($map.alpha[$i])=255)
				
				$color:=($map.red[$i] << 16)+($map.green[$i] << 8)+$map.blue[$i]
				
				Case of 
						
						//______________________________________________________
					: ($color=0x00FFFFFF)
						
						// White
						
						//______________________________________________________
					: ($color=0x0000)
						
						// Black
						
						//______________________________________________________
					: ($map.red[$i]=$map.green[$i])\
						 & ($map.green[$i]=$map.blue[$i])
						
						// Grey
						
						//______________________________________________________
					Else 
						
						var $o : Object
						$o:=$c.query("color = :1"; $color).pop()
						
						If ($o=Null:C1517)
							
							$c.push(New object:C1471(\
								"color"; $color; \
								"weight"; 1))
							
						Else 
							
							$o.weight:=$o.weight+1
							
						End if 
						
						//______________________________________________________
				End case 
			End if 
		End for 
		//%R+
		
		$c:=$c.query("!= null")
		
		If ($c.length>0)
			
			$c:=$c.orderBy("weight desc")
			$color:=$c[0].color
			$ƒ:=cs:C1710.color.new()
			$hsl:=$ƒ.colorToHSL($color)
			
			If ($hsl.saturation<50)
				
				$hsl.saturation:=50
				
			End if 
			
			If ($hsl.lightness<50)
				
				$hsl.lightness:=50
				
			Else 
				
				If ($hsl.lightness>97)
					
					$hsl.lightness:=97
					
				Else 
					
					
					
				End if 
				
			End if 
			
			$color:=$ƒ.hslToColor($hsl)
			
		Else 
			
			$color:=0x0000
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getBitmap()->$map : Object
	
	If (This:C1470._isOK())
		
		$map:=New object:C1471
		
		var $header : Object
		$header:=This:C1470.header
		
		var $pixels : Integer
		$pixels:=$header.pixelNumber-1
		$map.red:=New collection:C1472.resize($pixels; 0x00FF)
		$map.blue:=New collection:C1472.resize($pixels; 0x00FF)
		$map.green:=New collection:C1472.resize($pixels; 0x00FF)
		
		var $withAlpha : Boolean
		$withAlpha:=($header.pixelSize=4)
		
		If ($withAlpha)
			
			$map.alpha:=New collection:C1472.resize($pixels; 0x00FF)
			
		End if 
		
		var $x; $y; $offset; $pixel : Integer
		$x:=$header.x
		$y:=$header.y
		$offset:=$header.startOffset
		
		var $data : Blob
		$data:=This:C1470.data
		
		//%R-
		For ($y; Choose:C955($header.lineShift=1; 0; $header.height-1); Choose:C955($header.lineShift=1; $header.height-1; 0); $header.lineShift)
			
			$pixel:=$y*$header.width
			
			For ($x; 0; $header.width-1; 1)
				
				$map.blue[$pixel]:=$data{$offset}
				$map.green[$pixel]:=$data{$offset+1}
				$map.red[$pixel]:=$data{$offset+2}
				
				If ($withAlpha)
					
					$map.alpha[$pixel]:=$data{$offset+3}
					
				End if 
				
				$pixel:=$pixel+1
				$offset:=$offset+$header.pixelSize
				
			End for 
			
			$offset:=$offset+$header.padding
			
		End for 
		//%R+
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getHeader()->$header : Object
	
	var $data : Blob
	$data:=This:C1470.data
	
	$header:=New object:C1471
	
	// UINT16 File Type = 'BM'
	var $offset : Integer
	This:C1470.success:=(0x4D42=BLOB to integer:C549($data; PC byte ordering:K22:3; $offset))
	
	If (This:C1470.success)
		
		// UINT32 Size of File (in bytes)
		var $fileSize : Integer
		$fileSize:=BLOB to longint:C551($data; PC byte ordering:K22:3; $offset)
		This:C1470.success:=(BLOB size:C605($data)=$fileSize)
		
		If (This:C1470.success)
			
			// INT16 Reserved Field(1)
			// INT16 Reserved Field(2)
			var $offset : Integer
			$offset:=0x000A
			
			// UINT32 Starting Position of Image Data (offset in bytes)
			var $startOffset : Integer
			$startOffset:=BLOB to longint:C551($data; PC byte ordering:K22:3; $offset)
			
			// UINT32 Header size
			var $headerSize : Integer
			$headerSize:=BLOB to longint:C551($data; PC byte ordering:K22:3; $offset)
			
			// UINT32 Picture width
			var $width : Integer
			$width:=BLOB to longint:C551($data; PC byte ordering:K22:3; $offset)
			This:C1470.success:=($width>0)
			
			If (This:C1470.success)
				
				// UINT32 Picture height
				var $height : Integer
				$height:=BLOB to longint:C551($data; PC byte ordering:K22:3; $offset)
				This:C1470.success:=($height#0)
				
				If (This:C1470.success)
					
					// INT16 Planes
					var $planes : Integer
					$planes:=BLOB to integer:C549($data; PC byte ordering:K22:3; $offset)
					This:C1470.success:=($planes=1)
					
					If (This:C1470.success)
						
						// INT16 Color depth
						var $colorDepth : Integer
						$colorDepth:=BLOB to integer:C549($data; PC byte ordering:K22:3; $offset)
						This:C1470.success:=($colorDepth=24) | ($colorDepth=32)
						
						If (This:C1470.success)
							
							var $isTopToBottom : Boolean
							$isTopToBottom:=($height<0)
							
							var $y; $lineShift : Integer
							If ($isTopToBottom)
								
								// In a top to bottom bmp, the first pixel is on the top left,
								// the next one is on its left and we go down the lines
								$y:=1
								$lineShift:=1
								$height:=-$height
								
							Else 
								
								// In a bottom to top bmp, the first pixel is at the bottom left,
								// the next one is on its left and we go up the lines
								$y:=$height
								$lineShift:=-1
								
							End if 
							
							var $padding; $pixelSize; $lineSizeBytes; $expectefFilesize : Integer
							$padding:=Choose:C955($colorDepth=32; 0; $width%4)
							$pixelSize:=$colorDepth >> 3
							$lineSizeBytes:=($width*$pixelSize)+$padding
							$expectefFilesize:=$startOffset+($lineSizeBytes*$height)
							This:C1470.success:=(BLOB size:C605($data)=$expectefFilesize)
							
							If (This:C1470.success)
								
								var $dataSize : Integer
								$dataSize:=$fileSize-$startOffset
								
								$header:=New object:C1471(\
									"size"; $headerSize; \
									"x"; 0; \
									"y"; $y; \
									"width"; $width; \
									"height"; $height; \
									"nbPixel"; ($dataSize-($padding*$height))\$pixelSize; \
									"lineShift"; $lineShift; \
									"planes"; $planes; \
									"colorDepth"; $colorDepth; \
									"pixelNumber"; $width*Abs:C99($height); \
									"pixelSize"; $pixelSize; \
									"padding"; $padding; \
									"startOffset"; $startOffset; \
									"topToBottom"; $isTopToBottom)
								
							Else 
								
								This:C1470.error:="Unexepected file size : "+String:C10($expectefFilesize)
								
							End if 
							
						Else 
							
							This:C1470.error:="Unexepected color depth : "+String:C10($colorDepth)
							
						End if 
						
					Else 
						
						This:C1470.error:="Unexepected planes count : "+String:C10($planes)
						
					End if 
					
				Else 
					
					This:C1470.error:="Invalid bmp height : "+String:C10($height)
					
				End if 
				
			Else 
				
				This:C1470.error:="Invalid bmp width : "+String:C10($width)
				
			End if 
			
		Else 
			
			This:C1470.error:="Unexpected data size"
			
		End if 
		
	Else 
		
		This:C1470.error:="Unexpected signature"
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _isOK()->$ok : Boolean
	
	Case of 
			//______________________________________________________
		: (This:C1470.data=Null:C1517)
			
			This:C1470.error:="The picture was not initialized"
			
			//______________________________________________________
		: (Not:C34(This:C1470.success))
			
			// <NOTHING MORE TO DO>
			
			//______________________________________________________
		Else 
			
			$ok:=True:C214
			
			//______________________________________________________
	End case 
	