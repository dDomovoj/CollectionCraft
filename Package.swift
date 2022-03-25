// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "CollectionCraft",
  platforms: [SupportedPlatform.iOS(.v11)],
  products: [.library(name: "CollectionCraft", targets: ["CollectionCraft"])],
  dependencies: [.package(url: "https://github.com/ra1028/DifferenceKit", .upToNextMajor(from: .init(1, 2, 0)))],
  targets: [.target(name: "CollectionCraft", dependencies: ["DifferenceKit"], path: "Sources/CollectionCraft")],
  swiftLanguageVersions: [.v5]
)
