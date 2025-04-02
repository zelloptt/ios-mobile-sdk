// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "ZelloSDK",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "ZelloSDK",
            targets: ["ZelloSDK"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/zelloptt/Opus-iOS", from: "1.0.4"),
        .package(url: "https://github.com/krzyzanowskim/OpenSSL-Package", from: "3.3.2000"),
        .package(url: "https://github.com/robbiehanson/CocoaAsyncSocket.git", from: "7.6.5"),
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack.git", from: "3.7.0"),
        .package(url: "https://github.com/google/promises", from: "2.4.0"),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", from: "3.8.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.13.0"),
        .package(url: "https://github.com/snowplow/snowplow-objc-tracker.git", from: "6.0.0"),
    ],
    targets: [
        // Binary targets for each .xcframework
        .binaryTarget(
            name: "ZelloCore",
            url: "https://zello.com/sdk/dist/ios/spm/1.1.0/ZelloCore.zip",
            checksum: "cb85de0ebd85d0dea61e73fbca15504d51d49884d7480519ed739dade3670999"
        ),
        .binaryTarget(
            name: "ZelloSecure",
            url: "https://zello.com/sdk/dist/ios/spm/1.1.0/ZelloSecure.zip",
            checksum: "dc3fa98c6af889f59093a856195fcf279accf236e2fe1de320b538702a3055dd"
        ),
        .binaryTarget(
            name: "ZelloNetworking",
            url: "https://zello.com/sdk/dist/ios/spm/1.1.0/ZelloNetworking.zip",
            checksum: "06ccb9d9fa881b7923856eaaa9fc5af67b720878ef09e9cc3b70fcc4614a695e"
        ),
        .binaryTarget(
            name: "Utility",
            url: "https://zello.com/sdk/dist/ios/spm/1.1.0/Utility.zip",
            checksum: "a48b98f836de4ecb96462c6226efb8e4621e40fbf428c63d10fb4077827ac89b"
        ),
        .binaryTarget(
            name: "UIUtility",
            url: "https://zello.com/sdk/dist/ios/spm/1.1.0/UIUtility.zip",
            checksum: "953308e571c8e69d16f33300e9594170bde513a5adb42f243ada117a0074b3ac"
        ),
        .binaryTarget(
            name: "ZelloSharedData",
            url: "https://zello.com/sdk/dist/ios/spm/1.1.0/ZelloSharedData.zip",
            checksum: "fc4727b46784a578e55efc8a49121e93f9067a2fa92119ba771aa3b10dc4dc52"
        ),
        .binaryTarget(
            name: "ZelloCoreSDK",
            url: "https://zello.com/sdk/dist/ios/spm/1.1.0/ZelloCoreSDK.zip",
            checksum: "2aaf10a1cb00292487891f9c63b05bd74b79383771f29bfcf5ed9ed4ac6f40b0"
        ),
        .binaryTarget(
            name: "ZelloSDK",
            url: "https://zello.com/sdk/dist/ios/spm/1.1.0/ZelloSDK.zip",
            checksum: "d6022b5a32096f1a4fce00afdc9eeb01aa32b2d620ed01a635ea8133b009c17c"
        ),
        .binaryTarget(
            name: "ZelloNetworkExtension",
            url: "https://zello.com/sdk/dist/ios/spm/1.1.0/ZelloNetworkExtension.zip",
            checksum: "5187c858c4a92eac0f83e9ab2600947c7fedf513d829b2dc6a41e85d6b641c4f"
        )
    ],
    swiftLanguageVersions: [.v5]
)
