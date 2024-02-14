// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "playgrounds-modules",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "DependenciesExplorations", targets: ["DependenciesExplorations"]),
        .library(name: "Play", targets: ["Play"]),
        .library(name: "StructuredConcurrency", targets: ["StructuredConcurrency"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", .upToNextMajor(from: "1.2.0")),
    ],
    targets: [
        .target(
            name: "DependenciesExplorations",
            dependencies: [
                .product(
                    name: "Dependencies",
                    package: "swift-dependencies"
                )
            ]
        ),
        .testTarget(name: "DependenciesExplorationsTests", dependencies: ["DependenciesExplorations"]),

        .target(name: "StructuredConcurrency"),
        .testTarget(name: "StructuredConcurrencyTests", dependencies: ["StructuredConcurrency"]),

        .target(name: "Play"),
        .testTarget(name: "PlayTests", dependencies: ["Play"]),
    ]
)
