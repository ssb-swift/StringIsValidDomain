// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "StringIsValidDomain",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
    .watchOS(.v6),
    .tvOS(.v13),
  ],
  products: [
    .library(name: "StringIsValidDomain", targets: ["StringIsValidDomain"])
  ],
  dependencies: [
    .package(url: "https://github.com/sindresorhus/Regex", from: "0.1.1"),
    .package(name: "Punycode", url: "https://github.com/gumob/PunycodeSwift.git", from: "2.1.0"),
  ],
  targets: [
    .target(
      name: "StringIsValidDomain",
      dependencies: [
        .product(name: "Regex", package: "Regex"),
        .product(name: "Punnycode", package: "Punycode"),
      ]),
    .testTarget(name: "StringIsValidDomainTests", dependencies: ["StringIsValidDomain"]),
  ]
)
