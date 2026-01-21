#import <Foundation/Foundation.h>
#import <dlfcn.h>

typedef void (*ZelloSDWebImageSwiftInstallFn)(void);

@interface ZelloSDWebImageAutoInstall: NSObject @end
@implementation ZelloSDWebImageAutoInstall
+ (void)load {
  // Optionally call Swift installer if present (no link-time dep)
  ZelloSDWebImageSwiftInstallFn swiftInstall = (ZelloSDWebImageSwiftInstallFn)dlsym(RTLD_DEFAULT, "ZelloSDWebImageConfigurationInstall");
  if (swiftInstall) {
    swiftInstall();
  }
}
@end
