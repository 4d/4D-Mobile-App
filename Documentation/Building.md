# Building

This page contains detailled information on how to build the component with all needed software dependencies.

## Component

Like any other component it could be builded using [4D software](https://doc4d.github.io/docs/fr/Project/compiler/) or [Compile project](https://doc.4d.com/4Dv19/4D/19.6/Compile-project.301-6269659.en.html) command.

## Dependencies

### Tools

Some tools must be inside [Resources/scripts](../Resources/scripts)

#### iOS tools

This iOS tools are already commited but you could rebuild them using each projects instructions

- `Resources/scripts/xprojstep` [XProjStep](https://github.com/4d/ios-XProjStep#build)
- `Resources/scripts/coredataimport` [CoreDataImport](https://github.com/4d/ios-CoreDataImport#build)

#### Android tool

- `Resources/scripts/androidprojectgenerator.jar` [ProjectGenerator](https://github.com/4d/android-ProjectGenerator#build)

This one will be downloaded from [latest release](https://github.com/4d/android-ProjectGenerator/releases) if it not present inside expected path. It could also be builded using provided script.

### Mobile native SDK

Native SDK are files copied to the generated mobile application according to target OS.

The 4D code of method [downloadSDK](../Project/Sources/Methods/downloadSDK.4dm) will try to download the latest available components from GitHub release.

But you also choose to build yourself using provided `build.sh` of each project and inject it in this component or your component by using path defined bellow.

#### iOS mobile native SDK

[iOS SDK](https://github.com/4d/ios-sdk#build) could be put in

- `Resources/sdk/ios.zip`
- `<your base>/Resources/mobile/sdk/ios.zip`

or downloaded from [latest release](https://github.com/4d/ios-sdk/releases/latest)

#### Android mobile native SDK

[Android SDK](https://github.com/4d/android-sdk#build) could be put in

- `Resources/sdk/android.zip`
- `<your base>/Resources/mobile/sdk/android.zip`

or downloaded from [latest release](https://github.com/4d/android-sdk/releases/latest)
