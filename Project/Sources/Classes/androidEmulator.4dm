/*
Android Emulator usage: emulator [options] [-qemu args]
options:
-list-avds                             list available AVDs
-sysdir <dir>                          search for system disk images in <dir>
-system <file>                         read initial system image from <file>
-vendor <file>                         read initial vendor image from <file>
-writable-system                       make system & vendor image writable after 'adb remount'
-delay-adb                             delay adb communication till boot completes
-datadir <dir>                         write user data into <dir>
-kernel <file>                         use specific emulated kernel
-ramdisk <file>                        ramdisk image (default <system>/ramdisk.img
-image <file>                          obsolete, use -system <file> instead
-initdata <file>                       same as '-init-data <file>'
-data <file>                           data image (default <datadir>/userdata-qemu.img
-encryption-key <file>                 read initial encryption key image from <file>
-logcat-output <file>                  output file of logcat(default none)
-partition-size <size>                 system/data partition size in MBs
-cache <file>                          cache partition image (default is temporary file)
-cache-size <size>                     cache partition size in MBs
-no-cache                              disable the cache partition
-nocache                               same as -no-cache
-sdcard <file>                         SD card image (default <datadir>/sdcard.img
-quit-after-boot <timeout>             quit emulator after guest boots completely, or after timeout in seconds
-snapstorage <file>                    file that contains all state snapshots (default <datadir>/snapshots.img)
-no-snapstorage                        do not mount a snapshot storage file (this disables all snapshot functionality)
-snapshot <name>                       name of snapshot within storage file for auto-start and auto-save (default 'default-boot')
-no-snapshot                           perform a full boot and do not auto-save, but qemu vmload and vmsave operate on snapstorage
-no-snapshot-save                      do not auto-save to snapshot on exit: abandon changed state
-no-snapshot-load                      do not auto-start from snapshot: perform a full boot
-snapshot-list                         show a list of available snapshots
-no-snapshot-update-time               do not try to correct snapshot time on restore
-wipe-data                             reset the user data image (copy it from initdata)
-avd <name>                            use a specific android virtual device
-skindir <dir>                         search skins in <dir> (default <system>/skins)
-skin <name>                           select a given skin
-no-skin                               deprecated: create an AVD with no skin instead
-noskin                                same as -no-skin
-memory <size>                         physical RAM size in MBs
-ui-only <UI feature>                  run only the UI feature requested
-cores <number>                        Set number of CPU cores to emulator
-accel <mode>                          Configure emulation acceleration
-no-accel                              Same as '-accel off'

-ranchu                                Use new emulator backend instead of the classic one

-engine <engine>                       Select engine. auto|classic|qemu2
-netspeed <speed>                      maximum network download/upload speeds
-netdelay <delay>                      network latency emulation
-netfast                               disable network shaping
-code-profile <name>                   enable code profiling
-show-kernel                           display kernel messages
-shell                                 enable root shell on current terminal
-no-jni                                disable JNI checks in the Dalvik runtime
-nojni                                 same as -no-jni
-logcat <tags>                         enable logcat output with given tags
-no-audio                              disable audio support
-noaudio                               same as -no-audio
-audio <backend>                       use specific audio backend
-radio <device>                        redirect radio modem interface to character device
-port <port>                           TCP port that will be used for the console
-ports <consoleport>,<adbport>         TCP ports used for the console and adb bridge
-onion <image>                         use overlay PNG image over screen
-onion-alpha <%age>                    specify onion-skin translucency
-onion-rotation 0|1|2|3                specify onion-skin rotation
-dpi-device <dpi>                      specify device's resolution in dpi (default 165)
-scale <scale>                         scale emulator window (deprecated)
-wifi-client-port <port>               connect to other emulator for WiFi forwarding
-wifi-server-port <port>               listen to other emulator for WiFi forwarding
-http-proxy <proxy>                    make TCP connections through a HTTP/HTTPS proxy
-timezone <timezone>                   use this timezone instead of the host's default
-dns-server <servers>                  use this DNS server(s) in the emulated system
-net-tap <interface>                   use this TAP interface for networking
-net-tap-script-up <script>            script to run when the TAP interface goes up
-net-tap-script-down <script>          script to run when the TAP interface goes down
-cpu-delay <cpudelay>                  throttle CPU emulation
-no-boot-anim                          disable animation for faster boot
-no-window                             disable graphical window display
-no-sim                                device has no SIM card
-lowram                                device is a low ram device
-version                               display emulator version number
-no-passive-gps                        disable passive gps updates
-read-only                             allow running multiple instances of emulators on the same AVD, but cannot save snapshot.
-is-restart <restart-pid>              specifies that this emulator was a restart, and to wait out <restart-pid> before proceeding
-report-console <socket>               report console port to remote socket
-gps <device>                          redirect NMEA GPS to character device
-shell-serial <device>                 specific character device for root shell
-tcpdump <file>                        capture network packets to file
-bootchart <timeout>                   enable bootcharting
-charmap <file>                        use specific key character map
-studio-params <file>                  used by Android Studio to provide parameters
-prop <name>=<value>                   set system property on boot
-shared-net-id <number>                join the shared network, using IP address 10.1.2.<number>
-nand-limits <nlimits>                 enforce NAND/Flash read/write thresholds
-gpu <mode>                            set hardware OpenGLES emulation mode
-camera-back <mode>                    set emulation mode for a camera facing back
-camera-front <mode>                   set emulation mode for a camera facing front
-webcam-list                           lists web cameras available for emulation
-virtualscene-poster <name>=<filename> Load a png or jpeg image as a poster in the virtual scene
-screen <mode>                         set emulated screen mode
-force-32bit                           always use 32-bit emulator
-selinux <disabled|permissive>         Set SELinux to either disabled or permissive mode
-unix-pipe <path>                      Add <path> to the list of allowed Unix pipes

-fixed-scale                           Use fixed 1:1 scale for the initial emulator window.

-wait-for-debugger                     Pause on launch and wait for a debugger process to attach before resuming
-skip-adb-auth                         Skip adb authentication dialogue
-metrics-to-console                    Enable usage metrics and print the messages to stdout
-metrics-to-file <file>                Enable usage metrics and write the messages into specified file
-detect-image-hang                     Enable the detection of system image hangs.
-feature <name|-name>                  Force-enable or disable (-name) the features

-sim-access-rules-file <file>          Use SIM access rules from specified file

-phone-number <phone_number>           Sets the phone number of the emulated device
-acpi-config <file>                    specify acpi device proprerties (hierarchical key=value pair)
-fuchsia                               Run Fuchsia image. Bypasses android-specific setup; args after are treated as standard QEMU args
-allow-host-audio                      Allows sending of audio from audio input devices. Otherwise, zeroes out audio.
-restart-when-stalled                  Allows restarting guest when it is stalled.
-perf-stat <file>                      Run periodic perf stat reporter in the background and write output to specified file.
-grpc <port>                           TCP ports used for the gRPC bridge

-qemu args...                         pass arguments to qemu
-qemu -h                              display qemu help

-verbose                              same as '-debug-init'
-debug <tags>                         enable/disable debug messages
-debug-<tag>                          enable specific debug messages
-debug-no-<tag>                       disable specific debug messages

-help                                 print this help
-help-<option>                        print option-specific help

-help-disk-images                     about disk images
-help-debug-tags                      debug tags for -debug <tags>
-help-char-devices                    character <device> specification
-help-environment                     environment variables
-help-virtual-device                  virtual device management
-help-sdk-images                      about disk images when using the SDK
-help-build-images                    about disk images when building Android
-help-all                             prints all help content
*/

