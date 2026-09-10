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
            url: "https://zello.com/sdk/dist/ios/spm/3.3.1/UIUtility.zip",
            checksum: "0daf8f86090004bd089bd183e90810a2f7e0a6fe8294f298ecb43f6341d0349d"
        ),
        .binaryTarget(
            name: "Utility",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.1/Utility.zip",
            checksum: "faed37ee46e98d240775545b5484597d176367cecfcc0a57e65d101e679a6906"
        ),
        .binaryTarget(
            name: "ZelloCore",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.1/ZelloCore.zip",
            checksum: "b0ecb8926289319e6f72738d53ededa1de864855f831ee09b8ad03816188d256"
        ),
        .binaryTarget(
            name: "ZelloCoreSDK",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.1/ZelloCoreSDK.zip",
            checksum: "7f788437c85ecc8bda4cd8fac7885116f3d91f6807c61a183dacd4e32604565f"
        ),
        .binaryTarget(
            name: "ZelloNetworkExtension",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.1/ZelloNetworkExtension.zip",
            checksum: "5231f24cc509597d185ea5f3849bbbd3d47534c597769779605aaddea9040aa0"
        ),
        .binaryTarget(
            name: "ZelloNetworking",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.1/ZelloNetworking.zip",
            checksum: "b3313514910b2c528c91b9bb30d2e766291ab7a307a3b945721118164ec91aa8"
        ),
        .binaryTarget(
            name: "ZelloSDKBinary",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.1/ZelloSDK.zip",
            checksum: "41499ec3fb85577e2cb7f3b8525f91c028e21183a58d42e655dfd461e3d5ece7"
        ),
        .binaryTarget(
            name: "ZelloSecure",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.1/ZelloSecure.zip",
            checksum: "54442b5eb09c70fac1773354fa5e6f292eea6551499d0afad213dde9b6b54740"
        ),
        .binaryTarget(
            name: "ZelloSharedData",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.1/ZelloSharedData.zip",
            checksum: "6f79f313575fd2996a356be3784be28bc50f2e086b895dca8becbffa4612d6c5"
        ),
        .binaryTarget(
            name: "ZRemoteConfigurationForScripting",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.1/ZRemoteConfigurationForScripting.zip",
            checksum: "10142d87d87ffae33711dddd7539ad2595c928943401425a43a4ac43be789932"
        ),
        .binaryTarget(
            name: "ZRemoteConfigurationUtilities",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.1/ZRemoteConfigurationUtilities.zip",
            checksum: "cf17d828cdf5d7d68091c7b38feee43ec1ce94b24e1639315697eac9956368e3"
        ),
        .binaryTarget(
            name: "ZRemoteConfiguration",
            url: "https://zello.com/sdk/dist/ios/spm/3.3.1/ZRemoteConfiguration.zip",
            checksum: "0b052fa102cf550e5fddb9550bce5574bd0dd4d29f73b182cfa64277b2ce70f7"
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
