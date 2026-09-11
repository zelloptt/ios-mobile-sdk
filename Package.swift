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
            url: "https://zello.com/sdk/dist/ios/spm/3.3.2/UIUtility.zip",
            checksum: "056a75d767c4f6bf18219990ed35fb691659daf42b2de1659ccd67f940187ca8"
        ),
        .binaryTarget(
            name: "Utility",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.2/Utility.zip",
            checksum: "8ca19f571a45fb2ab7e06e56cd9115cd72b67fb4b73575805cf485a9d1a940bd"
        ),
        .binaryTarget(
            name: "ZelloCore",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.2/ZelloCore.zip",
            checksum: "c8bf3b659096902f7310ea8212f604b1307dccf0480c18bb6052563abeaf9810"
        ),
        .binaryTarget(
            name: "ZelloCoreSDK",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.2/ZelloCoreSDK.zip",
            checksum: "e76a81bc3d35f187255155d0c28842163087e27c30f3f6254fe0f809edda0e7b"
        ),
        .binaryTarget(
            name: "ZelloNetworkExtension",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.2/ZelloNetworkExtension.zip",
            checksum: "f86b585977e731ad97c331f436196c96f1b8155cdaa9c26dbcf62228fa1086ab"
        ),
        .binaryTarget(
            name: "ZelloNetworking",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.2/ZelloNetworking.zip",
            checksum: "4b39a74d36c44ce18360a2b477ab1d4e2914ac6c92b80a014da44f16d11a2af7"
        ),
        .binaryTarget(
            name: "ZelloSDKBinary",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.2/ZelloSDK.zip",
            checksum: "68410bb5824e4a0c9d7275211836b4a890b2a981b8dc1bb8d2ea59e3bd9acca2"
        ),
        .binaryTarget(
            name: "ZelloSecure",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.2/ZelloSecure.zip",
            checksum: "1641cd8a03033ad99770322c890b781de69242b86a0ee9aafa6d326583204420"
        ),
        .binaryTarget(
            name: "ZelloSharedData",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.2/ZelloSharedData.zip",
            checksum: "37db9853ff92d31979d54cc8a4b2ae18b057326a1daa93b28df018734d078e3c"
        ),
        .binaryTarget(
            name: "ZRemoteConfigurationForScripting",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.2/ZRemoteConfigurationForScripting.zip",
            checksum: "9d63be7742d08fdd9aa828ab158ea6e1dbba66abb0d5a98ae24764c45486dbc7"
        ),
        .binaryTarget(
            name: "ZRemoteConfigurationUtilities",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.2/ZRemoteConfigurationUtilities.zip",
            checksum: "5c22290576b2a7b647a99c857eb8cd6f4a69a1abe8116c1fdd5f39080015117f"
        ),
        .binaryTarget(
            name: "ZRemoteConfiguration",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.2/ZRemoteConfiguration.zip",
            checksum: "28ddeef931261147d5f0c0ffc5466bd05b603eb74072e3dd341e5d4b54911803"
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
