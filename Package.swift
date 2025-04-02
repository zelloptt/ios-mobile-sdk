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
            checksum: "60d24524cc2740d32a5a16f74e4cf5183dada3b4a23fac3bbc5a6ea4a3c2e69c"
        ),
        .binaryTarget(
            name: "ZelloSecure",
            url: "https://zello.com/sdk/dist/ios/spm/1.1.0/ZelloSecure.zip",
            checksum: "68a774198ec2cf83e09e9bed15ecdfd49969af82f350bd1397034410eeb538d5"
        ),
        .binaryTarget(
            name: "ZelloNetworking",
            url: "https://zello.com/sdk/dist/ios/spm/1.1.0/ZelloNetworking.zip",
            checksum: "2cc87d7aaade97fdbe10d6722843c0ac1a15dd3aa7de54a6f95eea7a9d7a91ee"
        ),
        .binaryTarget(
            name: "Utility",
            url: "https://zello.com/sdk/dist/ios/spm/1.1.0/Utility.zip",
            checksum: "3f4bfdc2fae4476ef6401ee6b7dc65992a7a4c37fdf1001f495087e07cb6af22"
        ),
        .binaryTarget(
            name: "UIUtility",
            url: "https://zello.com/sdk/dist/ios/spm/1.1.0/UIUtility.zip",
            checksum: "83e9f87602ddc1573333e43922a5c6abce10601100d16740f34c9708e0cfcbfb"
        ),
        .binaryTarget(
            name: "ZelloSharedData",
            url: "https://zello.com/sdk/dist/ios/spm/1.1.0/ZelloSharedData.zip",
            checksum: "3ce96a63fb9c9060175be12c81ef5b5f6ec7dd3ca6f07b252cdafc96c6374664"
        ),
        .binaryTarget(
            name: "ZelloCoreSDK",
            url: "https://zello.com/sdk/dist/ios/spm/1.1.0/ZelloCoreSDK.zip",
            checksum: "a46a7c823b5aaeb160e1b6e57ed72708398e2ff9312a8bd0bc915f1c6b1eb5f7"
        ),
        .binaryTarget(
            name: "ZelloSDK",
            url: "https://zello.com/sdk/dist/ios/spm/1.1.0/ZelloSDK.zip",
            checksum: "1b6280be4c814fb4772439a77efbbdd3fdeb73fec94accc8c401703bc025a25e"
        ),
        .binaryTarget(
            name: "ZelloNetworkExtension",
            url: "https://zello.com/sdk/dist/ios/spm/1.1.0/ZelloNetworkExtension.zip",
            checksum: "d1e43e45e690913a882bc66f61dcd9d762cb2b71512c073926fdc0717f581053"
        )
    ],
    swiftLanguageVersions: [.v5]
)
