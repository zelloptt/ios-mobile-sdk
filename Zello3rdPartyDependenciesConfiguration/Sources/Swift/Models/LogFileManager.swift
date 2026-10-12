#if ZELLO_SDK_DISTRIBUTION
@_spi(ThirdPartyBootstrap) import ZelloSDK
#else
import Utility
#endif
import CocoaLumberjack

final class LogFileManager: ZLogFileManager {

    init(logFileManager: DDLogFileManager) {
        self.logFileManager = logFileManager
    }

    var zSortedLogFilePaths: [String] {
        logFileManager.sortedLogFilePaths
    }

    // MARK: - Private

    private let logFileManager: DDLogFileManager
}
