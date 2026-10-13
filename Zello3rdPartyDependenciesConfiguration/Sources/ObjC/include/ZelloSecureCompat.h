// Compatibility header that resolves the correct ZelloSecure module import.
// - XcodeGen / Published SDK: ZelloSecure is a single framework/binary target
// - Local SPM: ZelloSecure ObjC types live in the ZelloSecureObjC module

#ifndef ZelloSecureCompat_h
#define ZelloSecureCompat_h

#if __has_include("ZelloSDKDistributionMarker.h")
// Packaged single-xcframework SDK distribution: no ZelloSecure module ships;
// the protocol contracts come from vendored header copies that the packaging
// (scripts/release_sdk.sh) placed beside this header — drift-checked against
// ZelloSecure/ObjC/include at release time. Detection is __has_include on the
// packaging marker because build-setting defines are invisible to clang
// module builds of public headers.
#import "AesKey.h"
#import "Decipher.h"
#import "Encipher.h"
#import "RsaKeyPublic.h"
#import "RsaKeyPrivate.h"
#import "RsaKeyPair.h"
#import "Crypto.h"
#elif __has_include(<ZelloSecure/ZelloSecure.h>)
// XcodeGen framework build or published SDK binary target
#import <ZelloSecure/ZelloSecure.h>
#else
// Local SPM build with split ObjC/Swift targets
@import ZelloSecureObjC;
#endif

#endif /* ZelloSecureCompat_h */
