// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "swift-playgrounds",
    platforms: [.iOS(.v16)],
    products: [
      .library(name: "Playgrounds", targets: ["Playgrounds"]),
    ],
    dependencies: [
      .package(url: "https://github.com/pointfreeco/swift-case-paths.git", .upToNextMajor(from: "0.14.1")),
    ],
    targets: [
      .target(name: "Playgrounds", dependencies: [.product(name: "CasePaths", package: "swift-case-paths")]),
      .testTarget(name: "PlaygroundsTests", dependencies: ["Playgrounds"]),
    ]
)
