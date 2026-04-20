#import <Foundation/Foundation.h>
#import <dlfcn.h>

typedef void (*ZelloCocoaAsyncSocketSwiftInstallFn)(void);

@interface ZelloCocoaAsyncSocketAutoInstall : NSObject
@end
@implementation ZelloCocoaAsyncSocketAutoInstall
+ (void)load {
    // Optionally call Swift installer if present (no link-time dep)
    void *handle = dlopen(NULL, RTLD_LAZY);
    if (handle) {
        ZelloCocoaAsyncSocketSwiftInstallFn swiftInstall =
            (ZelloCocoaAsyncSocketSwiftInstallFn)dlsym(handle, "ZelloCocoaAsyncSocketConfigurationInstall");
        if (swiftInstall) {
            swiftInstall();
        }
    }
}
@end
