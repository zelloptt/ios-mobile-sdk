// Compatibility header that resolves the correct ZelloSecure module import.
// - XcodeGen / Published SDK: ZelloSecure is a single framework/binary target
// - Local SPM: ZelloSecure ObjC types live in the ZelloSecureObjC module

#ifndef ZelloSecureCompat_h
#define ZelloSecureCompat_h

#if __has_include(<ZelloSecure/ZelloSecure.h>)
// XcodeGen framework build or published SDK binary target
#import <ZelloSecure/ZelloSecure.h>
#else
// Local SPM build with split ObjC/Swift targets
@import ZelloSecureObjC;
#endif

#endif /* ZelloSecureCompat_h */
