import Utility
import Zello3rdPartyDependenciesConfigurationObjC

public final class ZAsyncSocketBuilder: NSObject, ZAsyncSocketBuildable {
    public func build(delegate: UnifiedTCPSocketDelegate?) -> UnifiedTCPSocket {
        guard let delegate else {
            return ZAsyncSocketImpl()
        }
        return ZAsyncSocketImpl(delegate: delegate)
    }
}
