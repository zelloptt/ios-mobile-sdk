// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ZelloSDK",
    platforms: [.iOS("17.0")],
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
            url: "https://zello.com/sdk/dist/ios/spm/3.3.0/UIUtility.zip",
            checksum: "ce4f5e10bf01dc6c19002ca116960a249cf90127872e4dfea076f3f12cb6a8f6"
        ),
        .binaryTarget(
            name: "Utility",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.0/Utility.zip",
            checksum: "222c26ebb9521acf417bd14dd9c04c5f091bbcf9e850075a85e49d42816d6a8a"
        ),
        .binaryTarget(
            name: "ZelloCore",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.0/ZelloCore.zip",
            checksum: "df77163ba3d03fbccf9ec2c2e758b16516ad24e49d8f95e44ae3686a4c133686"
        ),
        .binaryTarget(
            name: "ZelloCoreSDK",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.0/ZelloCoreSDK.zip",
            checksum: "36beec70c7d01cf33169ab46123cc82e6288694ddbf3e301b6f0a09cb1aaccc9"
        ),
        .binaryTarget(
            name: "ZelloNetworkExtension",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.0/ZelloNetworkExtension.zip",
            checksum: "3b70684b90b65d8695f54c25ab0444e34340ccef60c0df34638c3838b5791521"
        ),
        .binaryTarget(
            name: "ZelloNetworking",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.0/ZelloNetworking.zip",
            checksum: "38c0c04b4d90c7436f0d82308560b265dcc8ec6e61e9b5ef0068de7303ead798"
        ),
        .binaryTarget(
            name: "ZelloSDKBinary",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.0/ZelloSDK.zip",
            checksum: "9f517231e74e76d5e6bddb31a335f9bd17980ebf526b8e2d54ce46484fae67b1"
        ),
        .binaryTarget(
            name: "ZelloSecure",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.0/ZelloSecure.zip",
            checksum: "5ee34bbbfdd43a3304bac9e62fe2a1274097a9ff5fed55abc9afc8bdec256fa5"
        ),
        .binaryTarget(
            name: "ZelloSharedData",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.0/ZelloSharedData.zip",
            checksum: "22a15343163e61a4b5776adb4a3260b1fee8aaf6dab0bb4df7cf9184ebe6b580"
        ),
        .binaryTarget(
            name: "ZRemoteConfigurationForScripting",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.0/ZRemoteConfigurationForScripting.zip",
            checksum: "277e9014eb8b247f847fcb1dd68a7d2c65c63c643306cfb12cb548bafaf66626"
        ),
        .binaryTarget(
            name: "ZRemoteConfigurationUtilities",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.0/ZRemoteConfigurationUtilities.zip",
            checksum: "b6853b233362893325e930eac979857aa68f62b50a4cbd95fc32b20027ca3742"
        ),
        .binaryTarget(
            name: "ZRemoteConfiguration",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.0/ZRemoteConfiguration.zip",
            checksum: "e25da8795190d4fb6dc933e904a2bf9c4735016f8130d553b3a421d2297ab5a8"
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
                "ZRemoteConfigurationForScripting",
                "ZRemoteConfigurationUtilities",
                "ZRemoteConfiguration"
            ],
            path: "Sources/Umbrella"
        )
    ]
)
