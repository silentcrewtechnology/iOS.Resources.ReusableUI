// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ReusableUI",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "ReusableUI",
            targets: [
                "ReusableUI"
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://gitlab.akbars.tech/abo/ios.designsystem", .upToNextMinor(from: "4.0.3")),
        .package(url: "https://gitlab.akbars.tech/abo/ios.architecture", .upToNextMinor(from: "0.0.6")),
        .package(url: "https://github.com/onevcat/Kingfisher", exact: "7.11.0"),
    ],
    targets: [
        .target(
            name: "ReusableUI",
            dependencies: [
                .product(name: "DesignSystem", package: "ios.designsystem"),
                .product(name: "Architecture", package: "ios.architecture"),
                .product(name: "Kingfisher", package: "Kingfisher")
            ]
        ),
    ]
)
