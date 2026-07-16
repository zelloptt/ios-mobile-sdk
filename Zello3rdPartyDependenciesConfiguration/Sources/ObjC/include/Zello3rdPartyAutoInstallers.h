#import <Foundation/Foundation.h>

/// Forward declarations of the ObjC `+load` autoinstaller classes whose
/// implementations live in their respective `.m` files. Exposed publicly so
/// the Swift retainer in `Zello3rdPartyAutoInstallRetainer` can take class
/// references and force the linker to keep their metadata in customer
/// binaries that build without `-ObjC`.

@interface ZelloCLJAutoInstall : NSObject
@end

@interface SnowplowAnalyticsProxyAutoInstall : NSObject
@end

@interface ZelloSDWebImageAutoInstall : NSObject
@end

@interface ZelloOpenSSLAutoInstall : NSObject
@end

@interface ZelloPhoneNumberKitAutoInstall : NSObject
@end
