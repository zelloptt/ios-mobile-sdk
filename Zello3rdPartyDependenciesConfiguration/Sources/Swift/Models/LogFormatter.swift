import Utility
import CocoaLumberjack

final class LogFormatter: NSObject, DDLogFormatter {

    init(logFormatter: ZLogFormatter) {
        self.logFormatter = logFormatter
    }

    func format(message logMessage: DDLogMessage) -> String? {
        logFormatter?.zFormat(message: logMessage.asZLogMessage)
    }

    // MARK: - Private

    private let logFormatter: ZLogFormatter?
}
