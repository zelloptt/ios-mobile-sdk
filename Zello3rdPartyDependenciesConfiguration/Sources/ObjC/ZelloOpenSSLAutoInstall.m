#import <Foundation/Foundation.h>
#import <dlfcn.h>

typedef void (*ZelloOpenSSLSwiftInstallFn)(void);

@interface ZelloOpenSSLAutoInstall : NSObject
@end
@implementation ZelloOpenSSLAutoInstall
+ (void)load {
    // Optionally call Swift installer if present (no link-time dep)
    ZelloOpenSSLSwiftInstallFn swiftInstall =
        (ZelloOpenSSLSwiftInstallFn)dlsym(RTLD_DEFAULT, "ZelloOpenSSLConfigurationInstall");
    if (swiftInstall) {
        swiftInstall();
    }
}
@end
