#if ZELLO_SDK_DISTRIBUTION
@_spi(ThirdPartyBootstrap) import ZelloSDK
#else
import Utility
#endif
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
