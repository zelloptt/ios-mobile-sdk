// swift-tools-version: 5.9
import PackageDescription

// ZelloSDK distribution package (single-xcframework shape, IOS-4698).
//
// Consumers add this package and import ZelloSDK. The SDK proper is ONE
// prebuilt binary (ZelloSDKBinary — every internal Zello module statically
// folded in; only the ZelloSDK module and its .swiftinterface ship). The
// third-party glue compiles from source in the consumer's build against the
// SDK's @_spi(ThirdPartyBootstrap) surface (ZELLO_SDK_DISTRIBUTION define)
// and the third-party packages below; its ObjC crypto implementations build
// against vendored protocol headers (Sources/ObjC/include-dist). opus/ogg are
// binary frameworks the fat SDK references at @rpath — the umbrella target
// links them so the consumer app embeds them.

let package = Package(
    name: "ZelloSDK",
    platforms: [.iOS("17.0")],
    products: [
        .library(name: "ZelloSDKUmbrella", type: .dynamic, targets: ["ZelloSDKUmbrella"])
    ],
    dependencies: [
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack", from: "3.9.0"),
        .package(url: "https://github.com/PhoneNumberKit/PhoneNumberKit", from: "5.0.7"),
        .package(url: "https://github.com/SDWebImage/SDWebImage", from: "5.19.1"),
        .package(url: "https://github.com/snowplow/snowplow-ios-tracker", from: "6.0.7"),
        .package(url: "https://github.com/krzyzanowskim/OpenSSL", from: "1.1.2301"),
        .package(url: "https://github.com/zelloptt/Opus-iOS", from: "1.0.5")
    ],
    targets: [
        .binaryTarget(
            name: "ZelloSDKBinary",
            url: "https://zello.com/sdk/dist/ios/spm/3.4.0/ZelloSDK.zip",
            checksum: "f86c904e66ba9226c49d103e204c654a0123d71362bf2d879c4efffe984a1bcb"
        ),
        .target(
            name: "Zello3rdPartyDependenciesConfigurationObjC",
            dependencies: [
                "ZelloSDKBinary",
                .product(name: "CocoaLumberjack", package: "CocoaLumberjack"),
                .product(name: "OpenSSL", package: "OpenSSL")
            ],
            path: "Zello3rdPartyDependenciesConfiguration/Sources/ObjC",
            publicHeadersPath: "include",
            cSettings: [
                .define("ZELLO_SDK_DISTRIBUTION", to: "1"),
                .headerSearchPath("include-dist"),
                .define("DEBUG", .when(configuration: .debug))
            ]
        ),
        .target(
            name: "Zello3rdPartyDependenciesConfiguration",
            dependencies: [
                "ZelloSDKBinary",
                "Zello3rdPartyDependenciesConfigurationObjC",
                .product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack"),
                .product(name: "CocoaLumberjack", package: "CocoaLumberjack"),
                .product(name: "PhoneNumberKit", package: "PhoneNumberKit"),
                .product(name: "SDWebImage", package: "SDWebImage"),
                .product(name: "OpenSSL", package: "OpenSSL"),
                .product(name: "SnowplowTracker", package: "snowplow-ios-tracker"),
                .product(name: "opus", package: "opus-ios"),
                .product(name: "ogg", package: "opus-ios")
            ],
            path: "Zello3rdPartyDependenciesConfiguration/Sources/Swift",
            swiftSettings: [
                .define("ZELLO_SDK_DISTRIBUTION"),
                .define("DEBUG", .when(configuration: .debug))
            ]
        ),

        // -------- Umbrella target (public) --------
        .target(
            name: "ZelloSDKUmbrella",
            dependencies: [
                "ZelloSDKBinary",
                "Zello3rdPartyDependenciesConfiguration",
                .product(name: "opus", package: "opus-ios"),
                .product(name: "ogg", package: "opus-ios")
            ],
            path: "Sources/Umbrella"
        )
    ]
)
