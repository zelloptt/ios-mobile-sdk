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
            url: "https://zello.com/sdk/dist/ios/spm/3.2.0/UIUtility.zip",
            checksum: "b48044411a73e04987aab4eb968de8a30dd917bd8466940a153d956bfc1d1749"
        ),
        .binaryTarget(
            name: "Utility",
            url: "https://zello.com/sdk/dist/ios/spm/3.2.0/Utility.zip",
            checksum: "f1419a368d5bacc9cf9da4fcf05b1c95962f94ab749ec6f542d51982ac915b71"
        ),
        .binaryTarget(
            name: "ZelloCore",
            url: "https://zello.com/sdk/dist/ios/spm/3.2.0/ZelloCore.zip",
            checksum: "30b52cdd23f92f858908795fd9f0fa334fec5af913ddfa5318c3967940b4b0e1"
        ),
        .binaryTarget(
            name: "ZelloCoreSDK",
            url: "https://zello.com/sdk/dist/ios/spm/3.2.0/ZelloCoreSDK.zip",
            checksum: "4b780bbfc0d2892637d4024cbead73fbc7fdb82ea53710a02edf995f72f17d7f"
        ),
        .binaryTarget(
            name: "ZelloNetworkExtension",
            url: "https://zello.com/sdk/dist/ios/spm/3.2.0/ZelloNetworkExtension.zip",
            checksum: "ab00987b28dbd9fa5ee38191fab3cc03810d6f96a1d647329550641297706979"
        ),
        .binaryTarget(
            name: "ZelloNetworking",
            url: "https://zello.com/sdk/dist/ios/spm/3.2.0/ZelloNetworking.zip",
            checksum: "6ca21aec9e6c467216d691769cf65c6718f2e4687a78cc069ec764e67c5b1ebc"
        ),
        .binaryTarget(
            name: "ZelloSDKBinary",
            url: "https://zello.com/sdk/dist/ios/spm/3.2.0/ZelloSDK.zip",
            checksum: "80a637a07fa12565c867500f1bbb7134a15f7272598f52938caadf17b16db434"
        ),
        .binaryTarget(
            name: "ZelloSecure",
            url: "https://zello.com/sdk/dist/ios/spm/3.2.0/ZelloSecure.zip",
            checksum: "604bed4c55bf5784dc46c3270f7bb26dc552da0f4469c124bc93406f477a0a2e"
        ),
        .binaryTarget(
            name: "ZelloSharedData",
            url: "https://zello.com/sdk/dist/ios/spm/3.2.0/ZelloSharedData.zip",
            checksum: "d5a2b5bf80b4097804b9b59f9a104d384668564f8fcb05c3cfec1500902a16a8"
        ),
        .binaryTarget(
            name: "RemoteConfigurationForScripting",
            url: "https://zello.com/sdk/dist/ios/spm/3.2.0/RemoteConfigurationForScripting.zip",
            checksum: "930bc6ca9581b7b0adeaeedf5d51a696d603a4f4fb922d94b45890573d5d5656"
        ),
        .binaryTarget(
            name: "RemoteConfigurationUtilities",
            url: "https://zello.com/sdk/dist/ios/spm/3.2.0/RemoteConfigurationUtilities.zip",
            checksum: "a775df489c7d7f3e7249a899154b23d745d482b23359efc52b62d3cce1c1b8cd"
        ),
        .binaryTarget(
            name: "RemoteConfiguration",
            url: "https://zello.com/sdk/dist/ios/spm/3.2.0/RemoteConfiguration.zip",
            checksum: "661ab2cd3b10061acfe52a90363ee7f215adc5ea72a0d5c7a880e8c75bbbfb44"
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
