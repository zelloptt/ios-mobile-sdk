// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "ZelloSDK",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "ZelloSDK",
            targets: ["ZelloSDKTargets",
                      "UtilityTarget",
                      "UIUtility",
                      "ZelloCore",
                      "ZelloCoreSDK",
                      "ZelloSecure",
                      "ZelloNetworking",
                      "ZelloSharedData",
                      "ZelloNetworkExtension"
                     ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/zelloptt/Opus-iOS", from: "1.0.4"),
        .package(url: "https://github.com/krzyzanowskim/OpenSSL-Package", from: "3.3.2000"),
        .package(url: "https://github.com/robbiehanson/CocoaAsyncSocket.git", from: "7.6.5"),
        .package(url: "https://github.com/cooksey/CocoaLumberjack.git", branch: "master"),
        .package(url: "https://github.com/google/promises", from: "2.4.0"),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", from: "3.8.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.13.0"),
        .package(url: "https://github.com/snowplow/snowplow-objc-tracker.git", from: "6.0.0"),
    ],
    targets: [
      .target(name: "ZelloSDKTargets",
              dependencies: [
                .target(name: "ZelloCore"),
                .target(name: "ZelloSecure"),
                .target(name: "ZelloNetworking"),
                .target(name: "UIUtility"),
                .target(name: "ZelloSDK"),
                .target(name: "UtilityTarget"),
                .target(name: "ZelloSharedData"),
                .target(name: "ZelloCoreSDK"),
                .target(name: "ZelloNetworkExtension"),
                .product(name: "opus", package: "Opus-iOS"),
                .product(name: "CocoaLumberjack", package: "CocoaLumberjack"),
                .product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack"),
              ]
             ),
      .target(name: "UtilityTarget",
              dependencies: [
                .target(name: "Utility"),
                .product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack"),
                .product(name: "CocoaLumberjack", package: "CocoaLumberjack"),
                .product(name: "Promises", package: "Promises"),
                .product(name: "PhoneNumberKit-Static", package: "PhoneNumberKit")
              ]
             ),
        // Binary targets for each .xcframework
        .binaryTarget(
            name: "ZelloCore",
            url: "https://zello.com/sdk/dist/ios/spm/1.1.0/ZelloCore.zip",
            checksum: "c79cb3b1043e4e025816c08b64c49e849c5f5a8d3c507fc8f7e1183407a30fff"
        ),
        .binaryTarget(
            name: "ZelloSecure",
            url: "https://zello.com/sdk/dist/ios/spm/1.1.0/ZelloSecure.zip",
            checksum: "b14f41c199e5606c220411ecb617bde927387ce04c0ad8dc61a58b8a2a443c8e"
        ),
        .binaryTarget(
            name: "ZelloNetworking",
            url: "https://zello.com/sdk/dist/ios/spm/1.1.0/ZelloNetworking.zip",
            checksum: "e3a53a5ef672d898f700b53ec8d67272ce02ea4ac244a6ccc8da7ec18b3ef0c3"
        ),
        .binaryTarget(
            name: "Utility",
            url: "https://zello.com/sdk/dist/ios/spm/1.1.0/Utility.zip",
            checksum: "656260a7ccec76d6055d96e9797a54954a2d4e69f3b31a67f6478574ef9ce7f3"
        ),
        .binaryTarget(
            name: "UIUtility",
            url: "https://zello.com/sdk/dist/ios/spm/1.1.0/UIUtility.zip",
            checksum: "a8d91d845f5349f72e0c48222fdd44bc5450d07c1a38471783418f26525b8c77"
        ),
        .binaryTarget(
            name: "ZelloSharedData",
            url: "https://zello.com/sdk/dist/ios/spm/1.1.0/ZelloSharedData.zip",
            checksum: "6fa4f4587b43106aa8d3d3a8bb55f914f46dbdfde35a8b71e4d1870ed39e6991"
        ),
        .binaryTarget(
            name: "ZelloCoreSDK",
            url: "https://zello.com/sdk/dist/ios/spm/1.1.0/ZelloCoreSDK.zip",
            checksum: "a01152113e97058cc2a8fba4dca5823cf6458bcbfa9bfd1a156f8288f583d5b8"
        ),
        .binaryTarget(
            name: "ZelloSDK",
            url: "https://zello.com/sdk/dist/ios/spm/1.1.0/ZelloSDK.zip",
            checksum: "4e92bb12c8d57a02262687a8f48976a2517069dd6375d453cbe7d3f28fdf1bea"
        ),
        .binaryTarget(
            name: "ZelloNetworkExtension",
            url: "https://zello.com/sdk/dist/ios/spm/1.1.0/ZelloNetworkExtension.zip",
            checksum: "18266a221f8f110564477d70bc7e074462e943fe3594d2deaa5d79951f9166b5"
        )
    ],
    swiftLanguageVersions: [.v5]
)
