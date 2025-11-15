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
        .package(url: "https://github.com/silentcrewtechnology/iOS.DesignSystem.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/silentcrewtechnology/iOS.Architecture.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/onevcat/Kingfisher.git", exact: "7.11.0"),
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
