#import <Foundation/Foundation.h>
#import <dlfcn.h>

typedef void (*ZelloPhoneNumberKitSwiftInstallFn)(void);

@interface ZelloPhoneNumberKitAutoInstall : NSObject
@end
@implementation ZelloPhoneNumberKitAutoInstall
+ (void)load {
    // Optionally call Swift installer if present (no link-time dep)
    ZelloPhoneNumberKitSwiftInstallFn swiftInstall =
        (ZelloPhoneNumberKitSwiftInstallFn)dlsym(RTLD_DEFAULT, "ZelloPhoneNumberConfigurationInstall");
    if (swiftInstall) {
        swiftInstall();
    }
}
@end
