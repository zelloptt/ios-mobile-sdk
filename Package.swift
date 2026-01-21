// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "ZelloSDK",
  platforms: [.iOS(.v15)],
  products: [
    .library(name: "ZelloSDKUmbrella", targets: ["ZelloSDKUmbrella"]),
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
      url: "https://zello.com/sdk/dist/ios/spm/2.0.4/UIUtility.zip",
      checksum: "2b81134ff0ea9c46510cc76e163546de2534063adf5a14e79ca5f3b8c5c2793c"
    ),
    .binaryTarget(
      name: "Utility",
      url: "https://zello.com/sdk/dist/ios/spm/2.0.4/Utility.zip",
      checksum: "3c101807fb84a87da49453cb8b89630fa84f474153a1ef6e82eae43834033811"
    ),
    .binaryTarget(
      name: "ZelloCore",
      url: "https://zello.com/sdk/dist/ios/spm/2.0.4/ZelloCore.zip",
      checksum: "b9ecbd9cac3b6bc0c4329e3f68ba06d005d987a9104c0370f707ec7d25201550"
    ),
    .binaryTarget(
      name: "ZelloCoreSDK",
      url: "https://zello.com/sdk/dist/ios/spm/2.0.4/ZelloCoreSDK.zip",
      checksum: "bd409a776f44f991f6150a58694476211e8332510c07036b90b801f110f15e2b"
    ),
    .binaryTarget(
      name: "ZelloNetworkExtension",
      url: "https://zello.com/sdk/dist/ios/spm/2.0.4/ZelloNetworkExtension.zip",
      checksum: "e77dc85611cea08586d2675700782a4abb989e8eb28d19ae1dca0b1cbc5078c1"
    ),
    .binaryTarget(
      name: "ZelloNetworking",
      url: "https://zello.com/sdk/dist/ios/spm/2.0.4/ZelloNetworking.zip",
      checksum: "0f7f52144e1728c370a74f61a4bce51a0b9d6fdcc7b0882b822f293267f53651"
    ),
    .binaryTarget(
      name: "ZelloSDKBinary",
      url: "https://zello.com/sdk/dist/ios/spm/2.0.4/ZelloSDK.zip",
      checksum: "fb1184b2008a1472104be526bee786e71d58756b3c5b42671d40c927f539a902"
    ),
    .binaryTarget(
      name: "ZelloSecure",
      url: "https://zello.com/sdk/dist/ios/spm/2.0.4/ZelloSecure.zip",
      checksum: "5690c2f8f04a477ad8bf80d6956a7953759be50e8f8bf06bb65bcda58f403ee9"
    ),
    .binaryTarget(
      name: "ZelloSharedData",
      url: "https://zello.com/sdk/dist/ios/spm/2.0.4/ZelloSharedData.zip",
      checksum: "5ec7d00b06e0bd1a854633e3ca4e480c0050f49b7beec10767dcb7fb2d52fc6a"
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
        .product(name: "ogg",  package: "opus-ios")
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
        "ZelloNetworkExtension"
      ],
      path: "Sources/Umbrella"
    )
  ]
)
