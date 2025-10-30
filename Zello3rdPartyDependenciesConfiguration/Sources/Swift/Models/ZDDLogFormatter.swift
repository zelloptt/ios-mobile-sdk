import Utility
import CocoaLumberjack

final class ZDDLogFormatter: NSObject, ZLogFormatter {

  init(logFormatter: DDLogFormatter?) {
    self.logFormatter = logFormatter
  }

  func zFormat(message logMessage: ZLogMessage) -> String? {
    logFormatter?.format(message: logMessage.asDDLogMessage)
  }

  // MARK: - Private

  private weak var logFormatter: DDLogFormatter?
}
