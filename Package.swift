// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "CollectionCraft",
  platforms: [SupportedPlatform.iOS(.v11)],
  products: [.library(name: "CollectionCraft", targets: ["CollectionCraft"])],
  dependencies: [],
  targets: [.target(name: "CollectionCraft", dependencies: [], path: "Sources/CollectionCraft")],
  swiftLanguageVersions: [.v5]
)
