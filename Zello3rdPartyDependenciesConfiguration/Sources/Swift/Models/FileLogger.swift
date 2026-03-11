import Utility
import CocoaLumberjack

final class FileLogger: NSObject, ZFileLogger {

  init(fileLogger: DDFileLogger) {
    self.fileLogger = fileLogger
  }

  var zLogFileManager: any ZLogFileManager {
    LogFileManager(logFileManager: fileLogger.logFileManager)
  }

  func zRollLogFile(withCompletion completion: (() -> Void)?) {
    fileLogger.rollLogFile(withCompletion: completion)
  }

  var zIsOnInternalLoggerQueue: Bool {
    fileLogger.isOnInternalLoggerQueue
  }

  func zLog(message: ZLogMessage) {
    fileLogger.log(message: message.asDDLogMessage)
  }

  var zLogFormatter: (any ZLogFormatter)? {
    get {
      guard let logFormatter = fileLogger.logFormatter else {
        return nil
      }
      return ZDDLogFormatter(logFormatter: logFormatter)
    }
    set {
      guard let newValue else {
        fileLogger.logFormatter = nil
        return
      }

      fileLogger.logFormatter = LogFormatter(logFormatter: newValue)
    }
  }

  // MARK: - Private

  private let fileLogger: DDFileLogger
}
