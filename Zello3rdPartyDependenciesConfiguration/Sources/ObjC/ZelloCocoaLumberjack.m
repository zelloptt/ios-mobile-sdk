#import <Foundation/Foundation.h>
#import <dlfcn.h>
#if __has_include(<CocoaLumberjack/CocoaLumberjack.h>)
#import <CocoaLumberjack/CocoaLumberjack.h>
#elif __has_include(<CocoaLumberjack/DDLog.h>)
#import <CocoaLumberjack/DDLogMacros.h>
#endif
#import <Utility/ZLog.h>

DDLogLevel ddLogLevel = DDLogLevelOff;

static void CLJInfo(NSString *msg) {
    DDLogInfo(@"%@", msg);
}
static void CLJError(NSString *msg) {
    DDLogError(@"%@", msg);
}
static void CLJWarn(NSString *msg) {
    DDLogWarn(@"%@", msg);
}
static void CLJDebug(NSString *msg) {
    DDLogDebug(@"%@", msg);
}
static void CLJVerbose(NSString *msg) {
    DDLogVerbose(@"%@", msg);
}
static void CLJFlushLog(void) {
    [DDLog flushLog];
}

typedef void (*ZelloCLJSwiftInstallFn)(void);

@interface ZelloCLJAutoInstall : NSObject
@end
@implementation ZelloCLJAutoInstall
+ (void)load {
#if DEBUG
    ddLogLevel = DDLogLevelDebug;
#else
    ddLogLevel = DDLogLevelInfo;
#endif

    // Install ObjC-side handlers immediately
    UtilityLogSetHandlers(CLJInfo, CLJError, CLJWarn, CLJDebug, CLJVerbose);
    UtilityLogSetFlushHandler(CLJFlushLog);

    // Optionally call Swift installer if present (no link-time dep)
    ZelloCLJSwiftInstallFn swiftInstall =
        (ZelloCLJSwiftInstallFn)dlsym(RTLD_DEFAULT, "ZelloCocoaLumberjackConfigurationInstall");
    if (swiftInstall) {
        swiftInstall();
    }
}
@end
