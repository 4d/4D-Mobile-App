# iOS Project

## ⛩ Project structures

### 📝 Sources

#### 📐 Forms

Contains all application forms :

- Main: entry point form, which define if must be display login form or navigation form
- Login: form used to login user
- Navigation: form which defined the navigation (By default iOS tab bar)
- Tables: contains list and details forms for each table.
- Settings: the settings form

#### 📲 Application

This folder contains all sources about application definition.

- `main.swift` which create a `QApplication`, and application that use 4D iOS sdk
- `AppDelegate` and `SceneDelegate`: well-known iOS class to defined to register to application event.

#### 💉 Embedded

Some useful code that cannot be in SDK, but only embedded in application

### 🖼 Resources

Contains all media.

### ⚙️ Settings

Contains file to configure your application.

### ⚒️ Xcode

Xcode folder, xcodeproj and xcworkspace contains useful file for iOS project.

### 📦Carthage

This folder contains the 4d for iOS SDK.

### Root

- copy-frameworks.sh: script used by xcode project to inject SDK with only the needed architecture (arm, x86_64)
- sdkVersion: contains 4D for iOS sdk version

## ⚖️ Licenses

You can find licenses for third party framework into [[Licenses.md]]