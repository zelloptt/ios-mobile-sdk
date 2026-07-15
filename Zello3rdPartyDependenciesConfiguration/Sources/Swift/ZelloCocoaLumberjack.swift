#if canImport(CocoaLumberjackSwift)
import CocoaLumberjackSwift
#else
import CocoaLumberjack
#endif
import Utility
import Zello3rdPartyDependenciesConfigurationObjC

@_cdecl("ZelloCocoaLumberjackConfigurationInstall")
// swiftlint:disable:next identifier_name
public func ZelloCocoaLumberjackConfigurationInstall() {
    dynamicLogLevel = ddLogLevel

    UtilityThirdPartySupport.loggerConfiguration = ZelloLoggingConfiguration()

    UtilityThirdPartySupport.logger = .init(
        info: { DDLogInfo(DDLogMessageFormat(stringLiteral: $0)) },
        error: { DDLogError(DDLogMessageFormat(stringLiteral: $0)) },
        warning: { DDLogWarn(DDLogMessageFormat(stringLiteral: $0)) },
        debug: { DDLogDebug(DDLogMessageFormat(stringLiteral: $0)) },
        verbose: { DDLogVerbose(DDLogMessageFormat(stringLiteral: $0)) }
    )
}