// https://developer.android.com/studio/run/emulator-commandline

Class extends androidProcess

//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	var $o; $options : Object
	var $c : Collection
	var $file : 4D:C1709.File
	
	Super:C1705()
	
	This:C1470.exe:=This:C1470.androidSDKFolder().file("emulator/emulator"+Choose:C955(Is Windows:C1573; ".exe"; ""))
	This:C1470.cmd:=This:C1470.exe.path
	
	This:C1470.version:=This:C1470.getVersion()
	
	// Search the user's database first
	$file:=File:C1566("/RESOURCES/android.json"; *)
	
	If ($file.exists)
		
		$o:=JSON Parse:C1218($file.getText())
		
		If ($o.emulatorOptions#Null:C1517)
			
			$options:=$o.emulatorOptions
			
		End if 
	End if 
	
	If ($options=Null:C1517)
		
		// Use defaults from the component
		$options:=JSON Parse:C1218(File:C1566("/RESOURCES/android.json").getText()).emulatorOptions
		
	End if 
	
	$c:=New collection:C1472
	
	For each ($o; OB Entries:C1720($options))
		
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($o.value)=Is text:K8:3)
				
				$c.push($o.key+" "+$o.value)
				
				//______________________________________________________
			: (Value type:C1509($o.value)=Is boolean:K8:9)
				
				If ($o.value)
					
					$c.push($o.key)
					
				End if 
				
				//______________________________________________________
			Else 
				
				$c.push($o.key+" "+String:C10($o.value))
				
				//______________________________________________________
		End case 
	End for each 
	
	This:C1470.options:=" -"+$c.join(" -")
	
	This:C1470.bootTimeOut:=6000  // 1 minutes
	
	This:C1470.adb:=cs:C1710.adb.new()
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the current version of the emulator tool
Function getVersion()->$version : Text
	
	This:C1470.launch(This:C1470.cmd; "-version")
	
	ARRAY LONGINT:C221($pos; 0x0000)
	ARRAY LONGINT:C221($len; 0x0000)
	
	If (Match regex:C1019("(?m-si)\\sversion\\s([\\d\\.]+)\\s\\(build_id\\s(\\d+)"; This:C1470.outputStream; 1; $pos; $len))
		
		$version:=Substring:C12(This:C1470.outputStream; $pos{1}; $len{1})
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the list of emulators names available in the "avd manager"
Function available()->$emulators : Collection
	
	If (This:C1470.launch(This:C1470.cmd; "-list-avds").success)
		
		$emulators:=Split string:C1554(This:C1470.outputStream; "\n"; sk ignore empty strings:K86:1)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Start (& wait) an emulator by name
