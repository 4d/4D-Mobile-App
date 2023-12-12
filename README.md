# 4D-Mobile-App

This component allow to easily create native iOS and Android apps from 4D projects.

You could find more information into the [official documentation](https://developer.4d.com/go-mobile)

## Installation

Download this component and add it to your base `Components` folder.

You could download a full packaged and compiled version from the [latest release](https://github.com/4d/4D-Mobile-App/releases/latest)
> ⚠️ On macOS if you have some issue about to use it with some errors like "cannot open lib4d-arm64.dylib", it's because the component is not yet notarized, so Apple block it.
> 💡 To fix that you could open the file using MacOS Finder:
> - Right clic on "4D Mobile App.4dbase" and select "Show package content" to enter inside.
> - Then find the file "lib4d-arm64.dylib" inside "Library" and do a right click to "Open" it.
> - An alert must also be displayed but this time you could accept to open it.
> - Then relaunch your database.

or better launch this command-line on macOS (or windows using MINGW64/git bash) in your database root folder:

```bash
cd Your/Base/Path
curl -sL https://raw.githubusercontent.com/4d/4D-Mobile-App/main/install.sh | sh # will download the latest release in Components
```

> alternatively you could use this code [download.4dm](Documentation/download.4dm) in your component to also download this time using 4D code.

### Using sources

> ⚠️ This part is for advanced user that want to compile this component, use custom android or ios sdk etc. It will not work if some part are missing. See not integrated tools.

Alternatively you could download this project sources. _[More detailled instructions to download from source bellow if you want](#download-from-sources-instructions)_

> ⚠️ If you download sources be sure to name the folder with extension `.4dbase`

If you do so, you must integrated manually some of the dependencies described bellow (even if at runtime the code will try to download latest version).

## Dependencies

This project has some dependencies on some other projects described bellow.

> You could find also this information in ["building dependencies documentation"](Documentation/Building.md)

### for iOS

#### iOS command-line tools

| Name  | Usefulness | Path | Integrated |
|-|-|-|-|
| [XProjStep](https://github.com/4d/ios-XProjStep) | to convert JSON project created by 4D to native Xcode project | `Resources/scripts/xprojstep` | YES |
| [CoreDataImport](https://github.com/4d/ios-CoreDataImport) | to dump 4D database to iOS CoreData database | `Resources/scripts/coredataimport` | YES |

#### iOS mobile native SDK

| Name  | Usefulness | Path | Integrated |
|-|-|-|-|
| [iOS SDK](https://github.com/4d/ios-sdk) | the SDK copied to mobile iOS Apps | • `<your base>/Resources/mobile/sdk/ios.zip` <br>• or `<4D mobile app>/Resources/sdk/ios.zip` <br>• or downloaded from [latest release](https://github.com/4d/ios-sdk/releases/latest) | NO |

### for Android

#### Android command-line tools

| Name  | Usefulness | Path | Integrated |
|-|-|-|-|
| [ProjectGenerator](https://github.com/4d/android-ProjectGenerator) | Create Android project | • `Resources/scripts/androidprojectgenerator.jar` <br>• or downloaded from [latest release](https://github.com/4d/android-ProjectGenerator/releases/latest) | NO |

#### Android mobile native SDK

| Name  | Usefulness | Path | Integrated |
|-|-|-|-|
| [Android SDK](https://github.com/4d/android-sdk) | the SDK copied to mobile Android Apps | • `<your base>/Resources/mobile/sdk/android.zip` <br>• or `<4D mobile app>/Resources/sdk/android.zip` <br>• or downloaded from [latest release](https://github.com/4d/android-sdk/releases/latest) | NO |

#### Android vd-tool

| Name  | Usefulness | Path | Integrated |
|-|-|-|-|
| [vd-tool](https://github.com/e-marchand/vdtool) | convert svg to Android image | • `Resources/scripts/vd-tool.jar` <br>• or downloaded from [latest release](https://github.com/e-marchand/vdtool/releases/latest) | YES |

---

## Download from sources instructions

### Download on web interface

1️⃣ Download sources using GitHub `Download` button, or by going to a specific release and getting sources
- for instance for main version `Download` button will download component using URL: [https://github.com/4d/4D-Mobile-App/archive/refs/heads/main.zip](https://github.com/4d/4D-Mobile-App/archive/refs/heads/main.zip)

2️⃣ Then unzip into your `Components` folder, and rename it folder to `4D-Mobile-App.4dbase` if needed

> 💡  if your are in git a repository
> Adding `Components` or `Components/4D-Mobile-App.4dbase` in your `.gitignore` file is recommended

#### macOS one line command to download

On macOS the following command-line will do the job for you.

Open a terminal, go to your 4d database root folder (`cd /your/base/path/`) and type:

```bash
curl -sL https://raw.githubusercontent.com/4d/4D-Mobile-App/main/download.sh | sh
```

### Alternatively using git

Go to your 4d database root folder (`cd /your/base/path/`) and clone it using the commande line

```bash
git clone git@github.com:4d/4D-Mobile-App.git Components/4D-Mobile-App.4dbase
```

_or using submodule if you use already git as vcs_

```bash
git submodule add git@github.com:4d/4D-Mobile-App.git Components/4D-Mobile-App.4dbase
```

## Contributing

You can contribute by fixing bugs or adding new features.

When submitting a pull request
- please follow the [contributing guide](.github/CONTRIBUTING.md)
- be sure that you have the right to license your contribution to the community, and agree by submitting the patch that your contributions are licensed under the [following license](LICENSE.md)
- sign the [contributing](.github/cla/4DCLA.md) for your first pull request

