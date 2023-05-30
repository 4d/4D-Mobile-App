# 4D-Mobile-App

This component allow to easily create native iOS and Android apps from 4D projects.

You could find more information into the [official documentation](https://developer.4d.com/go-mobile)

## Installation

Download this component and add it to your base `Components` folder.

You could download a full packaged and compiled version from [latest release](https://github.com/4d/4D-Mobile-App/releases/latest)

### Using sources

Alternatively you could download this project sources. _[More detailled instructions to download from source bellow if you want](#download-from-sources-instructions)_

> ⚠️ If you download sources be sure to name the folder with extension `.4dbase`

If you do so, you must integrated manually some of the dependencies described bellow (even if at runtime the code will try to download latest version).

## Dependencies

This project has some dependencies on some other projects described bellow. 

> You could find also this information in ["building dependencies documentation"](Documentation/Building.md) 

### for iOS

#### iOS cli tools

| Name  | Usefulness | Path | Integrated |
|-|-|-|-|
| [XProjStep](https://github.com/4d/ios-XProjStep) | to convert JSON project created by 4D to native Xcode project | `Resources/scripts/xprojstep` | YES |
| [CoreDataImport](https://github.com/4d/ios-CoreDataImport) | to dump 4D database to iOS CoreData database | `Resources/scripts/coredataimport` | YES |

#### iOS mobile native SDK

| Name  | Usefulness | Path | Integrated |
|-|-|-|-|
| [iOS SDK](https://github.com/4d/ios-sdk) | the SDK copied to mobile iOS Apps | • `<your base>/Resources/mobile/sdk/ios.zip` <br>• or `<4D mobile app>/Resources/sdk/ios.zip` <br>• or downloaded from [latest release](https://github.com/4d/ios-sdk/releases/latest) | NO |

### for android

#### android cli tools

| Name  | Usefulness | Path | Integrated |
|-|-|-|-|
| [ProjectGenerator](https://github.com/4d/android-ProjectGenerator) | Create android project | • `Resources/scripts/androidprojectgenerator.jar` <br>• or downloaded from [latest release](https://github.com/4d/android-ProjectGenerator/releases/latest) | NO |

#### android mobile native SDK

| Name  | Usefulness | Path | Integrated |
|-|-|-|-|
| [Android SDK](https://github.com/4d/android-sdk) | the SDK copied to mobile Android Apps | • `<your base>/Resources/mobile/sdk/android.zip` <br>• or `<4D mobile app>/Resources/sdk/android.zip` <br>• or downloaded from [latest release](https://github.com/4d/android-sdk/releases/latest) | NO |

---

## Download from sources instructions

### Download on web interface

1️⃣ Download sources using github `Download` button, or by going to a specific release and getting sources
- for instance for main version `Download` button will download component using URL: [https://github.com/4d/4D-Mobile-App/archive/refs/heads/main.zip](https://github.com/4d/4D-Mobile-App/archive/refs/heads/main.zip)

2️⃣ Then unzip into your `Components` folder, and rename it folder to `4D-Mobile-App.4dbase` if needed

> 💡  if your are in git a repository
> Adding `Components` or `Components/4D-Mobile-App.4dbase` in your `.gitignore` file is recommended

#### macOS one line command to download

On macOS the following command line will do the job for you.

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
