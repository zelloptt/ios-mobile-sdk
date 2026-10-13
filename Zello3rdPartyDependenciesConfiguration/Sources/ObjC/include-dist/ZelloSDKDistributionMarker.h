// Presence of this header (copied into include/ by the SDK packaging in
// scripts/release_sdk.sh) marks the packaged single-xcframework distribution
// layout. ZelloSecureCompat.h keys its vendored-header branch off it via
// __has_include — build-setting defines are invisible to clang module builds
// of public headers, so the header must self-detect its layout.
#ifndef ZelloSDKDistributionMarker_h
#define ZelloSDKDistributionMarker_h
#endif
