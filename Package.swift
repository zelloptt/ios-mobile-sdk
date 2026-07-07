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
            url: "https://zello.com/sdk/dist/ios/spm/3.1.0/UIUtility.zip",
            checksum: "2db45ccb16ff5d643379d2ebde6643763300d24cc2b7f288fb2a23ec2d3545e2"
        ),
        .binaryTarget(
            name: "Utility",
            url: "https://zello.com/sdk/dist/ios/spm/3.1.0/Utility.zip",
            checksum: "32f6bc5f04bf69e9272c2a813e884feea4f5f02fdca9b44e55376199bd3c602e"
        ),
        .binaryTarget(
            name: "ZelloCore",
            url: "https://zello.com/sdk/dist/ios/spm/3.1.0/ZelloCore.zip",
            checksum: "5d5c4b3beaf31965372817c1e400e9bcf28b1084756e4f9dcb155a86135586cb"
        ),
        .binaryTarget(
            name: "ZelloCoreSDK",
            url: "https://zello.com/sdk/dist/ios/spm/3.1.0/ZelloCoreSDK.zip",
            checksum: "0d66c054a3f6ae287fd73421bfa3caeac6629d8d676051ec8461fead3e32f39b"
        ),
        .binaryTarget(
            name: "ZelloNetworkExtension",
            url: "https://zello.com/sdk/dist/ios/spm/3.1.0/ZelloNetworkExtension.zip",
            checksum: "f5bb1eddc9ac415e51b832a16c8e325d5222e0440bf51c376e1b91e7aeaf9c1a"
        ),
        .binaryTarget(
            name: "ZelloNetworking",
            url: "https://zello.com/sdk/dist/ios/spm/3.1.0/ZelloNetworking.zip",
            checksum: "481d0cf585e1efb6b45ddfb92abacd3250925918b0b5d05ee5956bc480d32a16"
        ),
        .binaryTarget(
            name: "ZelloSDKBinary",
            url: "https://zello.com/sdk/dist/ios/spm/3.1.0/ZelloSDK.zip",
            checksum: "f8bc7e0313aaeb9d96e74da01504127ed1981412c9ec55c7c25ed8990ab7ccc2"
        ),
        .binaryTarget(
            name: "ZelloSecure",
            url: "https://zello.com/sdk/dist/ios/spm/3.1.0/ZelloSecure.zip",
            checksum: "13d4a0c6069769a0e025840a8b52bf4737fddf4d6324a52a293845fc47d48bca"
        ),
        .binaryTarget(
            name: "ZelloSharedData",
            url: "https://zello.com/sdk/dist/ios/spm/3.1.0/ZelloSharedData.zip",
            checksum: "843b8c6a1a0c1ac07d5bbdd7d82caf9d20862defedcf6c90d9e38046fc1239eb"
        ),
        .binaryTarget(
            name: "RemoteConfigurationForScripting",
            url: "https://zello.com/sdk/dist/ios/spm/3.1.0/RemoteConfigurationForScripting.zip",
            checksum: "8a15fe09649e455da61cdcefa1e852ace817bacac960dc8f5b9aa481c8a1a37d"
        ),
        .binaryTarget(
            name: "RemoteConfigurationUtilities",
            url: "https://zello.com/sdk/dist/ios/spm/3.1.0/RemoteConfigurationUtilities.zip",
            checksum: "e9973e02159e3d1e1e9f893584964964c24aed424aed711bed76f874b60a8910"
        ),
        .binaryTarget(
            name: "RemoteConfiguration",
            url: "https://zello.com/sdk/dist/ios/spm/3.1.0/RemoteConfiguration.zip",
            checksum: "e6c724c4e5d990c75267a2f8293c6901022a0a61d56267b2b32f1c81391f2691"
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
