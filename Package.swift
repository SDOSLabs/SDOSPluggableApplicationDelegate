// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "SDOSPluggableApplicationDelegate",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "SDOSPluggableApplicationDelegate",
            targets: ["SDOSPluggableApplicationDelegate"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SDOSPluggableApplicationDelegate",
            dependencies: [
            ],
            path: "src")
    ]
)
