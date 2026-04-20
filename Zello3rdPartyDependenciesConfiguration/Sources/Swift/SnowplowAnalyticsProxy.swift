import SnowplowTracker
import Utility
import UIKit
import Combine

private var cancellable: AnyCancellable?

@_cdecl("SnowplowAnalyticsProxyConfigurationInstall")
// swiftlint:disable:next identifier_name
public func SnowplowAnalyticsProxyConfigurationInstall() {
    /// Snowplow calls UIScreen, so we need to wait until UIKit is setup
    /// before accessing UIScreen to prevent a deadlock.
    /// The proxy starts as a SnowplowAnalyticsProxyBuffered that queues calls
    /// until the real implementation is installed.
    cancellable = NotificationCenter
        .default
        .publisher(for: UIApplication.didFinishLaunchingNotification)
        .first()
        .sink(receiveValue: { _ in
            (UtilityThirdPartySupport.snowplowAnalyticsProxy as? UtilityThirdPartySupport.SnowplowAnalyticsProxyBuffered)?
                .install(SnowplowAnalyticsProxyImpl())
            cancellable = nil
        })
}
