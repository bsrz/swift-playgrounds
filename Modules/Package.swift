// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "playgrounds-modules",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "DependenciesExplorations", targets: ["DependenciesExplorations"]),
        .library(name: "InterviewQuestions", targets: ["InterviewQuestions"]),
        .library(name: "Play", targets: ["Play"]),
        .library(name: "StructuredConcurrency", targets: ["StructuredConcurrency"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", .upToNextMajor(from: "1.9.2")),
        .package(url: "https://github.com/pointfreeco/swift-navigation.git", .upToNextMajor(from: "2.3.1")),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", .upToNextMajor(from: "1.20.2")),
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

        .target(name: "InterviewQuestions"),
        .testTarget(name: "InterviewQuestionsTests", dependencies: [
            "InterviewQuestions",
            .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
        ]),

        .target(name: "StructuredConcurrency"),
        .testTarget(name: "StructuredConcurrencyTests", dependencies: ["StructuredConcurrency"]),

        .target(name: "Play"),
        .testTarget(name: "PlayTests", dependencies: ["Play"]),
    ]
)
