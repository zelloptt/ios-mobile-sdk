#pragma once
#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif

NS_ASSUME_NONNULL_BEGIN

typedef void (*UtilityLogHandler)(NSString *message);
typedef void (*UtilityLogFlushHandler)(void);

// Set all handlers at once (pass NULL to keep the current value)
void UtilityLogSetHandlers(UtilityLogHandler _Nullable info, UtilityLogHandler _Nullable error,
                           UtilityLogHandler _Nullable warning, UtilityLogHandler _Nullable debug,
                           UtilityLogHandler _Nullable verbose);

// Allow replacing just the flush handler
void UtilityLogSetFlushHandler(UtilityLogFlushHandler _Nullable flushHandler);

// Reset to default NSLog-based handlers
void UtilityLogUseNSLog(void);

// printf-style front API used by your sources and by consumers
void UtilityLogInfoFormat(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);
void UtilityLogErrorFormat(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);
void UtilityLogWarningFormat(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);
void UtilityLogDebugFormat(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);
void UtilityLogVerboseFormat(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);

/// Flush buffered loggers (file, etc.)
void UtilityLogFlush(void);

// Convenience macros matching your existing call sites
#define ZLogInfo(frmt, ...) UtilityLogInfoFormat((frmt), ##__VA_ARGS__)
#define ZLogError(frmt, ...) UtilityLogErrorFormat((frmt), ##__VA_ARGS__)
#define ZLogWarning(frmt, ...) UtilityLogWarningFormat((frmt), ##__VA_ARGS__)
#define ZLogDebug(frmt, ...) UtilityLogDebugFormat((frmt), ##__VA_ARGS__)
#define ZLogVerbose(frmt, ...) UtilityLogVerboseFormat((frmt), ##__VA_ARGS__)
#define ZLogFlush() UtilityLogFlush()

NS_ASSUME_NONNULL_END

#ifdef __cplusplus
}
#endif
