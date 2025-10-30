// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ZelloSDK",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "ZelloSDKUmbrella", targets: ["ZelloSDKUmbrella"]),
    ],
    dependencies: [
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack", exact: "3.9.0"),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", exact: "3.7.10"),
        .package(url: "https://github.com/SDWebImage/SDWebImage", exact: "5.19.1"),
        .package(url: "https://github.com/snowplow/snowplow-ios-tracker", exact: "6.0.7"),
        .package(url: "https://github.com/krzyzanowskim/OpenSSL", exact: "1.1.2301"),
        .package(url: "https://github.com/robbiehanson/CocoaAsyncSocket", exact: "7.6.5"),
        .package(url: "https://github.com/zelloptt/Opus-iOS", exact: "1.0.5")
    ],
    targets: [
        .binaryTarget(
            name: "UIUtility",
            url: "https://zello.com/sdk/dist/ios/spm/2.0.2/UIUtility.zip",
            checksum: "ea0520fc93ebc3156d7f22af5a63c0289d43835d3840431aec4e2c93c0a8a0e2"
        ),
        .binaryTarget(
            name: "Utility",
            url: "https://zello.com/sdk/dist/ios/spm/2.0.2/Utility.zip",
            checksum: "efb9c2b83f48638400465f42cf83237b8a81376f5f180fc6680e44c95125362d"
        ),
        .binaryTarget(
            name: "ZelloCore",
            url: "https://zello.com/sdk/dist/ios/spm/2.0.2/ZelloCore.zip",
            checksum: "e77b84fbe7c455e7f2924a0288f3439de4f838a88ebe5ef0c2f072cde6ac7db6"
        ),
        .binaryTarget(
            name: "ZelloCoreSDK",
            url: "https://zello.com/sdk/dist/ios/spm/2.0.2/ZelloCoreSDK.zip",
            checksum: "5137e3e2a06711dab2d914bc2425c437a51782426134bdac1b4eb68b487f6287"
        ),
        .binaryTarget(
            name: "ZelloNetworkExtension",
            url: "https://zello.com/sdk/dist/ios/spm/2.0.2/ZelloNetworkExtension.zip",
            checksum: "314cebe3d655e2daed90c8054532574e02e9330f2c2c7e78ddf9fecd270dced6"
        ),
        .binaryTarget(
            name: "ZelloNetworking",
            url: "https://zello.com/sdk/dist/ios/spm/2.0.2/ZelloNetworking.zip",
            checksum: "84940ff708a76e4df124ce9b5c2868fd8b640cef2d1ad4551b914d3e4c6c5d6f"
        ),
        .binaryTarget(
            name: "ZelloSDKBinary",
            url: "https://zello.com/sdk/dist/ios/spm/2.0.2/ZelloSDK.zip",
            checksum: "78a946f6f78d89a68c2e4dfae21a737fe38f4db0086bfdc6e29a6e25ebb9c6bf"
        ),
        .binaryTarget(
            name: "ZelloSecure",
            url: "https://zello.com/sdk/dist/ios/spm/2.0.2/ZelloSecure.zip",
            checksum: "abb026013a9dbb16abc4eb1df69e070ee472ef1704887fd0513fba911d67b884"
        ),
        .binaryTarget(
            name: "ZelloSharedData",
            url: "https://zello.com/sdk/dist/ios/spm/2.0.2/ZelloSharedData.zip",
            checksum: "6f413869283dbad8d43a492d49c583a659359773b6ec1cc7f5919152ede647a8"
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
                .product(name: "ogg",  package: "opus-ios")
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
                "ZelloNetworkExtension"
            ],
            path: "Sources/Umbrella"
        )
    ]
)

