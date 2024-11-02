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
        .package(url: "https://gitlab.akbars.tech/abo/ios.designsystem.git", .upToNextMajor(from: "25.0.0")),
        .package(url: "https://gitlab.akbars.tech/abo/ios.architecture.git", .upToNextMajor(from: "3.0.0")),
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
