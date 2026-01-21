import Utility
import CocoaLumberjack

final class CustomLogger: DDAbstractLogger {

  init(abstractLogger: ZAbstractLogger) {
    self.abstractLogger = abstractLogger
  }

  override func log(message: DDLogMessage) {
    abstractLogger.zLog(message: message.asZLogMessage)
  }

  override var isOnInternalLoggerQueue: Bool {
    abstractLogger.zIsOnInternalLoggerQueue
  }

  override var logFormatter: DDLogFormatter? {
    get {
      guard let logFormatter = abstractLogger.zLogFormatter else {
        return nil
      }

      return LogFormatter(logFormatter: logFormatter)
    }
    set {
      guard let newValue else {
        abstractLogger.zLogFormatter = nil
        return
      }

      abstractLogger.zLogFormatter = ZDDLogFormatter(logFormatter: newValue)
    }
  }

  // MARK: - Private

  private let abstractLogger: ZAbstractLogger
}
