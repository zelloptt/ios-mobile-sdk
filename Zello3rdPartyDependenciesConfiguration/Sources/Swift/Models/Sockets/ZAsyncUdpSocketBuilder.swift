import Utility
import Zello3rdPartyDependenciesConfigurationObjC

public final class ZAsyncUdpSocketBuilder: NSObject, ZAsyncUdpSocketBuildable {
  public func build(delegate: ZAsyncUdpSocketDelegate?, delegateQueue: DispatchQueue?) -> ZAsyncUdpSocket {
    ZAsyncUdpSocketWrapper(delegate: delegate, delegateQueue: delegateQueue)
  }
}
