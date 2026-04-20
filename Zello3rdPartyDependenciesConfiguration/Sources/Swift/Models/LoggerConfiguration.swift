import Utility
#if canImport(CocoaLumberjackSwift)
import CocoaLumberjackSwift
#endif
#if canImport(CocoaLumberjack)
import CocoaLumberjack
#endif

struct ZelloLoggingConfiguration: LoggingConfiguration {
    func zSetupLogLevel(_ level: ZLogLevel) {
        dynamicLogLevel = level.asLogLevel
    }

    func zAddLogger(with type: ZLoggerType, osLogLevel: ZLogLevel) {
        DDLog.add(type.logger, with: osLogLevel.asLogLevel)
    }

    func zConfigureGlobalLogFormatter(logFormatter: ZLogFormatter) {
        DDOSLogger.sharedInstance.logFormatter = LogFormatter(logFormatter: logFormatter)
    }

    // swiftlint:disable:next function_parameter_count
    func zConfigureFileLogger(
        osLogLevel: ZLogLevel,
        logFormatter: ZLogFormatter,
        rollingFrequency: TimeInterval,
        doNotReuseLogFiles: Bool,
        maximumNumberOfLogFiles: UInt,
        maximumFileSize: UInt64
    ) -> ZFileLogger {
        let fileLogger = DDFileLogger()
        fileLogger.rollingFrequency = rollingFrequency
        fileLogger.doNotReuseLogFiles = doNotReuseLogFiles
        fileLogger.logFileManager.maximumNumberOfLogFiles = maximumNumberOfLogFiles
        fileLogger.maximumFileSize = maximumFileSize
        fileLogger.logFormatter = LogFormatter(logFormatter: logFormatter)
        DDLog.add(fileLogger, with: osLogLevel.asLogLevel)
        return FileLogger(fileLogger: fileLogger)
    }

    func zFlushLog() {
        DDLog.flushLog()
    }
}

private extension ZLoggerType {
    var logger: DDLogger {
        switch self {
        case .ddos:
            DDOSLogger.sharedInstance
        case let .custom(logger):
            CustomLogger(abstractLogger: logger)
        @unknown default:
            fatalError("We need to handle all ZLoggerType cases")
        }
    }
}
