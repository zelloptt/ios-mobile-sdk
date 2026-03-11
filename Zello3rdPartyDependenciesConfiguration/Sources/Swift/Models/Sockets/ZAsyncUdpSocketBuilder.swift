import Utility
import Zello3rdPartyDependenciesConfigurationObjC

public final class ZAsyncUdpSocketBuilder: NSObject, ZAsyncUdpSocketBuildable {
  public func build(delegate: UnifiedUDPSocketDelegate?, delegateQueue: DispatchQueue?) -> UnifiedUDPSocket {
    ZAsyncUdpSocketWrapper(delegate: delegate, delegateQueue: delegateQueue)
  }
}
