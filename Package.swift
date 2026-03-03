// swift-tools-version: 6.2

import PackageDescription

// IEEE 754: Standard for Floating-Point Arithmetic
//
// Implements IEEE 754-2019 binary floating-point standard
// - IEEE 754-2019: Current standard (published August 2019)
// - IEEE 754-2008: Previous revision
// - IEEE 754-1985: Original standard
//
// This package provides canonical binary serialization for Float and Double
// types following IEEE 754 binary interchange formats.
//
// Pure Swift implementation with no Foundation dependencies,
// suitable for Swift Embedded and constrained environments.

let package = Package(
    name: "swift-ieee-754",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(
            name: "IEEE 754",
            targets: ["IEEE 754"]
        )
    ],
    dependencies: [
        .package(path: "../../swift-primitives/swift-binary-primitives"),
        .package(path: "../../swift-primitives/swift-standard-library-extensions"),
        .package(path: "../../swift-primitives/swift-decimal-primitives"),
        .package(path: "../../swift-primitives/swift-dependency-primitives"),
    ],
    targets: [
        .target(
            name: "CIEEE754",
            dependencies: []
        ),
        .target(
            name: "IEEE 754",
            dependencies: [
                .product(name: "Binary Primitives", package: "swift-binary-primitives"),
                .product(name: "Decimal Primitives", package: "swift-decimal-primitives"),
                .product(name: "Dependency Primitives", package: "swift-dependency-primitives"),
                .target(name: "CIEEE754", condition: .when(platforms: [.macOS, .linux, .iOS, .tvOS, .watchOS]))
            ]
        ),
        .testTarget(
            name: "IEEE 754 Tests",
            dependencies: [
                "IEEE 754",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self { self + " Tests" }
}

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableExperimentalFeature("SuppressedAssociatedTypesWithDefaults"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
