// swift-tools-version: 5.8

import Foundation
import PackageDescription

extension Target.Dependency {
    static let navigation: Self = .product(name: "SwiftUINavigation", package: "swiftui-navigation")
    static func named(_ name: String) -> Self { .init(stringLiteral: name) }
}

let package = Package(
    name: "playgrounds-modules",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "Play", targets: ["Play"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swiftui-navigation.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(
            name: "Play",
            dependencies: [
                .navigation
            ]
        ),
        .testTarget(
            name: "PlayTests",
            dependencies: [
                "Play"
            ]
        ),
    ]
)
