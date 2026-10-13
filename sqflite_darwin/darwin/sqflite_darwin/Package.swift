// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "sqflite_darwin",
    platforms: [
        .iOS("12.0"),
        .macOS("10.14")
    ],
    products: [
        // If the plugin name contains "_", replace with "-" for the library name
        .library(name: "sqflite-darwin", targets: ["sqflite_darwin"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        // SQLite (patched) + spatialite + PROJ + GEOS + rttopo + ICU, built by iulian0512/libspatialite-ios
        // Same zip as the podspec prepare_command; on a new zip update url and checksum
        // (swift package compute-checksum <zip>).
        // Office LAN: large downloads via the public IP of dev.intergraph.ro fail (TLS error), map it to
        // the internal IIS 10.10.40.7 in /etc/hosts.
        .binaryTarget(
            name: "libspatialite",
            url: "https://dev.intergraph.ro/iulian/libspatialite_sqflite244.xcframework.zip",
            checksum: "f921b8d9169a6c40c696fdb616c791b9c107c96a423477893cfeb020e3846eaf"
        ),
        .target(
            name: "sqflite_darwin",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .target(name: "libspatialite", condition: .when(platforms: [.iOS]))
            ],
            resources: [
                .process("Resources"),

                // TODO: If you have other resources that need to be bundled with your plugin, refer to
                // the following instructions to add them:
                // https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package
            ],
            cSettings: [
                .headerSearchPath("include/sqflite_darwin"),
                .define("SqfliteDarwinDB_SQLITE_STANDALONE", to: "1", .when(platforms: [.iOS]))
            ],
            linkerSettings: [
                // necessary for spatialite
                .linkedLibrary("c++", .when(platforms: [.iOS])),
                .linkedLibrary("iconv", .when(platforms: [.iOS])),
                .linkedLibrary("charset", .when(platforms: [.iOS])),
                .linkedLibrary("z", .when(platforms: [.iOS]))
            ]
        )
    ]
)