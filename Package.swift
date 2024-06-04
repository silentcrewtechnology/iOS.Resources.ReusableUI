// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iOS.Resources.ReusableUI",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "iOS.Resources.ReusableUI",
            targets: [
                "Modules"
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://gitlab.akbars.tech/abo/ios.designsystem", .upToNextMinor(from: "3.3.0")),
        .package(url: "https://gitlab.akbars.tech/abo/ios.architecture", .upToNextMinor(from: "0.0.6")),
    ],
    targets: [
        .target(
            name: "Modules",
            dependencies: [
                .product(name: "DesignSystem", package: "ios.designsystem"),
                .product(name: "Architecture", package: "ios.architecture"),
            ]
        ),
    ]
)
