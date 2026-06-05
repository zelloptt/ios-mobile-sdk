// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ZelloSDK",
    platforms: [.iOS("16.1")],
    products: [
        .library(name: "ZelloSDKUmbrella", type: .dynamic, targets: ["ZelloSDKUmbrella"])
    ],
    dependencies: [
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack", from: "3.9.0"),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", from: "3.7.10"),
        .package(url: "https://github.com/SDWebImage/SDWebImage", from: "5.19.1"),
        .package(url: "https://github.com/snowplow/snowplow-ios-tracker", from: "6.0.7"),
        .package(url: "https://github.com/krzyzanowskim/OpenSSL", from: "1.1.2301"),
        .package(url: "https://github.com/zelloptt/Opus-iOS", from: "1.0.5")
    ],
    targets: [
        .binaryTarget(
            name: "UIUtility",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.2/UIUtility.zip",
            checksum: "b888f51d1cf00be52f11d61649d063255f79250404f50a20cf1af3a4f115a169"
        ),
        .binaryTarget(
            name: "Utility",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.2/Utility.zip",
            checksum: "4b8b269cda9764e430fc67b2dd02f715e775ec6a4978af9d65534cad68523f1a"
        ),
        .binaryTarget(
            name: "ZelloCore",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.2/ZelloCore.zip",
            checksum: "9123916c71d2eb2f817df8281877f56aea26cfa4cb74340b798adc05f54107bc"
        ),
        .binaryTarget(
            name: "ZelloCoreSDK",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.2/ZelloCoreSDK.zip",
            checksum: "a8833ccaa75426e0669765dbe2e540babbdc6d808ad7aa944aa5fe7f6bd55ee1"
        ),
        .binaryTarget(
            name: "ZelloNetworkExtension",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.2/ZelloNetworkExtension.zip",
            checksum: "19dbda764930e00042ad8092d86e40beb5089fec5c29e51448ae04d7bb584cfc"
        ),
        .binaryTarget(
            name: "ZelloNetworking",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.2/ZelloNetworking.zip",
            checksum: "d773337c17265baad429bf28be0c7af758141ec212e7d55e99f2e2320ea97129"
        ),
        .binaryTarget(
            name: "ZelloSDKBinary",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.2/ZelloSDK.zip",
            checksum: "1ee2719ea1033a88d2fb6c0d042ac751514d14bff4248bbeb04ef2a55acbe768"
        ),
        .binaryTarget(
            name: "ZelloSecure",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.2/ZelloSecure.zip",
            checksum: "889bf3a2c9540fa53bbbd3d90ed2f5d7c28b8d127ffbe91c0de3420de3e97bce"
        ),
        .binaryTarget(
            name: "ZelloSharedData",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.2/ZelloSharedData.zip",
            checksum: "59c00ce71c474a44d89f6b4643a28d05f46448bb51dd3101697fdbe4a99db5d8"
        ),
        .binaryTarget(
            name: "RemoteConfigurationForScripting",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.2/RemoteConfigurationForScripting.zip",
            checksum: "325b4fce611a20c3aee31b1925c62efd03e7c2773c86fe9a2c2dfd12f3275ecb"
        ),
        .binaryTarget(
            name: "RemoteConfigurationUtilities",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.2/RemoteConfigurationUtilities.zip",
            checksum: "83015382498e808aecfecf8b642097e5d858e4a53aa305b3b58a2c72a5944d53"
        ),
        .binaryTarget(
            name: "RemoteConfiguration",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.2/RemoteConfiguration.zip",
            checksum: "59dc37f9eab111c0d7f3f1b92e5ff3108192ecedf50eeafd59e1bd6efa64077b"
        ),
        .target(
            name: "Zello3rdPartyDependenciesConfigurationObjC",
            dependencies: [
                .product(name: "CocoaLumberjack", package: "CocoaLumberjack"),
                "Utility",
                "ZelloSecure",
                .product(name: "OpenSSL", package: "OpenSSL")
            ],
            path: "Zello3rdPartyDependenciesConfiguration/Sources/ObjC",
            publicHeadersPath: "include",
            cSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        .target(
            name: "Zello3rdPartyDependenciesConfiguration",
            dependencies: [
                "Zello3rdPartyDependenciesConfigurationObjC",
                "Utility",
                "ZelloSecure",
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
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),

        // -------- Umbrella target (public) --------
        .target(
            name: "ZelloSDKUmbrella",
            dependencies: [
                // Your prebuilt SDK module
                "ZelloSDKBinary",
                "Zello3rdPartyDependenciesConfiguration",
                "ZelloCore",
                "ZelloCoreSDK",
                "ZelloNetworking",
                "ZelloSecure",
                "ZelloSharedData",
                "UIUtility",
                "Utility",
                "ZelloNetworkExtension",
                "RemoteConfigurationForScripting",
                "RemoteConfigurationUtilities",
                "RemoteConfiguration"
            ],
            path: "Sources/Umbrella"
        )
    ]
)
