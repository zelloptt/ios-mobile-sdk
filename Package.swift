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
        .package(url: "https://github.com/zelloptt/Opus-iOS", from: "1.0.5")
    ],
    targets: [
        .binaryTarget(
            name: "UIUtility",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.1/UIUtility.zip",
            checksum: "445043020f6b146614700efe544c7db854954d56265717e75e3b7329699319da"
        ),
        .binaryTarget(
            name: "Utility",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.1/Utility.zip",
            checksum: "025cc9a8376ffa2ca9050300db2dfa4efbeb9ce52974981bff82ce83ab5c41da"
        ),
        .binaryTarget(
            name: "ZelloCore",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.1/ZelloCore.zip",
            checksum: "9bc81b1f23e7ca1cf8b4c47da874fcea0bbf7ed18c27b5d0ce111a21fa29a167"
        ),
        .binaryTarget(
            name: "ZelloCoreSDK",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.1/ZelloCoreSDK.zip",
            checksum: "ff23ce61df663fc0fc7909ccb96765f52cfbb23d4966beabcbef123669177642"
        ),
        .binaryTarget(
            name: "ZelloNetworkExtension",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.1/ZelloNetworkExtension.zip",
            checksum: "d95aa8c999c1c03dbb89aec9b81ea1ae771ca35c4a37bff4aee2eb531fad372e"
        ),
        .binaryTarget(
            name: "ZelloNetworking",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.1/ZelloNetworking.zip",
            checksum: "505b26f54cbbf4d8f2a5e37fb0ff76ebe9a433f4a7ab5eca39a1ca4cae5d3db0"
        ),
        .binaryTarget(
            name: "ZelloSDKBinary",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.1/ZelloSDK.zip",
            checksum: "dcd496d584a0c8eaf0e35cf5fa6ecda24c5d5db0c4fe111e8d4f0d667c994368"
        ),
        .binaryTarget(
            name: "ZelloSecure",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.1/ZelloSecure.zip",
            checksum: "4302ad482435d20d0ae88fee12507c4778718908a4ef4059bd48e058de1f5b28"
        ),
        .binaryTarget(
            name: "ZelloSharedData",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.1/ZelloSharedData.zip",
            checksum: "a33695b3b112dd05a0b58467698fe8bb13d27d4b52863a0afe487dc79f79ed61"
        ),
        .binaryTarget(
            name: "RemoteConfigurationForScripting",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.1/RemoteConfigurationForScripting.zip",
            checksum: "d82bee5c7255120c3a2d7623a7981fa1b51ad2de0e7dc13cc77d2511477186a2"
        ),
        .binaryTarget(
            name: "RemoteConfigurationUtilities",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.1/RemoteConfigurationUtilities.zip",
            checksum: "9af09444fe859508dea9504d3c440bc7263be253314b07e57450cec7975970f3"
        ),
        .binaryTarget(
            name: "RemoteConfiguration",
            url: "https://zello.com/sdk/dist/ios/spm/3.0.1/RemoteConfiguration.zip",
            checksum: "9edafc5ef1fdcf33fa79612ba5f1cbbd92219da243a8a5a5a9608311c49878c0"
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
