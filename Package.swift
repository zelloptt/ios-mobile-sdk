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
      url: "https://zello.com/sdk/dist/ios/spm/2.0.5/UIUtility.zip",
      checksum: "00ca375d2207d4cbe3d1912c5e9d880440a71537b938e621554a800c03a64a81"
    ),
    .binaryTarget(
      name: "Utility",
      url: "https://zello.com/sdk/dist/ios/spm/2.0.5/Utility.zip",
      checksum: "85566e1bd790c4c50b87d5d87a8f9ac1cde879109ec177fee882f49ea9bd2772"
    ),
    .binaryTarget(
      name: "ZelloCore",
      url: "https://zello.com/sdk/dist/ios/spm/2.0.5/ZelloCore.zip",
      checksum: "8781b45264b2cb02748b8fcc6b768365e2b2b8dbc39c20d5e94ab46aeec16779"
    ),
    .binaryTarget(
      name: "ZelloCoreSDK",
      url: "https://zello.com/sdk/dist/ios/spm/2.0.5/ZelloCoreSDK.zip",
      checksum: "2dd5972af558607ee4085f789b3c94b685fa282b505f15a080d2405a6001f9ba"
    ),
    .binaryTarget(
      name: "ZelloNetworkExtension",
      url: "https://zello.com/sdk/dist/ios/spm/2.0.5/ZelloNetworkExtension.zip",
      checksum: "9fff4a1885873b8acd7baca7ef9f2420dbfaa6a00623d8c0ce6b6b3423a473a7"
    ),
    .binaryTarget(
      name: "ZelloNetworking",
      url: "https://zello.com/sdk/dist/ios/spm/2.0.5/ZelloNetworking.zip",
      checksum: "5734372715cad7076fd55cfe4a6cf9551181fa6c8b6e1a9000385799482cf53a"
    ),
    .binaryTarget(
      name: "ZelloSDKBinary",
      url: "https://zello.com/sdk/dist/ios/spm/2.0.5/ZelloSDK.zip",
      checksum: "0c974be19335e394fdcbe520079ccba5e0ff88ef0f94cd8b96ba4c72a4de237e"
    ),
    .binaryTarget(
      name: "ZelloSecure",
      url: "https://zello.com/sdk/dist/ios/spm/2.0.5/ZelloSecure.zip",
      checksum: "3a7b937dda1d57de21267c5c5e71fdd4fc51d3b90159f61a213661ae2d1119f3"
    ),
    .binaryTarget(
      name: "ZelloSharedData",
      url: "https://zello.com/sdk/dist/ios/spm/2.0.5/ZelloSharedData.zip",
      checksum: "1700dcd55b3e32f9639422d20a012f82b7e984a4963e8126a64db37793d68964"
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