Function start($avdName : Text; $wait : Boolean)->$result : Object
	
	$result:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	If ($avdName="Pixel_4")  // Default avd
		
		This:C1470.launchAsync(This:C1470.cmd+" -avd "+This:C1470.quoted($avdName)+" -skin pixel_4 -skindir "+This:C1470.quoted(This:C1470.androidSDKFolder().folder("skins").path)+This:C1470.options)
		
	Else 
		
		This:C1470.launchAsync(This:C1470.cmd+" -avd "+$avdName+" -memory 512 -no-boot-anim")
		
	End if 
	
	If (This:C1470.success)
		
		If (Count parameters:C259>=2)
			
			var $startTime : Integer
			var $isBooted : Boolean
			$startTime:=Milliseconds:C459
			
			Repeat 
				
				$isBooted:=This:C1470.isBooted($avdName)
				
				If (Not:C34($isBooted))
					
					IDLE:C311
					DELAY PROCESS:C323(Current process:C322; 120)
					
					$isBooted:=This:C1470.isBooted($avdName)
					
				End if 
			Until ($isBooted) | (Milliseconds:C459-$startTime>This:C1470.bootTimeOut)
			
			If ($isBooted)
				
				$result.success:=True:C214
				$result.serial:=This:C1470.adb.serialFromName($avdName)
				
			Else 
				
				// Timeout
				$result.errors.push("(timeout reached when starting the emulator)")
				
			End if 
			
			This:C1470.bringToFront(This:C1470.pid)
			
		Else 
			
			$result.success:=True:C214
			
		End if 
		
		
	Else 
		
		$result.errors.push("Failed to start "+$avdName)
		$result.errors.combine(Split string:C1554(String:C10(This:C1470.errorStream); "\n"))
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns true if the emulator is launched
Function isBooted($avdName : Text)->$booted : Boolean
	
	$booted:=(This:C1470.adb.availableDevices().indexOf($avdName)>=0)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Bringing the Emulator to the forefront
Function bringToFront()
	
	//je ne sais pas comment faire pour le moment
	