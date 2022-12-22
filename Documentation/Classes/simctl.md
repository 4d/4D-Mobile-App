# [sim]ULATOR [c]ON[t]RO[l]The `simctl` class provides you the interface you need to use and configure Simulator in a programmatic way.

If you have Xcode installed, `simctl` is accessible through the `xcrun` command (which routes binary executables to the active copy of Xcode on your system). You can get a description of the utility and a complete list of subcommands by running simctl without any arguments:

`$ xcrun simctl`

Many of the functions implemented by this class are self-explanatory and offer a simple interface to functionality accessible through the Simulator app itself.

> 📌 Not all subcommands are implemented as function, only the necessary commands for `4D for iOS` are packed in hight level functions. 
> 
> For instance, for the `.boot()` function
> 
> * If you don't give a device name or identifier, the default device is used.
> * The function test, at first, if the device is not already booted. If so, does nothing.
> * The function ensure that the Simulator Application is launched, if not open it and then launch the device.
> * An optional parameter allow to wait for the device is booted

## Summary

⚠️ `simctl` extends the <a href="lep.md">`lep`</a>class 

## Properties:

In addition of the class lep:

|Properties|Type|Description|Initial value|
|---------|:----:|------|:------:|
|**.simulatorTimeout**|Integer|The iOS simulator time out|**10000**|
|**.minimumVersion**|Text|The minimum ios deployment target|**""**|
|**.simulatorApp**|**4D**.Folder|The Simulator App bundle localisation|if Xcode is available|


## Functions:   
    
> 📌 Each device has an associated name and UUID, you can switch to either one or the other for any function that takes a `device` parameter.  If you omit it, the function applies to the the `default` device with 2 exceptions:   
> 
> - The `.deleteDevice()` function which will be performed on all devices.
> 
> - The "App" functions which will be performed on the `booted` device.  

 
### Device

|Functions|Action|
|--------|------|
|.**defaultDevice** ()  → device : `Object` | Returns (and set if any) the default device    
|.**setDefaultDevice** (udid : `Text`) | Set a default device from UUID 
|.**availableDevices** ({iosDeploymentTarget : `Text`})  → devices : `Collection` | List available devices (iPhone & iPad) according to the minimum iOS version target 
|.**bootedDevices** ()  → devices : `Collection` | List of started devices
|.**device** ({device : `Text`})  → device : `Object` | Returns a device object
|.**deviceFolder** ({device : `Text` {; data : Boolean}})  → folder : `4D.Folder` | Returns the device (data) folder
|.**deviceLog** ({device : `Text`})  → file : `4D.File` | Returns the device log file
|.**showDeviceLog** ({device : `Text`})| Shows on disk the device log file
|.**bootDevice** ({device : `Text`{; wait : Boolean}})| Start a device and wait if you wish
|.**shutdownDevice** ({device : `Text`{; wait : Boolean}})| Shutdown a device and wait if you wish
|.**isDeviceBooted** ({device : `Text`})  → booted : `Boolean` | Returns true if a device is booted
|.**isDeviceShutdown** ({device : `Text`})  → shutdown : `Boolean` | Returns true if a device is shutdown
|.**shutdownAllDevices** () | Stops all devices
|.**deleteDevice** ({device : `Text`}) |  Delete a device or all the devices if there is no parameter
|.**eraseDevice** ({device : `Text`}) |  Erase a device's contents and settings

### Simulator App

|Functions|Action|
|--------|------|
|.**openSimulatorApp** () | Open the Simulator App, if any
|.**quitSimulatorApp** ({killAll : `Boolean`}) | Quit the Simulator App after switching off all devices if desired
|.**bringSimulatorAppToFront** () | Bringing the Simulator App to the forefront
|.**isSimulatorAppLaunched** ()  → launched : `Boolean` | Returns true if the Simulator App is launched   
 
### Application

|Functions|Action|
|--------|------|
|.**installApp** (bundleID : `Text` {; device : `Text`}) | Install an App
|.**uninstallApp** (bundleID : `Text` {; device : `Text`}) | Uninstall an App
|.**launchApp** (bundleID : `Text` {; device : `Text`}) | Launch an App
|.**terminateApp** (bundleID : `Text` {; device : `Text`}) | Quit an App

### Miscellaneous

|Functions|Action|
|--------|------|
|.**devices** (udid : `Text`)  → devices : `Object` | List devices
|.**runtimes** ()  → runtimes : `Collection` | List Simulator Runtimes
|.**deviceTypes** ({type : `Text`})  → devices : `Collection` | List the product famillies
|.**openUrl** (url : `Text` {; device : `Text`}) | Open up the specified URL on a device
|.**openUrlScheme** (scheme : `Text` {; device : `Text`}) | Open up a custom scheme associated with an app
|.**plist** ()  → file : `4D.File` | Returns the `com.apple.iphonesimulator.plist` file

## 🔸 simctl.new()

The class constructor `cs.simctl.new()` creates a new class instance.
The class constructor accepts an optional text parameter to set the `.minimumVersion` property
When created, the class instance perform a cache cleanup by deleting old devices.


