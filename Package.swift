// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iOS.Resources.ReusableUI",
    products: [
        .library(
            name: "iOS.Resources.ReusableUI",
            targets: [
                "Modules"
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://gitlab.akbars.tech/abo/ios-resources-ui-components.git", .upToNextMinor(from: "0.0.46")),
    ],
    targets: [
        .target(
            name: "Modules",
            dependencies: [
                .product(name: "iOS.Resources.UiComponents", package: "ios-resources-ui-components"),
            ]
        ),
    ]
)
