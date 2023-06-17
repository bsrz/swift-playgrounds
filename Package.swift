// swift-tools-version: 5.9

import Foundation
import PackageDescription

extension String {
  static let casePathsDemo = "CasePathsDemo"
  static let playgrounds = "Playgrounds"

  var tests: String { self + "Tests" }
}

extension Target.Dependency {
  static let casePaths: Self = .product(name: "CasePaths", package: "swift-case-paths")
  static func named(_ name: String) -> Self { .init(stringLiteral: name) }
}

let package = Package(
    name: "swift-playgrounds",
    platforms: [.iOS(.v17)],
    products: [
      .library(name: .casePathsDemo, targets: [.casePathsDemo]),
      .library(name: .playgrounds, targets: [.playgrounds]),
    ],
    dependencies: [
      .package(url: "https://github.com/pointfreeco/swift-case-paths.git", .upToNextMajor(from: "0.14.1")),
    ],
    targets: [
      .target(name: .casePathsDemo, dependencies: [.casePaths]),
      .testTarget(name: .casePathsDemo.tests, dependencies: [.named(.casePathsDemo)]),
      .target(name: .playgrounds, dependencies: [.casePaths]),
      .testTarget(name: .playgrounds.tests, dependencies: [.named(.playgrounds)]),
    ]
)
