// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ZelloSDK",
    platforms: [.iOS("16.1")],
    products: [
        .library(name: "ZelloSDKUmbrella", targets: ["ZelloSDKUmbrella"])
    ],
    dependencies: [
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack", from: "3.9.0"),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", from: "3.7.10"),
        .package(url: "https://github.com/SDWebImage/SDWebImage", from: "5.19.1"),
        .package(url: "https://github.com/snowplow/snowplow-ios-tracker", from: "6.0.7"),
        .package(url: "https://github.com/krzyzanowskim/OpenSSL", from: "1.1.2301"),
        .package(url: "https://github.com/robbiehanson/CocoaAsyncSocket", from: "7.6.5"),
        .package(url: "https://github.com/zelloptt/Opus-iOS", from: "1.0.5")
    ],
    targets: [
        .binaryTarget(
            name: "UIUtility",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.0/UIUtility.zip",
            checksum: "ce9233a3955c62ace7426ee1f056b606e2c0e789dcd71a6b0156413c980aee01"
        ),
        .binaryTarget(
            name: "Utility",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.0/Utility.zip",
            checksum: "eab1847d5ad01b72b15d25b5d8b541be426b9b3eedd4f7111a85e4cca76ae0a9"
        ),
        .binaryTarget(
            name: "ZelloCore",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.0/ZelloCore.zip",
            checksum: "e214ce7642881ecf0ae49241f05f10a3b788872a3e4978fa7be0a8a11bdc7b2a"
        ),
        .binaryTarget(
            name: "ZelloCoreSDK",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.0/ZelloCoreSDK.zip",
            checksum: "09b47d3ad64d3ce1b43803b631aa4f45b667ebf6a05d718828ddccf0392c2987"
        ),
        .binaryTarget(
            name: "ZelloNetworkExtension",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.0/ZelloNetworkExtension.zip",
            checksum: "3f31d1d62e3c7e7a15d7c49b98bbea868593cb89e94579d92a45c26984aab922"
        ),
        .binaryTarget(
            name: "ZelloNetworking",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.0/ZelloNetworking.zip",
            checksum: "e49ceba92397f1b98aa481518bbabadb33b616f78996c59a4023ffc58fc1d914"
        ),
        .binaryTarget(
            name: "ZelloSDKBinary",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.0/ZelloSDK.zip",
            checksum: "40dde44fcbfedcdcaf7b2617d0d91fac2a4f3544a8190b4a62e3a18f084bd3a7"
        ),
        .binaryTarget(
            name: "ZelloSecure",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.0/ZelloSecure.zip",
            checksum: "32fdb2cac5565a075a54738f71c160bcb8a7e68a74ed414947640dbe5a8688a5"
        ),
        .binaryTarget(
            name: "ZelloSharedData",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.0/ZelloSharedData.zip",
            checksum: "8a0861db80600d67c0ee4894034f6c098b77ad2f0454b19d10ef0972372d7041"
        ),
        .binaryTarget(
            name: "RemoteConfigurationForScripting",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.0/RemoteConfigurationForScripting.zip",
            checksum: "bffcad5f03cbbc8e897e5cafe568172182f9a58f4b70a6cbc3324648b80b5cd3"
        ),
        .binaryTarget(
            name: "RemoteConfigurationUtilities",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.0/RemoteConfigurationUtilities.zip",
            checksum: "cd2eedc78e9c56f20d28414f20518cc992a9f9973e8b9cab25cb4d35c7d3923c"
        ),
        .binaryTarget(
            name: "RemoteConfiguration",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.0/RemoteConfiguration.zip",
            checksum: "b8e501e36d91c78f433df5a79f8da47bfbc3f9ffcf3840b7065eb849676caf65"
        ),
        .target(
            name: "Zello3rdPartyDependenciesConfigurationObjC",
            dependencies: [
                .product(name: "CocoaLumberjack", package: "CocoaLumberjack"),
                "Utility",
                "ZelloSecure",
                .product(name: "OpenSSL", package: "OpenSSL"),
                .product(name: "CocoaAsyncSocket", package: "CocoaAsyncSocket")
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
                .product(name: "CocoaAsyncSocket", package: "CocoaAsyncSocket"),
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
