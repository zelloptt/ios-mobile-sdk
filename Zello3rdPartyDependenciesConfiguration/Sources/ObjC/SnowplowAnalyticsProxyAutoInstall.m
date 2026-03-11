#import <Foundation/Foundation.h>
#import <dlfcn.h>

typedef void (*SnowplowAnalyticsProxySwiftInstallFn)(void);

@interface SnowplowAnalyticsProxyAutoInstall: NSObject @end
@implementation SnowplowAnalyticsProxyAutoInstall
+ (void)load {
  // Optionally call Swift installer if present (no link-time dep)
  SnowplowAnalyticsProxySwiftInstallFn swiftInstall = (SnowplowAnalyticsProxySwiftInstallFn)dlsym(RTLD_DEFAULT, "SnowplowAnalyticsProxyConfigurationInstall");
  if (swiftInstall) {
    swiftInstall();
  }
}
@end
