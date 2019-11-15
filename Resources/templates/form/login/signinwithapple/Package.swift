// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LoginForm",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "___PRODUCT___", targets: ["___PRODUCT___"])
    ],
    dependencies: [
        .package(url: "https://github.com/phimage/Prephirences.git", .revision("HEAD")),
//         .package(url: "https://github.com/devicekit/DeviceKit.git", from: "2.3.0"), // no mac support
        .package(url: "https://github.com/phimage/DeviceKit.git", .branch("feature/macos")), //
        .package(url: "https://github.com/4d-for-ios/QMobileAPI.git", .revision("HEAD")),
        .package(url: "https://github.com/4d-for-ios/QMobileUI.git", .revision("HEAD"))
    ],
    targets: [
        .target(name: "___PRODUCT___", dependencies: ["QMobileUI", "QMobileAPI", "Prephirences", "DeviceKit"], path: "Sources")
    ]
)
