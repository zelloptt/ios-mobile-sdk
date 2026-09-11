import SnowplowTracker
import Utility
import UIKit

@_cdecl("SnowplowAnalyticsProxyConfigurationInstall")
// swiftlint:disable:next identifier_name
public func SnowplowAnalyticsProxyConfigurationInstall() {
    /// Snowplow touches `UIScreen` during tracker creation, so concrete proxies install only after
    /// ``UIApplication/didFinishLaunchingNotification`` (see ``SnowplowLaunchGate``). Buffers queue calls until then.
    /// Only the buffer type resolved from DI runs its install closure (embedded SDK vs consumer app).
    SnowplowLaunchGate.prepare()
    SnowplowProxyBufferInstallRunners.register(
        embeddedSdk: {
            SnowplowAnalyticsProxyBufferEmbeddedSdk.shared.install(SnowplowAnalyticsProxyImpl())
        },
        clientApp: {
            SnowplowAnalyticsProxyBufferClientApp.shared.install(SnowplowAnalyticsProxyImplApp())
        }
    )
}
