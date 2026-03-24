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
            url: "https://zello.com/sdk/dist/ios/spm/2.0.6/UIUtility.zip",
            checksum: "b98228198b5d3ab10601e003d473491983f096131cc179b0f12ad00475d0ab17"
        ),
        .binaryTarget(
            name: "Utility",
            url: "https://zello.com/sdk/dist/ios/spm/2.0.6/Utility.zip",
            checksum: "c9cdf766bf55fa91ce7320bb1e50b83c87483cedc10869c1cfd1d21f72464bdc"
        ),
        .binaryTarget(
            name: "ZelloCore",
            url: "https://zello.com/sdk/dist/ios/spm/2.0.6/ZelloCore.zip",
            checksum: "1be10cc49cd2a19669dfadbec2dc06ee505be1b7eef63a5fea5673122c108c1c"
        ),
        .binaryTarget(
            name: "ZelloCoreSDK",
            url: "https://zello.com/sdk/dist/ios/spm/2.0.6/ZelloCoreSDK.zip",
            checksum: "baf8e6a9a9e96a4294c4ccd88f3088a0f6681338011d78afce269671a880e3f6"
        ),
        .binaryTarget(
            name: "ZelloNetworkExtension",
            url: "https://zello.com/sdk/dist/ios/spm/2.0.6/ZelloNetworkExtension.zip",
            checksum: "c89adcfc84d48666250ccd602337d4c2ef1ea01d3d2bee4cddf59b77af6ec732"
        ),
        .binaryTarget(
            name: "ZelloNetworking",
            url: "https://zello.com/sdk/dist/ios/spm/2.0.6/ZelloNetworking.zip",
            checksum: "efc452610aeb190af6c6ea7b655055cc595e045eb42b612d48362a506cd7ca38"
        ),
        .binaryTarget(
            name: "ZelloSDKBinary",
            url: "https://zello.com/sdk/dist/ios/spm/2.0.6/ZelloSDK.zip",
            checksum: "4e2bf43245550b9b3baf619f985669e8df73cffb7a3be9c8a931f7da58285b76"
        ),
        .binaryTarget(
            name: "ZelloSecure",
            url: "https://zello.com/sdk/dist/ios/spm/2.0.6/ZelloSecure.zip",
            checksum: "6429babd4c1cb2462254948999bae86254368fd31f785c8f066b1c81b11046b8"
        ),
        .binaryTarget(
            name: "ZelloSharedData",
            url: "https://zello.com/sdk/dist/ios/spm/2.0.6/ZelloSharedData.zip",
            checksum: "22fbde4f4d3f1ee6cad9d20e8306cc73d4f2457f3eae751a0458437acd551d26"
        ),
        .binaryTarget(
            name: "RemoteConfigurationForScripting",
            url: "https://zello.com/sdk/dist/ios/spm/2.0.6/RemoteConfigurationForScripting.zip",
            checksum: "308fb286e5a48a4df979596e5ecfa817737651293dd330dd0eba36ed20fabfcb"
        ),
        .binaryTarget(
            name: "RemoteConfigurationUtilities",
            url: "https://zello.com/sdk/dist/ios/spm/2.0.6/RemoteConfigurationUtilities.zip",
            checksum: "e4e2601839da72600683e44ae526b4c8f80cf15d6580a7d3a8310e4c6208982b"
        ),
        .binaryTarget(
            name: "RemoteConfiguration",
            url: "https://zello.com/sdk/dist/ios/spm/2.0.6/RemoteConfiguration.zip",
            checksum: "192a33e0416c911671d53e7327a30c7369d8d4e428fd4db4eeb8faffb2884f9b"
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
