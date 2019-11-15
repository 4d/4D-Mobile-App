// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TabBar",
    platforms: [
        .iOS(.v13)
    ],
    dependencies: [
       .package(url: "https://github.com/quatreios/QMobileUI.git", .revision("HEAD"))
    ],
    targets: [
        .target(
            name: "___PRODUCT___",
            dependencies: ["QMobileUI"],
            path: "Sources")
    ]
)
